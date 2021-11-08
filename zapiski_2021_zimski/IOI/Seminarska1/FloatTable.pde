// first line of the file should be the column headers
// first column should be the row titles
// all other values are expected to be floats
// getFloat(0, 0) returns the first data value in the upper lefthand corner
// files should be saved as "text, tab-delimited"
// empty rows are ignored
// extra whitespace is ignored


class FloatTable {
  int rowCount;
  int columnCount;
  String[][] data;
  float[] rowNames;
  String[] columnNames;
  
  
  FloatTable(String filename) {
    String[] rows = loadStrings(filename);
    
    String[] columns = split(rows[0], ";");
    columnNames = subset(columns, 1); // upper-left corner ignored
    columnCount = columnNames.length;
    
    rowNames = new float[rows.length-1];
    data = new String[rows.length-1][];
        // start reading at row 1, because the first row was only the column headers
    for (int i = 1; i < rows.length; i++) {
      if (trim(rows[i]).length() == 0) {
        continue; // skip empty rows
      }
      if (rows[i].startsWith("#")) {
        continue;  // skip comment lines
      }

      // split the row on the tabs
      String[] pieces = split(rows[i], ";");
      
      // copy row title
      rowNames[rowCount] = parseFloat(pieces[0]);
      // copy data into the table starting at pieces[1]
      data[rowCount] = subset(pieces, 1);
      
      /*
      if (i==10){
        printArray(data[rowCount]);
      }*/

      // increment the number of valid rows found so far
      rowCount++;      
    }
    // resize the 'data' array as necessary
    data = (String[][]) subset(data, 0, rowCount);
  }
  
    int getRowCount() {
    return rowCount;
  }
  
  
  float getRowName(int rowIndex) {
    return rowNames[rowIndex];
  }
  
  
  float[] getRowNames() {
    return rowNames;
  }
  
  int getColumnCount() {
    return columnCount;
  }
  
  String[] getColumn(int col) {
    String[]tab = new String[rowCount];
    for (int row = 0; row < rowCount; row++) {
      if (isValid(row, col)) {
        tab[row]=data[row][col];
      }
    }
    return tab;
  }
  
  String getColumnName(int colIndex) {
    return columnNames[colIndex];
  }
  
  
  String[] getColumnNames() {
    return columnNames;
  }
  
  float getColumnMin(int col) {
    float m = Float.MAX_VALUE;
    for (int row = 0; row < rowCount; row++) {
      if (isValid(row, col)) {
        if (float(data[row][col]) < m) {
          m = float(data[row][col]);
        }
      }
    }
    return m;
  }
  
    boolean isValid(int row, int col) {
    if (row < 0) return false;
    if (row >= rowCount) return false;
    //if (col >= columnCount) return false;
    if (col >= data[row].length) return false;
    if (col < 0) return false;
    return !Float.isNaN(float(data[row][col]));
  }


  float getColumnMax(int col) {
    float m = -Float.MAX_VALUE;
    for (int row = 0; row < rowCount; row++) {
      if (isValid(row, col)) {
        if (float(data[row][col]) > m) {
          m = float(data[row][col]);
        }
      }
    }
    return m;
  }
    float getFloat(int rowIndex, int col) {
    // Remove the 'training wheels' section for greater efficiency
    // It's included here to provide more useful error messages
    
    // begin training wheels
    if ((rowIndex < 0) || (rowIndex >= data.length)) {
      throw new RuntimeException("There is no row " + rowIndex);
    }
    if ((col < 0) || (col >= data[rowIndex].length)) {
      throw new RuntimeException("Row " + rowIndex + " does not have a column " + col);
    }
    // end training wheels
    
    return float(data[rowIndex][col]);
  }
  
  String getString(int rowIndex, int col){
    
    if ((rowIndex < 0) || (rowIndex >= data.length)) {
      throw new RuntimeException("There is no row " + rowIndex);
    }
    if ((col < 0) || (col >= data[rowIndex].length)) {
      throw new RuntimeException("Row " + rowIndex + " does not have a column " + col);
    }
    return data[rowIndex][col];
  }
}
