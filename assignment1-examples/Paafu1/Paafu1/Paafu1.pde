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
color ui_start_color, ui_end_color, ui_mid_color;

ArrayList<Float[]> ui_1980, ui_1994, ui_2000, ui_2010, curr_pop_year;
color[] color_1980, color_1994, color_2000, color_2010, curr_year_colors;

boolean using_1980 = true;
boolean using_1994 = false;
boolean using_2000 = false;
boolean using_2010 = false;

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
void setup_ui_array()
{
  num_islands = locationTable.getRowCount();

  ui_1980 = new ArrayList<Float[]>();
  ui_1994 = new ArrayList<Float[]>();
  ui_2000 = new ArrayList<Float[]>();
  ui_2010 = new ArrayList<Float[]>();

  color_1980 = new color[num_islands];
  color_1994 = new color[num_islands];
  color_2000 = new color[num_islands];
  color_2010 = new color[num_islands];

  ui_start_color = color(255, 255, 255);
  ui_end_color = color(9, 107, 13);
  ui_mid_color = lerpColor(ui_start_color, ui_end_color, 0.5);

  ui_coords[0] = 0.0;
  ui_coords[1] = 0.0;
  ui_coords[2] = width / 7.0;
  ui_coords[3] = height / 18.0;

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

  for (int i = 0; i < num_islands; i++)
  {
    color start = ui_start_color;
    color end = ui_end_color;

    float ui80 = ui[ui_1980.get(i)[0].intValue()].pop_1980;
    float ui94 = ui[ui_1994.get(i)[0].intValue()].pop_1994;
    float ui00 = ui_2000.get(i)[1];
    float ui10 = ui_2010.get(i)[1];

    // float ui80norm = (ui80 - minPop1980) / (maxPop1980 - minPop1980);
    // float ui94norm = (ui94 - minPop1994) / (maxPop1994 - minPop1994);
    // float ui00norm = (ui00 - minPop2000) / (maxPop2000 - minPop2000);
    // float ui10norm = (ui10 - minPop2010) / (maxPop2010 - minPop2010);
    float max, min;
    if (ui80 > thresh)
    {
      max = maxPop1980;
      min = thresh;
    } 
    else 
    {
      max = thresh;
      min = minPop1980;
    }
    float ui80norm = (ui80 - min) / (max-min);

    if (ui94 > thresh)
    {
      max = maxPop1994;
      min = thresh;
    } 
    else 
    {
      max = thresh;
      min = minPop1994;
    }
    float ui94norm = (ui94 - min) / (max-min);

    if (ui00 > thresh)
    {
      max = maxPop2000;
      min = thresh;
    } 
    else 
    {
      max = thresh;
      min = minPop2000;
    }
    float ui00norm = (ui00 - min) / (max-min);

    if (ui10 > thresh)
    {
      max = maxPop2010;
      min = thresh;
    } 
    else 
    {
      max = thresh;
      min = minPop2010;
    }
    float ui10norm = (ui10 - min) / (max-min);

    if (ui80 > thresh) 
    {
      start = ui_mid_color;
      end = ui_end_color;
    }
    else
    {
      start = ui_start_color;
      end = ui_mid_color;
    }
    color_1980[i] = lerpColor(start, end, ui80norm);

    if (ui94 > thresh)
    {
      start = ui_mid_color;
      end = ui_end_color;
    }
    else
    {
      start = ui_start_color;
      end = ui_mid_color;
    }
    color_1994[i] = lerpColor(start, end, ui94norm);

    if (ui00 > thresh)
    {
      start = ui_mid_color;
      end = ui_end_color;
    }
    else
    {
      start = ui_start_color;
      end = ui_mid_color;
    }
    color_2000[i] = lerpColor(start, end, ui00norm);

    if (ui10 > thresh)
    {
      start = ui_mid_color;
      end = ui_end_color;
    }
    else
    {
      start = ui_start_color;
      end = ui_mid_color;
    }
    color_2010[i] = lerpColor(start, end, ui10norm);
  }

  curr_pop_year = ui_1980;
  curr_year_colors = color_1980;

  ui_head = createFont("Times New Roman", 12, true);
}

float thresh = 1500;
void draw_legend()
{ 
  float upleftx, uplefty, botrightx, botrighty;
  float ulx, uly, brx, bry;
  if (ui1_open && ui2_open)
  {
    upleftx = ui_coords[2];
    uplefty = ui_coords[3]*4.5;
    botrightx = ui_coords[2]+100;
    botrighty = height-1;

    ulx = ui_coords[2]+100;
    uly = ui_coords[3]*4.5;
    brx = ui_coords[2]*2;
    bry = uly + 50;
  }
  else if (!ui1_open)
  {
    upleftx = 0;
    uplefty = ui_coords[3];
    botrightx = 100;
    botrighty = height-1;

    ulx = 100;
    uly = ui_coords[3];
    brx = ui_coords[2];
    bry = uly + 50;
  }
  else
  {
    upleftx = ui_coords[2];
    uplefty = ui_coords[3];
    botrightx = ui_coords[2]+100;
    botrighty = height-1;

    ulx = ui_coords[2]+100;
    uly = ui_coords[3];
    brx = ui_coords[2]*2;
    bry = uly + 50;
  }

  stroke(0);
  fill(40);
  rect(
    upleftx,
    uplefty,
    botrightx,
    botrighty
  );

  rect(
    ulx, uly,
    brx, bry
  );
  textFont(ui_head, 20);
  fill(74, 176, 89);
  text("Size ~ Area", ulx + (brx-ulx)/2, uly + 30);

  loadPixels();

  float thresh_norm = 0;
  int jump = 0;
  float max_pop = 0;
  if (using_1980) 
  {
    max_pop = maxPop1980;
    jump = floor((botrighty - uplefty) / (maxPop1980 / 1000));
  }
  else if (using_1994) 
  {
    max_pop = maxPop1994;
    jump = floor((botrighty - uplefty) / (maxPop1994 / 1000));
  }
  else if (using_2000) 
  {
    max_pop = maxPop2000;
    jump = floor((botrighty - uplefty) / (maxPop2000 / 1000));
  }
  else if (using_2010) 
  {
    max_pop = maxPop2010;
    jump = floor((botrighty - uplefty) / (maxPop2010 / 1000));
  }

  float pixel_thresh = lerp(botrighty, uplefty, 0.4);
  color startc = color(255, 0, 0);
  color endc = color(0,0,0);
  for (int i = floor(uplefty+1); i < botrighty; i++)
  {
    /* get thresh point for the lerp color */
    // float pixel_norm = (i - )
    float pixel_norm;
    if (i < pixel_thresh) 
    {
      startc = ui_end_color;
      endc = ui_mid_color;
      pixel_norm = (i - uplefty) / (pixel_thresh - uplefty);
    }
    else 
    {
      startc = ui_mid_color;
      endc = ui_start_color;
      pixel_norm = (i - pixel_thresh) / (botrighty - pixel_thresh);
    }
    color c = lerpColor(startc, endc, pixel_norm);
    for (int j = floor(upleftx+1); j < upleftx+50; j++)
    {
      pixels[i*width+j] = c;
    }
    int ind = floor(i*width + upleftx+50);
    pixels[ind] = color(0,0,0);
  }
  updatePixels();

  textFont(ui_head, 12);
  textAlign(LEFT);
  int count = 0;
  int sub = 0;

  for (int i = floor(uplefty+1); i < botrighty; i++)
  {
    if (count % jump == 0)
    {
      float f = max_pop - sub*1000;
      String s = Float.toString(f);
      text(s, upleftx+55, i+12);
      sub++;
    }
    count++;
  }
}

void draw_ui()
{
  stroke(0);
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
    ui_coords[2]*2.2,
    ui_coords[3]
  );
  fill(74, 176, 89);
  textAlign(CENTER);
  textFont(ui_head, 24);
  text("Islands (Click)", ui_coords[2]/2, ui_coords[3]/1.5);
  text("Years (Click)", ui_coords[2] * 3.2 / 2, ui_coords[3] / 1.5);
  textFont(ui_head, 12);
  fill(40);
  if (ui2_open)
  { 
    if (using_1980)
      fill(78, 78, 82);
    rect(
      ui_coords[2],
      ui_coords[3],
      ui_coords[2]*2.2,
      ui_coords[3]*1.7
    );
    if (using_1980)
      fill(40);
    if (using_1994)
      fill(78, 78, 82);
    rect(
      ui_coords[2],
      ui_coords[3]*1.7,
      ui_coords[2]*2.2,
      ui_coords[3]*2.4
    );
    if (using_1994)
      fill(40);
    if (using_2000)
      fill(78, 78, 82);
    rect(
      ui_coords[2],
      ui_coords[3]*2.4,
      ui_coords[2]*2.2,
      ui_coords[3]*3.1
    );
    if (using_2000)
      fill(40);
    if (using_2010)
      fill(78, 78, 82);
    rect(
      ui_coords[2],
      ui_coords[3]*3.1,
      ui_coords[2]*2.2,
      ui_coords[3]*3.8
    );
    if (using_2010)
      fill(40);
    rect(
      ui_coords[2],
      ui_coords[3]*3.8,
      ui_coords[2]*2.2,
      ui_coords[3]*4.5
    );
    fill(74, 176, 89);
    if (arrow_island != null)
    {
      if (using_1980)
      {
        String s = arrow_island.name + ": " + 
          arrow_island.pop_2010 + " / Area: " + arrow_island.area
          + "km^2";
        text(
          s, 
          ui_coords[2] * 3.2 / 2, 
          ui_coords[3] * 4.25
        );
      }
      else if (using_1994)
      {
        String s = arrow_island.name + ": " + 
          arrow_island.pop_2010 + " / Area: " + arrow_island.area
          + "km^2";
        text(
          s, 
          ui_coords[2] * 3.2 / 2, 
          ui_coords[3] * 4.25
        );
      }
      else if (using_2000)
      {
        String s = arrow_island.name + ": " + 
          arrow_island.pop_2010 + " / Area: " + arrow_island.area
          + "km^2";
        text(
          s, 
          ui_coords[2] * 3.2 / 2, 
          ui_coords[3] * 4.25
        );
      }
      else if (using_2010)
      {
        String s = arrow_island.name + ": " + 
          arrow_island.pop_2010 + " / Area: " + arrow_island.area
          + "km^2";
        text(
          s, 
          ui_coords[2] * 3.2 / 2, 
          ui_coords[3] * 4.25
        );
      }
    }
    else 
    {
      text(
          "No Island Selected", 
          ui_coords[2] * 3.2 / 2, 
          ui_coords[3] * 4.25
        );
    }
    text("Population (1980)", ui_coords[2] * 3.2 / 2, ui_coords[3] * 1.45);
    text("Population (1994)", ui_coords[2] * 3.2 / 2, ui_coords[3] * 2.15);
    text("Population (2000)", ui_coords[2] * 3.2 / 2, ui_coords[3] * 2.85);
    text("Population (2010)", ui_coords[2] * 3.2 / 2, ui_coords[3] * 3.55);

  }
  fill(40);
  for (int i = 0; i < num_islands; i++)
  {
    int c = curr_pop_year.get(i)[0].intValue();
    ui[c].setColor(curr_year_colors[i]);
  }
  if (ui1_open)
  {
    int counter = 0;
    float jump = (height-1 - ui_coords[3]) / (num_islands*0.5);
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
        if (arrow_island != null && arrow_island.name.compareTo(ui[curr_isle].name) == 0)
          fill(78, 78, 82);
        else
          fill(40);
        rect(
          ui[curr_isle].ulx,
          ui[curr_isle].uly,
          ui[curr_isle].brx,
          ui[curr_isle].bry
        );
        fill(curr_year_colors[counter]);
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
    stroke(arrow_island.curr_color);
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
  background(99, 102, 117);
  
  // draw the bounds of the map
  fill(40);
  stroke(0);
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

    float area_normalized = (area - scaled_min) / (scaled_max - scaled_min);

    float rad = panZoomMap.mapLengthToScreenLength(lerp(scaled_min, scaled_max, area_normalized)) / 2.0;

    int ind = f[3].intValue();
    ui[ind].setRad(rad);

    fill(ui[ind].curr_color);
    circle(cx, cy, rad);
  }
  for (int i = 0; i < num_islands; i++)
  {
    Float[] f = pairs.get(i);

    float cx = panZoomMap.longitudeToScreenX(f[0]);
    float cy = panZoomMap.latitudeToScreenY(f[1]);
    fill(0);
    textAlign(CENTER);
    text(ui[f[3].intValue()].name, cx, cy);
  }

  float m_lon = panZoomMap.screenXtoLongitude(mouseX);
  float m_lat = panZoomMap.screenYtoLatitude(mouseY);
  if (m_lon >= minLongitude &&
      m_lon <= maxLongitude &&
      m_lat >= minLatitude &&
      m_lat <= maxLatitude)
  {
    textFont(ui_head, 12);
    textAlign(LEFT);
    fill(0);
    String put = "" + m_lat + ", " + m_lon + "";
    text(
      put,
      mouseX,
      mouseY
    );
  }

  if (show_arrow)
  {
    draw_arrow();
  }

  draw_ui();
  draw_legend();
}

void keyPressed() {
  if (key == ' ') {
    println("current scale: ", panZoomMap.scale, " current translation: ", panZoomMap.translateX, "x", panZoomMap.translateY);
  }
}

// float last_mouseX = 0;
// float last_mouseY = 0;
// void mouseMoved()
// {
//   last_mouseX = mouseX;
//   last_mouseY = mouseY;
// }

boolean show_arrow = false;
UIValue arrow_island = null;
void mousePressed() {
  panZoomMap.mousePressed();

  if (mouseX >= ui_coords[2] &&
      mouseX <= ui_coords[2]*2.2 &&
      mouseY >= ui_coords[1] &&
      mouseY <= ui_coords[3])
  {
    ui2_open = !ui2_open;
  }
  else if (ui2_open)
  {
    if (mouseX >= ui_coords[2] &&
        mouseY >= ui_coords[3] &&
        mouseX <= ui_coords[2]*2.2 &&
        mouseY <= ui_coords[3]*1.7)
    {
      curr_pop_year = ui_1980;
      curr_year_colors = color_1980;
      using_1980 = true;
      using_2010 = false;
      using_1994 = false;
      using_2000 = false;
    }
    else if (mouseX >= ui_coords[2] &&
        mouseY >= ui_coords[3]*1.7 &&
        mouseX <= ui_coords[2]*2.2 &&
        mouseY <= ui_coords[3]*2.4)
    {
      curr_pop_year = ui_1994;
      curr_year_colors = color_1994;
      using_1994 = true;
      using_2010 = false;
      using_1980 = false;
      using_2000 = false;
    }
    else if (mouseX >= ui_coords[2] &&
        mouseY >= ui_coords[3]*2.4 &&
        mouseX <= ui_coords[2]*2.2 &&
        mouseY <= ui_coords[3]*3.1)
    {
      curr_pop_year = ui_2000;
      curr_year_colors = color_2000;
      using_2000 = true;
      using_2010 = false;
      using_1994 = false;
      using_1980 = false;
    }
    else if (mouseX >= ui_coords[2] &&
        mouseY >= ui_coords[3]*3.1 &&
        mouseX <= ui_coords[2]*2.2 &&
        mouseY <= ui_coords[3]*3.8)
    {
      curr_pop_year = ui_2010;
      curr_year_colors = color_2010;
      using_2010 = true;
      using_1980 = false;
      using_1994 = false;
      using_2000 = false;
    }
  }

  if (mouseX >= ui_coords[0] && 
      mouseX <= ui_coords[2] &&
      mouseY >= ui_coords[1] &&
      mouseY <= ui_coords[3])
  {
    ui1_open = !ui1_open;
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
