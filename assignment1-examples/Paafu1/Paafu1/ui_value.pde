class UIValue
{
  String name;
  float lon, lat, area, ulx, uly, brx, bry;
  float curr_rad;
  float pop_1980, pop_1994, pop_2000, pop_2010;
  color curr_color;
  public UIValue(String name, float lat, float lon, float area)
  {
    this.name = name;
    this.lon = lon;
    this.lat = lat;
    this.area = area;
    this.curr_color = color(0,0,0);
  }

  public void setRectBounds(float ulx, float uly, float brx, float bry)
  {
    this.ulx = ulx;
    this.uly = uly;
    this.brx = brx;
    this.bry = bry;
  }

  public void setRad(float rad)
  {
    this.curr_rad = rad;
  }

  public void setPop(float p80, float p94, float p00, float p10)
  {
    this.pop_1980 = p80;
    if (Float.isNaN(p80))
    {
      this.pop_1980 = 0.0;
    }
    this.pop_1994 = p94;
    this.pop_2000 = p00;
    this.pop_2010 = p10;
  }

  public void setColor(color col)
  {
    this.curr_color = col;
  }
}