import SimpleOpenNI.*;
SimpleOpenNI kinect;

import ddf.minim.*;
Minim minim;
AudioPlayer player;
AudioPlayer player1;
PImage picture;
PImage p2;
PVector convertedLeftHand= new PVector();
int w= 50;
int offset;
void setup() {
  minim = new Minim(this);
  player = minim.loadFile("sniper.mp3");  
  player1 = minim.loadFile("headshot.mp3"); 
  picture= loadImage("p1.jpg");
  p2= loadImage("p2.png");
  size(640, 480);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableRGB();
  
  //enable tracking interface
  kinect.enableUser();

}

void draw() 
{
  
  int interpolatedX, interpolatedY;
  
  kinect.update();
  PImage depth= kinect.depthImage();
  PImage k_RGB= kinect.rgbImage();
  //image(depth, 0,0 );
  image(k_RGB, 0, 0);
  IntVector userList= new IntVector();
  
  //write a list of detected Users into the vector
  kinect.getUsers(userList);
  
  //if users are found
  if (userList.size() > 0) {
    int userId = userList.get(0);
    
    //if succesfully calibrated
    if( kinect.isTrackingSkeleton(userId)) {
      PVector leftHand= new PVector();
      float confidence = kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_NECK, leftHand);
      
    //convert hand position to coordinates
    PVector convertedLeftHand = new PVector();
    kinect.convertRealWorldToProjective(leftHand, convertedLeftHand);    
    fill(255,0,0);
    
    if(confidence > 0.5) {
      ellipse(convertedLeftHand.x, convertedLeftHand.y,20,20);
      println(convertedLeftHand.x + " " +convertedLeftHand.y);
      sniper(mouseX, mouseY);
      if(mousePressed){
      if(((mouseX < (convertedLeftHand.x+w))
          &&(mouseX > (convertedLeftHand.x-w)))&&
          ((mouseY > ((convertedLeftHand.y -30)-w))
           &&(mouseY < ((convertedLeftHand.y -30)+w)))) {
            player.rewind();
            player.play();
            
            player1.rewind();
            player1.play();
            
           
      }else{
        player.rewind();
       player.play();
        
      }
    }
   
  }
  }
  }
}






  
  /*
if(((mouseX < (convertedLeftHand.x+w))
&&(mouseX > (convertedLeftHand.x-w)))&&
((mouseY > (convertedLeftHand.y-w))
&&(mouseY < (convertedLeftHand.y+w))))
  */
  
  
//user-tracking callbacks

void onNewUser(SimpleOpenNI curkinect,int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  kinect.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curkinect,int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curkinect,int userId)
{
  //println("onVisibleUser - userId: " + userId);
}



  void sniper(float x, float y) 
{
  noFill();
  strokeWeight(3.5);
  ellipse(x, y, 50 ,50);
  line(x, y-75, x, y-10);
  line(x, y+75, x, y+10);
  line(x+75, y, x+10, y);
  line(x-75, y, x-10, y);
}

void smile(float x, float y){
  imageMode(CENTER);
  image(p2, x, y);
}
  
