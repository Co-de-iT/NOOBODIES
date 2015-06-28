class Frame {

  ArrayList<Vec3D> pts;
  ArrayList<Line> lines;
  float thres = 20;

  Frame() {
    pts = new ArrayList<Vec3D>();
    lines = new ArrayList<Line>();
  }

  void record(ArrayList<Ple_Agent> boids) {
    for (Ple_Agent a : boids) {
      pts.add(new Vec3D(a.loc));
    }
  }

  void connect() {
    for (int i=0; i<pts.size (); i++) {
      Vec3D p = pts.get(i);
      for (int j=i+1; j< pts.size (); j++) {
        Vec3D other = pts.get(j);
        if (p.distanceToSquared(other) < thres*thres) {
          Line l = new Line(p, other);
          lines.add(l);
        }
      }
    }
  }

  void display() {
    for (Vec3D p : pts) {
      point(p.x, p.y, p.z);
    }
  }

  void displayLines() {
    for (Line l : lines) {
      l.display(0.5, color(255, 0, 0,80));
    }
  }
}
