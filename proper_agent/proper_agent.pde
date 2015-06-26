

import controlP5.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import peasy.*;

ArrayList <Agent> agents = new ArrayList<Agent>();
ArrayList <Vec3D> pts = new ArrayList<Vec3D>();
Vec3D[] bounds = new Vec3D[2];
Vec3D dimW = new Vec3D(600,400,300);
float r = 250;
int numAg = 350;
int nPts = 7;
//int cols = 40;
///int rows = 60;
Field field;
Path p;
PeasyCam cam;

void setup() {
  size(800, 800, P3D);
  //size(displayWidth-20, displayHeight-80, P3D);
  smooth(4);
  new PeasyCam(this, 1000);
  //colorMode(HSB);
  // init bounds
  bounds[0] = new Vec3D(-dimW.x*.5,-dimW.y*.5, -dimW.z*.5);
  bounds[1] =  new Vec3D(dimW.x*.5,dimW.y*.5, dimW.z*.5);
  // init field
  field = new Field(5, 5, 0.02);

  // init agents
  for (int i=0; i<numAg; i++) {
    //agents.add(new Agent(new Vec3D(width*.5, height*.5, 0), new Vec3D(random(-5, 5), random(-5, 5), 0)));
    // agents.add(new Agent(new Vec3D(random(width), random(height), 0), new Vec3D(random(-5, 5), random(-5, 5), 0)));
    agents.add(new Agent(new Vec3D(width*.5, height*.5, 0), new Vec3D(random(-5, 5), random(-5, 5), random(-5, 5))));
  }

  // init Path
  float ang = TWO_PI/(float)nPts;
  for (int i=0; i< nPts; i++) {  
    //pts.add (new Vec3D(r*cos(ang*i), r*sin(ang*i), noise(ang*i*0.5-PI)*sin(ang*i*2)*100));
    pts.add (new Vec3D(width*.5+(r+random(-50, 50))*cos(ang*i), height*.5+(r+random(-50, 50))*sin(ang*i), 0));
  }
  p = new Path(pts, 20);
}

void draw() {

  /* if (frameCount<300)*/  background(221);

  // environment

  pushStyle();
  noFill();
  stroke(0, 40);
  strokeWeight(.5);
  box(dimW.x, dimW.y, dimW.z);
   //field.noiseField(frameCount*0.005);
   //field.displayField(50);
  /*if (frameCount<300-50)  p.display();*/
  // fill(80, 50);
  // noStroke();
  // ellipse(mouseX, mouseY, agents.get(0).arriveDist, agents.get(0).arriveDist);
  popStyle();
  
  // control agent's behavior

  for (Agent a : agents) {
    //a.seek(new Vec3D(mouseX, mouseY, 0),mousePressed?-1:1, 0.1);
    //a.arrive(new Vec3D(mouseX, mouseY, 0));
    // a.wander(20);
    // path, sign (direction), attraction force
    // a.followPath(p, 1, 5);
    a.run(agents, bounds);
  }
}

boolean sketchFullScreen() {
  return false;
}
