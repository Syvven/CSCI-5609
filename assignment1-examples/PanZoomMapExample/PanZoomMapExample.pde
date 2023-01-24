/* CSci-5609 Support Code created by Prof. Dan Keefe, Fall 2023

Click and drag the left mouse button to pan the map, and scroll the mouse wheel up 
or down to zoom in and out.  See the comments at the top of the PanZoomMap and
PanZoomPage files to learn more.
*/

PanZoomMap panZoomMap;

void setup() {
  size(1600, 900);
  // these coordinates define a rectangular region for the map that happens to be
  // centered around Micronesia
  panZoomMap = new PanZoomMap(5.2, 138.0, 10.0, 163.1); 
}

void draw() {
  background(100);
  
  // draw a white square that covers the entire map
  fill(255);
  stroke(0);
  rectMode(CORNERS);
  float x1 = panZoomMap.longitudeToScreenX(138.0);
  float y1 = panZoomMap.latitudeToScreenY(5.2);
  float x2 = panZoomMap.longitudeToScreenX(163.1);
  float y2 = panZoomMap.latitudeToScreenY(10.0);
  rect(x1, y1, x2, y2);
  
  // the island of Weno (Moan) is located at 7°27′0″ N, 151°51′0″ E or in decimal (7.45, 151.85)
  // let's draw a circle centered at that location.
  float cx = panZoomMap.longitudeToScreenX(151.85);
  float cy = panZoomMap.latitudeToScreenY(7.45);
  
  // using OpenStreetMap, I estimate the West edge of the island is at long=151.8376 and
  // the East edge is at long=151.8376, a difference of just 0.0641 degrees.  We can use
  // this value to create a circle that approximates the size of the island like below.
  // However, it is a pretty small island--zoom in to make it bigger.
  float radius = panZoomMap.mapLengthToScreenLength(0.0641) / 2.0;
  fill(200,0,200); //<>//
  ellipseMode(RADIUS);
  circle(cx, cy, radius);   
  
  // This displays the latitude and longitude under the mouse cursor
  fill(0);
  String s2 = "(" + panZoomMap.screenXtoLongitude(mouseX) + ", " + panZoomMap.screenYtoLatitude(mouseY) +  ")";
  text(s2, mouseX, mouseY);
}

void mousePressed() {
  panZoomMap.mousePressed();
}

void mouseDragged() {
  panZoomMap.mouseDragged();
}

void mouseWheel(MouseEvent e) {
  panZoomMap.mouseWheel(e);
}
