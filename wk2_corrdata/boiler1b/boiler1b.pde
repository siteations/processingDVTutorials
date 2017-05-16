// second graph of boiler age over building age (sums and graphs)

// diameters shown according to key thresholds, define color arrays

// turn map underlay on or off



//------------------------------------ADDITIONS ABOVE----------------------------------------

//GLOBAL VARIABLES
PShape mapNYC; //This is an underlying vector map

Table boiler;//This calls a new table
int rowCount;//to loop thru rows 

color cyan=color(0, 200);//this will be the symbol color r,g,b

color orange= color(211, 58, 6);
color red= color(211, 32, 80);
color pink= color(211, 6, 154);
color purple= color(129, 20, 177);
color blue= color(47, 34, 200);

int li=35;
int mid=150;
//int dark=220;

float dia; // we'll use this to loop circle radii
int count; //number of manhattan boiler counts calls total

//sorting and writing new tables
Table manhattanBoiler;

// getting the count by dates
StringList allDates = new StringList();
IntDict dateCount = new IntDict();
String[] sortedDates;
int[] sortedCounts;

// getting the count by dates
StringList allInstall = new StringList();
IntDict installCount = new IntDict();
String[] sortedInstall;
int[] sortedICounts;

int rowCountMB;//counts for 311 dogs in mahattan 

//-----------------INTERACTION aids----------------
boolean zoom=false; //zoom to area or not
boolean m=true; //map on or not

//****************************************************************
//-----------------BEGIN SETUP/ LOADS ONCE----------------
void setup() {
  size(1000, 800);
  mapNYC=loadShape("NYC1alts.svg");
  boiler=loadTable("boilers_clean.csv", "header");

  manhattanBoiler=new Table();


  //------after table loads grab some basic values------------
  rowCount=boiler.getRowCount();
  println(rowCount);

  //------do permanent filtering/write additional tables------------------------------    
  //TableRow newRow = manhattanBoiler.addRow(0); // adds header for search
  manhattanBoiler.addColumn("id");
  manhattanBoiler.addColumn("longitude");
  manhattanBoiler.addColumn("latitude");
  manhattanBoiler.addColumn("borough");
  manhattanBoiler.addColumn("zipcode");
  manhattanBoiler.addColumn("number of boilers");
  manhattanBoiler.addColumn("oil type");
  manhattanBoiler.addColumn("million btu");
  manhattanBoiler.addColumn("typology");
  manhattanBoiler.addColumn("lot area");
  manhattanBoiler.addColumn("number of units");
  manhattanBoiler.addColumn("built");
  manhattanBoiler.addColumn("installed");
  // how is this efficient?

  for (TableRow boro : boiler.findRows("Manhattan", "borough")) {// collect only manhattan series
    TableRow newRow = manhattanBoiler.addRow(boro);
  }    
  saveTable(manhattanBoiler, "data/boilers_M.csv");// all boilers manhattan as table

  rowCountMB=manhattanBoiler.getRowCount();
  println(rowCountMB);



  //---------------built counts-----------------
  for (TableRow dateRow : manhattanBoiler.rows()) {
    // get the values under the building built date
    String date = dateRow.getString("built");
    // add the dates to the StringList
    allDates.append(date);
  }

  // Get the count of how many times each string appears, copy it to an IntDict, and sort
  // this tells how the # of complaints/day for creating a timeline
  dateCount = allDates.getTally();
  dateCount.sortKeys();
  println(dateCount);

  // Split sorted strings and sorted counts into arrays
  sortedDates = dateCount.keyArray();
  sortedCounts = dateCount.valueArray();// these will then show general age of older boiler systems
}

//***************************************************************
//-----------------BEGIN DYNAMIC FUNCTIONS----------------
void draw() {
  background(255);

  //crosshairs
  line(0, height/2, width, height/2);
  line(width/2, 0, width/2, height);

  //-----------------simple zoom of view----------------  
  if (zoom==true) {
    scale(10);
    translate((mouseX - width/(20))*-1, (mouseY - height/20)*-1);
  } 
  else {
    scale(1);
  }

  if (m==true) { 
    shape(mapNYC, 0, 0, width, height);
  }

  noFill();
  stroke(cyan);
  //strokeWeight(5); comment out for smaller stroke
  strokeWeight(.25);

  //-----------------reading thru data table for:---------------- 
  for (int i=0;i<rowCountMB;i++) {// loops through all rows!

    //-----------geographic location------------------ 
    float x=manhattanBoiler.getFloat(i, "longitude");// for each row, grabs the float from longtitude
    float y=manhattanBoiler.getFloat(i, "latitude");

    float blBTU=manhattanBoiler.getFloat(i, "million btu");//for diameter and for color keys

    /* map lat/longitude note:
     (x goes from -74.3 to -73.65, y goes from 40.95 to 40.45)*/

    float lng = map(x, -74.3, -73.65, 0, width);
    float lat = map(y, 40.95, 40.45, 0, height);

    noFill();//fill
    dia=blBTU*.5;//diameter of symbol


    //------------the symbolization------------------


    if (blBTU<=5) {
      fill(blue, li);
      stroke(blue, mid);
    } 
    if (blBTU>5 && blBTU<=25) {
      fill(purple, li);
      stroke(purple, mid);
    }
    if (blBTU>25 && blBTU<=50) {
      fill(pink, li);
      stroke(pink, mid);
    }
    if (blBTU>50 && blBTU<=100) {
      fill(red, li);
      stroke(red, mid);
    } 
    if (blBTU>100 && blBTU<=1000) {
      fill(orange, li);
      stroke(orange, mid);
    }

    //noStroke();
    //----------------the symbol-------------------------
    ellipse(lng, lat, dia, dia);// draws symbol

    //----add hover labels-----------------------
    String date=manhattanBoiler.getString(i, "built");
    String type=manhattanBoiler.getString(i, "typology");
    String zip=manhattanBoiler.getString(i, "zipcode");
    String oil=manhattanBoiler.getString(i, "oil type");

    if (zoom==false && mouseX>(lng-2) && mouseX<(lng+2) && mouseY>(lat-2) && mouseY<(lat+2)) {
      textSize(10);
      textAlign(LEFT);
      text(oil + " " + date + " " + type + " " + zip, 100, 260);
    } 
    else if (zoom==true && mouseX>(lng-1) && mouseX<(lng+1) && mouseY>(lat-1) && mouseY<(lat+1)) {
      textSize(1);
      textAlign(LEFT);
      fill (0);
      text(oil + " " + date + " " + type + " "  + zip, mouseX+2, mouseY);    

      fill(cyan);
    }
  } //ends the read thru of table

  //--------------------OVERALL TITLE/KEY---------------------------

  textSize(24);
  textAlign(LEFT);
  fill(cyan);
  text("#4 and #6 Oil Consumption, Manhattan Heating Boilers", 20, 40);

  textSize(10);
  textAlign(LEFT);
  text("Press P to record png", 50, 70);
  text("Click mouse to zoom", 50, 80);

  // addition of ellipse key
  //------------------------add in the text labels for series
  fill(blue, li);
  ellipse(50, 90, 2.5, 2.5);
  fill(purple, li);
  ellipse(50, 110, 10, 10);
  fill(pink, li);
  ellipse(50, 140, 20, 20);
  fill(red, li);
  ellipse(50, 190, 40, 40);
  fill(orange, li);
  ellipse(50, 300, 100, 100);


  //BAR GRAPH OF VALUES 
  //borders for graph - left, right, top
  int lb = 100;
  int rb = 25;
  int tb = 200;
  int of=10;

  int barWidth = ((width - lb)/sortedDates.length);
  int graphHeight = (height - tb);
  float graphHeightIn = max(sortedCounts)/max(sortedCounts);
  int maxValue = max(sortedCounts);


  for (int i = 0; i <sortedCounts.length; i++) {     // map data to height of graph     
    int barHeight = (int) map(sortedCounts[i], 0, maxValue, 0, graphHeight);     
    fill(purple, mid);     
    //if the mouse is within the x-boundary of a bar, highlight it 
    //and display its data over the bar      
    if (mouseX >= lb + (i*barWidth) && mouseX <= lb +((i+1)*barWidth) && mouseY >= height-barHeight-of && mouseY <= height-of) {
      fill(0);
      textAlign(CENTER);
      text(sortedCounts[i], (lb+(i*barWidth)+barWidth/2), height-barHeight-30-of);
      text(sortedDates[i], (lb+(i*barWidth)+barWidth/2), height-barHeight-20-of);
    }

    // draw the bar
    rect(lb+(i*barWidth), height-of, barWidth, -barHeight-of);
  }
}

//------MOUSE interaction to trigger zoom---------------------------
void mousePressed() {
  zoom=! zoom;
}

void keyPressed() {
  //-----------------------the on/off of the map
  if (key=='m') {
    m = !m;//inverts the boolean
  }



  //--------------------for saving out images-----------------------
  if (key=='p') {

    saveFrame("boiler-######.png");//save out a png file also
  }
}

