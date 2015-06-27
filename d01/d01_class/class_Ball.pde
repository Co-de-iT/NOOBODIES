class Ball {

  // fields
  color col;
  float rad;
  float period;
  Vec3D loc;
  Vec3D vel;

  // constructors
  // same name as the class, no function type!
  Ball(Vec3D _loc, float _rad, color _col) {
    loc = _loc;
    rad = _rad;
    col = _col;
    vel = new Vec3D(random(-2, 2), random(-2, 2), 0);
    period = 1/random(2,50);
  }

  // behaviors
  void update() {
    move();
    // wrap();
    bounce();
    //display();
    //display2();
    display3();
  }

  // moving behaviors
  void move() {
    loc.addSelf(vel);
  }

  // border checking b.
  void wrap() {
    // x direction
    if (loc.x+rad < 0) {
      loc.x = width+rad;
    } else if (loc.x-rad > width) {
      loc.x = 0-rad;
    }
    // y direction
    if (loc.y+rad < 0) {
      loc.y = height+rad;
    } else if (loc.y-rad > height) {
      loc.y = 0-rad;
    }
  }

  void bounce() {
    // boolean operators
    // || or
    // && and
    // != not
    if (loc.x-rad<0 || loc.x+rad > width){
      vel.x *= -1;
    }
     if (loc.y-rad<0 || loc.y+rad > height){
      vel.y *= -1; // vel.y = vel.y * -1;
    }
  }

  // display behaviors
  void display() {
    noStroke();
    fill(col);
    ellipse(loc.x, loc.y, rad*2, rad*2);
  }
  
  void display2(){
    noFill();
    stroke(col);
    strokeWeight(5);
    ellipse(loc.x, loc.y, rad*2, rad*2);
  }
  
  void display3(){
    noStroke();
    fill(col);
    float x1=loc.x+cos(frameCount*period)*rad*2/3;
    float y1 = loc.y+sin(frameCount*period)*rad*2/3;
    ellipse(x1, y1, rad*2/3, rad*2/3);
    noFill();
    stroke(col);
    strokeWeight(5);
    ellipse(loc.x, loc.y, rad*2, rad*2);
  
  }
}
