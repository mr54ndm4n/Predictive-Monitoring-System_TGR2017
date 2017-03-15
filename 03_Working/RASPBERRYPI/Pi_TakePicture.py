from picamera import PiCamera
from time import *

def takePic():
	camera = PiCamera()
	resolution = (640, 480)

	takeTime = strftime("%d-%m-%Y %H:%M:%S", localtime())

	path = "/home/pi/Pictures/"+takeTime+".jpg"

	camera.capture(path)
