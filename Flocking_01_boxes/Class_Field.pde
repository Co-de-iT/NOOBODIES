class Field {
  ArrayList<Attractor> attractors;
  float infl = 0.8;

  Field(ArrayList<Attractor> attractors) {
    this.attractors = attractors;
  }

  Vec3D eval(Vec3D p) {
    float sc;
    Attractor a;
    Vec3D vp, v = new Vec3D();
    for (int i=0; i< attractors.size (); i++) {
      a = attractors.get(i);
      vp = a.loc.sub(p);
      sc = vp.magSquared();
      vp.normalizeTo(a.mag/pow(sc, 2));
      v.add(vp);
    }
    v.normalizeTo(infl);
    return v;
  }

  void displayField(int sizeX, int sizeY, int sizeZ, float cellSize, float len) {
    Vec3D p, f, c;
    for (int i=0; i< sizeX; i++) {
      for (int j=0; j<sizeY; j++) {
        for (int k=0; k<sizeZ; k++) {
          p = new Vec3D(cellSize*(i+.5), cellSize*(j+.5), cellSize*(k+.5));
          f = eval(p).normalizeTo(len);
          c = new Vec3D(f).normalize();
          stroke((c.x+1)*255*.5, (c.y+1)*255*.5, (c.z+1)*255*.5);
          line(p.x, p.y, p.z, p.x+f.x, p.y+f.y, p.z+f.z);
        }
      }
    }
  }
}

class Attractor {
  Vec3D loc;
  float mag, rot;

  Attractor(Vec3D loc, float mag, float rot) {
    this.loc = loc;
    this.mag = mag;
    this.rot = rot;
  }
}
