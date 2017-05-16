class Rose {

  //THINGS TO BE CALCULATED
  float lines;//per category
  float sum;//per category
  float sumWhole;
  float wedgeRad;
  int j;

  //TABLE REFERENCE
  Table []boilerT=new Table[7];// background boilerT of boiler info 
  //(again, but trying to work not from Fry's old boilerT, but use the built in java boilerT functions...)
  int []rowCount=new int[7]; //

  //INHERITED FROM ROSE_ARRAY
  String boro;
  float xPos; 

  String[] bldgType= {
    "Elevator Apartments", "Loft Buildings", "Walk-Up Apartments", "Educational Structures", "Office Buildings", 
    "Condominiums", "Churches, Synagogues, etc.", "Warehouses", "Hospitals & Health", "Hotels", "Factory & Industrial Buildings", 
    "Cultural & Public Assembly", "Asylums & Homes", "Transportation Facilities", "Utility Bureau", "Selected Government"
  };

  float []rad0=new float[16];
  float []rad1=new float[16];
  float []rad2=new float[16];
  float []rad3=new float[16];


  float[]r=new float[16];
  float[]b=new float[16];
  color[]c=new color[16]; //no green, set alpha for layering
  int w=2;

  /* NOTES FOR VARIABLE VALUES
   
   COLUMN 8
   String[] bldgType= {"Elevator Apartments", "Loft Buildings", "Walk-Up Apartments", "Educational Structures", "Office Buildings", 
   "Condominiums", "Churches, Synagogues, etc.", "Warehouses", "Hospitals & Health", "Hotels", "Factory & Industrial Buildings",
   "Cultural & Public Assembly", "Asylums & Homes", "Transportation Facilities", "Utility Bureau", "Selected Government"}; //categories & labels
   all in boilerT column 8
   
   COLUMN 3
   {"Manhattan", "Staten", "Bronx", "Queens", "Brooklyn"} 
   
   COLUMN 6
   type of oil (strings #6 or #4)
   
   COLUMN 7
   millions of BTU, estimated consumption
   
   COLUMN 9
   area of buildinglot
   
   COLUMN 10
   number of units
   
   COLUMN 11
   age of building
   
   */

  Rose(float _xPos, String _boro) {
    xPos=_xPos;
    boro=_boro;
    
    boilerT[0] = loadTable("boilers_clean.csv");
    boilerT[1] = loadTable("boilers_clean.csv");
    boilerT[2] = loadTable("boilers_cleanM.csv");
    boilerT[3] = loadTable("boilers_cleanS.csv");
    boilerT[4] = loadTable("boilers_cleanB.csv");
    boilerT[5] = loadTable("boilers_cleanQ.csv");
    boilerT[6] = loadTable("boilers_cleanR.csv");
    
    for (int i=0;i<7;i++) {    
      rowCount[i]=(boilerT[i].getRowCount());
    }
    frameRate(5);
  }

  void drawData() {// the pie's combined/arrayed per selector category
    // if ((boro=="Manhattan")||(boro=="Staten")||(boro=="Bronx")||(boro=="Queens")||(boro=="Brooklyn")) {
    // if (boro=="Manhattan"){
    //for (TableRow row : boilerT.findRows(boro, 3)) {//limits according to boro... will be in effect for all those
    //array function to hand the building types

    //NOT GETTING THE BORO SORT TO WORK SO I'M BREAKING THIS SUCKER UP (ADDING ANOTHER INHERITED VARIABLE FOR MATH/CLASS)
  if (boro=="Citywide"){
    j=0;
  }
  if (boro=="Manhattan"){
    j=2;
  }
    if (boro=="Staten"){
    j=3;
  }
  if (boro=="Bronx"){
    j=4;
  }
    if (boro=="Queens"){
    j=5;
  }
    if (boro=="Brooklyn"){
    j=6;
  }

    for (int i=0;i<16; i++) {
      rad0[i]= valRowSum(j,bldgType[i], 8, 7)/4;//outer ellipse, contribution 10k BTU consumed
      rad1[i]= rad0[i]*1000000/valRowSum(j,bldgType[i], 8, 9)/2;//average from totals=btu/sqft lot
      rad2[i]= (2013-(valRowAvg(j,bldgType[i], 8, 12)))/2+rad1[i];//average age of building (offset from center by rad1)
      rad3[i]= (valRowAvg(j,bldgType[i], 8, 10))/2+rad2[i];//average number of units (offset from center by rad1+rad2)
      println(rad0[i]+","+rad1[i]+","+rad2[i]+","+rad3[i]);

      r[i]= (valRowCount(j,"#4", 6)/valRowCount(j,bldgType[i], 8))*255;//color coded by fuel type!
      b[i]= (valRowCount(j,"#6", 6)/valRowCount(j,bldgType[i], 8))*255;
      c[i]=color(r[i], 50, b[i], 75); //overall

      //DRAW ELLIPSES
      noFill();
      stroke(c[i]);
      strokeWeight(w);
      ellipse(xPos, (i+1)*33, rad0[i], rad0[i]);
      ellipse(xPos, (i+1)*33, rad0[i], rad0[i]);
      line(xPos, (i+1)*33, xPos+rad0[i]/2, (i+1)*33);  // total contribution 10k BTU consumed

      stroke(255);
      strokeWeight(.25);
      fill(c[i]);
      ellipse(xPos, (i+1)*33, rad3[i], rad3[i]);//drawing values from bottom to top
      ellipse(xPos, (i+1)*33, rad2[i], rad2[i]);
      ellipse(xPos, (i+1)*33, rad1[i], rad1[i]);
      //}
      //}
    }
  }


  //ALL THE MATH- to get radii, pie angle slices and color values
  float valRowCount(int j, String type, int ColumnN) {//number of entries of that type
    // borough, oil, building type
    lines=0;  
    for (TableRow row : boilerT[j].findRows(type, ColumnN)) {
      lines=lines+1.0;
    }
    return lines;
  }

  float valRowSum (int j, String type, int ColumnN, int ColumnO) {//sum of those entries for additional value
    //total energy used, lot footage, years of installation blg or furnace
    sum=0; 
    for (TableRow row : boilerT[j].findRows(type, ColumnN)) {
      sum=sum+float(row.getString(ColumnO));
    }
    return sum;
  }

  float valColumnSum (int j, int ColumnO) {//sum of all entries in column
      //for things like energy used, lot footage, years of installation blg or furnace
      sumWhole=0; 
      for (TableRow row : boilerT[j].rows()) {
        sumWhole=sumWhole+float(row.getString(ColumnO));
    
    }
    return sumWhole;
  }

  float valRowAvg(int j, String type, int ColumnN, int ColumnO) {//average from above single 
    //variable sum and number of rows it occurs in
    lines=0;  
    sum=0;
    for (TableRow row : boilerT[j].findRows(type, ColumnN)) {
      lines=lines+1.0;
      sum=sum+float(row.getString(ColumnO));
    }
    float avg=sum/lines;
    return avg;
  }

  float radPerc(Float part, Float whole) {//to establish pie angle width from
    //valRowSum/valCoumnSun for basic pie wedges 
    wedgeRad=part/whole*360;//this is still in degrees so for use radians(wedgeRad); 
    return wedgeRad;
  }
}

