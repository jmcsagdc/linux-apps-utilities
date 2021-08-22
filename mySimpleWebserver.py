# Adapted from https://pythonbasics.org/webserver/ with a bunch of my junk thrown in

# To test this, use a separate shell and either run this code block in python directly or as its own script:
# (you may need to pip install requests if you haven't already...)
#
# import requests
# for i in range (0, 30):
#     requests.get("http://127.0.0.1:8080").text
#
# Output is something like this:
# 
# u'Host606'
# u'Host209'
# u'Host123'
# u'Host209'
# u'Host209'
# [...]

# Python 3 server example
from http.server import BaseHTTPRequestHandler, HTTPServer
import time, random, os

hostName = "localhost"
serverPort = 8080
theDoors=["Host123","Host303","Host209", "Host5", "Host606"]

def randomizedMessage(myChoiceIndex):
    # myChoiceIndex = random.randint(0,2)
    return theDoors[myChoiceIndex]

class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        myChoiceIndex = random.randint(0,4)
        myMessage=randomizedMessage(myChoiceIndex)
        httpDocument = myMessage #"<p>"+myMessage+"</p>"
        # Log it to a temp file:
        outLogLine='echo '+myMessage+ ' >> LOG.txt'
        os.popen(outLogLine)
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        #self.wfile.write(bytes("<html><head><title>https://pythonbasics.org</title></head>", "utf-8"))
        #self.wfile.write(bytes("<p>Request: %s</p>" % self.path, "utf-8"))
        #self.wfile.write(bytes("<body>", "utf-8"))
        self.wfile.write(bytes(httpDocument, "utf-8"))
        #self.wfile.write(bytes("<p>This is an example web server.</p>", "utf-8"))
        #self.wfile.write(bytes("</body></html>", "utf-8"))



if __name__ == "__main__":
    webServer = HTTPServer((hostName, serverPort), MyServer)
    print("Server started http://%s:%s" % (hostName, serverPort))
    # This prints the contents of the list theDoors using the function:    randomizedMessage()
    # This prints a handle of the execution of the function randomizedMessage: print(randomizedMessage)

    try:
        webServer.serve_forever()
    except KeyboardInterrupt:
        pass

    webServer.server_close()
    print("Server stopped.")
