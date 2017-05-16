//global variables
float a=25;
float b=.5;
color c= color(255, 150);//white @ 50% transparent
boolean d=false;

void setup() {//reads once
  size(500, 300);
  background(0);
}

void draw() {
  frameRate(10);
  if (d==false) {//conditional if
    noFill();//appearance control
    stroke(c);
    strokeWeight(b);
    
    rect(mouseX, mouseY, a, a*2);//shape rectangle
    
    a=a*1.005;//update to variables
    b=(frameCount%2)+1*b;
    println(a); //terminal printout
  } 
  else {//conditional else
    noStroke();//appearance control
    fill(c);
    
    ellipse(mouseX, mouseY, a, a*2);//shape ellipse
    
    a=a*1.005;//update to variables
    b=(frameCount%2)+1*b;
    text(a, 25, height/2);
  }
}

void mousePressed(){
  d=!d;
}

