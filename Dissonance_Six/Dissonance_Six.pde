//OpenNI for Kinect MiddleWare link
import SimpleOpenNI.*;
SimpleOpenNI kinect;

// number of tree objects per person - the final work requires six
int NumTrees = 2;
//Tree Objects
OneTree[] trees = new OneTree[NumTrees];
//Variables for Tree Objects
float[] Xs = new float[NumTrees];
float[] Ys = new float[NumTrees];
float[] Zs = new float[NumTrees];
float[] Ls = new float[NumTrees];
float[] pXs = new float[NumTrees];
float[] Xspeed = new float[NumTrees];
float[] pXspeed = new float[NumTrees];
float[] aXspeed = new float[NumTrees];
boolean[] active = new boolean[NumTrees];
// Transfer variables
float theta;   
float myX;
float myY;
float myZ;
long myUsers;
//Boolean for when leaves move off branches
boolean leavesFall = false;
float baseLen = 120;
//float leafVar = 0;

void setup() {
  size(800, 600, P3D);
  smooth();
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_NONE);
  
  for (int i = 0; i < trees.length; i ++ ) { 
    trees[i] = new OneTree();
  }
}

void draw() {
  background(0);
  // set defaults for non active trees
  for (int i = 0; i < NumTrees; i++) {
    Xs[i] = 0;
    Ys[i] = 0;
    Zs[i] = 0;
    aXspeed[i] = 0;
    active[i] = false;
  }
  
  // get's user information from Kinect
  kinect.update();
  //image(kinect.depthImage(), 0, 0);
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  myUsers = userList.size();
 
//move leaves based on tree limit
    if(myUsers == NumTrees){
      leavesFall = true;
    } else {
      leavesFall = false;
    }  
    
 // only assign draw for users
  for (int i=0; i<userList.size(); i++) {
    int userId = userList.get(i);
    PVector position = new PVector();
    kinect.getCoM(userId, position);
    kinect.convertRealWorldToProjective(position, position);
    //textSize(40);
    //text(userId, position.x, position.y-20);
    
    // only draw with in tree limit
   if(myUsers <= NumTrees){
    // variable assignment
    myX = position.x;
    myY = position.y;
    // position user "tree" on screen width or height
    myZ = map(position.z, 500, 2000, 400, 0);
    // direction and speed previous assignment of tree's
    pXs[i] = Xs[i];
    pXspeed[i] = Xspeed[i];
    // drawing loctions
    Xs[i] = myX;
    Ys[i] = height-100;
    Zs[i] = myZ;
    Ls[i] = (map(position.z, 500, 2000, 0, 100))*myUsers;
    Xspeed[i] = dist(pXs[i], 0, Xs[i], 0);
    aXspeed[i] = ((pXspeed[i] -Xspeed[i])*0.03);
    // active for angles and leaves
    active[i] = true; 
   }
  }
  // run for tree's with a push / pop matirx for all active users
  for (int ii =0; ii < NumTrees; ii++) {
    // draw in place based on user position if active
    pushMatrix();
    translate(Xs[ii], Ys[ii], Zs[ii]);
    if(active[ii]){
    trees[ii].drawBase(myUsers*6, aXspeed[ii], baseLen);
    trees[ii].leaves(baseLen, aXspeed[ii], Ls[ii]);
    } else {
     trees[ii].drawBase(0, 0, baseLen);
      pXs[ii] = 0;
     Xspeed[ii] = 0;
     pXspeed[ii] = 0;
    }
    popMatrix();
  }
}

// test for leaves on or off (if you don't have more than one person around when testing.
void keyPressed(){
  if(key == 'f'){
    leavesFall = true;
  }
  if(key == 'g'){
    leavesFall = false;
  }
}




