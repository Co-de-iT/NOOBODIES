class Line {

  // fields
  Vec3D s, e;

  // constructors
  Line(Vec3D _s, Vec3D _e) {
    s = _s;
    e = _e;
  }

  // behaviors
  void display(float w, color col) {
    pushStyle();
    strokeWeight(w);
    stroke(col);
    line(s.x, s.y, s.z, e.x, e.y, e.z);
    popStyle();
  }
}
