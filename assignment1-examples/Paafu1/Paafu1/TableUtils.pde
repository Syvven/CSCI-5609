/* CSci-5609 Visualization Support Code  created by Prof. Dan Keefe, Fall 2023

To size or color graphics based on data, we need to know min and max ranges for the data.
These utilities help to quickly calculate mins and maxes for data organized in tables.
*/
static class TableUtils {
  
  static float findMinFloatInColumn(Table t, int column) {
    float[] values = t.getFloatColumn(column);
    float min = values[0];
    for (int i=0; i<values.length; i++) {
      if (values[i] < min) {
        min = values[i]; 
      }
    }
    return min;
  }

  static float findMinFloatInColumn(Table t, String columnName) {
    return findMinFloatInColumn(t, t.getColumnIndex(columnName));
  }
  
  static float findMaxFloatInColumn(Table t, int column) {
    float[] values = t.getFloatColumn(column);
    float max = values[0];
    for (int i=0; i<values.length; i++) {
      if (values[i] > max) {
        max = values[i]; 
      }
    }
    return max;
  }

  static float findMaxFloatInColumn(Table t, String columnName) {
    return findMaxFloatInColumn(t, t.getColumnIndex(columnName));
  }

  
}
