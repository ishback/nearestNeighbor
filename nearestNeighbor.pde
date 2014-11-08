PImage sample;
PImage[] modelImages;
String[] modelFilenames;

ArrayList<PVector> sampleWhitePix;
ArrayList<PVector> modelWhitePix;
ArrayList<ArrayList<PVector>> models;
FloatList distances;

int imageW = 180;
int imageH = 200;
color ghost = color(0, 255, 0, 100);
color white = color(255);
PFont f;
int numModels;


void setup() {
  background(0);
  smooth();
  f = loadFont( "Inconsolata-Regular-14.vlw" );
  textFont(f);  
  // load all the model images
  java.io.File modelFolder = new java.io.File(dataPath("models"));
  modelFilenames = modelFolder.list();
  numModels = modelFilenames.length;
  modelImages = new PImage[numModels];
  models = new ArrayList<ArrayList<PVector>>();
  distances = new FloatList();
  size(imageW * 3, imageW * numModels);
  pushMatrix();
  scale(0.7);
  sample = loadImage("sample.jpg");
  sample.filter(THRESHOLD);
  sampleWhitePix = new ArrayList<PVector>();
  storeWhitePixels(sample, sampleWhitePix);

  for (int i = 0; i < numModels; i++) {
    println("models/" + modelFilenames[i]);
    modelImages[i] = loadImage("models/" + modelFilenames[i]);
    modelImages[i].filter(THRESHOLD);
    models.add(new ArrayList<PVector>());
    storeWhitePixels(modelImages[i], models.get(i));
    
    displayPixels(sampleWhitePix, 0, i, white);
    displayPixels(models.get(i), 1, i, white);
    displayPixels(sampleWhitePix, 1, i, ghost);
    distances.append(nn(sampleWhitePix, models.get(i), i));
  }
  println(numModels + " model Images");
  popMatrix();

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
