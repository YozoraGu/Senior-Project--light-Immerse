import processing.sound.*;
import oscP5.*;
import netP5.*;
Cell cell;
int nbCell = 0;
OscP5 oscP5Location2;
NetAddress location1;
SoundFile file;
float x1;
float y1;
float x2;
float y2;
void setup() {
  frameRate(60);
  //size(1920,1080);
  fullScreen(2);//3860x1080
  smooth(8);
  colorMode(HSB, 300, 100, 100);
  OscProperties myProperties = new OscProperties();
  // increase the datagram size to 10000 bytes
  // by default it is set to 1536 bytes
  myProperties.setDatagramSize(1000000); 
  myProperties.setListeningPort(6001);
  oscP5Location2=new OscP5(this,myProperties);
  cell = new Cell(new PVector(width*0.5, height*0.5), 200);
  textSize(30);
  file= new SoundFile(this,"bubble.mp3");
}
 
 
void draw() {
  background(0);
  fill(100,0,100);
  text("bubbles: " + nbCell,50,50);
  println(frameRate);
  println(width,height);
  println("x1"+":"+x1,"y1"+":"+y1);
  println("x2"+":"+x2,"y2"+":"+y2);
  cell.run();
  noStroke();
  fill(300,100,100);
  rect(x2-20,y2-20,10,40,18);
  float ex = 1;
  if (x1>= width*1/2 && y1<=height*3/4 && y1>= height*1/4) //go right
  {
    cell.applyForce(new PVector(noise(frameCount*0.1)*ex, 0));
  }
 
  else if (y1>=height*3/4) //go down
  {
    cell.applyForce(new PVector(0, noise(frameCount*0.1)*ex));
  }
 
  else if (x1<=width*1/2 && y1<=height*3/4 && y1>= height*1/4 ) //A, left
  {
    cell.applyForce(new PVector(noise(frameCount*0.1)*-ex, 0));
  }
 
  else if (y1<=height*1/4 )  // go up
  {
    cell.applyForce(new PVector(0, noise(frameCount*0.1)*-ex));
  }
 
  if (keyPressed && key == 'r') {
    cell.slideTowardMouse();
  }
 
  if (nbCell>8500 ){
    colorMode(HSB,random(0,360),100,100);
    cell.Clear();
    nbCell=0;
  }
    
}
void oscEvent(OscMessage theOscMessage) {  
  float incomingMouseX = theOscMessage.get(0).floatValue();
  float incomingMouseY = theOscMessage.get(1).floatValue();
  float incomingMouseX2 = theOscMessage.get(2).floatValue();
  float incomingMouseY2 = theOscMessage.get(3).floatValue();
  // print out the message
 // print("OSC Message Received: ");;
  x1=incomingMouseX*6;
  y1=incomingMouseY*3;
  //x1,y1 direction
  x2=incomingMouseX2*6;
  y2=incomingMouseY2*3;
  //x2,y2 the location of slush sticker
}