import toxi.volume.*;

import toxi.physics2d.constraints.*;
import toxi.physics.*;
import toxi.physics.constraints.*;
import toxi.physics2d.behaviors.*;
import toxi.physics.behaviors.*;
import toxi.physics2d.*;

import toxi.math.conversion.*;
import toxi.geom.*;
import toxi.math.*;
import toxi.geom.mesh2d.*;
import toxi.util.datatypes.*;
import toxi.util.events.*;
import toxi.geom.mesh.subdiv.*;
import toxi.geom.mesh.*;
import toxi.math.waves.*;
import toxi.util.*;
import toxi.math.noise.*;

import toxi.processing.*;

import toxi.sim.grayscott.*;
import toxi.sim.fluids.*;
import toxi.sim.automata.*;
import toxi.sim.erosion.*;
import toxi.sim.dla.*;

import plethora.core.*;

import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

import megamu.mesh.*;

import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

import generativedesign.*;
import processing.xml.*;

import toxi.data.csv.*;
import toxi.data.feeds.*;
import toxi.data.feeds.util.*;

import controlP5.*;

import toxi.color.*;
import toxi.color.theory.*;

import toxi.music.*;
import toxi.music.scale.*;
import toxi.audio.*;
PImage logo;

int numCirc = 60;
Circle[] circles = new Circle[numCirc];

void setup() {
  size(900, 300);
  smooth();
  colorMode(HSB);
  imageMode(CENTER);
  ellipseMode(CENTER);
  strokeCap(SQUARE);
  logo = loadImage("Noobodies_txt.png");
  randomCircle(numCirc);
  noFill();
}

void draw() {
  background(frameCount*0.2%255, 200, 255);
  for (int i=0; i<numCirc; i++) {
    circles[i].update();
    circles[i].display();
  }
  image(logo, width*.5-18, height*.5);
}


void randomCircle(int num) {
  PVector loc = new PVector(width*.5, height*.5);
  float rad, angS, angE, speed, thick;
  color col;
  for (int i=0; i<num; i++) {
    rad = random(20, 600);
    angS = random(-TWO_PI, TWO_PI);
    angE = random(-TWO_PI, TWO_PI);
    speed = random(-0.05, 0.05);
    thick = random(1, 30);
    col = color(random(20, 100), random(20, 200));
    circles[i] = new Circle(loc, rad, angS, angE, speed, thick, col);
  }
}

class Circle {
  PVector loc;
  float rad, ang, angS, angE, speed, thick;
  color col;

  Circle(PVector loc, float rad, float angS, float angE, float speed, float thick, color col) {
    this.loc = loc;
    this.rad = rad;
    this.angS = angS;
    this.angE = angE;
    this.speed = speed;
    this.thick = thick;
    this.col = col;
    ang =0;
  }

  void update() {
    ang+=speed;
  }
  void display() {
    pushMatrix();
    pushStyle();
    // ellipseMode(CENTER);
    noFill();
    stroke(col);
    strokeWeight(thick);
    translate(loc.x, loc.y);
    rotate(ang);
    arc(0, 0, rad, rad, angS, angE);
    popStyle();
    popMatrix();
  }
}
