final int nbU = 100; //<>//
final int nbV = 100;
final int tileSize = 20;

class Landscape {

  PShape shape;
  PVector[] points;
  PVector offset;
  PVector center;

  float lenU = tileSize * nbU;
  float lenV = tileSize * nbV;

  Landscape() {
    offset = new PVector();
    this.clear();
    updateGeometry();
    shape = this.makeLandscape();

    center = new PVector(
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

      updateGeometry();
      this.shape = makeLandscape();
    }
  }

  void render() {
    shape(this.shape);
  }

  void run() {
    update();
    render();
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
        //PVector norm = PVector.random3D(); // For fun

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
    PVector vec = points[getIndex(u, v)];
    s.fill(
      map(vec.x, 0, lenU, 0, 127), 
      map(vec.x, 0, lenU, 255, 0), 
      map(vec.z, 0, lenV, 0, 255));
    if ( normalCorrection ) {
      determineNormal(s, u, v);
    }
    s.vertex(vec.x, vec.y, vec.z);
  }

  int getIndex(int u, int v) {
    u = constrain(u, 0, nbU - 1);
    v = constrain(v, 0, nbV - 1);
    return u + v * nbU;
  }

  // Optimised by nking - Returns the normal a vertex deserves 
  void determineNormal(PShape s, int x, int y) {
    int l = getIndex(x-1, y);
    int r = getIndex(x+1, y);
    int u = getIndex(x, y+1);
    int d = getIndex(x, y-1);
    PVector normal = new PVector();
    PVector.cross(
      PVector.sub(points[r], points[l]), 
      PVector.sub(points[u], points[d]), 
      normal
      );
    s.normal(normal.x, normal.y, normal.z);
  }
}
