from time import *
from subprocess import *

# TakePic
from picamera import PiCamera

# SQLite
import sqlite3 as lite
import sys

# UART Modbus
import serial
import modbus_tk
import modbus_tk.defines as cst
from modbus_tk import modbus_rtu

# postToDB
import requests

# MQTT
import paho.mqtt.client as mqtt , os, urlparse

# LED
import RPi.GPIO as GPIO

leds = [15, 16, 18]     # 22: Greem 15: Red 16: Blue: 18
LED_GREEN = 0
LED_RED = 1
LED_BLUE = 2

# Set LED GPIO
GPIO.setmode(GPIO.BCM)
for led in leds:
        print('Setup ' + str(led) +' as GPIO.OUT')
        GPIO.setup(led, GPIO.OUT)

# Set Pic
pathFilePic = "/home/pi/Pictures/"
WIDTH = 150
HIGH = 150


def takePic():
        camera = PiCamera()
        camera.resolution = (WIDTH, HIGH)
        takeTime = strftime("%d-%m-%Yh%Hm%Ms%S", localtime())
        nameFile = takeTime+".jpg"
        path = pathFilePic+nameFile
        print("TAKING PICTURE...")
        camera.capture(path)
        camera.close()
        print("COMPLETE TAKE PICTURE!\n")
        return path


# MQTT
##########################################################
def on_subscribe(client, userdata, mid, granted_qos):
        print("Subscribed: "+str(mid)+" "+str(granted_qos))

def on_message(client, userdata, msg):
        #print(msg.topic+" "+str(msg.qos)+" "+str(msg.payload))
        message = str(msg.payload)
        print ("got message:: " + message)

        print("\nSTARTING PROCESS...\n")

        try:
                GPIO.output(leds[LED_BLUE], True)

                urlPic = takePic()
                #data = readSoilMoisture()
                data = "276"

                GPIO.output(leds[LED_BLUE], False)
                GPIO.output(leds[LED_GREEN], True)

                print("COMPLETE PROCESS!!!\n")
        except:
                for i in range(0,3):
                        GPIO.output(leds[i], False)
                GPIO.output(leds[LED_RED], True)

        postRealtime(data, urlPic, message)
##########################################################


def postRealtime(data, pathFile, user):
        print("Uploading...\n")

        filestack_url = 'http://hoykhom-bot.herokuapp.com/dataRealtime'

        #print(filestack_url)
        #print(pathFile)

        pic_file = {'file': open(pathFile, 'rb')}

        r = requests.post(filestack_url, data={'s_moisture': data, 'user': user}, files = pic_file)

        print("Upload Complete!\n")


def postToDB(data, pathFile, dateTime):
        print("Uploading...\n")

        filestack_url = 'http://hoykhom-bot.herokuapp.com/dataIn'

        #print(filestack_url)
        #print(pathFile)

        pic_file = {'file': open(pathFile, 'rb')}

        r = requests.post(filestack_url, data={'s_moisture': data}, files = pic_file)

        print("Upload Complete!\n")


def readSoilMoisture():
        ser = serial.Serial(                    #Setup UART spec ; $ ls /dev/ >>> 'Check PORT'
                port = "/dev/ttyACM0",
                baudrate = 115200,
                parity = serial.PARITY_NONE,
                stopbits = serial.STOPBITS_ONE,
                bytesize = serial.EIGHTBITS,
                timeout = 2.0
        )

        for i in range (0,5):
                moisture = ser.read(1)

        ser.close()

        data = str(ord(moisture)*4)
        print("RECIEVE_DATA::::: "+data+"\n")
        return data


##########################################################################################################


client = mqtt.Client()
# Assign event callbacks
client.on_message = on_message
client.username_pw_set("mypi", "test1234")
client.connect('m13.cloudmqtt.com', 11675, 60)

client.loop_start()

client.subscribe("/LINE/REALTIME" ,0 )
run = True
count = 0
while run:
        count += 3