// MyServer is a java webserver. Start it in a console
// Use a browser and go to 127.0.0.1:8080

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.util.Random;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

public class MyServer {

    public static void main(String[] args) throws IOException {
        int serverPort = 8080;
        HttpServer server = HttpServer.create(new InetSocketAddress(serverPort), 0);
        server.createContext("/", new MyHandler());
        server.setExecutor(null);
        server.start();
        System.out.println("Server started http://localhost:" + serverPort);
    }

    static class MyHandler implements HttpHandler {
        private int arrayInstancesCounter = 0;

        @Override
        public void handle(HttpExchange exchange) throws IOException {
            Runtime runtime = Runtime.getRuntime();
            long totalMemory = runtime.totalMemory();
            long freeMemory = runtime.freeMemory();

            Random random = new Random();
            int myChoiceIndex = random.nextInt(5);
            String myMessage = randomizedMessage(myChoiceIndex);
            String httpDocument = myMessage;

            String outLogLine = "echo " + myMessage + " >> LOG.txt";
            runtime.exec(outLogLine);

            exchange.sendResponseHeaders(200, httpDocument.length());
            OutputStream outputStream = exchange.getResponseBody();
            outputStream.write(httpDocument.getBytes());
            outputStream.close();
           
            /*
                This is debugging info to get a sense of performance
                differences from the python3 version I typically use
            */
             arrayInstancesCounter++;
            System.out.println("Array instances created: " + arrayInstancesCounter);
            System.out.println("Total Memory: " + totalMemory);
            System.out.println("Free Memory: " + freeMemory);
        }
    }

    private static String randomizedMessage(int myChoiceIndex) {
        String[] theDoors = { "Host123", "Host303", "Host209", "Host5", "Host606" };
        return theDoors[myChoiceIndex];
    }
}
