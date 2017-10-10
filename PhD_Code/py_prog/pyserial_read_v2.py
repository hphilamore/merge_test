import serial
ser = serial.Serial('/dev/ttyUSB0', 9600, 5)  # open first serial port
print ser.name          # check which port was really used
#ser.write("hello")      # write a string
state=ser.read(1)
print(state)
ser.close()             # close port
