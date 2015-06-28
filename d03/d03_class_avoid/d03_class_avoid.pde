
import toxi.geom.*;
import processing.dxf.*;

// this is a single line comment
// variables declaration
boolean recDxf = false;
int sizeX = 900;
int sizeY = 700;
int nBalls = 0;
float xPos = 300;
float yPos = sizeY/2; // in the middle of the canvas
float speed = 1.5;
Ball b; // declaration: "you know, I think I REALLY need a new Ball!"
//   flag <type>  name
//          |     |
ArrayList<Ball> bColl; //flagged arraylist declaration: "you know, I think I REALLY need a new Ball collection!"

ArrayList<Line> lColl;

// void: no output data - the function will not output a value
//       no input data needed
//         |
void setup() {
  size(sizeX, sizeY, P3D);
  background(221);

  bColl = new ArrayList<Ball>(); // instantiation: "Ok guys, this is where my collection is going to be hosted!"
  lColl = new ArrayList<Line>();
  // a = a+1; <> a +=1; <> a++;
  for (int i=0; i<nBalls; i++) {
    float r = random(15, 40);
    //Vec3D loc = new Vec3D(random(r, width-r), random(r, height-r), 0);
    Vec3D loc = new Vec3D(width/2+random(-10, 10), height/2+random(-10, 10), 0);
    b = new Ball(loc, r, color(random(255), 0, 0, random(20, 180)));// instantiation
    bColl.add(b); // add to collection
  }
}

void draw() {
  if (recDxf == true) {
    beginRaw(DXF, "dxfOut/lines.dxf");
  }
  background(221);
  // 

  for (int i=0; i< bColl.size (); i++) {
    b = bColl.get(i); // pick the i-th element of the collection
    b.update();       // call its update() function
  }
  color a = color(#D3E029, 60);
  color b = color(0, 60);
  for (int i=0; i< lColl.size (); i++) {
    float r = i/(float)lColl.size();
    Line l = lColl.get(i);
    l.display(1, lerpColor(a, b, r));
  }

  if (recDxf==true) {
    endRaw();
    recDxf = false;
    println("DXF file saved");
  }
}

// ..........................................................................................................

void mouseDragged() {
  if (mouseButton==LEFT) {
    Vec3D loc = new Vec3D(mouseX, mouseY, 0);
    b = new Ball(loc, random(5, 50), color(random(255), 0, 0, random(20, 180)));// instantiation
    bColl.add(b); // add to collection
  }
}
