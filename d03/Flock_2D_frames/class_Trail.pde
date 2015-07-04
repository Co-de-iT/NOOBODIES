class Trail {

  ArrayList<Vec3D> points;

  Trail() {
    points = new ArrayList <Vec3D>();
  }

  void display() {
    beginShape();
    stroke(0, 80);
    strokeWeight(1);
    for (Vec3D v : points) { 
      vertex(v.x, v.y, v.z);
    }
    endShape();
  }
}
