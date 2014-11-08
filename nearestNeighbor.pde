PImage sample;
PImage model1;
PImage model2;
ArrayList<PVector> sampleWhitePix;
ArrayList<PVector> model1WhitePix;
ArrayList<PVector> model2WhitePix;
int imageW = 180;
int imageH = 200;
color ghost = color(0, 255, 0, 100);
color white = color(255);
PFont f;

void setup() {
  background(0);
  smooth();
  f = loadFont( "Inconsolata-Regular-14.vlw" );
  textFont(f);
  sample = loadImage("sample.jpg");
  model1 = loadImage("model1.jpg");
  model2 = loadImage("model2.jpg");
  size(sample.width * 3, sample.height*2);
  sample.filter(THRESHOLD);
  model1.filter(THRESHOLD);
  model2.filter(THRESHOLD);
  sampleWhitePix = new ArrayList<PVector>();  // Create an empty ArrayList
  model1WhitePix = new ArrayList<PVector>();
  model2WhitePix = new ArrayList<PVector>();
  
  // we store the white pixels in a new array
  storeWhitePixels(sample, sampleWhitePix);
  storeWhitePixels(model1, model1WhitePix);
  storeWhitePixels(model2, model2WhitePix);
  //image(sample, 0, 0);
  displayPixels(sampleWhitePix, 0, 0, white);
  displayPixels(model1WhitePix, 1, 0, white);
  displayPixels(sampleWhitePix, 1, 0, ghost);

  displayPixels(sampleWhitePix, 0, 1, white);
  displayPixels(model2WhitePix, 1, 1, white);
  displayPixels(sampleWhitePix, 1, 1, ghost);

  println("sample: " + sampleWhitePix.size());
  println("model: " + model1WhitePix.size());
  float totalDist0 = nn(sampleWhitePix, model1WhitePix, 0);
  float totalDist1 = nn(sampleWhitePix, model2WhitePix, 1);
}

void displayPixels(ArrayList<PVector> arrayModel, int posX, int posY, color c){
  for (int i = 0; i < arrayModel.size(); i++){
    PVector p = arrayModel.get(i);
    stroke(c);
    point(imageW*posX + p.x, imageH*posY + p.y);
  }
}

float nn (ArrayList<PVector> arraySample, ArrayList<PVector> arrayModel, int num){
  float totalDist = 0;
  PVector closest = new PVector(0,0);
  for (int i = 0 ; i < arraySample.size() ; i++) {
    float dist = 100000000; // set to large number initially. no need to store.
    PVector s = arraySample.get(i);
    for (int j = 0 ; j < arrayModel.size() ; j++) {
      PVector m = arrayModel.get(j);
      float thisDist = dist(s.x, s.y, m.x, m.y);
      
      if (thisDist < dist) {
        dist = thisDist;
        closest = new PVector(m.x, m.y);
      }
    }
    stroke(0, 255, 0,30);
    pushMatrix();
    translate(180*2, 200*num);
    line(s.x, s.y, closest.x, closest.y);
    popMatrix();
    totalDist += dist;
  }
  
  fill(255);
  text(totalDist, 450, 190*(1+num));
  println("totalDist: " + totalDist);
  return totalDist;
}

void storeWhitePixels(PImage image, ArrayList<PVector> array){
  for (int i=0; i < 36000 ; i++){
    if (red(image.pixels[i]) == 255){ //the pixels is white
      array.add(new PVector(i%image.width, i/image.width));
    }
  }
}
