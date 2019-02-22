// Managing noise

float noiseEx = 0.001;

float getNoise(PVector v, PVector offset) {
  return noise(
    v.x * noiseEx + offset.x, 
    v.y * noiseEx + offset.y, 
    v.z * noiseEx + offset.z
    );
}

float getElevation(PVector v, PVector offset) {
  return getNoise(v, offset) * 600;
}
