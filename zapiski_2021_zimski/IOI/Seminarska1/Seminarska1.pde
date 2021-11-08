FloatTable data;
float dataMin, dataMax;

float plotX1, plotY1;
float plotX2, plotY2;
float labelX, labelY;

int rowCount;

int mocMin, mocMax;
int tezaMin, tezaMax;
float[] moci;
float[] teze;
int porabaMin = 1;
int porabaMax = 22;
int st_dizel = 11141;
int st_benz = 7456;

int mociInterval = 50;
int tezeInterval = 500;
int volumeInterval = 2;
int volumeIntervalMinor = 1;

float[] tabLeft, tabRight;
float tabTop, tabBottom;
float tabPad = 10;
int currentTab = 0;
int tabCount = 3;
float[] tabLeft2, tabRight2;
float tabTop2, tabBottom2;
int currentTab2 = 0;
int tabCount2 = 2;

PFont plotFont;

void setup() {
  size(1280, 720);
  
  data = new FloatTable("nio_vozila_3_try.csv");
  rowCount = data.getRowCount();
  
  moci = data.getRowNames();
  mocMin = 0;
  mocMax = 547;
  tezaMax = 4170;
  tezaMin = 424;
  
  teze = float(data.getColumn(0));  
  
  dataMin = 0;
  dataMax = ceil(data.getColumnMax(1) / volumeInterval) * volumeInterval;

  plotX1 = 100; 
  plotX2 = width - 300;
  labelX = 40;
  plotY1 = 120;
  plotY2 = height - 120;
  labelY = height - 80;
  
  plotFont = createFont("SansSerif", 20);
  textFont(plotFont);

  smooth();
}

void draw() {
  background(224);
  
  // Show the plot area as a white box  
  fill(255);
  rectMode(CORNERS);
  noStroke();
  rect(plotX1, plotY1, plotX2, plotY2);

  strokeWeight(3.5); 
  // Draw the data for the first column 
  stroke(#5679C1); 
  drawDataPoints(currentTab2, currentTab);
  if (currentTab2==0)
    drawMociLabels();
  else
    drawTezeLabels();
  drawStats(currentTab);
  drawPorabaLabels();
  drawTitle();
  drawAxisLabels(0, 0);
  drawTitleTabs();
  drawOdvisnostTabs();
}

void drawTitleTabs() {
  rectMode(CORNERS);
  noStroke();
  textSize(20);
  textAlign(LEFT);

  // On first use of this method, allocate space for an array
  // to store the values for the left and right edges of the tabs
  if (tabLeft == null) {
    tabLeft = new float[tabCount];
    tabRight = new float[tabCount];
  }
  
  float runningX = plotX1; 
  tabTop = plotY1 - textAscent() - 15;
  tabBottom = plotY1;
  
  for (int col = 0; col < tabCount; col++) {
    String title = "";
    if(col==0)
      title="Vsi";
    if(col==1)
      title="Bencin";
    if(col==2)
      title="Dizel";
    tabLeft[col] = runningX; 
    float titleWidth = textWidth(title);
    tabRight[col] = tabLeft[col] + tabPad + titleWidth + tabPad;
    
    // If the current tab, set its background white, otherwise use pale gray
    fill(col == currentTab ? 255 : 224);
    rect(tabLeft[col], tabTop, tabRight[col], tabBottom);
    text(title, runningX + tabPad, plotY1 - 10);
    
    // If the current tab, use black for the text, otherwise use dark gray
    fill(col == currentTab ? 0 : 64);
    text(title, runningX + tabPad, plotY1 - 10);
    runningX = tabRight[col];
  }
}

void drawOdvisnostTabs() {
  rectMode(CORNERS);
  noStroke();
  textSize(25);
  textAlign(LEFT);

  // On first use of this method, allocate space for an array
  // to store the values for the left and right edges of the tabs
  if (tabLeft2 == null) {
    tabLeft2 = new float[tabCount];
    tabRight2 = new float[tabCount];
  }
  
  float runningX = ((abs(plotX2-plotX1))/2);
  tabTop2 = (plotY2+75) - textAscent() - 10;
  tabBottom2 = (plotY2+75);
  
  for (int col = 0; col < tabCount2; col++) {
    stroke(255);
    String title = "";
    if(col==0)
      title="Moč (kW)";
    if(col==1)
      title="Teža (kg)";
    tabLeft2[col] = runningX; 
    float titleWidth = textWidth(title);
    tabRight2[col] = tabLeft2[col] + tabPad + titleWidth + tabPad;
    
    // If the current tab, set its background white, otherwise use pale gray
    fill(col == currentTab2 ? 255 : 224);
    rect(tabLeft2[col], tabTop2, tabRight2[col], tabBottom2);
    text(title, runningX + tabPad, (plotY2+75) - 10);
    
    // If the current tab, use black for the text, otherwise use dark gray
    fill(col == currentTab2 ? 0 : 64);
    text(title, runningX + tabPad, (plotY2+75) - 10);
    
    
    fill(255);
    float tx1 = plotX2+tabPad;
    float tx2 = width-tabPad-1;
    float ty1 = plotY1+260;
    float ty2 = ty1 + 60;
    rect(tx1-2, ty1-2, tx2+2, ty2+2);
    for(float i=0;i<tx2-tx1-10 + tabPad;i++){
      stroke(255-i,255-i,255-i);
      line(i+tx1,ty1,i+tx1,ty2);
    }
    
    runningX = tabRight2[col];
    
    
  }
}

void mousePressed() {
  if (mouseY > tabTop && mouseY < tabBottom) {
    for (int col = 0; col < tabCount; col++) {
      if (mouseX > tabLeft[col] && mouseX < tabRight[col]) {
        setCurrent(col);
      }
    }
  }
  
    if (mouseY > tabTop2 && mouseY < tabBottom2) {
    for (int col = 0; col < tabCount2; col++) {
      if (mouseX > tabLeft2[col] && mouseX < tabRight2[col]) {
        setCurrent2(col);
      }
    }
  }
}

void drawStats(int tab){
  rectMode(CORNERS);
  noStroke();
  textSize(20);
  textAlign(LEFT);
  float povp_poraba = 0;
  float povp_teza = 0;
  float povp_moc = 0;
  
  if (tab == 0){
    for (int i = 0;i<rowCount;i++){
      povp_poraba+=data.getFloat(i, 1);
      povp_teza+=teze[i];
      povp_moc+=moci[i];
    }
    povp_poraba = povp_poraba/(st_benz+st_dizel);
    povp_teza = povp_teza/(st_benz+st_dizel);
    povp_moc = povp_moc/(st_benz+st_dizel);
  }
  if (tab == 2){
    for (int i = 0;i<rowCount;i++){
      if(data.getFloat(i, 2)>0.0){
        povp_poraba+=data.getFloat(i, 1);
        povp_teza+=teze[i];
        povp_moc+=moci[i];
      }
    }
    povp_poraba = povp_poraba/(st_dizel);
    povp_teza = povp_teza/(st_dizel);
    povp_moc = povp_moc/(st_dizel);
  }
  if (tab == 1){
    for (int i = 0;i<rowCount;i++){
      if(data.getFloat(i, 2)==0.0){
        povp_poraba+=data.getFloat(i, 1);
        povp_teza+=teze[i];
        povp_moc+=moci[i];
      }
    }
    povp_poraba = povp_poraba/(st_benz);
    povp_teza = povp_teza/(st_benz);
    povp_moc = povp_moc/(st_benz);
  }
  povp_poraba*=10;
  povp_poraba=round(povp_poraba);
  povp_poraba/=10;
  povp_teza*=10;
  povp_teza=round(povp_teza);
  povp_teza/=10;
  povp_moc*=10;
  povp_moc=round(povp_moc);
  povp_moc/=10;
  
  fill(255);
  rect(plotX2+tabPad, plotY1+50, width-tabPad, plotY1+200);
  fill(0);
  textSize(30);
  text("Povprečja", plotX2+85, plotY1+17);
  textSize(25);
  text("Poraba:", plotX2+tabPad+10, plotY1+100);
  text(povp_poraba + " l/100km", plotX2+tabPad+110, plotY1+100);
  text("Teža:", plotX2+tabPad+10, plotY1+135);
  text(povp_teza + " kg", plotX2+tabPad+110, plotY1+135);
  text("Moč:", plotX2+tabPad+10, plotY1+170);
  text(povp_moc + " kW", plotX2+tabPad+110, plotY1+170);
  
  
}


void setCurrent(int col) {
  currentTab = col;
}

void setCurrent2(int col) {
  currentTab2 = col;
}


void drawMociLabels() {
  fill(0);
  textSize(15);
  textAlign(CENTER, TOP);
  
  // Use thin, gray lines to draw the grid
  stroke(224);
  strokeWeight(1);
  
  for (int row = 0; row < 551; row++) {
    if (row % mociInterval == 0) {
      float x = map(row, mocMin, mocMax, plotX1, plotX2);
      text(row, x, plotY2 + 5);
    }
  }
    fill(0);
    textSize(25);
    text("Teža (kg)", width-150, plotY2-plotY1-20);
    textSize(15);
    text(tezaMin, width-282, plotY2-plotY1-35);
    text(tezaMax, width-20, plotY2-plotY1-35);
}

void drawTezeLabels() {
  fill(0);
  textSize(15);
  textAlign(CENTER, TOP);
  
  // Use thin, gray lines to draw the grid
  stroke(224);
  strokeWeight(1);
  
  for (int row = 1; row < tezaMax; row++) {
    if (row % tezeInterval == 0) {
      float x = map(row, tezaMin, tezaMax, plotX1, plotX2);
      text(row, x, plotY2 + 5);
    }
  }
    fill(0);
    textSize(25);
    text("Moč (kW)", width-150, plotY2-plotY1-20);
    textSize(15);
    text(13, width-287, plotY2-plotY1-35);
    text(mocMax, width-20, plotY2-plotY1-35);
}

void drawAxisLabels(int x, int y) {
  fill(0);
  textSize(13);
  textLeading(15);
  
  textAlign(CENTER, CENTER);
  // Use \n (enter/linefeed) to break the text into separate lines
  text("Poraba\n(l/100km)", labelX, (plotY1+plotY2)/2);
  textAlign(CENTER);
  //text("Nazivna moč avtomobila (kW)", (plotX1+plotX2)/2, labelY);
}

void drawPorabaLabels() {
  fill(0);
  textSize(15);
  textAlign(RIGHT);
  
  stroke(128);
  strokeWeight(1);

  for (float v = 0; v <= dataMax; v += volumeIntervalMinor) {
    if (v % volumeIntervalMinor == 0) {     // If a tick mark
      float y = map(int(v), dataMin, dataMax, plotY2, plotY1);  
      if (v % volumeInterval == 0) {        // If a major tick mark
        float textOffset = (textAscent()/2)-3;  // Center vertically
        if (v == dataMin) {
          textOffset = 0;                   // Align by the bottom
        } else if (v == dataMax) {
          textOffset = (textAscent()-5);        // Align by the top
        }
        text(int(v), plotX1 - 10, y + textOffset);
        line(plotX1 - 4, y, plotX1, y);     // Draw major tick
      } else {
        line(plotX1 - 2, y, plotX1, y);     // Draw minor tick
      }
    }
  }
}

void drawDataPoints(int col, int gor) {
  if(col==0){
    int rowCount = data.getRowCount(); 
    for (int row = 0; row < rowCount; row++) { 
      if (data.isValid(row, 1)) { 
        float value = data.getFloat(row, 1);
        float x = map(moci[row], mocMin, mocMax, plotX1, plotX2); 
        float y = map(value, dataMin, dataMax, plotY2, plotY1);
        if (gor==0){
          if (data.getFloat(row, 2)>0.0 && (gor==0 || gor==2)){
            stroke(#DC143C, map(data.getFloat(row,0),424,4160, 20,255));
            point(x, y);
          }else{
            stroke(#008000, map(data.getFloat(row,0),424,4160, 20,255));
            point(x, y); 
          }      
        }
        if (data.getFloat(row, 2)>0.0 && gor==2){
          stroke(#DC143C, map(data.getFloat(row,0),424,4160, 20,255));
          point(x, y);
        }else if(data.getFloat(row, 2)==0.0 && gor==1){
          stroke(#008000, map(data.getFloat(row,0),424,4160, 20,255));
          point(x, y); 
        }
      } 
    }
  }else{
    int rowCount = data.getRowCount(); 
    for (int row = 0; row < rowCount; row++) { 
      if (data.isValid(row, col)) { 
        float value = data.getFloat(row, col);
        float x = map(teze[row], tezaMin, tezaMax, plotX1, plotX2); 
        float y = map(value, dataMin, dataMax, plotY2, plotY1);
        if (gor==0){
          if (data.getFloat(row, 2)>0.0 && (gor==0 || gor==2)){
            stroke(#DC143C, map(moci[row],mocMin,mocMax, 20,255));
            point(x, y);
          }else{
            stroke(#008000, map(moci[row],mocMin,mocMax, 20,255));
            point(x, y); 
          }      
        }
        if (data.getFloat(row, 2)>0.0 && gor==2){
          stroke(#DC143C, map(moci[row],mocMin,mocMax, 20,255));
          point(x, y);
        }else if(data.getFloat(row, 2)==0.0 && gor==1){
          stroke(#008000, map(moci[row],mocMin,mocMax, 20,255));
          point(x, y); 
        }
      } 
    }
  }
}

void drawTitle() {
  fill(0);
  textSize(30);
  textAlign(LEFT);
  text("Vrsta goriva", plotX1, plotY1 - 50);
}
