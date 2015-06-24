class BoxTail {
  ArrayList<TriangleMesh> boxes;
  ToxiclibsSupport gfx;
  PApplet p5;
  int freq;

  BoxTail(PApplet p5, int freq) {
    this.p5 = p5;
    this.freq = freq;
    boxes = new ArrayList<TriangleMesh>();
    gfx=new ToxiclibsSupport(p5);
  }

  void addBox(Ple_Agent p) {
    if (frameCount%freq==0) {
      // TriangleMesh b=(TriangleMesh)new AABB(new Vec3D(), BOX_SIZE).toMesh();
      //TriangleMesh b= pyramid(3);
      TriangleMesh b= triang(3);
      float freq = 1+abs(cos(frameCount*0.05));
      b.scale(new Vec3D(freq, freq, 1));
      b.scale(new Vec3D(1,1,2));
      b.rotateZ(frameCount*0.09);
      // align the Z axis of the box with the direction vector
      b.pointTowards(p.vel);
      
      // move the box to the correct position
      b.transform(new Matrix4x4().translateSelf(p.loc.x, p.loc.y, p.loc.z));
      boxes.add(b);
    }
  }

  void displayMesh() {
    for (int i=0; i< boxes.size (); i++) {
      fill(lerpColor(0, 255, (float)i/boxes.size()));
      noStroke();

      gfx.mesh(boxes.get(i));
    }
  }

  TriangleMesh pyramid(float t) {
    TriangleMesh p = new TriangleMesh();
    Vec3D a = new Vec3D(-t, -t, -t);
    Vec3D b = new Vec3D( t, -t, -t);
    Vec3D c = new Vec3D( t, t, -t);
    Vec3D d = new Vec3D(-t, t, -t);
    Vec3D e = new Vec3D( 0, 0, t);

    p.addFace(a, b, e);
    p.addFace(b, c, e);
    p.addFace(c, d, e);
    p.addFace(d, a, e);
    p.addFace(a, b, c);
    p.addFace(c, d, a);
    return p;
  }
  
  TriangleMesh triang(float t) {
    TriangleMesh p = new TriangleMesh();
    Vec3D a = new Vec3D(-t, 0, -t);
    Vec3D b = new Vec3D( t, 0, -t);
    Vec3D c = new Vec3D( 0, 0, t);

    p.addFace(a, b, c);

    return p;
  }
}
