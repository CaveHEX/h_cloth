// Credit where credit is due:
// Van Den Heuvel Matthew
// nking : Big math optimisation - phong shader

PShader phong;
Landscape landscape;
float time = 0;
boolean pause = false;
boolean normalCorrection = false;
OpenSimplexNoise noise;


void setup() {
  size(1000, 1000, P3D);
  frameRate(60);
  smooth(8);
  
  phong = loadShader("phongFrag.glsl", "phongVert.glsl");
  noise = new OpenSimplexNoise();
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
}

// Controls
void keyPressed() {
  if ( key == 'p' ) {
    pause = !pause;
  }

  if ( key == 's' ) {
    screenshot();
  }

  if ( key == 'c' ) {
    normalCorrection = !normalCorrection;
  }

  if ( key == '+' ) {
    noiseEx *= 1.5;
  }
  
  if ( key == '-' ) {
    noiseEx *= 0.5;
  }
}
