import sys
from time import *
import serial
import modbus_tk
import modbus_tk.defines as cst
from modbus_tk import modbus_rtu

PORT = '/dev/ttyACM0' # PORT THAT STM32 CONNECT WITH RPi
def readSerial(deviceAddress):
        """main"""
       logger = modbus_tk.utils.create_logger("console")

       try:
       #Connect to the slave
       master = modbus_rtu.RtuMaster(
               serial.Serial(	port=PORT, 
               					baudrate=115200, 
               					bytesize=8, 
               					parity='N', 
               					stopbits=1, 
               					xonxoff=0
               				)
       )
       master.set_timeout(5.0)
       master.set_verbose(True)
       logger.info("connected")

       #logger.info(master.execute(add, cst.READ_INPUT_REGISTERS, 0, 1))
       data = master.execute(deviceAddress, cst.READ_INPUT_REGISTERS, 0, 1)
       print "Modbus Data : " + str(data[0])

       except modbus_tk.modbus.ModbusError as exc:
               logger.error("%s- Code=%d", exc, exc.get_exception_code())

      return data