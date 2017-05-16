int nodeCount;
Node[] nodes = new Node[100];
HashMap nodeTable = new HashMap( );
int edgeCount;
Edge[] edges = new Edge[500];

static final color nodeColor = #F0C070;
static final color selectColor = #FF3030;
static final color fixedColor = #FF8080;
static final color edgeColor = #000000;


PFont font;
void setup( ) {
  size(600, 600);
  loadData( );
  font = createFont("SansSerif", 10);
  textFont(font);
  smooth( );
}
void loadData( ) {
  addEdge("joe", "food");
  addEdge("joe", "dog");
  addEdge("joe", "tea");
  addEdge("joe", "cat");
  addEdge("joe", "table");
  addEdge("table", "plate");
  addEdge("plate", "food");
  addEdge("food", "mouse");
  addEdge("food", "dog");
  addEdge("mouse", "cat");
  addEdge("table", "cup");
  addEdge("cup", "tea");
  addEdge("dog", "cat");
  addEdge("cup", "spoon");
  addEdge("plate", "fork");
  addEdge("dog", "flea1");
  addEdge("dog", "flea2");
  addEdge("flea1", "flea2");
  addEdge("plate", "knife");
}

void addEdge(String fromLabel, String toLabel) {
  Node from = findNode(fromLabel);
  Node to = findNode(toLabel);
  Edge e = new Edge(from, to);
  if (edgeCount == edges.length) {
    edges = (Edge[]) expand(edges);
  }
  edges[edgeCount++] = e;
}

Node findNode(String label) {
  label = label.toLowerCase( );
  Node n = (Node) nodeTable.get(label);
  if (n == null) {
    return addNode(label);
  }
  return n;
}

Node addNode(String label) {
  Node n = new Node(label);
  if (nodeCount == nodes.length) {
    nodes = (Node[]) expand(nodes);
  }
  nodeTable.put(label, n);
  nodes[nodeCount++] = n;
  return n;
}

void draw( ) {
  background(255);
  for (int i = 0 ; i < edgeCount ; i++) {
    edges[i].relax( );
  }
  for (int i = 0; i < nodeCount; i++) {
    nodes[i].relax( );
  }
  for (int i = 0; i < nodeCount; i++) {
    nodes[i].update( );
  }
  for (int i = 0 ; i < edgeCount ; i++) {
    edges[i].draw( );
  }
  for (int i = 0 ; i < nodeCount ; i++) {
    nodes[i].draw( );
  }
}


//----------- for interaction---------------------
Node selection;
void mousePressed( ) {
  // Ignore anything greater than this distance.
  float closest = 20;
  for (int i = 0; i < nodeCount; i++) {
    Node n = nodes[i];
    float d = dist(mouseX, mouseY, n.x, n.y);
    if (d < closest) {
      selection = n;
      closest = d;
    }
  }
  if (selection != null) {
    if (mouseButton == LEFT) {
      selection.fixed = true;
    } 
    else if (mouseButton == RIGHT) {
      selection.fixed = false;
    }
  }
}
void mouseDragged( ) {
  if (selection != null) {
    selection.x = mouseX;
    selection.y = mouseY;
  }
}
void mouseReleased( ) {
  selection = null;
}


//-------------------------------to draw the lines between
class Edge {
  Node from;
  Node to;
  float len;

  Edge(Node from, Node to) {
    this.from = from;
    this.to = to;
    this.len = 50;
  }

  void relax( ) {
    float vx = to.x - from.x;
    float vy = to.y - from.y;
    float d = mag(vx, vy);
    if (d > 0) {
      float f = (len - d) / (d * 3);
      float dx = f * vx;

      float dy = f * vy;
      to.dx += dx;
      to.dy += dy;
      from.dx -= dx;
      from.dy -= dy;
    }
  }

  void draw( ) {
    stroke(edgeColor);
    strokeWeight(0.35);
    line(from.x, from.y, to.x, to.y);
  }
}

//---------Node
class Node {
  float x, y;
  float dx, dy;
  boolean fixed;
  String label;
  Node(String label) {
    this.label = label;
    x = random(width);
    y = random(height);
  }
  void relax( ) {
    float ddx = 0;
    float ddy = 0;
    for (int j = 0; j < nodeCount; j++) {
      Node n = nodes[j];
      if (n != this) {
        float vx = x - n.x;
        float vy = y - n.y;
        float lensq = vx * vx + vy * vy;
        if (lensq == 0) {
          ddx += random(1);
          ddy += random(1);
        } 
        else if (lensq < 100*100) {
          ddx += vx / lensq;
          ddy += vy / lensq;
        }
      }
    }
    float dlen = mag(ddx, ddy) / 2;
    if (dlen > 0) {
      dx += ddx / dlen;
      dy += ddy / dlen;
    }
  }
  void update( ) {
    if (!fixed) {
      x += constrain(dx, -5, 5);
      y += constrain(dy, -5, 5);
      x = constrain(x, 0, width);
      y = constrain(y, 0, height);
    }
    dx /= 2;
    dy /= 2;
  }
  void draw( ) {
    if (selection == this) {
      fill(selectColor);
    } 
    else if (fixed) {
      fill(fixedColor);
    } 
    else {
      fill(nodeColor);
    }
    stroke(0);
    strokeWeight(0.5);
    rectMode(CORNER);
    float w = textWidth(label) + 10;
    float h = textAscent( ) + textDescent( ) + 4;
    rect(x - w/2, y - h/2, w, h);
    fill(0);
    textAlign(CENTER, CENTER);
    text(label, x, y);
  }
}

