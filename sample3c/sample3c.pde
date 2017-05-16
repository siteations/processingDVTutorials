//GLOBAL VARIABLES
PShape mapNYC; //This is an underlying vector map

Table noise311;//This calls a new table
int rowCount;//to loop thru rows 

color cyan=color(61, 146, 208, 175);//this will be the symbol color r,g,b
int dia; // we'll use this to loop circle radii
int count; //number of manhattan dog calls total

//sorting and writing new tables
Table dogTable;
Table manhattanTable;

// getting the count by dates
StringList allDates = new StringList();
IntDict dateCount = new IntDict();
String[] sortedDates;
int[] sortedCounts;

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

//STUDENTS STOPPED HERE... WK 2 BEGINS WITH THE ALLDATES.APPEND SERIES OF SUMMATIONS
//NO LABELS, NO TEXT, NO SYMBOLS, NO SAVE OUT OR IMPORT LESSONS YET....
  //---------------sum instances for display-----------------
  for (TableRow dateRow : manhattanTable.rows()) {
    // get the values under the published date column
    String date = dateRow.getString(1);
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
  sortedCounts = dateCount.valueArray();
}
//BACK ON SCHEDULE BUT NEED TO ADD IN THE SYMBOLOGY @ THE BOTTOM


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
  


// AFTER THE CALCULATIONS NEED TO RE-BEGIN THE STUDENT LESSON HERE.....
  //BAR GRAPH OF VALUES 
  //borders for graph - left, right, top
  int lb = 100;
  int rb = 25;
  int tb = 600;

  int barWidth = ((width - lb)/sortedDates.length);
  int graphHeight = (height - tb);
  int maxValue = max(sortedCounts);


  for (int i = 0; i <sortedCounts.length; i++) {     // map data to height of graph     
    int barHeight = (int) map(sortedCounts[i], 0, maxValue, 0, graphHeight);     
    fill(cyan);     
    //if the mouse is within the x-boundary of a bar, highlight it 
    //and display its data over the bar      
    if (mouseX >= lb + (i*barWidth) && mouseX <= lb +(i*barWidth) + barWidth && mouseY >= height-barHeight) {
      fill(0);
      textAlign(CENTER);
      text(sortedCounts[i], (lb+(i*barWidth)+barWidth/2), height-barHeight-10);
      text(sortedDates[i], (lb+(i*barWidth)+barWidth/2), height-barHeight-30);     
      }

      // draw the bar
      rect(lb+(i*barWidth), height, barWidth, -barHeight);
// END ADDITION OF SYMBOLOGY
    }
   
  }

  //------MOUSE interaction to trigger zoom---------------------------
  void mousePressed() {
    zoom=! zoom;
  }
  


