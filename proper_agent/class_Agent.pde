class Agent {
  Vec3D loc, vel, acc;
  float maxSpeed = 1.5;
  float maxForce = .15; //0.1 o 0.15
  float arriveDist = 100;

  float cohRad = 80; 
  float aliRad = 40;
  float sepRad = 15;

  float visAng = radians(10);
  color col;

  Vec3D steer;

  Agent(Vec3D loc, Vec3D vel) {
    this.loc = loc;
    this.vel = vel;
    acc = new Vec3D();
    col = color(random(255), 0, 0);
  }


  void run(ArrayList ags, Vec3D[] bounds) {
    flock(ags);
    // followField(field, 0.1);
    update();
    wrap(bounds);
    display();
  }

  void applyForce(Vec3D force) {
    // We could add mass here if we want A = F / M
    acc.addSelf(force);
  }



  void update() {
    vel.addSelf(acc);
    vel.limit(maxSpeed);
    loc.addSelf(vel);
    // reset acceleration
    acc = new Vec3D();
  }

  Vec3D futLoc(float r) {
    return loc.add(vel.normalizeTo(r));
  }


  // ......................... movement behaviors

  void wander(float rad) {
    Vec3D target = futLoc(2); // future location
    Vec3D r = new Vec3D(rad, 0, 0).rotateZ(random(-PI, PI)); // wandering vector
    target.addSelf(r);
    Vec3D desired = target.sub(loc);
    desired.normalizeTo(maxSpeed);
    Vec3D steer = desired.sub(vel);
    steer.limit(maxForce);
    applyForce(steer);
  }

  // ............................. flocking behaviors

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Agent> ags) {
    Vec3D sep = separate(ags, sepRad);   // Separation 15
    Vec3D ali = align(ags, aliRad);      // Alignment
    Vec3D coh = cohesion(ags, cohRad);   // Cohesion
    // Arbitrarily weight these forces
    sep.scaleSelf(1.5);//1.5
    ali.scaleSelf(.3);//1.0
    coh.scaleSelf(1.0);//1.0
    // Add the force vectors to acceleration
    acc.addSelf(sep);
    acc.addSelf(ali);
    acc.addSelf(coh);
  }

  Vec3D cohesion (ArrayList<Agent> ags, float radC) {
    Vec3D sum = new Vec3D();   // Start with empty vector to accumulate all locations
    int count = 0;
    float ang;
    for (int i = ags.size ()-1; i >= 0; i--) {
      Agent other =  ags.get(i);
      if (this != other) {
        ang = 0;//acos(vel.normalize().dot( other.loc.sub(loc).normalize()));
        if (loc.distanceToSquared(other.loc) < radC && ang<visAng ) {
          sum.addSelf(other.loc); // Add location
          count++;
        }
      }
    }
    if (count > 0) {
      sum.scaleSelf(1.0/count);
      sum.normalizeTo(maxSpeed);
      steer = sum.sub(vel);
      steer.limit(maxForce); // maxForce
      return steer;
    } else return new Vec3D();
  }

  Vec3D align (ArrayList<Agent> ags, float radA) {
    Vec3D steer = new Vec3D();
    int count = 0;
    float ang;
    for (int i = ags.size ()-1; i >= 0; i--) {
      Agent other =  ags.get(i);
      if (this != other) {
        ang = 0;//acos(vel.normalize().dot( other.loc.sub(loc).normalize()));
        if (loc.distanceTo(other.loc) < radA && ang<visAng ) {
          steer.addSelf(other.vel);
          count++;
        }
      }
    }
    if (count > 0) {
      steer.scaleSelf(1.0/count);
    }

    // As long as the vector is greater than 0
    if (steer.magSquared() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalizeTo(maxSpeed);
      steer.subSelf(vel);
      steer.limit(maxForce);
    }
    return steer;
  }

  Vec3D separate (ArrayList<Agent> ags, float radS) {
    Vec3D sum = new Vec3D(), diff;
    int count = 0;
    float d;
    for (Agent other : ags) {
      d = loc.distanceTo(other.loc);
      if ((d > 0) && (d < radS)) { // desiredSep
        diff = loc.sub(other.loc);
        diff.normalizeTo(1.0/d);
        // What is the magnitude of the Vector pointing away from the other vehicle?
        // The closer it is, the more we should flee. The farther, the less. So we divide
        // by the distance to weight it appropriately.
        sum.addSelf(diff);
        count++;
      }
    }
    if (count > 0) {
      sum.scaleSelf(1.0/count);
      sum.normalizeTo(maxSpeed);
      steer = sum.sub(vel);
      steer.limit(maxForce); // maxForce
      return steer;
    } else return new Vec3D();
  }

  // ............................. boundary behaviors

  void wrap(Vec3D[] bounds) {
    // x
    if (loc.x<bounds[0].x) { 
      loc.x = bounds[1].x;
    } else if (loc.x>bounds[1].x) { 
      loc.x = bounds[0].x;
    }
    // y
    if (loc.y<bounds[0].y) { 
      loc.y = bounds[1].y;
    } else if (loc.y>bounds[1].y) { 
      loc.y = bounds[0].y;
    }
    // z
    if (loc.z<bounds[0].z) { 
      loc.z = bounds[1].z;
    } else if (loc.z>bounds[1].z) { 
      loc.z = bounds[0].z;
    }
  }

  // ............................. seek+follow behaviors

  Vec3D seek(Vec3D target, float sign) {
    Vec3D desired = target.sub(loc);
    // normalize desired to maxSpeed and sign (1= seek -1=flee)
    desired.normalizeTo(maxSpeed*sign);
    Vec3D steer = desired.sub(vel);
    steer.limit(maxForce);
    return steer;
  }

  void arrive(Vec3D target) {
    Vec3D desired = target.sub(loc);
    // The distance is the magnitude of the vector pointing from location to target
    float d = desired.magnitude();
    desired.normalize();
    // If we are closer than 100 pixels...
    if (d < arriveDist) {
      //...set the magnitude according to how close we are
      float m = map(d, 0, arriveDist, 0, maxSpeed);
      desired.scaleSelf(m);
      //
    } else {
      // Otherwise, proceed at maximum speed.
      desired.scaleSelf(maxSpeed);
    }

    // The usual steering = desired - velocity
    Vec3D steer = desired.sub(vel);
    steer.limit(maxForce);
    applyForce(steer);
  }

  void followField(Field flow, float force) {
    // What is the vector at that spot in the flow field?
    Vec3D desired = flow.eval(loc);
    //desired.scaleSelf(maxSpeed);
    desired.normalizeTo(maxSpeed);

    // Steering is desired minus velocity
    Vec3D steer = desired.sub(vel);
    steer.limit(force); // should be maxForce but I want to be able to regulate the intensity
    applyForce(steer);
  }

  void followPath(Path p, float sign, float force) {
    Vec3D[] n = p.getNormalDir(futLoc(10), force*sign);

    float d = loc.distanceTo(n[0]);
    if (d > p.rad) {
      applyForce(seek(n[1], 1)); // seek point on path
      /*
      Vec3D desired = n[1].sub(loc);
       //desired.scaleSelf(maxSpeed);
       desired.normalizeTo(maxSpeed);
       // Steering is desired minus velocity
       Vec3D steer = desired.sub(vel);
       steer.limit(force); // should be maxForce but I want to be able to regulate the intensity
       line(loc.x, loc.y, loc.add(steer.scale(10)).x, loc.add(steer.scale(10)).y);
       applyForce(steer);
       
       pushStyle();
       stroke(255,0,0,80);
       strokeWeight(5);
       point(n[1].x, n[1].y, n[1].z);
       popStyle();
       // line(n.x,n.y, loc.x, loc.y);
       */
    }
  }




  // ............................. display behaviors

  void display() {
    pushStyle();
    strokeWeight(3);
    stroke(0);
    point(loc.x, loc.y, loc.z);
    Vec3D fL = loc.add(vel.scale(10));
    strokeWeight(1);
    stroke(255, 0, 0, 80);
    line(loc.x, loc.y, loc.z, fL.x, fL.y, fL.z);
    popStyle();
  }

  void display2() {
    // Vehicle is a triangle pointing in the direction of velocity; since it is drawn
    // pointing up, we rotate it an additional 90 degrees.
    float r = 5;

    fill(col);
    //stroke(0);
    noStroke();
    pushMatrix();
    translate(loc.x, loc.y);
    // rotation angle
    // float theta = vel.heading() + PI/2;
    float theta = atan2(vel.y, vel.x) + PI/2;
    rotate(theta);
    beginShape();
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape(CLOSE);
    popMatrix();
  }

  void display3() {

    pushStyle();
    ellipse(loc.x, loc.y, 10, 10);
    popStyle();
  }
}
