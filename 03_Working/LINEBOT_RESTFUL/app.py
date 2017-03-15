#!/usr/bin/python
#-*-coding: utf-8 -*-

import paho.mqtt.client as mqtt
import os
import urlparse
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
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from models import Base, Weather
from werkzeug import secure_filename
import psycopg2
import os
import json
import requests
import datetime

import psycopg2

dbname = 'd9h676ge1i7hgt'
user = 'gvcvbeuobxhyvh'
host = 'ec2-23-21-80-230.compute-1.amazonaws.com'
password = 'ece432448e4dac9e2124ee90a8630b2f11b2b532ae97645eadc1032eff950ea5'

connectionString = "dbname='{}' user='{}' host='{}' password='{}'"
connectionString = connectionString.format(dbname, user, host, password)


app = Flask(__name__)

line_bot_api = LineBotApi(
    '0WduROX5bV3eILlYQr3hI6QyHzevja8Y9lFKn9Pl/nqSyzvNaOK3oC2t9ugNgfgFbW3M591iHZXDYUhHPZEH5KveFuE/d9UrKJckVjoCQCmDt3Evqt2pndxhiv3u1J4latfY4FlbQxJkqGhVqS8TewdB04t89/1O/w1cDnyilFU=')
handler = WebhookHandler('365a4e426c7086eb6a96c25125b45ec3')

WEATHER_ID = '9b0a16392ec219fbe5f10103acd11098'
WEATHER_PLACE = 'Bangkok,th'

dburl = 'postgresql://{}:{}@{}:{}/{}'
dburl = dburl.format('hoykhomdb', 'A86qPz9oWnZAao8',
                 '52.230.29.224', 5432, 'tgr2017')

# MQTT configuration
client = mqtt.Client()
client.username_pw_set("lineapi", "test1234")
client.connect('m13.cloudmqtt.com', 11675, 60)
client.loop_start()

engine = create_engine(dburl, client_encoding='utf8')
Base.metadata.create_all(engine)

DBSession = sessionmaker(bind=engine)
session = DBSession()

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

@app.route("/member.json")
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
            mimetype='application/json',
            headers={'Content-Disposition':'attachment;filename=hoykhom.json'})

def createWeatherdb():
    try:
        conn = psycopg2.connect(connectionString)
        cur = conn.cursor()
        sql_command = """
            CREATE TABLE weather (
                wdate DATE PRIMARY KEY,
                temp REAL);"""
        cur.execute(sql_command)
        conn.commit()
        r = 'success'
    except:
        r = "error happens"
    return r

def updateWeather():
    date = ['20170310', '20170311', '20170312', '20170313', '20170314']
    for d in date:
        data = requests.get('http://api.wunderground.com/api/b728a7436f25b9f2/history_'+d+'/q/TH/Bangkok.json')
        data = data.json()
        temp = data['history']['dailysummary'][0]['meantempm']
        conn = psycopg2.connect(connectionString)
        cur = conn.cursor()
        query = "INSERT INTO weather (wdate, temp) VALUES ('{}', {})"
        query = query.format(d, temp)
        cur.execute(query)
        print(query)
        conn.commit()    

def getWeather():
    s = ''
    date = ['20170310', '20170311', '20170312', '20170313', '20170314']
    for d in date:
        s += 'Day (' + d + '): ' + str() + '\n Temp: '
        conn = psycopg2.connect(connectionString)
        cur = conn.cursor()
        query = "SELECT * FROM weather WHERE wdate='" + d + "';"
        cur.execute(query)  
        rows = cur.fetchone()
        s += str(rows[1]) + '\n================\n'
        print s
    return s

# HANDLE MESSAGE
@handler.add(MessageEvent, message=TextMessage)
def handle_message(event):
    print 'tired'
    print event.message.text.encode('utf-8')
    if event.message.text.encode('utf-8') == 'เหนื่อยไหม':

        line_bot_api.reply_message( event.reply_token, TextSendMessage(text=getWeather()) )
    else:
        line_bot_api.reply_message( event.reply_token, TextSendMessage(text = 'Line Bot สามารถทำงานได้'))
        input_text = event.message.text.lower()
        if input_text == 'info':
            client.publish("/GET/DATA", json.loads(str(event.source))['userId'])
            # PRINT PLEASE WAIT
            line_bot_api.reply_message( event.reply_token, TextSendMessage(text="Please wait....") )

@app.route('/weather')
def weather():
    return '<pre>' + getWeather() + '</pre>'


@app.route('/currentweather', methods=['POST'])
def CurrentWeather():
    if request.method == 'POST':
        # POST data to line API
        print 'Create new weather log'

        # Get weather from API
        weathUrl = 'http://api.openweathermap.org/data/2.5/weather?q=%s&appid=%s'
        param = (WEATHER_PLACE, WEATHER_ID, )
        weath = requests.get(weathUrl % param)
        weather_data = json.loads(weath.text)
        
        user = request.form.get('user')
        picture = request.form.get('picture')
        soil_moisture = request.form.get('soil_moisture')
        temperature = weather_data['main']['temp']
        weather_description = weather_data['weather'][0]['description']
        air_pressure = weather_data['main']['pressure']
        air_moisture = weather_data['main']['humidity']

        print user
        print picture
        print temperature
        print soil_moisture
        print weather_description
        print air_pressure
        print air_moisture

        data_string = 'temperature: ' + str(temperature) + '\n' + \
                    'soil_moisture: ' + str(soil_moisture) + '\n' + \
                    'weather_description: ' + weather_description + '\n' + \
                    'air_pressure: ' + str(air_pressure) + '\n' + \
                    'air_moisture: ' + str(air_moisture)  

        
        # SEND TEXT MSG
        line_bot_api.push_message(user, TextMessage(text=data_string))

        # SEND PIC
        pic = ImageSendMessage(
            original_content_url=picture,
            preview_image_url=picture
        )
        try:
            line_bot_api.push_message(user, pic)
        except LineBotApiError as e:
            print(e.status_code)
            print(e.error.message)
            print(e.error.details)

        # COMMIT TO DATABASE
        w = Weather(picture=picture,
                    temperature=temperature,
                    user = user,
                    soil_moisture=soil_moisture,
                    weather_description=weather_description,
                    air_pressure=air_pressure,
                    air_moisture=air_moisture)

        session.add(w)
        session.commit()
        return jsonify(Weather=w.serialize)


if __name__ == "__main__":
    app.run(debug=True)


# requests.post(posturl, data={'picture': 'eiei','temperature': 3.2,'soil_moisture': 2.3,'weather_description': 'good','air_pressure': 33,'air_moisture': 65})

# def Get_time():
#     line_bot_api.reply_message(event.reply_token, TextSendMessage(
#         text=str(datetime.datetime.now())))


# def Control_led(control_text):
#     client.publish("/GET/DATA", control_text)


# def Dont_know():
#     line_bot_api.reply_message(
#         event.reply_token, TextSendMessage(text='I don\'t know'))