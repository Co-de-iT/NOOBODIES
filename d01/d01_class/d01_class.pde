
import toxi.geom.*;


// this is a single line comment
// variables declaration

int sizeX = 800;
int sizeY = 800;
int nBalls = 200;
float xPos = 300;
float yPos = sizeY/2; // in the middle of the canvas
float speed = 1.5;
Ball b; // declaration: "you know, I think I REALLY need a new Ball!"
//   flag <type>  name
//          |     |
ArrayList<Ball> bColl; //flagged arraylist declaration: "you know, I think I REALLY need a new Ball collection!"

// void: no output data - the function will not output a value
//       no input data needed
//         |
void setup() {
  size(sizeX, sizeY);
  background(221);

  bColl = new ArrayList<Ball>(); // instantiation: "Ok guys, this is where my collection is going to be hosted!"

  // a = a+1; <> a +=1; <> a++;
  for (int i=0; i<nBalls; i++) {
    float r = random(5, 60);
    Vec3D loc = new Vec3D(random(r, width-r), random(r, height-r), 0);
    b = new Ball(loc, r, color(random(255), 0, 0, random(20, 180)));// instantiation
    bColl.add(b); // add to collection
  }
}

void draw() {
  background(221);
  // 
  for (int i=0; i< bColl.size (); i++) {
    b = bColl.get(i); // pick the i-th element of the collection
    b.update();       // call its update() function
  }
}
// ..........................................................................................................
//
//  example of a function returning values (not used by the sketch)
//
// <function type> <function name> ( <param type> <param name>,...){ <instructions> }
float moveY(float y) {
  float newY;
  newY = height/2+sin(frameCount*0.1)*100;
  // if a function returns a value it must contain the 'return' instruction
  // the returned value must be of the same type of the function
  return newY;
}
