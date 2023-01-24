/* CSci-5609 Support Code created by Prof. Dan Keefe, Fall 2023

Click and drag the left mouse button to pan the virtual page, and scroll the mouse 
wheel up or down to zoom in and out.  See the comments at the top of the PanZoomPage
file to learn more.
*/

PanZoomPage panZoomPage;

void setup() {
  size(1600, 900);
  panZoomPage = new PanZoomPage(); 
}

void draw() {
  background(100);
  
  // draw a white square that covers the entire virtual page
  fill(255);
  stroke(0);
  rectMode(CORNERS);
  rect(panZoomPage.pageXtoScreenX(0), panZoomPage.pageYtoScreenY(0),
       panZoomPage.pageXtoScreenX(1), panZoomPage.pageYtoScreenY(1));

  // draw a circle at the center of the page with a radius 0.25 times the width
  // of the page
  float radius = panZoomPage.pageLengthToScreenLength(0.25);
  float cx = panZoomPage.pageXtoScreenX(0.5);
  float cy = panZoomPage.pageYtoScreenY(0.5);
  fill(200,0,200);
  ellipseMode(RADIUS);
  circle(cx, cy, radius);  
}

void mousePressed() {
  panZoomPage.mousePressed();
}

void mouseDragged() {
  panZoomPage.mouseDragged();
}

void mouseWheel(MouseEvent e) {
  panZoomPage.mouseWheel(e);
}
