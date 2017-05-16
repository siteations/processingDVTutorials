Table windy;
int windyRowCount;

PFont strong;

void setup() {
  size(800, 800);

  windy=loadTable("MonthlyHistory.csv", "header");
  strong = loadFont("CenturyGothic-48.vlw");

  textFont(strong, 12);

  windyRowCount=windy.getRowCount();
  println("# of rows in table: " + windyRowCount);
}

void draw() {
  background(255);
  frameRate(10);

  //for (int j=100; j<width-100; j+=100) {
  for (int i=0; i<windyRowCount; i++) { // i=i+1

    int speed=windy.getInt(i, " Mean Wind SpeedMPH");
    int direction= windy.getInt(i, " WindDirDegrees");
    String date= windy.getString(i, "date");
    // int xPos=(i+1)*(100);
    // int yPos=100;

    noStroke();
    fill(150, 100);
    //if (xPos<width-100){
    // for (int j=100; j<width-100; j+=100) {
    //  for (int k=100; k<height-100;k+=100) {
    arc(width/2, height/3, speed*40, speed*40, radians(direction), radians(direction+5), PIE);  


    //----------------------------------Bar graph---------------------------------------------------
    int lm=100;
    int rm=100;
    int bm=50;

    int barWidth = ((width - 2*lm)/windyRowCount);
    int graphHeight = height/3-bm;
    //basically all those speeds

    float graphHeightIn = map(speed, 0, 9, 0, graphHeight);
    fill(125, 150);

    if (mouseX>(100+i*barWidth) && mouseX<(100+i*barWidth+barWidth) &&
      mouseY>(height-bm-(graphHeightIn)) && mouseY<(height-bm)) {
      fill(0);
      textAlign(CENTER);
      text(date, (100+i*barWidth+barWidth/2), (height-bm-graphHeightIn-2));
      text(speed, (100+i*barWidth+barWidth/2), (height-bm-graphHeightIn-16));
      arc(width/2, height/3, speed*40, speed*40, radians(direction), radians(direction+5), PIE);
    }
    rect(100+i*barWidth, height-bm, barWidth, -(graphHeightIn));

    // }
    // xPos=0;
    // yPos=yPos+100;
    //}
  }
} 

