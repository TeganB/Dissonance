// tree object
class OneTree {
  
    color treeStroke;
    float treeBase;
    float treeLen;
    float treeTheta;
    float fallY = 0;
    float branchAngle;
    float Angle;
    
  OneTree(){
  treeStroke = color(255,255,255,100);
  treeBase = 10;
  }
 
 // drawing the trunk of the tree and branches coming off it 
 void drawBase(float Ang, float tAng, float tLen){
   Angle = Ang;
   branchAngle = tAng;
   treeLen = tLen;
   stroke(treeStroke);
   strokeWeight(treeBase);
  float a = Angle;
  // Convert it to radians
  treeTheta = radians(a);
  line(0,0,0,-treeLen);
  // Move to the end of that line
  translate(0,-treeLen);
  // Start the recursive branching!
  branch(treeLen);
  }
  
 //Branch recurision - angle based on number of people in the scene
  void branch(float h) {
  // Each branch will be 2/3rds the size of the previous one
  h *= 0.66;
  // the exit condition if the branch reaches a 5 pixel width
  if (h > 5) {
    pushMatrix();
    rotate(treeTheta + branchAngle);
    strokeWeight(h/10);
    stroke(treeStroke);
    line(0, 0, 0, -h);  
    translate(0, -h);
    branch(h);
    popMatrix();     
    
    // repeating on the left branch
    pushMatrix();
    rotate(-treeTheta + branchAngle);
    strokeWeight(h/15);
    stroke(treeStroke);
    line(0, 0, 0, -h);
    translate(0, -h);
    branch(h);
    popMatrix();
  }
}

// Leaves that are attached to the branches
void leaves(float h, float leafAngle, float tri3) { 
  h *= 0.66;
  if (h > 3) {
    float base = 10;
    float baseL = constrain(tri3, 0, 1000);
    pushMatrix();
    rotate(treeTheta + leafAngle);
    translate(0, (-h)); 
    leaves(h, leafAngle, tri3); 
    popMatrix();  
    
    // restricting the movement fo the leaves when they fall
    if(leavesFall && fallY<height){
    //println(leavesFall);
    fallY = fallY + 0.02;
    }
    
    if(!leavesFall && fallY > 0){
    fallY = fallY - 0.02;
    }    
    
    pushMatrix();
    rotate(-treeTheta + leafAngle);
    translate(0, (-h));
    leaves(h, leafAngle, tri3);
    
    //yellow leaves
    noStroke();
    fill(255,255, 0, 50);
    triangle(-5-fallY, 0-fallY, 5-fallY, 0-fallY, 0-fallY, -baseL-fallY);
    //treeline
    strokeWeight(2);
    stroke(12,192,245,100);
    line(-base+fallY, fallY, base+fallY, base+fallY);
    popMatrix();
  }
  
}
  
 
}
