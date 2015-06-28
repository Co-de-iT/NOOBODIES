// simple 3D camera to start playing in 3D!

import peasy.*;

PeasyCam cam;

void setup() {
  size(800, 800, P3D);
  cam = new PeasyCam(this, 300);
}


void draw() {
  background(221);
  box(100);
}
