/*
overall structure:
 
 4 levels of complexity: 
 
 for each- articulated rose w/ 3 layers:
 angle=percentage contibution to total (Type1 and Type2)
 persqft consumption in 10k BTU, (all Types)
 average building age,
 average number of units,
 
 map red to blue tones based on #4 to #6
 #4 percentage total (b, 0-255)
 #6 percentage total (r, 0-255)

(RoseType1)-  citywide - split by boro- sum circle...later
 
(RoseType2)- circle behind/before each shows total contribution... later
 for each boro, pie-slices(RoseType2) are by building type
 
(RoseType3)- arrayed building types (RoseType3) w/ #4 vs #6 contributions
 
 buttons pull up each type- called by
*/


Button []selectB=new Button[7];// buttons to select between scales of info...
Rose []dataRoses= new Rose [7];//body of data display based on table values...

//Table []boilerT=new Table[7]; ALL INTERNAL TO ROSE TABLE
//// background table of boiler info 
////(again, but trying to work not from Fry's old table, but use the built in java table functions...)
//int rowCount; //


String[] boro= {"Citywide", " ", "Manhattan", "Staten", "Bronx", "Queens", "Brooklyn"}; //categories & labels
Boolean[] boroSelect= {false, false, false, false, false, false, false};

String[] bldgType= {"Elevator Apartments", "Loft Buildings", "Walk-Up Apartments", "Educational Structures", "Office Buildings", 
"Condominiums", "Churches, Synagogues, etc.", "Warehouses", "Hospitals & Health", "Hotels", "Factory & Industrial Buildings",
"Cultural & Public Assembly", "Asylums & Homes", "Transportation Facilities", "Utility Bureau", "Selected Government"}; //categories & labels

PFont font;// so the above will display correctly- simple and universal font!

void setup() {
  size(850, 600);
  background(255);
  font = loadFont("Avenir45BookLight-10.vlw");// so the above will display correctly- simple and universal font!
  textFont(font, 10);

//  boilerT = loadTable("boilers_clean.csv");
//  rowCount=(boilerT.getRowCount());

  for (int i=0; i<7; i++) {
    selectB[i]=new Button((i+1)*100-50, boro[i]);
    dataRoses[i]=new Rose((i+1)*100-25, boro[i]);
  }
}


void draw() { 
  background(0);
  for (int i=0; i<7; i++) {//BUTTONS AND ROSE SERIES IN HERE
    selectB[i].drawButton();
    if (boroSelect[i]==true) {// use this to then pull up each rose spread as seperate if statement
     dataRoses[i].drawData();
      //ellipse((i+1)*100-25, height/2, 50, 50);//placeholder for cycling through the label/tag types
    }
  } 
  
 for (int j=0;j<16; j++){//ROSE LEFT LABELS HERE
   textAlign(LEFT);
   textFont(font, 8);
   fill(255);
   text(bldgType[j], 750, (j+1)*33);
   strokeWeight(.15);
   stroke(200);
   line(0,(j+1)*33, 740, (j+1)*33);
   noFill();
   textAlign(CENTER);
   textFont(font, 10);
 }
   
}

void mousePressed() {
  for (int i=0; i<7;i++) {//turn buttons-fill(add back) and rose variants back
    if (selectB[i].mouseInt()==true) {
      selectB[i].buttonState=!selectB[i].buttonState;
      boroSelect[i]=!boroSelect[i];
    }
  }
  saveFrame("boilers-####.png");
}







