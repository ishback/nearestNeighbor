PImage sample;
PImage sample1;
PImage model;
ArrayList<PVector> sampleWhitePix;
ArrayList<PVector> sample1WhitePix;
ArrayList<PVector> modelWhitePix;
PFont f;

void setup() {
  smooth();
  f = loadFont( "Inconsolata-Regular-14.vlw" );
  textFont(f);
  model = loadImage("model.jpg");
  sample = loadImage("sample.jpg");
  sample1 = loadImage("sample1.jpg");
  size(sample.width * 3, sample.height*2);
  sample.filter(THRESHOLD);
  sample1.filter(THRESHOLD);
  model.filter(THRESHOLD);
  sampleWhitePix = new ArrayList<PVector>();  // Create an empty ArrayList
  sample1WhitePix = new ArrayList<PVector>();
  modelWhitePix = new ArrayList<PVector>();
  image(sample, 0, 0);
  image(model, 180, 0);
  tint(255, 50);  // Display at half opacity
  image(sample, 180, 0);
  fill(0);
  rect(180*2,0,180,200);
  
  pushMatrix();
  translate(0, 200);
  image(sample1, 0, 0);
  image(model, 180, 0);
  tint(255, 50);  // Display at half opacity
  image(sample1, 180, 0);
  fill(0);
  rect(180*2,0,180,200);
  
  popMatrix()
  
  // we store the white pixels in a new array
  
  storeWhitePixels(sample, sampleWhitePix);
  storeWhitePixels(sample1, sample1WhitePix);
  storeWhitePixels(model, modelWhitePix);
  
  println("sample: " + sampleWhitePix.size());
  println("model: " + modelWhitePix.size());
  PVector closest = new PVector(0, 0);
  float totalDist = 0;
  // we calculate the nearest neighbor
  for (int i = 0 ; i < sampleWhitePix.size() ; i++) {
    float dist = 100000000; // set to large number initially. no need to store.
    PVector s = sampleWhitePix.get(i);
    for (int j = 0 ; j < modelWhitePix.size() ; j++) {
      PVector m = modelWhitePix.get(j);
      float thisDist = dist(s.x, s.y, m.x, m.y);
      
      if (thisDist < dist) {
        dist = thisDist;
        closest = new PVector(m.x, m.y);
      }
    }
    stroke(0, 255, 0,30);
    pushMatrix();
    translate(180*2,0);
    line(s.x, s.y, closest.x, closest.y);
    popMatrix();
    totalDist += dist;
  }
  fill(255);
  text(totalDist, 450, 190);
  println("totalDist: " + totalDist);
  
}


void storeWhitePixels(PImage image, ArrayList<PVector> array){
  for (int i=0; i < 36000 ; i++){
    if (red(image.pixels[i]) == 255){ //the pixels is white
      array.add(new PVector(i%image.width, i/image.width));
    }
  }
}
