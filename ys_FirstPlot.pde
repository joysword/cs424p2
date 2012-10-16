class FirstPlot {

  float dataMin;
  //float dataMax;
  //float dataMax_decade;
  float originalDataMax;

  float plotX1, plotX2, plotY1, plotY2;
  float unitWidth;
  float decadeWidth;

  int yearMin, yearMax;
  int showYearMin, showYearMax;
  int yearCount;
  int decadeCount;

  //Integrator[] interpolators;

  //float[] spacing; // for dashline

  //Legend[] legend;

  float dataScale;
  float dragStartY;

  int which; // 1 or 2

  float minimumY;

  FirstPlot(float x1, float y1, float x2, float y2, int _which) {


    which = _which;
    //rowCount = dataSets[0].getData().getRowCount();
    //columnCount = dataSets[0].getData().getColumnCount();

    yearMin = YEAR_MIN;
    yearMax = YEAR_MAX;

    showYearMin = yearMin;
    showYearMax = yearMax;

    /*
    interpolators = new Integrator[columnCount];
     
     for (int column = 0; column < columnCount; column++) {
     float initialValue = data.getFloat(0, column);
     interpolators[column] = new Integrator(initialValue);
     interpolators[column].attraction = 0.1;
     }*/

    // setup Colors
    //colors = new int[] {COLOR_0, COLOR_1, COLOR_2, COLOR_3, COLOR_4, COLOR_5, COLOR_6};

    plotX1 = x1;
    plotX2 = x2;

    //TABLE_WINDOW_X = plotX1-30*scale;
    //TABLE_PAGE_BTN_X = plotX2-TABLE_PAGE_BTN_H*0.5-TABLE_PAGE_BTN_DIFF;

    plotY1 = y1;
    plotY2 = y2;

    //tableY1 = plotY2+20*scale;
    //tableY2 = (Height - 60)*scale;

    //displayNumber = DATA_SET_COUNT;

    //unitHeight = (tableY2-tableY1)/displayNumber;

    dataMin = 0;
    //for (int i=0;i<DATA_SET_COUNT;i++) {
    //dataMax[i] = ceil(dataSets[i].getData().getTableMax()/dataSets[i].getInterval())*dataSets[i].getInterval();
    //originalDataMax[i] = dataMax[i];
    //}


    //setupDecade();

    //    legend = new Legend[DATA_SET_COUNT];
    //    for (int i=0;i<DATA_SET_COUNT;i++) {
    //      legend[i] = new Legend(PAGE_BTN_X+PAGE_BTN_W+LEGEND_DIFF, LIST_Y + (i - 1)*2.1*LIST_LINE_H + 12*scale, LIST_LINE_H, ui.dataSelector[i].getTxt()+"\n"+unitText[i], colors[i]);
    //    }
    dataScale = 1;

    minimumY = plotY2 - (plotY2 - plotY1) * 0.05;
  }


  void render(int whichGraph) {
    yearCount = showYearMax-showYearMin+1;
    unitWidth = (plotX2-plotX1)/yearCount;
    decadeCount = 11; //change
    decadeWidth = (plotX2 - plotX1) / decadeCount;

    // three way
    int mode = ui.getFirstPage().getDisplayMode();
    if (mode == YEAR_MODE) {
      drawPlot(whichGraph);
    }
    else if (mode == DECADE_MODE) {
      drawBar();
    }
    else if (mode == TABULAR_MODE) {
      drawTable();
    }
  }

  private void drawPlot(int whichGraph) {
    pushStyle();

    fill(PLOT_BG_COLOR);
    strokeWeight(OUTLINE_WIDTH);
    stroke(PLOT_LINE_COLOR);
    rectMode(CORNERS);
    rect(plotX1, plotY1, plotX2, plotY2);

    //drawAxisLabels();
    drawVolumeLabels();

    drawYearLabels();

    noFill();
    strokeWeight(INLINE_WIDTH);

    //////////BEGIN OF VOLUME

    // change   

    //////////END OF VOLUME

    //drawDataCurve(currentRow[j], j, i, showYearMin, showYearMax);
    drawDataCurve(currentFilter, NUMBER_OF_CLUSTERS[currentFilter], whichGraph);

    popStyle();
  }

  private void drawBar() {
    pushStyle();

    fill(PLOT_BG_COLOR);
    strokeWeight(OUTLINE_WIDTH);
    stroke(PLOT_LINE_COLOR);
    rectMode(CORNERS);
    rect(plotX1, plotY1, plotX2, plotY2);

    drawVolumeLabels();

    drawDecadeLabels();

    noFill();
    strokeWeight(INLINE_WIDTH);
    drawDataBar(currentFilter, NUMBER_OF_CLUSTERS[currentFilter]); //change

    popStyle();
  }

  private void drawAxisLabels() {
    pushStyle();
    /*fill(0);
     textSize(13*scale);
     textLeading(15);
     
     textAlign(RIGHT, CENTER);
     text("What\nthe\nX", labelX, (plotY1+plotY2)/2);
     textAlign(CENTER);
     text("What the Y", (plotX1+plotX2)/2, labelY);*/
    popStyle();
  }

  private void drawYearLabels() {
    pushStyle();

    fill(PLOT_LINE_COLOR);
    textSize(12*scale);
    textAlign(CENTER);

    stroke(100);
    strokeWeight(scale);


    float x = plotX1 + unitWidth*0.5;
    if (which == 1) {
      if (yearCount > 80) {
        for (int i=0;i<yearCount;i+=5) {
          text(showYearMin+i, x, plotY2 + textAscent() + 5*scale);
          line(x, plotY2 - OUTLINE_WIDTH*0.5, x, plotY1 + OUTLINE_WIDTH*0.5);
          x += unitWidth*5;
        }
      }
      else if (yearCount > 50) {
        for (int i=0;i<yearCount;i+=3) {
          text(showYearMin+i, x, plotY2 + textAscent() + 5*scale);
          line(x, plotY2 - OUTLINE_WIDTH*0.5, x, plotY1 + OUTLINE_WIDTH*0.5);
          x += unitWidth*3;
        }
      }
      else if (yearCount > 30) {
        for (int i=0;i<yearCount;i+=2) {
          text(showYearMin+i, x, plotY2 + textAscent() + 5*scale);
          line(x, plotY2 - OUTLINE_WIDTH*0.5, x, plotY1 + OUTLINE_WIDTH*0.5);
          x += unitWidth*2;
        }
      }
      else {
        for (int i=0;i<yearCount;i++) {
          text(showYearMin+i, x, plotY2 + textAscent() + 5*scale);
          line(x, plotY2 - OUTLINE_WIDTH*0.5, x, plotY1 + OUTLINE_WIDTH*0.5);
          x += unitWidth;
        }
      }
    }
    else {
      if (yearCount > 80) {
        for (int i=0;i<yearCount;i+=5) {
          line(x, plotY2 + OUTLINE_WIDTH*0.5, x, plotY1 - OUTLINE_WIDTH*0.5);
          x += unitWidth*5;
        }
      }
      else if (yearCount > 50) {
        for (int i=0;i<yearCount;i+=3) {
          line(x, plotY2 + OUTLINE_WIDTH*0.5, x, plotY1 - OUTLINE_WIDTH*0.5);
          x += unitWidth*3;
        }
      }
      else if (yearCount > 30) {
        for (int i=0;i<yearCount;i+=2) {
          line(x, plotY2 + OUTLINE_WIDTH*0.5, x, plotY1 - OUTLINE_WIDTH*0.5);
          x += unitWidth*2;
        }
      }
      else {
        for (int i=0;i<yearCount;i++) {
          line(x, plotY2 + OUTLINE_WIDTH*0.5, x, plotY1 - OUTLINE_WIDTH*0.5);
          x += unitWidth;
        }
      }
    }
    popStyle();
  }

  void drawDecadeLabels() {
    pushStyle();

    fill(PLOT_LINE_COLOR);
    textSize(12*scale);
    textAlign(CENTER);

    stroke(100);
    strokeWeight(scale);

    if (which == 1) {
      for (int i=1;i<11;i++) {
        line(plotX1+i*decadeWidth, plotY2 - OUTLINE_WIDTH*0.5, plotX1+i*decadeWidth, plotY1 + OUTLINE_WIDTH*0.5);
      }
      for (int i=1;i<12;i++) {
        text((showYearMin+(i-1)*10) + "'s"/* + " -- " + (showYearMin+i*10-1)*/, plotX1+(i-0.5)*decadeWidth, plotY2 + textAscent() + 5*scale);
      }
    }
    else {
      for (int i=1;i<11;i++) {
        line(plotX1+i*decadeWidth, plotY2 + OUTLINE_WIDTH*0.5, plotX1+i*decadeWidth, plotY1 - OUTLINE_WIDTH*0.5);
      }
    }

    popStyle();
  }

  void drawVolumeLabels() {

    pushStyle();
    fill(PLOT_LINE_COLOR);
    textSize(12*scale);
    textAlign(RIGHT);

    stroke(100);
    strokeWeight(1);

    //for (float v = dataMin; v <= dataMax[i]; v += volumeInterval[i]) {
    if (ui.getFirstPage().displayMode == YEAR_MODE) {
      for (float v = dataMin; v < dataMax*dataScale; v += int((dataMax*dataScale-dataMin)/4)/10*10) {

        float y = map(v, dataMin, dataMax*dataScale, minimumY, plotY1);  
        float textOffset = textAscent()/2;  // Center vertically
        if (v == dataMin) {
        } 
        else if (v == dataMax) {
          text(round(v), plotX1 - 10*scale, y + textAscent());
        }
        else {
          text(round(v), plotX1 - 10*scale, y + textOffset);
        }
        line(plotX1, y, plotX2, y);     // Draw major tick
      }
    }
    else if (ui.getFirstPage().displayMode == DECADE_MODE) {
      for (float v = dataMin; v < dataMax_decade*dataScale; v += int((dataMax_decade*dataScale-dataMin)/4)/10*10) {

        float y = map(v, dataMin, dataMax_decade*dataScale, minimumY, plotY1);  
        float textOffset = textAscent()/2;  // Center vertically
        if (v == dataMin) {
          //textOffset = 0;                   // Align by the bottom
        } 
        else if (v == dataMax_decade) {
          text(round(v), plotX1 - 10*scale, y + textAscent());
        }
        else {
          text(round(v), plotX1 - 10*scale, y + textOffset);
        }
        line(plotX1, y, plotX2, y);     // Draw major tick
      }
    }
    popStyle();
  }

  private void drawDataCurve(int whichFilter, int howManyCluters, int whichGraph) {
    pushStyle();

    noFill();
    //stroke(colors[colour]);
    stroke(CURVE_COLOR_TEMP);
    strokeWeight(INLINE_WIDTH);

    // test function

    float left, right;

    for (int clust=0;clust<howManyCluters;clust++) {
      left = plotX1;
      right = left+unitWidth;
      fill(CLUSTER_COLOR[clust]);
      stroke(CLUSTER_COLOR[clust]);
      beginShape();
      //fill(CLUSTER_COLOR[clust]);

      for (int i=showYearMin;i<=showYearMax;i++) {
        if (true == true) {
          //float value = random(40,80);//(i+showYearMin)%100;//(i%10>4)?50:40; //change
          float value = 0;
          for (int j=0;j<=clust;j++) {
            if (whichGraph == 0) {
              value += plot_1_certificate.get(i-yearMin).get(j);
            }
            else {
              value += plot_2_certificate.get(i-yearMin).get(j);
            }
          }
          float x = (left+right)/2;
          float y = map(value, dataMin, dataMax*dataScale, minimumY, plotY1);
          //ellipse(x, y, 4*scale, 6*scale);

          vertex(x, y);
          println("x,y: "+x+ " "+y);
        }
        left = right;
        right += unitWidth;
      }
      vertex(plotX2-unitWidth*0.5, minimumY);
      vertex(plotX1+unitWidth*0.5, minimumY);
      endShape(CLOSE);
    }
    popStyle();
  }


  void drawDataBar(int whichFilter, int howManyCluters) {
    pushStyle();

    fill(CLUSTER_COLOR[0]);
    noStroke();//BAR_COLOR_TEMP);
    //strokeWeight(INLINE_WIDTH);

    float decadeWidth = (plotX2 - plotX1) / 11;
    for (int i=0;i<11;i++) {

      float value = 0;
      for (int j=(i*10);j<i*10+10 && j<yearCount;j++) {
        for (int k=0;k<howManyCluters;k++) {
          value += plot_1_certificate.get(j).get(k);
        }
      }
      float xx1 = plotX1 + decadeWidth*(i+0.2);
      float xx2 = plotX1 + decadeWidth*(i+0.8);
      float yy = map(value, dataMin, dataMax_decade*dataScale, minimumY, plotY1);
      rectMode(CORNERS);
      rect(xx1, yy, xx2, minimumY);
      //println("value: "+value);
    }
    //println("dataMax_decade: "+dataMax_decade);

    popStyle();
  }

  void drawDataCurveDash(int row, int colour, int i, int yMin, int yMax, int begin, int end) {
    pushStyle();
    /*
    noFill();
     stroke(colors[colour]);
     
     float[][] dashPoint = new float[columnCount][2];
     
     float left = plotX1;
     float right = left+unitWidth;
     
     for (int col = showYearMin-yearMin; col < showYearMax-yearMin+1; col++) {
     if (dataSets[i].getData().isValid(row, col) && col>=begin-1980 && col<=end-1980) {
     float value = dataSets[i].getData().getFloat(row, col);
     float x = (left+right)/2;
     float y = map(value, dataMin, dataMax[i]*dataScale, minimumY, plotY1);
     dashPoint[col][0] = x;
     dashPoint[col][1] = y;
     ellipse(x, y, 3*scale, 4*scale);
     }
     else {
     dashPoint[col][0] = -1000;
     dashPoint[col][1] = -1000;
     }
     
     left = right;
     right += unitWidth;
     }
     
     for (int col = showYearMin-yearMin+1; col < showYearMax-yearMin+1; col++) {
     if (dashPoint[col-1][0] != -1000 && dashPoint[col][0] != -1000)
     dashline(dashPoint[col-1][0], dashPoint[col-1][1], dashPoint[col][0], dashPoint[col][1], spacing);
     }
     */
    popStyle();
  }

  void drawDataCurveDashSpecial(int[] row, int colour, int i, int yMin, int yMax, int begin, int end) {
    pushStyle();
    /*
    noFill();
     stroke(colors[colour]);
     
     float[][] dashPoint = new float[columnCount][2];
     
     float left = plotX1;
     float right = left+unitWidth;
     
     int ct = row.length;
     
     for (int col = showYearMin-yearMin; col < showYearMax-yearMin+1; col++) {
     if (col>=begin-1980 && col<=end-1980) {
     float value = 0;
     for (int j=0;j<ct;j++) {
     value += dataSets[i].getData().getFloat(row[j], col);
     }
     float x = (left+right)/2;
     float y = map(value, dataMin, dataMax[i]*dataScale, minimumY, plotY1);
     dashPoint[col][0] = x;
     dashPoint[col][1] = y;
     ellipse(x, y, 3*scale, 4*scale);
     }
     else {
     dashPoint[col][0] = -1000;
     dashPoint[col][1] = -1000;
     }
     
     left = right;
     right += unitWidth;
     }
     
     for (int col = showYearMin-yearMin+1; col < showYearMax-yearMin+1; col++) {
     if (dashPoint[col-1][0] != -1000 && dashPoint[col][0] != -1000)
     dashline(dashPoint[col-1][0], dashPoint[col-1][1], dashPoint[col][0], dashPoint[col][1], spacing);
     }
     */
    popStyle();
  }

  private void drawTable() {
    pushStyle();

    for (int i=0;i<3;i++) { //change
      for (int j=0;j<yearCount;j++) {
        rectMode(CORNER);
        rect(plotX1 + j*unitWidth, plotY1+i*50*scale, unitWidth, 50*scale);
      }
    }
    popStyle();
  }

  // used in YEAR MODE to find DECADE
  public int getYear(float posx, float posy) {
    if (posx>plotX1 && posx<plotX2 &&  posy>getMin(plotY1, plotY2) && posy<getMax(plotY1, plotY2)) {
      return floor((posx - plotX1) / unitWidth) + showYearMin;
    }
    return -1;
  }

  // used in DECADE MODE to find DECADE
  public int getDecade(float posx, float posy) {
    if (posx>plotX1 && posx<plotX2 && posy>getMin(plotY1, plotY2) && posy<getMax(plotY1, plotY2)) {
      return floor((posx - plotX1) / decadeWidth)*10 + yearMin;
    }
    return -1;
  }

  public int getShowYearMax() {
    return showYearMax;
  }

  public int getShowYearMin() {
    return showYearMin;
  }

  public void setShowYearMin(int yy) {
    showYearMin = yy;
  }

  public void setShowYearMax(int yy) {
    showYearMax = yy;
  }

  public void setYearsMinMax(int x, int y) {
    showYearMin = x;
    showYearMax = y;
  }

  private float getMin(float x, float y) {
    return (x>y)?y:x;
  }
  private float getMax(float x, float y) {
    return (x>y)?x:y;
  }
}

