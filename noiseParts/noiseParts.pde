import toxi.geom.*;
import processing.pdf.*;
import peasy.*;

// float[] a = new float[100];           // array definition
// float[][] a = new float [100][50];    // array instantiation

int nPoints = 300, maxFrames = 200;
float thres= 20;
PeasyCam cam;
boolean calcLines = true;
Part[] pts = new Part[nPoints];
ArrayList<Line> lines = new ArrayList<Line>();
Vec3D loc;

void setup() {

  size(1280, 800, P3D);
  smooth();
  cam = new PeasyCam (this, width*.5, height*.5, 0, 1000);
  //noiseSeed(round(random(1000))); // seed for noise function
  noiseDetail(8, 0.5);              // detail for noise function
  for (int i=0; i<nPoints; i++) { 
    loc = new Vec3D(width*.5+random(-150, 150), height*.5+random(-150, 150), random(-50, 50));
    pts[i] = new Part(loc, new Vec3D(random(-10, 10), random(-10, 10), random(-10, 20)));
  }

} // end setup

void draw() {
  background(221);
  for (int i=0; i<nPoints; i++) {
    // myPoints[i].lineBetween(myPoints, 20);
    if (frameCount<maxFrames) pts[i].update();
    pts[i].display();
    pts[i].dispTrail();
  }

  if (frameCount > maxFrames) { 
    if (calcLines) {
      cam.beginHUD();
      lineBetween (pts);
      cam.endHUD();
    }
    if (lines != null && lines.size() >0) {
      pushStyle();

      for (Line l : lines) {
        stroke(20, 80);
        strokeWeight(.5);
        l.display();
      }
      popStyle();
    }
  }
} // end draw

void lineBetween(Part[] pts) {
  ArrayList<Vec3D> tra, trb;
  //Vec3D  b;
  float d;
  float tS = pow(thres, 2);
  float l = pts.length;
  pushStyle();
  ellipseMode(CENTER);
  noFill();
  stroke(0, 80);
  strokeWeight(5);
  for (int i=0; i< l; i++) {
    loadGraph((float)i, l, 100);
    // println(i); // cal draw line function instead
    tra = pts[i].trail;
    for (Vec3D a : tra) {
      for (int j=i+1; j<pts.length; j++) {
        trb = pts[j].trail;
        for (Vec3D b : trb) {
          d = a.distanceToSquared(b);
          if (d > tS*0.2 && d< tS) {
            lines.add(new Line(a, b));
          }
        }
      }
    }
  }
  ellipseMode(CORNER);
  popStyle();
  println("done, generated", lines.size(), "lines");
  calcLines = false;
}

void loadGraph(float perc, float total, float size) {
  float ang = perc/total*TWO_PI;
  arc(width*.5, height*.5, size, size, 0, ang);
}

void keyPressed() {
  if (key=='s') {
    saveFrame("images/frame_####.jpg");
  }
}
