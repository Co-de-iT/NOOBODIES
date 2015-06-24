class Line {
  Vec3D a, b;

  Line(Vec3D a, Vec3D b) {
    this.a = a;
    this.b = b;
  }

  void display() {
    line(a.x, a.y, a.z, b.x, b.y, b.z);
  }
}
