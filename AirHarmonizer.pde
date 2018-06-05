import processing.serial.*;
import java.util.Random;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

Serial myPort;  // The serial port
int dim = width;
int w_canvas = 1920;
int h_canvas = 1080;
color[] rectCol = new color[5];


void setup() {
  // Serial data setup
  // List all the available serial ports
  printArray(Serial.list());
  // Open the port you are using at the rate you want:
  //myPort = new Serial(this, Serial.list()[4], 115200);
  myPort = new Serial(this, Serial.list()[4], 9600);

  
  // Setup of OSC messaging
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  //myRemoteLocation = new NetAddress("127.0.0.1",57121);
  myRemoteLocation = new NetAddress("127.0.0.1",57120);
  
  // Visualization Setup
  //size(1200, 600);
  fullScreen();
  background(0);
  colorMode(RGB);
  noStroke();
  ellipseMode(RADIUS);
  frameRate(125);
  
  rectCol[0] = color(229, 49, 46); 
  rectCol[1] = color(227, 46, 176); 
  rectCol[2] = color(163, 46, 227); 
  rectCol[3] = color(46, 82, 227); 
  rectCol[4] = color(46, 213, 227); 
}

void draw() {
  while (myPort.available() > 0) { // questo ciclo dentro draw potrebbe essere un errore, facci caso
    String inBuffer = myPort.readString();
    inBuffer = inBuffer.substring(2);
    String[] parts = inBuffer.split("\t");
    
    //int foo = Integer.parseInt(parts[0]);
    
    int S1, S2, S3, S4, S5;
    
    S1 = Integer.parseInt(parts[1]);
    S2 = Integer.parseInt(parts[2]);
    S3 = Integer.parseInt(parts[3]);
    S4 = Integer.parseInt(parts[4]);
    S5 = Integer.parseInt(parts[5]);
    
    //println(S1, S2, S3, S4, S5);
    int[] sensor = new int[]{S1, S2, S3, S4, S5};
      
    // define random position generator
    //Random rand = new Random();
       
    // Draw something
    background(0);
    for (int i = 0; i < 5; i++) {
      //int x = rand.nextInt(w_canvas - 30) + 30;
      //int y = rand.nextInt(h_canvas - 30) + 30;
    //  drawGradient(x, y, sensor[i]);
    
      if (sensor[i]>0){
        drawBar(i,sensor[i]);
      }
      else{
        sensor[i]=0;
      }
    } 
    
    
    OscMessage myMessage = new OscMessage("/chord");
    ////myMessage.add(mouseX/(float)width);
    ////myMessage.add(mouseY/(float)height);
    //float MAX = 0;
    //int indexMAX = 0;    
    //for (int i =0; i<5; i++){
    //  if (sensor[i] > MAX){
    //    MAX = sensor[i];
    //    indexMAX = i;
    //  }
    //}
    
    //myMessage.add(indexMAX);
    //myMessage.add(MAX);
    
    myMessage.add((float)sensor[0]);
    myMessage.add((float)sensor[1]);
    myMessage.add((float)sensor[2]);
    myMessage.add((float)sensor[3]);
    myMessage.add((float)sensor[4]);
    oscP5.send(myMessage, myRemoteLocation); 
  }
}

//void drawGradient(float x, float y, int h) {
//  int radius = dim/2;

//  for (int r = radius; r > 0; --r) {
//    fill(h, 90, 90);
//    ellipse(x, y, r, r);
//    h = (h + 1) % 360;
//  }
//}

void drawBar(int i, int hh){
    float x = ((w_canvas-80)/5)*i+80;
    float h = h_canvas;
    float w = 200;
    float y = map(hh,400,40,h_canvas,0);
    fill(rectCol[i]);
    rect(x,y,w,h);
}
