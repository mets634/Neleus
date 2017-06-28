from threading import Thread
from scapy.all import *

class HttpSniff(Thread):
    def __init__(self):
        Thread.__init__(self)
        self.__index = 0

    def run(self):
        sniff(iface = "eth0" ,
              prn = self.saveFile ,
              filter = "tcp port 80")

    def saveFile(self,packet):
        wo = packet[TCP].payload
        if(wo.payload == ""):
            return
        my = file("saved/package" + str(self.__index),mode = 'w')
        my.write(str(wo))
        self.__index = self.__index + 1

a = HttpSniff()
a.start()
