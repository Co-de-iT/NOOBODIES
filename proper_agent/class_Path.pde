class Path {

  // A Path is now an ArrayList of points (PVector objects).
  ArrayList<Vec3D> pts;
  float rad;

  Path() {
    rad = 20;
    pts = new ArrayList<Vec3D>();
  }

  Path(ArrayList<Vec3D> pts, float rad) {
    this.rad = rad;
    this.pts = pts;
  }

  // append points to the path.
  void addPoint(float x, float y, float z) {
    Vec3D point = new Vec3D(x, y, z);
    pts.add(point);
  }


  // get normal functions (for path seeking)
  Vec3D getClosestNormal(Vec3D p) {
    Vec3D n = new Vec3D(), currN;
    float dist, minD = Float.MAX_VALUE;
    for (int i=0; i< pts.size (); i++) {
      currN = getNormalPoint(p, pts.get(i), pts.get((i+1)%(pts.size())), false);
      dist = p.distanceTo(currN);
      if (dist < minD) {
        n = currN;
        minD = dist;
      }
    }
    return n;
  }

  Vec3D[] getNormalDir(Vec3D p, float dir) {
    Vec3D[] n = new Vec3D[2];
    Vec3D currN, a, b;
    float dist, minD = Float.MAX_VALUE;
    for (int i=0; i< pts.size (); i++) {
      a = pts.get(i);
      b = pts.get((i+1)%(pts.size()));
      currN = getNormalPoint(p, a, b, false);
      dist = p.distanceTo(currN);
      if (dist < minD) {
        n[0] = currN; // normal location
        n[1] = n[0].add(b.sub(a).normalizeTo(dir)); // point in normal direction
        minD = dist;
      }
    }
    return n;
  }

  Vec3D getNormalPoint(Vec3D p, Vec3D a, Vec3D b, boolean overshoot) {
    // overshoot controls if considering the segment as direction (true) or finite segment (false)
    float segLen = a.distanceTo(b);
    // PVector that points from a to p
    Vec3D ap = p.sub(a);
    // PVector that points from a to b
    Vec3D ab = b.sub(a);

    // Using the dot product for scalar projection
    ab.normalize();
    ab.scaleSelf(ap.dot(ab));

    // Finding the normal point along the line segment
    Vec3D normalPoint = a.add(ab);
    // checks if the point overshoots the extremities of the segment, in which case it returns the closest extremity
    if (!overshoot) {
      if (normalPoint.distanceTo(a) > segLen) { 
        return b;
      } else if (normalPoint.distanceTo(b) > segLen) {
        return a;
      } else {
        return normalPoint;
      }
    } else {
      return normalPoint;
    }
  }


  // Display the path as a series of points.
  void displayPts() {
    stroke(0);
    noFill();
    beginShape();
    for (Vec3D v : pts) {
      vertex(v.x, v.y, v.z);
    }
    endShape(CLOSE);
  }

  void display() {
    pushStyle();
    stroke(0, 80);
    strokeWeight(rad*2);
    Vec3D a, b;
    beginShape();
    for (int i=0; i< pts.size(); i++) {
     a= pts.get((i)%pts.size());
      vertex(a.x, a.y, a.z);
    }
    endShape(CLOSE);
    /*
    for (int i=0; i< pts.size (); i++) {
      a = pts.get(i);
      b= pts.get((i+1)%pts.size());
      line(a.x, a.y, a.z, b.x, b.y, b.z);
    }
    */
    stroke(0);
    strokeWeight(1);
    for (int i=0; i< pts.size (); i++) {
      a = pts.get(i);
      b= pts.get((i+1)%pts.size());
      line(a.x, a.y, a.z, b.x, b.y, b.z);
    }
    popStyle();
  }
}
