/**
 * Simple call for agent population with a flocking behavior based on Craig Reynolds
 * more info at www.plethora-project.com
 * requires toxiclibs and peasycam
 */

/* 
 * Copyright (c) 2011 Jose Sanchez
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * http://creativecommons.org/licenses/LGPL/2.1/
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */

//import processing.opengl.
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.processing.*;

import plethora.core.*;

import peasy.*;

ArrayList <Ple_Agent> boids;
//ArrayList <NewAgent> boids;
ArrayList<BoxTail> bTails = new ArrayList<BoxTail>();
PImage logo;
int bFreq = 3, count = 0, maxTail=100;

Vec3D BOX_SIZE = new Vec3D(5, 5, 1);


//using peasycam
PeasyCam cam;

float DIMX = 3600;
float DIMY = 3300;
float DIMZ = 3200;

int pop = 100;

//int[] res;
int cores;
int activeThreads;
ArrayList<String> data;
String fileName = "test";

void setup() {
  size(1200, 600, P3D);
  smooth();
  logo = loadImage("Noobodies_logo_60.png");
  cores = Runtime.getRuntime().availableProcessors();
  activeThreads = 0;

  cam = new PeasyCam(this, 800);

  //initialize the arrayList
  //boids = new ArrayList <Ple_Agent>();
  boids = new ArrayList <Ple_Agent>();
  count=0;
  for (int i = 0; i < pop; i++) {

    //set the initial location as 0,0,0
    Vec3D v = new Vec3D ();
    //create the plethora agents!
    Ple_Agent pa = new NewAgent(this, v);

    //generate a random initial velocity
    Vec3D initialVelocity = new Vec3D (random(-1, 1), random(-1, 1), random(-1, 1));

    //set some initial values:
    //initial velocity
    pa.setVelocity(initialVelocity);
    //initialize the tail
    pa.initTail(5);

    //add the agents to the list
    boids.add(pa);

    // create and add tail
    bTails.add(new BoxTail(this, bFreq));
  }
}

void draw() {
  background(235);
  // buildBox(DIMX, DIMY, DIMZ);
  directionalLight(120,120,120,-1,-1,-1);
  directionalLight(200,200,200,1,1,1);
  lightSpecular(255,255,255);
  specular(255);
  shininess(5.0);
 
  count=0;
  for (Ple_Agent pa : boids) {
    // box tail operations
    BoxTail ba = bTails.get(count);
    if (frameCount > 150 && ba.boxes.size()<maxTail) ba.addBox(pa);
    ba.displayMesh();

    //call flock, cohesion, alignment, separation.
    //first define the population, then the distances for cohesion,alignment, 
    //separation and then the scales in same order. Try playing with the scales and distances!
    pa.flock(boids, 180, 40, 30, 1, 0.4, 1.5);


    //define the boundries of the space:
    pa.wrapSpace(DIMX/2, DIMY/2, DIMZ/2);

    //update the tail info every frame (1)
    pa.updateTail(5);

    //display the tail interpolating 2 sets of values:
    //R,G,B,ALPHA,SIZE - R,G,B,ALPHA,SIZE
    pa.displayTailPoints(0, 0, 0, 0, 1, 0, 0, 0, 255, 1);

    //set the max speed of movement:
    pa.setMaxspeed(3);
    //pa.setMaxforce(0.05);

    //update agents location based on past calculations
    pa.update();

    //Display the location of the agent with a point
    strokeWeight(2);
    stroke(0);
    pa.displayPoint();

    //Display the direction of the agent with a line
    strokeWeight(1);
    stroke(100, 90);
    pa.displayDir(pa.vel.magnitude()*3);
    count++;
  }
  cam.beginHUD();
  noLights();
  image(logo, width-90, height-80);
  cam.endHUD();
}

void buildBox(float x, float y, float z) {
  noFill();
  stroke(0, 90);
  strokeWeight(1);
  pushMatrix();
  //scale(x, y, z);
  box(x, y, z);
  popMatrix();
}

void keyPressed() {
  if (key=='s') {
    if (bTails.get(0).boxes.size() > 0) {
      saveSTL(bTails, fileName);
    }
  }
  if (key=='i') saveIMG();
}


void saveIMG(){
 saveFrame("imgs/"+this.getClass().getName()+"_#####.png");
  println("screenshot saved");
}

//...........................................................
// correct use of super()
class NewAgent extends Ple_Agent {
  ArrayList<TriangleMesh> boxes;
  ToxiclibsSupport gfx;
  PApplet p5;
  NewAgent(PApplet p5, Vec3D loc) {
    super(p5, loc);
    this.p5 = p5;
    boxes = new ArrayList<TriangleMesh>();
  }

  void addBox() {
    TriangleMesh b=(TriangleMesh)new AABB(new Vec3D(), BOX_SIZE).toMesh();
    b.pointTowards(vel);
    // move the box to the correct position
    b.transform(new Matrix4x4().translateSelf(loc.x, loc.y, loc.z));
    boxes.add(b);
  }

  void displayBoxes() {
    for (int i=0; i< boxes.size (); i++) {
      fill(lerpColor(0, 255, (float)i/boxes.size()));
      noStroke();
      gfx=new ToxiclibsSupport(p5);
      gfx.mesh(boxes.get(i));
    }
  }
}

//...............................
