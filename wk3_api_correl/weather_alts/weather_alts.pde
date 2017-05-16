Table monthly;

void setup() {
  size(1000, 500);
  background(255);

  //monthly = loadTable("http://www.wunderground.com/history/airport/KNYC/2013/11/22/MonthlyHistory.html?format=1");
  monthly = loadTable("MonthlyHistory.csv", "header");
  
    for (int i=0; i<monthly.getRowCount();i++) {
  
      TableRow row = monthly.getRow(i);
  
      String date=row.getString("EST");
      float speed=row.getFloat(" Mean Wind SpeedMPH");
      float direction=row.getFloat(" WindDirDegrees");
  
      fill(0);
      textAlign(RIGHT, TOP);
    
      textSize(10);
      text(date, 50, 16*i);
  
      fill((direction/360)*255);
      rect(55, 16*i, speed*10, 8);
    }
  }

