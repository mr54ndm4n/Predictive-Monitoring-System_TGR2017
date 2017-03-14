import serial
import time

ser = serial.Serial(
        port = "/dev/ttyUSB0",
        baudrate = 115200,
        parity = serial.PARITY_NONE,
        stopbits = serial.STOPBITS_ONE,
        bytesize = serial.EIGHTBITS,
        timeout = 5.0,
)

data = ser.read(1)
data = str(ord(data))

if data == 'c' or data == 'C':
	print("Success!")
else:
	print("Fail!!!!!!!!!")

print("Receive data:>> " + data)
ser.close()

