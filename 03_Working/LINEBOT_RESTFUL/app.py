import paho.mqtt.client as mqtt
import os
import urlparse
from flask import Flask, render_template, request, jsonify, send_from_directory, abort
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

# HANDLE MESSAGE
@handler.add(MessageEvent, message=TextMessage)
def handle_message(event):
    print event
    input_text = event.message.text.lower()
    print('input: ' + input_text)
    if input_text == 'info':
        client.publish("/GET/DATA", json.loads(str(event.source))['userId'])
        # PRINT PLEASE WAIT
        line_bot_api.reply_message( event.reply_token, TextSendMessage(text="Please wait....") )

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