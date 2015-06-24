import java.util.*;
import java.io.FileOutputStream;

void saveSTL(ArrayList<BoxTail> tails, String fileName) {
  //
  TriangleMesh superMesh = new TriangleMesh();
  ArrayList<TriangleMesh> tail = new ArrayList<TriangleMesh>();
  for (int i=0; i< tails.size (); i++) {
    tail = tails.get(i).boxes;
    for (int j=0; j< tail.size (); j++) {
      superMesh.addMesh(tail.get(j));
    }
  }

  // FileOutputStream fs;
  // fs=new FileOutputStream(sketchPath("meshOut/"+fileName+".stl"));
  // superMesh.saveAsSTL(sketchPath("meshOut/"+fileName));
  superMesh.saveAsSTL(sketchPath("meshOut/"+fileName+".stl"));
  println("STL file saved");
  // fs=new FileOutputStream(sketchPath("meshOut/"+fileName+".obj"));
  superMesh.saveAsOBJ(sketchPath("meshOut/"+fileName+".obj"));
  println("OBJ file saved");
  /*
  STLWriter stlW = new STLWriter();
   stlW.beginSave(sketchPath("meshOut/"+fileName+".stl"), superMesh.faces.size());
   
   int count =0;
   float r;
   for (Iterator i=superMesh.faces.iterator (); i.hasNext(); ) {
   Face f=(Face)i.next();
   r = count/superMesh.faces.size();
   stlW.face(f.a, f.b, f.c, f.normal, lerpColor(color(0), color(255,0,0),r));
   count++;
   }
   
   stlW.endSave();
   */
  // println("STL file saved");
}
