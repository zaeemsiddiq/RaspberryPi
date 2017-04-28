# RaspberryPi
## Description
This is nodejs script used to run on raspberrypi which was attached to a camera and an ultrasonic motion sensor. 
The IOT callibrates itself for 10 seconds by averaging motion sensor values and sets a threshold. On exceeding the threshold value, it generates a push notification and starts a live camera feed via HTTP multicast.
Created an iphone application for the purpose of viewing camera feed and receiving notifications
