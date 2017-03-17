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
WIDTH_Preview = 240
HIGH_Preview = 240
WIDTH_Origin = 1024
HIGH_Origin = 1024

# global path_Preview
# global path_Origin

def takePic():
        camera = PiCamera()
        camera.resolution = (WIDTH_Preview, HIGH_Preview)
        camera.brightness = 70
        takeTime = strftime("%d-%m-%Yh%Hm%Ms%S", localtime())
        nameFile_Preview = 's'+takeTime+".jpg"
        # nameFile_Origin = 'b'+takeTime+".jpg"
        path_Preview = pathFilePic+nameFile_Preview
        # path_Origin = pathFilePic+nameFile_Origin
        print("TAKING PICTURE...")
        camera.capture(path_Preview)
        # camera.capture(path_Origin)
        camera.close()
        print("COMPLETE TAKE PICTURE!\n")
        return path_Preview


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

                urlPic = takePic()
                data = readSoilMoisture()
                # data = "496"

                print("COMPLETE PROCESS!!!\n")
        except:

        postRealtime(data, urlPic, message)
##########################################################


def postRealtime(data, pathFile_Preview, user):
        print("Uploading...\n")

        filestack_url = 'http://hoykhom-bot.herokuapp.com/dataRealtime'

        #print(filestack_url)
        #print(pathFile)

        pic_file_Preview = {'file': open(pathFile_Preview, 'rb')}
        # pic_file_Origin = {'file': open(path_Origin, 'rb')}

        r = requests.post(filestack_url, data={'s_moisture': data, 'user': user}, files = pic_file_Preview)

        print("Upload Complete!\n")


def postToDB(data, pathFile_Preview):
        print("Uploading...\n")

        filestack_url = 'http://hoykhom-bot.herokuapp.com/dataIn'

        #print(filestack_url)
        #print(pathFile)

        pic_file_Preview = {'file': open(pathFile_Preview, 'rb')}
        # pic_file_Origin = {'file': open(path_Origin, 'rb')}

        r = requests.post(filestack_url, data={'s_moisture': data}, files = pic_file_Preview)

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


def main():
        print("\nSTARTING PROCESS...\n")

        try:
                path_Preview = takePic()
        #       data = readSerial(17)
                data = readSoilMoisture()
                #data = "276"

                # print(dateTime+": Done Local Process!\n")

                print("Start upload data to TGR2017!")
                print("Processing...\n")
                postToDB(data, path_Preview)

                print("COMPLETE PROCESS!!!\n")
        except:
        #print(str(LED_RED))

##########################################################################################################

#####################################
##              PERIOD             ##
#####################################
from threading import Thread

class PeriodThread(Thread):
    def __init__(self):
        self.stopped = False
        Thread.__init__(self)
    def run(self):
        while not self.stopped:
            self.downloadValue()
            sleep(15)
    def downloadValue(self):
        main()

myThread = PeriodThread()
myThread.start()

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