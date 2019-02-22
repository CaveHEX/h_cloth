Landscape landscape;
float time = 0;
boolean pause = false;

void setup() {
  size(1000, 1000, P3D);
  frameRate(60);
  smooth(8);

  landscape = new Landscape();
}

void draw() {
  background(40);

  // Control the speed of the sketch without impacting the framerate
  time = frameCount * 0.005;  

  applyCamera();
  applyLights();

  landscape.run();
  renderBox();

  endCamera();
  pop();

  debugInfo();
}

// Controls
void keyPressed() {
  if ( key == 'p' ) {
    pause = !pause;
  }
}
