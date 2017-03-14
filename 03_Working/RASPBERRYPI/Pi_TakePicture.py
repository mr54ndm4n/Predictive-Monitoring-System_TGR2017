from picamera import PiCamera
from time import *

camera = PiCamera()
resolution = (640, 480)

takeTime = strftime("%d-%m-%Y %H:%M:%S", gmtime())

camera.capture("/home/pi/Pictures/"+takeTime+".jpg")
