void renderBox() {
  push();
  translate(landscape.center.x, landscape.center.x, landscape.center.z);
  noFill();
  stroke(255);
  box(landscape.center.x * 2);
  pop();
}

void applyCamera() {
  float camAngle     = -map(mouseX, 0, width, -PI, PI);
  float camDistance  = map(mouseY, 0, height, 500, 6000);

  PVector cam = new PVector(cos(camAngle)*camDistance, 1000, sin(camAngle)*camDistance).add(landscape.center);

  camera(
    cam.x, cam.y, cam.z, // Where the camera is
    landscape.center.x, 0, landscape.center.z, // What the camera is looking at
    0, -1, 0                                                      // Telling the camera "Y axis is up"
    );
}

void applyLights () {
  shininess(1.0);
  lightFalloff(1.0, 0.000001, 0.0);
  //ambientLight(10, 10, 10);
  directionalLight(150, 150, 150, 0.25, 0, 0.25);
  //lightSpecular(102, 102, 102);
  pointLight(255, 0, 0, landscape.center.x, 600, landscape.center.z);
  float rad = PVector.dist(new PVector(), landscape.center);
  pointLight(255, 0, 0, landscape.center.x, 600, landscape.center.z);
  pointLight(0, 255, 127,
  landscape.center.x + cos(time) * rad,
  600,
  landscape.center.z + sin(time) * rad);
  
  shader(phong);
}

void screenshot() {
  save("data/img/img_" + str(round(random(1000, 9999))) + ".png");
}
