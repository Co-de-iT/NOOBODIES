class Ball {

  // fields
  color col;
  float rad;
  float period;
  Vec3D loc;
  Vec3D vel;
  Vec3D acc;
  float maxSpeed = 2.5;
  float maxForce = 0.05;

  // constructors
  // same name as the class, no function type!
  Ball(Vec3D _loc, float _rad, color _col) {
    loc = _loc;
    rad = _rad;
    col = _col;
    vel = new Vec3D(random(-2, 2), random(-2, 2), random(-2, 2));
    period = 1/random(2, 50);
    acc = new Vec3D();
  }

  // behaviors
  void update() {
    // 1. calculate influences
    //check(bColl);
    //seekMouse(200);
    //flock(bColl);

    vel.addSelf(acc);
    vel.limit(maxSpeed); 
    acc = new Vec3D();

    // 2. move
    //if (avoid(bColl)) move();
    avoid(bColl);
    //shrink();
    //wrap();
    // bounce();

    // 3. display
    //displayTri();
    //display();
    //display2();
    //display3();
  }

  boolean avoid(ArrayList<Ball> bColl) {
    boolean check = false;
    for (Ball other : bColl) {
      if (this!=other && checkOverlap(other)) {
        check=true;
        vel.rotateX(random(-.1, .1));
        vel.rotateY(random(-.1, .1));
        vel.rotateZ(random(-.1, .1));
        move();
        shrink();
        Line l = new Line(loc.copy(), other.loc.copy());
        // Line l = new Line(new Vec3D(loc), new Vec3D(other.loc));
        lColl.add(l);
      }
    }
    return check;
  }

  void shrink() {
    if (rad > 3) rad = rad - 0.1;
  }

  void flock(ArrayList <Ball> bColl) {
    // separation
    Vec3D separation = separate(bColl);
    // alignment
    // cohesion

    // adjust influence values


    // add to acceleration
    applyForce(separation);
  }


  Vec3D separate(ArrayList<Ball> bColl) {
    Vec3D steer = new Vec3D();
    float sepR = 25.0; // separation radius
    int count=0;
    for (Ball other : bColl) {
      float d = loc.distanceTo(other.loc);
      if (d>0 && d < sepR) {
        // calc UNdesired vector
        Vec3D diff = loc.sub(other.loc);
        diff.normalizeTo(1/d);   // the closest I am, the more violent the response
        steer.addSelf(diff);     // add to steer
        count++;
      }
    }
    // Average steer vector
    if (count > 0) steer.scaleSelf(1/(float)count);
    // if steer is > 0
    if (steer.magnitude() > 0) {
      steer.normalizeTo(maxSpeed);
      steer.subSelf(vel);
      steer.limit(maxForce);
    }
    return steer;
  }

  // moving behaviors
  void applyForce(Vec3D force) {
    acc.addSelf(force);
  }

  void move() {
    loc.addSelf(vel);
  }

  void seekMouse(float thres) {
    Vec3D mouse = new Vec3D(mouseX, mouseY, 0);
    float d = loc.distanceTo(mouse);
    if (mousePressed && mouseButton==LEFT && d < thres) {
      Vec3D m = seek(mouse);

      applyForce(m);
    }
  }

  void check(ArrayList<Ball> bColl) {
    Ball b1;
    int i = bColl.indexOf(this);
    pushStyle();
    for (int j=i+1; j<bColl.size (); j++) {
      b1 = bColl.get(j);
      if (flee(b1)) {
        stroke(0, 80);
        strokeWeight(1);
        line(loc.x, loc.y, loc.z, b1.loc.x, b1.loc.y, b1.loc.z);
      }
    }
    popStyle();
  }

  Vec3D seek(Vec3D target) {
    Vec3D desired = target.sub(loc);
    desired.normalizeTo(maxSpeed);
    Vec3D steer = desired.sub(vel);
    steer.limit(maxForce);
    return steer;
  }

  // neighbour checking

  boolean checkOverlap(Ball other) {
    return (loc.distanceToSquared(other.loc) < (rad+other.rad)*(rad+other.rad));
  }

  boolean flee(Ball other) {
    boolean overlap = false;
    float d = loc.distanceTo(other.loc);
    float force;
    Vec3D acc = loc.sub(other.loc); // other.loc.sub(loc);
    if ( d < (rad+other.rad)) {
      overlap=true;
      force = map(d, 0, rad+other.rad, 5, 0);
      acc.normalizeTo(force);
      applyForce(acc);
    }
    return overlap;
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
    if (loc.x-rad<0 || loc.x+rad > width) {
      vel.x *= -1;
    }
    if (loc.y-rad<0 || loc.y+rad > height) {
      vel.y *= -1; // vel.y = vel.y * -1;
    }
  }

  // display behaviors
  void display() {
    noStroke();
    fill(col);
    ellipse(loc.x, loc.y, rad*2, rad*2);
  }

  void display2() {
    noFill();
    stroke(col);
    strokeWeight(5);
    ellipse(loc.x, loc.y, rad*2, rad*2);
  }

  void display3() {
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

  void displayTri() {
    float r = 5;
    pushStyle();
    stroke(0, 80);
    strokeWeight(1);
    fill(col);
    pushMatrix(); // use my own UCS
    // translate to our location
    translate(loc.x, loc.y, loc.z);
    // align to velocity
    float theta = atan2(vel.y, vel.x) + PI/2;
    rotate(theta);
    beginShape(); // begin drawing a shape

      vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);

    endShape(CLOSE); // end drawing shape

    popMatrix(); // back to World Coordinates System
    popStyle();
  }
}
