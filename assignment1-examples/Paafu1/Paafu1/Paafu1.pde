/* CSci-5609 Assignment 1: Visualization of the Islands of Micronesia
*/

import java.util.Comparator;
import java.util.Collections;

// === GLOBAL VARIABLES ===

// Raw data tables
Table locationTable;
Table populationTable;

// Derived data: mins and maxes for each data variable
float minLatitude, maxLatitude;
float minLongitude, maxLongitude;
float minPop1980, maxPop1980;
float minPop1994, maxPop1994;
float minPop2000, maxPop2000;
float minPop2010, maxPop2010;
float minArea, maxArea;

// Graphics objects
PanZoomMap panZoomMap;



// === PROCESSING BUILT-IN FUNCTIONS ===
void setup() {
  // size of the graphics window
  size(1600,900);

  // load data in from disk and do any data processing
  loadRawDataTables();
  computeDerivedData();
  
  // these coordinates define a rectangular region for the map that happens to be
  // centered around Micronesia
  panZoomMap = new PanZoomMap(5.2, 138.0, 10.0, 163.1); 
  ellipseMode(RADIUS);
}


void draw() {
  // clear the screen
  background(0);
  
  // draw the bounds of the map
  fill(20);
  stroke(50);
  rectMode(CORNERS);
  float x1 = panZoomMap.longitudeToScreenX(138.0);
  float y1 = panZoomMap.latitudeToScreenY(5.2);
  float x2 = panZoomMap.longitudeToScreenX(163.1);
  float y2 = panZoomMap.latitudeToScreenY(10.0);
  rect(x1, y1, x2, y2);
  
  
  
  // Example of drawing just one island.  You'll want to replace this with your own visualization.
  
  // the island of Weno (Moan) is located at 7°27′0″ N, 151°51′0″ E or in decimal (7.45, 151.85)
  // let's draw a circle centered at that location.
  // float cx = panZoomMap.longitudeToScreenX(151.85);
  // float cy = panZoomMap.latitudeToScreenY(7.45);
  
  // using OpenStreetMap, I estimate the West edge of the island is at long=151.8376 and
  // the East edge is at long=151.8376, a difference of just 0.0641 degrees.  We can use
  // this value to create a circle that approximates the size of the island like below.
  // However, it is a pretty small island--zoom in to make it bigger.
  // float radius = panZoomMap.mapLengthToScreenLength(0.0641) / 2.0;
  // fill(200,0,200);
  // ellipseMode(RADIUS);
  // circle(cx, cy, radius);

  /*
    Layout of the data is <name_string> <lat_float> <long_float>
  */
  ArrayList<Float[]> pairs = new ArrayList<Float[]>();
  for (int i = 0; i < locationTable.getRowCount(); i++) 
  {
    TableRow loc_row = locationTable.getRow(i);
    String island_name = loc_row.getString(0);
    float lat = loc_row.getFloat(1);
    float lon = loc_row.getFloat(2);

    float cx = panZoomMap.longitudeToScreenX(lon);
    float cy = panZoomMap.latitudeToScreenY(lat);

    /* 
      Use the max and min areas here -- lerp between
    */
    float area = populationTable.getRow(i).getFloat(6) / 50000;

    float scaled_min = minArea / 50000;
    float scaled_max = maxArea / 50000;

    // println(scaled_min, scaled_max);

    float area_normalized = (area - scaled_min) / (scaled_max - scaled_min);

    float rad = panZoomMap.mapLengthToScreenLength(lerp(scaled_min, scaled_max, area_normalized)) / 2.0;

    Float[] f = {cx, cy, rad};
    pairs.add(f);
  }

  Collections.sort(pairs, new IslandComparator());

  for (int i = 0; i < locationTable.getRowCount(); i++)
  {
    Float[] f = pairs.get(i);
    fill(200, 0, 200);
    circle(f[0], f[1], f[2]);
  }
}

public class IslandComparator implements Comparator<Float[]>
{
  @Override
  public int compare(Float[] f1, Float[] f2)
  {
    return f2[2].compareTo(f1[2]);
  }
}


void keyPressed() {
  if (key == ' ') {
    println("current scale: ", panZoomMap.scale, " current translation: ", panZoomMap.translateX, "x", panZoomMap.translateY);
  }
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




// === DATA PROCESSING ROUTINES ===

void loadRawDataTables() {
  locationTable = loadTable("FSM-municipality-locations.csv", "header");
  println("Location table:", locationTable.getRowCount(), "x", locationTable.getColumnCount()); 
  
  populationTable = loadTable("FSM-municipality-populations.csv", "header");
  println("Population table:", populationTable.getRowCount(), "x", populationTable.getColumnCount()); 
}


void computeDerivedData() {
  // calculate min/max data ranges for the variables we will want to depict
  minLatitude = TableUtils.findMinFloatInColumn(locationTable, "Latitude");
  maxLatitude = TableUtils.findMaxFloatInColumn(locationTable, "Latitude");
  println("Latitude range:", minLatitude, "to", maxLatitude);

  minLongitude = TableUtils.findMinFloatInColumn(locationTable, "Longitude");
  maxLongitude = TableUtils.findMaxFloatInColumn(locationTable, "Longitude");
  println("Longitude range:", minLongitude, "to", maxLongitude);

  minPop1980 = TableUtils.findMinFloatInColumn(populationTable, "Population 1980 Census");
  maxPop1980 = TableUtils.findMaxFloatInColumn(populationTable, "Population 1980 Census");
  println("Pop 1980 range:", minPop1980, "to", maxPop1980);
  
  minPop1994 = TableUtils.findMinFloatInColumn(populationTable, "Population 1994 Census");
  maxPop1994 = TableUtils.findMaxFloatInColumn(populationTable, "Population 1994 Census");
  println("Pop 1994 range:", minPop1994, "to", maxPop1994);

  minPop2000 = TableUtils.findMinFloatInColumn(populationTable, "Population 2000 Census");
  maxPop2000 = TableUtils.findMaxFloatInColumn(populationTable, "Population 2000 Census");
  println("Pop 2000 range:", minPop2000, "to", maxPop2000);

  minPop2010 = TableUtils.findMinFloatInColumn(populationTable, "Population 2010 Census");
  maxPop2010 = TableUtils.findMaxFloatInColumn(populationTable, "Population 2010 Census");
  println("Pop 2010 range:", minPop2010, "to", maxPop2010);

  minArea = TableUtils.findMinFloatInColumn(populationTable, "Area");
  maxArea = TableUtils.findMaxFloatInColumn(populationTable, "Area");
  println("Area range:", minArea, "to", maxArea);
}
