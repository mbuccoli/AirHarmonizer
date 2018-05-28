
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;
int oldZone=-1;
float rotMin=0;
float rotMax=0;

int portIn=55000;
int portOut=57120;
//String myaddr="192.168.137.1";
float[] freqRatios =new float[12];
OscMessage buildHandMessage(OscMessage handMessage, boolean found, PVector position, PVector rotation){  
  handMessage.add(int(found));
  float[] pos=position.array();
  float P0=map(pos[0], 0, 1200, 0, 1);
  float P1=map(pos[1], 100, 800, 1, 0);
  float P2=map(pos[2], 15, 70, 0, 1);
  float[] P={P0,P1,P2};
  for (int i=0; i<3; i++){
    float p=P[i];
    if(P[i]<0 ){p=0;}
     if(P[i]>1 ){p=1;}
     handMessage.add(p);
  }
  float[] rot= rotation.array();
  float fact=0.8;
  for (int i=0; i<3; i++){    
    float r=map(rot[i],-90,90,-1,1);
     if(r<-fact){r=-fact;}
     if(r>fact ){r=fact;}
     handMessage.add(r/fact);
  }
  return handMessage;
  
}

void draw() {
//  frameRate(leap.getFrameRate());
  background(255);
  int vgreen=floor(map(centre, 0.1,0.5,255,0));
  int vred=floor(map(centre, 0.5,1,0,255));
  
  
  fill(vred,vgreen,0);
  stroke(0);
  rect(0,0, 640, 240);
  /*OscMessage handMessage = new OscMessage("/hand");
  handMessage = buildHandMessage(handMessage, leftFound, leftPosition, leftRotation);
  handMessage = buildHandMessage(handMessage, rightFound, rightPosition, rightRotation);
  handMessage.print();  
  oscP5.send(handMessage, myRemoteLocation);*/
}
float centre=1;
void convertAndSend(float rotX, float rotY, float rotZ){  
  int zone=0;
  if(rotX<-0.4 && abs(rotY)<0.4){zone=1;}
  else if(rotX>0.4 && abs(rotY)<0.4){zone=2;}
  else if(rotY<-0.4 && abs(rotX)<0.4){zone=3;}
  else if(rotY>0.4 && abs(rotX)<0.4){zone=4;}
  else if(abs(rotX)>0.4 && abs(rotY)>0.4){zone=5;}
  centre=sqrt(rotX*rotX+rotY*rotY+rotZ*rotZ);
  
  if(zone==oldZone){return;}
  oldZone=zone;
  println("Zone :"+str(zone));
  
  float secondGrade=1.0;
  float thirdGrade=1.0;
  float fourthGrade=2.0;
  if(zone==1){secondGrade=freqRatios[3]; thirdGrade=freqRatios[6];}  
  else if(zone==2){secondGrade=freqRatios[2]; thirdGrade=freqRatios[6];}
  else if(zone==3){secondGrade=freqRatios[3]; thirdGrade=freqRatios[6]; fourthGrade=freqRatios[10];}
  else if(zone==4){secondGrade=freqRatios[4]; thirdGrade=freqRatios[6]; }
  OscMessage chord = new OscMessage("/chord");
  chord.add(secondGrade);
  chord.add(thirdGrade);
  chord.add(fourthGrade);
  oscP5.send(chord, myRemoteLocation);
}


void setup() {
  size(640 , 480);
  background(255);
  oscP5 = new OscP5(this,portIn);
  myRemoteLocation = new NetAddress("127.0.0.1",portOut);
  for(int i=0; i<12; i++){
    freqRatios[i]=pow(2,(i+1.0)/12);  // MOST IMPORTANT LINE to get the ratio, which is basically 2^(i/12), where i= number of semichromes of intervals
    
  }
}



 //incoming osc message are forwarded to the oscEvent method.
void oscEvent(OscMessage theOscMessage) {
  //print("### received an osc message.");
  //println(" addrpattern: "+theOscMessage.addrPattern());
  //println(" typetag: "+theOscMessage.typetag());
  float rotX=theOscMessage.get(0).floatValue();
  float rotY=theOscMessage.get(1).floatValue();
  float rotZ=theOscMessage.get(2).floatValue();
  
  print(" X "+ str(rotX));
  print(" Y "+ str(rotY));
  println(" Z "+ str(rotZ));
/*  if(rotX>rotMax){rotMax=rotX;}
  if(rotY>rotMax){rotMax=rotY;}
  if(rotZ>rotMax){rotMax=rotZ;}
  if(rotX<rotMin){rotMin=rotX;}
  if(rotY<rotMin){rotMin=rotY;}
  if(rotZ<rotMin){rotMin=rotZ;}*/
  //print("Range: min= "+str(rotMin));
  //println(" max= "+str(rotMax));
  convertAndSend(rotX,rotY,rotZ);
}
 