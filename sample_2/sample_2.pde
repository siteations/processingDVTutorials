int y=50;
int x=25;


void setup() {
  size(500, 500);
  background(255);
}

void draw() {
  frameRate(10);

  strokeWeight(2);

  point( x, y );
  line ( x*2, y, x*3, y); 
  rect ( x*4, y, x, y);  
  ellipse ( x*6, y, x, x);  
  triangle ( x*7, y, x*8, y, x*7, y*2); 
  quad ( x*9, y, x*10, y, x*11, y*2, x*9, y*2); 

  arc ( x*12, y, x, x, 0, radians(90), CENTER); 
}
