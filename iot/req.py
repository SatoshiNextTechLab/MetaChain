#Library Setup
import requests
import RPi.GPIO as GPIO

#Api Setup
port = 'https://fathomless-beach-44318.herokuapp.com/api/iot'

#RPi Setup
pin = 18
led = 17

GPIO.setmode(GPIO.BCM)
GPIO.setup(pin, GPIO.IN)
GPIO.setup(led, GPIO.OUT)
GPIO.output(led, GPIO.LOW)

#Request Handler Function
def mainreq():
    r = requests.get(port , auth=('', ''))
    return (r) 

# Main Loop
while 1:
    if GPIO.input(pin):
        GPIO.output(led, GPIO.HIGH)
        iot = mainreq();
        print (iot.text + "\n" + iot.response)
    else:
        GPIO.output(led, GPIO.LOW)
