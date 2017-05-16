//GLOBAL VARIABLES
PShape mapNYC; //This is an underlying vector map

Table noise311;//This calls a new table
int rowCount;//to loop thru rows 

color cyan=color(61, 146, 208, 175);//this will be the symbol color r,g,b
int dia; // we'll use this to loop circle radii

//-----------------INTERACTION aids----------------
boolean zoom=false; //zoom to area or not

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
  
      //-----------------simple zoom of view----------------  
  if (zoom==true) {
    scale(10);
    translate((mouseX - width/(20))*-1, (mouseY - height/20)*-1);
  } 
  else {
    scale(1);
  }
  //-----------------------------map basics------------------
  
  //shape(mapNYC, 0, 0, width, height);

  noFill();
  stroke(cyan);
  //strokeWeight(5); comment out for smaller stroke
  strokeWeight(.25);
  

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

      //-----------filter and create symbology------------------ 
    String boro=noise311.getString(i, "Borough");
    String type=noise311.getString(i, "Descriptor");

    if (type.equals("Noise, Barking Dog (NR5)") && boro.equals("MANHATTAN")) {//if the info fits this description, draw as:
      strokeWeight(1);// stroke
      noFill();//fill
      dia=10;//diameter of symbol
      //------------the symbol------------------
      ellipse(lng, lat, dia, dia);// draws symbol
    } //end conditional search for dogs & manhattan
  } //ends the read thru of table
}

  //------MOUSE interaction to trigger zoom---------------------------
  void mousePressed() {
    zoom=! zoom;
  }

