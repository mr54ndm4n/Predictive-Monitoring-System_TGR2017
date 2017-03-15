from picamera import PiCamera
from time import *

def TakePic():
        camera = PiCamera()
        resolution = (640, 480)

        takeTime = strftime("%d-%m-%Y %H:%M:%S", localtime())
        path = "/home/pi/Pictures/"+takeTime+".jpg"

        print("TAKING PICTURE...")
        camera.capture(path)
        print("COMPLETE TAKE PICTURE!\n")
        
        return path
