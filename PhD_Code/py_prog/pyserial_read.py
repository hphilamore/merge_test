import serial
#ser = serial.Serial('/dev/ttyACM0', 9600)
ser = serial.Serial('/dev/ttyUSB0', 9600)
while True :
    try:
        state=serial.read()
        print(state)
    except:
        pass