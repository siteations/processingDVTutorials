//GLOBAL VARIABLES
PShape mapNYC; //This is an underlying vector map

Table noise311;//This calls a new table
int rowCount;//to loop thru rows 

color cyan=color(61, 146, 208, 175);//this will be the symbol color r,g,b
int diameter; // we'll use this to loop circle radii

//****************************************************************
//-----------------BEGIN SETUP/ LOADS ONCE----------------
void setup() {
  size(1000, 800);
  mapNYC=loadShape("NYC1alts.svg");
  noise311=loadTable("311_2009-Noise.csv", "header");

  //------after table loads grab some basic values------------
  rowCount=noise311.getRowCount();
  println(rowCount);
}

//***************************************************************
//-----------------BEGIN DYNAMIC FUNCTIONS----------------
void draw() {
  background(255);
  shape(mapNYC, 0, 0, width, height);

  noFill();
  stroke(cyan);
  strokeWeight(5);

//-----------------reading thru data table for:---------------- 
  for (int i=0;i<rowCount;i++) {// loops through all rows!

    //-----------geographic location------------------ 
    float x=noise311.getFloat(i, "Longitude");// for each row, grabs the float from longtitude
    float y=noise311.getFloat(i, "Latitude");
    /* map lat/longitude note:
     (x goes from -74.3 to -73.65, y goes from 40.95 to 40.45)*/

    float lng = map(x, -74.3, -73.65, 0, width);
    float lat = map(y, 40.95, 40.45, 0, height);

    point(lng, lat);//geographic point
  } //ends the read thru of table
  
}
