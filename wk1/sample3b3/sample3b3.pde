//GLOBAL VARIABLES
PShape mapNYC; //This is an underlying vector map

Table noise311;//This calls a new table
int rowCount;//to loop thru rows 

color cyan=color(61, 146, 208, 175);//this will be the symbol color r,g,b
int dia; // we'll use this to loop circle radii


//sorting and writing new tables
Table dogTable;
Table manhattanTable;

int rowCountDM;//counts for 311 dogs in mahattan 

//-----------------INTERACTION aids----------------
boolean zoom=false; //zoom to area or not

//****************************************************************
//-----------------BEGIN SETUP/ LOADS ONCE----------------
void setup() {
  size(1000, 800);
  mapNYC=loadShape("NYC1alts.svg");
  noise311=loadTable("311_2009-Noise.csv", "header");
  
  dogTable=new Table();
  manhattanTable=new Table();


  //------after table loads grab some basic values------------
  rowCount=noise311.getRowCount();
  println(rowCount);

  //------do permanent filtering/write additional tables------------------------------
  for (TableRow barking : noise311.findRows("Noise, Barking Dog (NR5)", "Descriptor")) {
    TableRow newRow = dogTable.addRow(barking);
  }    
  saveTable(dogTable, "data/dog311.csv");// all barking dogs into a table

    for (TableRow barkingM : dogTable.findRows("MANHATTAN", 8)) {
    TableRow newRow = manhattanTable.addRow(barkingM);
  }    
  saveTable(manhattanTable, "data/dogM311.csv");// all barking manhattan as table

    rowCountDM=manhattanTable.getRowCount();
  println(rowCountDM);

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

  shape(mapNYC, 0, 0, width, height);

  noFill();
  stroke(cyan);
  //strokeWeight(5); comment out for smaller stroke
  strokeWeight(.25);

  //-----------------reading thru data table for:---------------- 
  for (int i=0;i<rowCountDM;i++) {// loops through all rows!

    //-----------geographic location------------------ 
    float x=manhattanTable.getFloat(i, 10);// for each row, grabs the float from longtitude
    float y=manhattanTable.getFloat(i, 9);
    /* map lat/longitude note:
     (x goes from -74.3 to -73.65, y goes from 40.95 to 40.45)*/

    float lng = map(x, -74.3, -73.65, 0, width);
    float lat = map(y, 40.95, 40.45, 0, height);

    noFill();//fill
    dia=5;//diameter of symbol
    //------------the symbol------------------
    ellipse(lng, lat, dia, dia);// draws symbol
    

  
  } //ends the read thru of table
  



   
  }

  //------MOUSE interaction to trigger zoom---------------------------
  void mousePressed() {
    zoom=! zoom;
  }
  


