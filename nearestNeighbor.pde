PImage sample;
PImage[] modelImages;
ArrayList<String> modelFilenames;
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
int nearest;
boolean newImage = true;

void setup() {
  background(0);
  smooth();
  f = loadFont( "Inconsolata-Regular-14.vlw" );
  textFont(f);  
  // load all the model images
  java.io.File modelFolder = new java.io.File(dataPath("models"));
  String[] modelFilenamesTemp = modelFolder.list();
  modelFilenames = new ArrayList<String>();
  for (int i = 0; i < modelFilenamesTemp.length; i++) {
    if (!modelFilenamesTemp[i].startsWith(".")){
      modelFilenames.add(modelFilenamesTemp[i]);
    }
  }
  numModels = modelFilenames.size();
  modelImages = new PImage[numModels];
  models = new ArrayList<ArrayList<PVector>>();
  distances = new FloatList();
  size(imageW * 6, imageH * 3);
  
}

void draw(){
  
  if (newImage){
    background(0);
    recalculate();
    newImage = false;
  }
}

void recalculate(){
  sample = loadImage("sample.jpg");
  sample.resize(180, 200);
  sample.filter(THRESHOLD);
  sampleWhitePix = new ArrayList<PVector>();
  storeWhitePixels(sample, sampleWhitePix);
  displayPixels(sampleWhitePix, 0, white);
  for (int i = 0; i < numModels; i++) {
    println("models/" + modelFilenames.get(i));
    modelImages[i] = loadImage("models/" + modelFilenames.get(i));
    modelImages[i].filter(THRESHOLD);
    models.add(new ArrayList<PVector>());
    storeWhitePixels(modelImages[i], models.get(i));
    
    
    displayPixels(models.get(i), i+1, white);
    //displayPixels(sampleWhitePix, i+1, ghost);
    distances.append(nn(sampleWhitePix, models.get(i), i+1));
    if (distances.get(i) == distances.min()){
      nearest = i; //this saves the index of the closest model.
    }
  }
  println(numModels + " model Images");
  drawRectNearest();
  dataViz();
}

void dataViz(){
  pushMatrix();
  translate(550, 500);
  stroke(40);
  line(0, 0, 500, 0);
  for (int i=0; i < distances.size(); i++){
    noStroke();
    fill(0, 200, 220);
    ellipse(distances.get(i)/200, 0, 5, 5);
  
  }
  popMatrix();
}

void drawRectNearest(){
  stroke(0, 255, 0);
  noFill();
  int posX = (nearest+1)%(width/imageW);
  int posY = (nearest+1)/(width/imageW);
  rect(imageW*posX, imageH*posY, imageW, imageH);
}

void displayPixels(ArrayList<PVector> arrayModel, int pos, color c){
  int posX = pos%(width/imageW);
  int posY = pos/(width/imageW);
  for (int i = 0; i < arrayModel.size(); i++){
    PVector p = arrayModel.get(i);
    stroke(c);
    point(imageW*posX + p.x, imageH*posY + p.y);
  }
}

float nn (ArrayList<PVector> arraySample, ArrayList<PVector> arrayModel, int pos){
  float totalDist = 0;
  PVector closest = new PVector(0,0);
  int posX = pos%(width/imageW);
  int posY = pos/(width/imageW);
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
    translate(imageW*posX, imageH*posY);
    line(s.x, s.y, closest.x, closest.y);
    popMatrix();
    totalDist += dist;
  }
  pushMatrix();
  translate(imageW*posX + 50, imageH*posY + 190);
  fill(255);
  text(totalDist, 0, 0);
  popMatrix();
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

void keyPressed() {
  if (key == 'R' || key == 'r') {
    newImage = true;
  }
}
