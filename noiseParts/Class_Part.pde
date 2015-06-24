class Part {
  Vec3D loc, speed;
  float maxSpeed = 5; // 5
  float sc = 0.005; //0.007
  ArrayList <Vec3D> trail;

  Part(Vec3D loc, Vec3D speed) {
    this.loc=loc;
    this.speed=speed;
    trail = new ArrayList<Vec3D>();
    // this.speed = new Vec3D(0,0,maxSpeed*.5);
  }

  void update() {
    // moveNoise(5);
    moveNoiseRot(5);
  }

  void moveNoise(int freq) {
    speed = new Vec3D();
    speed.x =(noise(0, loc.x*sc, loc.y*sc)-.5)*maxSpeed;
    speed.y =(noise(1, loc.x*sc, loc.z*sc)-.5)*maxSpeed;
    speed.z =(noise(2, loc.y*sc, loc.z*sc)-.5)*maxSpeed;
    loc.addSelf(speed);
    if (frameCount%freq==0) trail.add(new Vec3D(loc));
  }
  
    void moveNoiseRot(int freq) {
    speed = new Vec3D(0,0,maxSpeed*.5);
    speed.rotateX(noise(0, loc.y*sc, loc.z*sc)*TWO_PI);//*frameCount*0.005);
    speed.rotateY(noise(1, loc.x*sc, loc.z*sc)*TWO_PI);//*frameCount*0.005);
    speed.rotateZ(noise(2, loc.x*sc, loc.y*sc)*TWO_PI);//*frameCount*0.005);
    // speed.x =(noise(0, loc.x*sc, loc.y*sc)-.5)*maxSpeed;
    // speed.y =(noise(1, loc.x*sc, loc.z*sc)-.5)*maxSpeed;
    // speed.z =(noise(2, loc.y*sc, loc.z*sc)-.5)*maxSpeed;
    loc.addSelf(speed);
    if (frameCount%freq==0) trail.add(new Vec3D(loc));
  }

  void display() {
    pushStyle();
    stroke(255, 0, 0);
    strokeWeight(3);
    point(loc.x, loc.y, loc.z);
    popStyle();
  }

  void dispTrail() {
    pushStyle();
    stroke(0, 80);
    strokeWeight(calcLines?3:1);
    beginShape(POINTS);
    for (Vec3D t : trail) {
      vertex(t.x, t.y, t.z);
    }
    endShape();
    popStyle();
  }
}
