class Field {
  Vec3D[][] field;
  int cols, rows;
  float xRes, yRes, noiseScale;

  Field(float xRes, float yRes, float noiseScale) {
    this.xRes = xRes;
    this.yRes = yRes;
    this.noiseScale = noiseScale;
    // Determine the number of columns and rows.
    cols = int(width/xRes);
    rows = int(height/yRes);
    //[end]
    field = new Vec3D[cols][rows];
    initField();
  }

  Field(int res) {
    this(res, res, 0.1);
  }

  void initField() {
    float xOff = 0, yOff;
    float theta;
    for (int i = 0; i < cols; i++) {
      yOff = 0;
      for (int j = 0; j < rows; j++) {
        //[offset-up] Noise
        theta = map(noise(xOff, yOff), 0, 1, 0, TWO_PI);
        field[i][j] = new Vec3D(cos(theta), sin(theta), 0);
        yOff += noiseScale;
      }
      xOff += noiseScale;
    }
  }
  
   void noiseField(float t) {
    float xOff = 0, yOff;
    float theta;
    for (int i = 0; i < cols; i++) {
      yOff = 0;
      for (int j = 0; j < rows; j++) {
        //[offset-up] Noise
        theta = map(noise(xOff, yOff, t), 0, 1, 0, TWO_PI);
        field[i][j] = new Vec3D(cos(theta), sin(theta), 0);
        yOff += noiseScale;
      }
      xOff += noiseScale;
    }
  }

  // A function to return a PVector based on a location
  Vec3D eval(Vec3D loc) {
    int col = int(constrain(loc.x/xRes,0,cols-1));
    int row = int(constrain(loc.y/yRes,0,rows-1));
    return new Vec3D(field[col][row]);
  }

  void displayField(float len) {

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        pushMatrix();
        translate(xRes*(i+.5), yRes*(j+.5));
        line(0, 0, field[i][j].x*len, field[i][j].y*len);
        popMatrix();
      }
    }
  }
}
