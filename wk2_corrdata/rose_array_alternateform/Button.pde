class Button {
  boolean buttonState=false; 
  int x; // input
  String label; // inputs
  int y=566;
  int xW=60;
  int yH=20;
  


  Button(int _x, String _label) {
    x=_x;
    label=_label;
  }

  void drawButton() {
    if (buttonState==true) {
      fill(100,0,125);//placeholder, def color from 4/6 ratio
    } 
    else {
      noFill();
    }
    stroke(255);// placeholder, color keyed to what?
    strokeWeight(3);
    rect(x, y, xW, yH);
    fill(255);
    textAlign(CENTER);
    text(label, x+xW/2, y+15);
  }

  boolean mouseInt() {
    if ((mouseX>x) && (mouseX<x+xW) && 
      (mouseY>y) && (mouseY<y+yH)) {
      return true;
    } 
    else {
      return false;
    }
  }
}   

