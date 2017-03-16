#!/usr/bin/python
#-*-coding: utf-8 -*-

import paho.mqtt.client as mqtt
from flask import Flask, render_template, request, jsonify, send_from_directory, abort, Response
from linebot import (
    LineBotApi, WebhookHandler,
)
from linebot.exceptions import (
    InvalidSignatureError, LineBotApiError,
)
from linebot.models import (
    MessageEvent, TextMessage, TextSendMessage, ImageSendMessage, TemplateSendMessage, ButtonsTemplate,
    PostbackTemplateAction, MessageTemplateAction, URITemplateAction
)
import psycopg2
import os
import json
import requests
from models import Weather

dbname = 'd9h676ge1i7hgt'
user = 'gvcvbeuobxhyvh'
host = 'ec2-23-21-80-230.compute-1.amazonaws.com'
password = 'ece432448e4dac9e2124ee90a8630b2f11b2b532ae97645eadc1032eff950ea5'

position = 'Bangkok'

connectionString = "dbname='{}' user='{}' host='{}' password='{}'"
connectionString = connectionString.format(dbname, user, host, password)


app = Flask(__name__)

line_bot_api = LineBotApi(
    '0WduROX5bV3eILlYQr3hI6QyHzevja8Y9lFKn9Pl/nqSyzvNaOK3oC2t9ugNgfgFbW3M591iHZXDYUhHPZEH5KveFuE/d9UrKJckVjoCQCmDt3Evqt2pndxhiv3u1J4latfY4FlbQxJkqGhVqS8TewdB04t89/1O/w1cDnyilFU=')
handler = WebhookHandler('365a4e426c7086eb6a96c25125b45ec3')

# MQTT configuration
client = mqtt.Client()
client.username_pw_set("lineapi", "test1234")
client.connect('m13.cloudmqtt.com', 11675, 60)
client.loop_start()

######################################################################
##                          MAIN FUNCTION                            #
######################################################################


# Line event callback
@app.route("/callback", methods=['POST'])
def callback():
    # get X-Line-Signature header value
    signature = request.headers['X-Line-Signature']

    # get request body as text
    body = request.get_data(as_text=True)
    app.logger.info("Request body: " + body)

    # handle webhook body
    try:
        handler.handle(body, signature)
    except InvalidSignatureError:
        abort(400)

    return 'OK'

@app.route("/")
def index():
    return "<h1>Hello, Top Gun Rally 2017</h1>"

@app.route("/member.csv")
def memberJson():
    conn = psycopg2.connect(connectionString)
    cur = conn.cursor()
    query = """
        SELECT * FROM hoykhom_data;
        """
    cur.execute(query)
    rows = cur.fetchall()
    s = "id, " + "fname, " + "lname, " + "university, " + "year, " + \
        "department, " + "gpa, " + "afterGraduate,\n"
    for row in rows:
        for ele in row:
            s += str(ele) + ', '
        s += '\n'
    # print str(s)
    return Response(s, 
            mimetype='application/csv',
            headers={'Content-Disposition':'attachment;filename=hoykhom.csv'})

def createWeatherdb():
    try:
        conn = psycopg2.connect(connectionString)
        cur = conn.cursor()
        sql_command = """
            CREATE TABLE weather (
                     TIMESTAMP PRIMARY KEY DEFAULT CURRENT_TIMESTAMP,
                s_moisture REAL,
                w_description VARCHAR(25),
                a_pressure INT,
                a_moisture REAL,
                picture VARCHAR(150));"""
        cur.execute(sql_command)
        conn.commit()
        r = 'success'
    except:
        r = "error happens"
    return r

def getLatestWeather():
    # SELECT * FROM weather ORDER BY timestamp DESC;
    conn = psycopg2.connect(connectionString)
    cur = conn.cursor()
    query = """
        SELECT * FROM weather ORDER BY timestamp DESC;
        """
    cur.execute(query)
    data = cur.fetchone()
    w = Weather(data[0], data[1], data[2], data[3], data[4], data[5])
    return w

@app.route("/dataIn", methods=['POST'])
def dataIn():
    #Insert db

    #get data from wunderground
    data = requests.get('http://api.wunderground.com/api/b728a7436f25b9f2/conditions/q/TH/%s.json' % position)
    data = data.json()

    print('=================JSON=================')
    print json.dumps(data['current_observation'], sort_keys=True, indent=4, separators=(',', ': '))
    print('\n\n====================Summary==============')

    w_description = data['current_observation']['weather']
    a_pressure = int(data['current_observation']['pressure_mb'])
    a_moisture = float(data['current_observation']['relative_humidity'].rstrip("%"))

    s_moisture = 678
    picture = 'https://henryherz.files.wordpress.com/2013/05/takei2.jpg?w=611&h=410'

    print('\nw_description :' + w_description)
    print('\na_pressure :' + str(a_pressure))
    print('\na_moisture :' + str(a_moisture))

    #Insert to database
    conn = psycopg2.connect(connectionString)
    cur = conn.cursor()    
    query = "INSERT INTO weather (s_moisture, w_description, a_pressure, a_moisture, picture) VALUES ({}, '{}', {}, {}, '{}');"
    query = query.format(s_moisture, w_description, a_pressure, a_moisture, picture)
    print query
    cur.execute(query)
    conn.commit()
    return True

# HANDLE MESSAGE
@handler.add(MessageEvent, message=TextMessage)
def handle_message(event):
    print 'tired'
    print event.message.text.encode('utf-8')
    if event.message.text.encode('utf-8') == 'เหนื่อยไหม':

        line_bot_api.reply_message( event.reply_token, TextSendMessage(text=getWeather()) )
    else:
        input_text = event.message.text.lower()
        if input_text == 'info':
            w = getLatestWeather()
            user = json.loads(str(event.source))['userId']
            # PRINT PLEASE WAIT
            showstr = 'ความชื้นของดิน : ' + str(w.s_moisture) + '%%\n' + \
                      'สภาพอากาศ : ' + w.w_description + '\n' + \
                      'ความกดอากาศ : ' + str(w.a_pressure) + ' pha\n' + \
                      'ความชื้นในอากาศ : ' + str(w.a_moisture) + '%%'
            line_bot_api.push_message(user, TextMessage(text=showstr))
            pic = ImageSendMessage(
                original_content_url=w.picture,
                preview_image_url=w.picture
            )
            line_bot_api.push_message(user, pic)
        else:
            line_bot_api.reply_message( event.reply_token, TextSendMessage(text = 'Line Bot สามารถทำงานได้'))

@app.route('/weather')
def weather():
    return '<pre>' + getWeatherCurrent() + '</pre>'


if __name__ == "__main__":
    app.run(debug=True)