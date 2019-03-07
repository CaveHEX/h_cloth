final int nbU = 100; //<>//
final int nbV = 100;
final int tileSize = 20;

class Landscape {

  PShape shape;
  PVector[] points;
  PVector offset;
  PVector center;

  // Just to manage colors
  float lenU = tileSize * nbU;
  float lenV = tileSize * nbV;

  Landscape() {
    offset = new PVector();
    this.clear();
    this.updateGeometry();
    shape = this.makeLandscape();

    this.center = new PVector(
      (nbU*tileSize)/2, 
      0, 
      (nbV*tileSize)/2
      );
  }

  void update() {
    if ( frameCount % 3 == 0 && !pause ) {
      // Mofidy offset to voyage through the infinite noise field
      offset.x = time;
      offset.z = sin(time)*3;

      this.updateGeometry();
      this.shape = this.makeLandscape();
    }
  }

  void render() {
    push();
    shape(this.shape);
    pop();
  }

  void run() {
    this.update();
    this.render();
  }

  // Updating the geometry of the landscape
  void updateGeometry() {
    for ( int u = 0; u < nbU; ++u ) {
      for ( int v = 0; v < nbV; ++v ) {
        int index = u + v * nbU;  // Index of that point in the array, from (https://processing.org/tutorials/pixels/)
        points[index].x = u * tileSize;
        points[index].z = v * tileSize;
        points[index].y = 0;
        points[index].y = getElevation(points[index], offset);
      }
    }
  }

  // Creates the landscape from the saved geometry
  PShape makeLandscape() {
    PShape s = createShape(GROUP);

    for ( int u = 0; u < nbU-1; ++u ) {
      PShape s_ = createShape();
      s_.beginShape(TRIANGLE_STRIP);
      s_.noFill();
      s_.noStroke();
      for ( int v = 0; v < nbV; ++v ) {
        int index = fetchIndex(u, v);  // Index of that point in the array, from (https://processing.org/tutorials/pixels/)

        //PVector norm;
        //norm = PVector.random3D();
        //norm = new PVector(1.0, 0.0, 0.0);

        //PVector A = points[index+1].copy();
        //PVector M = points[index].copy();
        //PVector B = points[constrain(index+(nbU), 0, 9999)].copy();
        //PVector MA = PVector.sub(M, A);
        //PVector MB = PVector.sub(M, B);
        //norm = MA.cross(MB);
        //s_.normal(norm.x, norm.y, norm.z);

        vert(s_, u, v);
        vert(s_, u+1, v);
      }
      s_.endShape(CLOSE);
      s.addChild(s_);
    }

    return s;
  }


  // Clearing all the points - mainly used to init the array
  void clear() {
    points = new PVector[nbU*nbV];

    for ( int i = 0; i < nbU*nbV; ++i ) {
      points[i] = new PVector();
    }
  }

  void vert(PShape s, int u, int v) {
    PVector vec = points[fetchIndex(u, v)];
    s.fill(
      map(vec.x, 0, lenU, 0, 127), 
      map(vec.x, 0, lenU, 255, 0), 
      map(vec.z, 0, lenV, 0, 255));
    if ( normalCorrection ) {
      determineNormal(s, u, v);
    }
    s.vertex(vec.x, vec.y, vec.z);
  }

  void determineNormal(PShape s, int u, int v) {
    if ( u == 0 || u == nbU-1 || v == 0 || v == nbV-1 ) {
      return; // Special case for the borders - not dealt with for now
    }

    int[] neighboursIndexes = {  // Can be expanded to 8 or more neighbours
      (fetchIndex(u+1, v)), 
      (fetchIndex(u-1, v+1)), 
      (fetchIndex(u, v+1)), 
      (fetchIndex(u+1, v+1)), 
      (fetchIndex(u+1, v)), 
      (fetchIndex(u+1, v-1)), 
      (fetchIndex(u, v-1)), 
      (fetchIndex(u-1, v-1)), 
    };

    PVector[] pts = new PVector[neighboursIndexes.length];  // Clowk-wise ordered neighbours
    PVector[] normals = new PVector[neighboursIndexes.length];

    for ( int i = 0; i < pts.length; ++i ) {   // Find the normals
      PVector seg = points[fetchIndex(u, v)].copy(); 
      seg.sub(points[neighboursIndexes[i]]);
      pts[i] = seg.copy();
    }

    for ( int i = 0; i < normals.length; ++i ) {
      PVector A = pts[i];
      PVector B = pts[(i+1)%normals.length];
      normals[i] = B.cross(A);
    }

    // Average all the normals
    PVector normalFinal = new PVector();
    for ( int i = 0; i < normals.length; ++i ) {
      normalFinal.add(normals[i]);
    }
    normalFinal.div(normals.length);

    normalFinal.normalize();

    // Apply normal
    s.normal(normalFinal.x, normalFinal.y, normalFinal.z);
  }

  int fetchIndex(int u, int v) {
    return u + v * nbU;
  }
}
