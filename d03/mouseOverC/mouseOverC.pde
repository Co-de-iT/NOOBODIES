import toxi.geom.*;

Vec3D center = new Vec3D();
float radius = 100;

void setup() {
  size(800, 800);
  center = new Vec3D(width/2, height/2,0);
}


void draw() {
  background(221);
  if (mouseOverCircle(center, radius)) {
    fill(255,0,0);
    if (mousePressed) fill(255);
     ellipse(center.x, center.y, radius*2*1.5, radius*2*1.5);
  } else {
    fill(0);
    ellipse(center.x, center.y, radius*2, radius*2);
  }
 
}

boolean mouseOverCircle (Vec3D c, float r) {
  Vec3D m = new Vec3D(mouseX, mouseY, 0);
  return m.distanceToSquared(c)< r*r;
}
