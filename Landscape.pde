final int nbU = 100;
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
    for ( int u = 0; u < nbU; ++u ) { //<>//
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
        int index = u + v * nbU;  // Index of that point in the array, from (https://processing.org/tutorials/pixels/)

        vert(s_, points[index]);
        vert(s_, points[index+1]);
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

  void vert(PShape s, PVector v) {
    s.fill(
      map(v.x, 0, lenU, 0, 127), 
      map(v.x, 0, lenU, 255, 0), 
      map(v.z, 0, lenV, 0, 255));
    s.vertex(v.x, v.y, v.z);
  }
}
