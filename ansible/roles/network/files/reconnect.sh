#!/bin/bash
ping -c 1 192.168.3.1
test $? -eq 1 && ifconfig wlan0 up
