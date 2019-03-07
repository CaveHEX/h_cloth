// Managing noise

float noiseEx = 0.005;

float getNoise(PVector v, PVector offset) {
  return (float) (noise.eval(
    v.x * noiseEx + offset.x, 
    v.y * noiseEx + offset.y, 
    v.z * noiseEx + offset.z
    ) + 1.0) * 0.5;
}

float getElevation(PVector v, PVector offset) {
  return getNoise(v, offset) * 600;
}
