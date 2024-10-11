## This is a networking example for IOS

UDP, which means User Datagram protocol, just sends data.
TCP, which mean Transmission Control Protocol, sends the data, but ensures that it gets sent.

## Python Scripts folder.
Of course, you will need the python code to be ran on a Rasberry Pi.
With the port and ip specified, it should send a message to that specific Port and IP.

That's really about it, the rest is for you to experiment with. It's like Dark Souls, you gotta grind and learn to gain victroy over an obstacle. 

* There is also an Iphone for those who are coding with IOS devices.

## NOTES:
_For Python_
* SOCK_DGRAM == UDP
* SOCK_STREAM == TCP


## TCP Sender Example

How to use:

1. Make sure to connect your iPhone and your Raspberry Pi to the same network.
2. Retrieve the IP address of your Raspberry Pi. You can do this by running the following command on your Raspberry Pi:
> ifconfig
Usually, the IP address is listed under **wlan0** as **inet**
3. Locate the necessary Python script. The script is called TCP_Example.py in the Python_Scripts folder.
4. Edit line 9 on TCP_Example.py and replace the string of the IP address with the IP address of your Raspberry Pi.
6. Transfer the neccessary python script to the Raspberry Pi.  I recommend using an app called [Termius](https://termius.com/)
7. Start the server on the Raspberry Pi. Go to the same directory you transferred TCP_Example.py and run the following command in the terminal:
> python3 TCP_Example.py
8. Run the UDP_Ios_app
9. Navigate to the Sender tab
10. Press "Connect"
11. Press "Send Message"
