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

pathFilePic = "/home/pi/Pictures/"
WIDTH = 100
HIGH = 100

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


def postToDB(data, pathFile, dateTime):
        print("Uploading...\n")

        filestack_url = 'http://hoykhom-bot.herokuapp.com/dataIn'

        #print(filestack_url)
        #print(pathFile)

        pic_file = {'file': open(pathFile, 'rb')}

        r = requests.post(filestack_url, data={'s_moisture': data}, files = pic_file)

        print("Upload Complete!\n")


con = lite.connect('pic.db')    # Database File
def insertDB(DATA, PIC_PATH):
        takeTime = strftime("%d-%m-%Yh%Hm%Ms%S", localtime())
        print("INSERTING DATABASE...")
        with con:
                cur = con.cursor()
                cur.execute( "insert into RPIDB VALUES(NULL, '{}', '{}', '{}');".format(DATA, PIC_PATH, takeTime))
        if con:
                con.close()
        print("COMPLETE INSERTING DATABASE!\n")

        return takeTime


# PORT = '/dev/ttyACM0' # PORT THAT STM32 CONNECT WITH RPi
# def readSerial(deviceAddress):
#         """main"""
#         logger = modbus_tk.utils.create_logger("console")

#         try:
#         #Connect to the slave
#                 master = modbus_rtu.RtuMaster(
#                         serial.Serial(  port=PORT,
#                                         baudrate=115200,
#                                         bytesize=8,
#                                         parity='N',
#                                         stopbits=1,
#                                         xonxoff=0
#                         )
#                 )
#                 master.set_timeout(5.0)
#                 master.set_verbose(True)
#                 logger.info("connected")      

#                 #logger.info(master.execute(add, cst.READ_INPUT_REGISTERS, 0, 1))
#                 master.write(b"-") ####################### Add to test drop one byte read of STM32
#                 data = master.execute(deviceAddress, cst.READ_INPUT_REGISTERS, 0, 1)
#                 print "Modbus Data : " + str(data[0])

#         except modbus_tk.modbus.ModbusError as exc:
#                 logger.error("%s- Code=%d", exc, exc.get_exception_code())

#         return data

def readSoilMoisture():
        ser = serial.Serial(                    #Setup UART spec ; $ demsg | grep tty >>> 'Check PORT'
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
   
        
###################################################################################################################

def main():
        print("\nSTARTING PROCESS...\n")

        urlPic = takePic()
#       data = readSerial(17)
        data = readSoilMoisture()
        dateTime = insertDB(data, urlPic)

        print(dateTime+": Done Local Process!\n")

        print("Start upload data to TGR2017!")
        print("Processing...\n")
        postToDB(data, urlPic, dateTime)

        print("COMPLETE PROCESS!!!\n")

###################################################################################################################
main()