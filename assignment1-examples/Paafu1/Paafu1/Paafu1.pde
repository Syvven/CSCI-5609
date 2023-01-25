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

  setup_ui_array();
}

class UIValue
{
  String name;
  float lon, lat, area, ulx, uly, brx, bry;
  public UIValue(String name, float lon, float lat, float area)
  {
    this.name = name;
    this.lon = lon;
    this.lat = lat;
    this.area = area;
  }

  public void setRectBounds(float ulx, float uly, float brx, float bry)
  {
    this.ulx = ulx;
    this.uly = uly;
    this.brx = brx;
    this.bry = bry;
  }
}

UIValue[] ui;
Float[] ui_coords = new Float[4];
int num_islands;
boolean ui_open = false;
PFont ui_head;
void setup_ui_array()
{
  ui_coords[0] = 0.0;
  ui_coords[1] = 0.0;
  ui_coords[2] = width / 7.0;
  ui_coords[3] = height / 18.0;

  num_islands = locationTable.getRowCount();
  ui = new UIValue[num_islands];
  for (int i = 0; i < num_islands; i++)
  {
    TableRow cur = locationTable.getRow(i);
    ui[i] = new UIValue(
      cur.getString(0),
      cur.getFloat(1),
      cur.getFloat(2),
      populationTable.getRow(i).getFloat(6)
    );
  }

  ui_head = createFont("Times New Roman", 12, true);
}

void draw_ui()
{
  fill(40);
  rect(
    ui_coords[0],
    ui_coords[1],
    ui_coords[2],
    ui_coords[3]
  );

  fill(100, 200, 30);
  textAlign(CENTER);
  textFont(ui_head, 24);
  text("Islands (Click)", ui_coords[2]/2, ui_coords[3]/1.5);
  textFont(ui_head, 12);
  fill(40);
  if (ui_open)
  {
    int curr_isle = 0;
    float jump = (height - ui_coords[3]) / (num_islands*0.5);
    for (int i = 0; i < num_islands / 2; i++)
    {
      for (int j = 0; j < 2; j++)
      {
        ui[curr_isle].setRectBounds(
          j*ui_coords[2]*0.5,
          ui_coords[3] + i*jump,
          (j+1)*ui_coords[2]*0.5,
          ui_coords[3] + (i+1)*jump
        );
        fill(40);
        rect(
          ui[curr_isle].ulx,
          ui[curr_isle].uly,
          ui[curr_isle].brx,
          ui[curr_isle].bry
        );
        fill(100, 200, 30);
        String[] toks = ui[curr_isle].name.split(" ", 2);
        if (toks.length == 2)
        {
          text(
            toks[0], 
            lerp(ui[curr_isle].ulx, ui[curr_isle].brx, 0.5),
            lerp(ui[curr_isle].uly, ui[curr_isle].bry, 0.4)
          );

          text(
            toks[1], 
            lerp(ui[curr_isle].ulx, ui[curr_isle].brx, 0.5),
            lerp(ui[curr_isle].uly, ui[curr_isle].bry, 0.8)
          );
        }
        else 
        {
          text(
            toks[0], 
            lerp(ui[curr_isle].ulx, ui[curr_isle].brx, 0.5),
            lerp(ui[curr_isle].uly, ui[curr_isle].bry, 0.6)
          );
        }
          
        curr_isle++;
      }
    }
  }
}

void draw() {
  // clear the screen
  background(0);
  
  // draw the bounds of the map
  fill(40);
  stroke(100);
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
    float scale = 50000;
    float area = populationTable.getRow(i).getFloat(6) / scale;

    float scaled_min = minArea / scale;
    float scaled_max = maxArea / scale;

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

  draw_ui();
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
  if (mouseX >= ui_coords[0] && 
      mouseX <= ui_coords[2] &&
      mouseY >= ui_coords[1] &&
      mouseY <= ui_coords[3])
  {
    ui_open = !ui_open;
  }
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
