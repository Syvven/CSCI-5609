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

UIValue[] ui;
Float[] ui_coords = new Float[4];
int num_islands;
boolean ui1_open = false;
boolean ui2_open = false;
PFont ui_head;
color ui_start_color, ui_end_color;

public class IslandComparator implements Comparator<Float[]>
{
  @Override
  public int compare(Float[] f1, Float[] f2)
  {
    return f2[2].compareTo(f1[2]);
  }
}

public class PopulationComparator implements Comparator<Float[]>
{
  @Override
  public int compare(Float[] f1, Float[] f2)
  {
    return f2[1].compareTo(f1[1]);
  }
}

// === PROCESSING BUILT-IN FUNCTIONS ===
ArrayList<Float[]> pairs;
void setup() {
  // size of the graphics window
  size(1600,900);

  // load data in from disk and do any data processing
  loadRawDataTables();
  computeDerivedData();

  frameRate(60);
  
  // these coordinates define a rectangular region for the map that happens to be
  // centered around Micronesia
  panZoomMap = new PanZoomMap(5.2, 138.0, 10.0, 163.1); 
  ellipseMode(RADIUS);

  setup_ui_array();

  pairs = new ArrayList<Float[]>();
  for (int i = 0; i < locationTable.getRowCount(); i++) 
  {
    TableRow loc_row = locationTable.getRow(i);
    String island_name = loc_row.getString(0);
    float lat = loc_row.getFloat(1);
    float lon = loc_row.getFloat(2);
    float area = populationTable.getRow(i).getFloat(6);

    float ind = (float) i;
    Float[] f = {lon, lat, area, ind};
    pairs.add(f);
  }

  Collections.sort(pairs, new IslandComparator());
}

/* color will be based on population */
ArrayList<Float[]> ui_1980;
ArrayList<Float[]> ui_1994;
ArrayList<Float[]> ui_2000;
ArrayList<Float[]> ui_2010;
void setup_ui_array()
{
  ui_1980 = new ArrayList<Float[]>();
  ui_1994 = new ArrayList<Float[]>();
  ui_2000 = new ArrayList<Float[]>();
  ui_2010 = new ArrayList<Float[]>();

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

    ui[i].setPop(
      populationTable.getRow(i).getFloat(2),
      populationTable.getRow(i).getFloat(3),
      populationTable.getRow(i).getFloat(4),
      populationTable.getRow(i).getFloat(5)
    );

    float fi = (float) i;
    float f80 = populationTable.getRow(i).getFloat(2);
    if (Float.isNaN(f80)) f80 = 0;
    ui_1980.add(new Float[]{fi, f80});
    ui_1994.add(new Float[]{fi, populationTable.getRow(i).getFloat(3)});
    ui_2000.add(new Float[]{fi, populationTable.getRow(i).getFloat(4)});
    ui_2010.add(new Float[]{fi, populationTable.getRow(i).getFloat(5)});

    Collections.sort(ui_1980, new PopulationComparator());
    Collections.sort(ui_1994, new PopulationComparator());
    Collections.sort(ui_2000, new PopulationComparator());
    Collections.sort(ui_2010, new PopulationComparator());
  }

  curr_pop_year = ui_1980;

  for (int i = 0; i < num_islands; i++)
  {
    println(curr_pop_year.get(i)[1]);
  }

  ui_head = createFont("Times New Roman", 12, true);
}

ArrayList<Float[]> curr_pop_year;
void draw_ui()
{
  stroke(80);
  fill(40);
  rect(
    ui_coords[0],
    ui_coords[1],
    ui_coords[2],
    ui_coords[3]
  );
  rect(
    ui_coords[2],
    ui_coords[1],
    ui_coords[2]*2,
    ui_coords[3]
  );
  fill(100, 200, 30);
  textAlign(CENTER);
  textFont(ui_head, 24);
  text("Islands (Click)", ui_coords[2]/2, ui_coords[3]/1.5);
  text("Years (Click)", ui_coords[2] * 3 / 2, ui_coords[3] / 1.5);
  textFont(ui_head, 12);
  fill(40);
  if (ui2_open)
  {

  }

  if (ui1_open)
  {
    int counter = 0;
    float jump = (height - ui_coords[3]) / (num_islands*0.5);
    for (int i = 0; i < num_islands / 2; i++)
    {
      for (int j = 0; j < 2; j++)
      {
        int curr_isle = curr_pop_year.get(counter)[0].intValue();
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
          
        counter++;
      }
    }
  }
}

void draw_arrow()
{
  if (arrow_island != null)
  {
    float cx = panZoomMap.longitudeToScreenX(arrow_island.lon);
    float cy = panZoomMap.latitudeToScreenY(arrow_island.lat);

    cy -= arrow_island.curr_rad;
    stroke(0, 255, 255);
    line(
      cx,
      cy - (height / 100),
      cx,
      cy - (height / 4)
    );

    line(
      cx,
      cy - (height / 100),
      cx - (width / 100),
      cy - (height / 30)
    );
    line(
      cx,
      cy - (height / 100),
      cx + (width / 100),
      cy - (height / 30)
    );
  }
}

void draw() {
  // clear the screen
  background(0);
  
  // draw the bounds of the map
  fill(40);
  stroke(80);
  rectMode(CORNERS);
  float x1 = panZoomMap.longitudeToScreenX(138.0);
  float y1 = panZoomMap.latitudeToScreenY(5.2);
  float x2 = panZoomMap.longitudeToScreenX(163.1);
  float y2 = panZoomMap.latitudeToScreenY(10.0);
  rect(x1, y1, x2, y2);

  /*
    Layout of the data is <name_string> <lat_float> <long_float>
  */

  for (int i = 0; i < num_islands; i++)
  {
    Float[] f = pairs.get(i);

    float cx = panZoomMap.longitudeToScreenX(f[0]);
    float cy = panZoomMap.latitudeToScreenY(f[1]);

    /* 
      Use the max and min areas here -- lerp between
    */
    float scale = 50000;
    float area = f[2] / scale;

    float scaled_min = minArea / scale;
    float scaled_max = maxArea / scale;

    // println(scaled_min, scaled_max);

    float area_normalized = (area - scaled_min) / (scaled_max - scaled_min);

    float rad = panZoomMap.mapLengthToScreenLength(lerp(scaled_min, scaled_max, area_normalized)) / 2.0;

    int ind = f[3].intValue();
    ui[ind].setRad(rad);

    fill(200, 0, 200);
    circle(cx, cy, rad);
  }

  if (show_arrow)
  {
    draw_arrow();
  }

  draw_ui();

  float m_lon = panZoomMap.screenXtoLongitude(last_mouseX);
  float m_lat = panZoomMap.screenYtoLatitude(last_mouseY);
  if (m_lon >= minLongitude &&
      m_lon <= maxLongitude &&
      m_lat >= minLatitude &&
      m_lat <= maxLatitude)
  {
    textFont(ui_head, 10);
    textAlign(LEFT);
    fill(0, 255, 255);
    String put = "" + m_lat + ", " + m_lon + "";
    text(
      put,
      last_mouseX,
      last_mouseY
    );
  }
}

void keyPressed() {
  if (key == ' ') {
    println("current scale: ", panZoomMap.scale, " current translation: ", panZoomMap.translateX, "x", panZoomMap.translateY);
  }
}

float last_mouseX = 0;
float last_mouseY = 0;
void mouseMoved()
{
  last_mouseX = mouseX;
  last_mouseY = mouseY;
}

boolean show_arrow = false;
UIValue arrow_island = null;
void mousePressed() {
  panZoomMap.mousePressed();
  if (mouseX >= ui_coords[0] && 
      mouseX <= ui_coords[2] &&
      mouseY >= ui_coords[1] &&
      mouseY <= ui_coords[3])
  {
    if (ui1_open)
    {
      arrow_island = null;
      show_arrow = false;
    }
    ui1_open = !ui1_open;
  }

  if (mouseX >= ui_coords[2] &&
      mouseX <= ui_coords[2]*2 &&
      mouseY >= ui_coords[1] &&
      mouseY <= ui_coords[3])
  {
    ui2_open = !ui2_open;
  }

  else if (ui1_open)
  {
    for (UIValue u : ui)
    {
      if (mouseX >= u.ulx &&
          mouseX <= u.brx &&
          mouseY >= u.uly &&
          mouseY <= u.bry)
      {
        if (show_arrow &&
            arrow_island != null &&
            u.name.compareTo(arrow_island.name) == 0)
        {
          show_arrow = false;
          arrow_island = null;
        }
        else
        {
          show_arrow = true;
          arrow_island = u;
        }
      }
    }
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
