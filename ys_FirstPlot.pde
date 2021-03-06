class FirstPlot {

  float dataMin;
  float dataMax_this;
  float dataMax_this_decade;
  float originalDataMax;

  float plotX1, plotX2, plotY1, plotY2;
  float unitWidth;
  float decadeWidth;
  float tableWidth;
  float tableHeight;

  int yearMin, yearMax;
  int showYearMin, showYearMax;
  int yearCount;
  int decadeCount;

  int showYearT;

  float dragStartY;

  float minimumY;

  boolean isSameY;

  FirstPlot(float x1, float y1, float x2, float y2) {

    yearMin = YEAR_MIN;
    yearMax = YEAR_MAX;

    showYearMin = yearMin;
    showYearMax = yearMax;
    showYearT = 1960;

    plotX1 = x1;
    plotX2 = x2;

    plotY1 = y1;
    plotY2 = y2;

    dataMin = 0;
    dataMax_this = 0;
    dataMax_this_decade = 0;

    minimumY = plotY2 - (plotY2 - plotY1) * 0.05;

    isSameY = false;
  }


  void render(int whichGraph) {
    yearCount = showYearMax-showYearMin+1;
    unitWidth = (plotX2-plotX1)/yearCount;
    decadeWidth = (plotX2 - plotX1) / 11;
    decadeCount = 11; //change
    decadeWidth = (plotX2 - plotX1) / decadeCount;
    tableWidth = (plotX2 - plotX1) / 11;
    tableHeight = (plotY2 - plotY1) / (NUMBER_OF_CLUSTERS[currentFilter[whichGraph]]+1);

    if (NUMBER_OF_CLUSTERS[currentFilter[whichGraph]] == 3) {
      tableHeight *= 0.8;
    }
    
    if (tableHeight < 0) tableHeight = -tableHeight;

    if (isSameY) {
      dataMax_this = dataMax;
      dataMax_this_decade = dataMax_decade;
    }
    else {
      if (whichGraph == 0) {
        dataMax_this = dataMax1;
        dataMax_this_decade = dataMax1_decade;
      }
      else {
        dataMax_this = dataMax2;
        dataMax_this_decade = dataMax2_decade;
      }
    }

    // three way
    int mode = ui.getFirstPage().getDisplayMode();
    if (mode == YEAR_MODE) {
      int increase;
      if (dataMax_this > 50) {
        increase = int(dataMax_this/4)/10*10;
      }
      else if (dataMax_this > 20) {
        increase = int(dataMax_this/4)/5*5;
      }
      else if (dataMax_this > 10) {
        increase = int(dataMax_this/4)/2*2;
      }
      else if (dataMax_this > 4) {
        increase = int(dataMax_this/4);
      }
      else {
        increase = 1;
      }
      drawPlot(currentFilter[whichGraph], NUMBER_OF_CLUSTERS[currentFilter[whichGraph]], whichGraph, plot_data[currentFilter[whichGraph]+whichGraph*6], increase);
      drawLegend(currentFilter[whichGraph], NUMBER_OF_CLUSTERS[currentFilter[whichGraph]], whichGraph);// plot_data[currentFilter[whichGraph]+whichGraph*6]);
    }
    else if (mode == DECADE_MODE) {
      int increase;
      if (dataMax_this_decade > 50) {
        increase = int(dataMax_this_decade/4)/10*10;
      }
      else if (dataMax_this_decade > 20) {
        increase = int(dataMax_this_decade/4)/5*5;
      }
      else if (dataMax_this_decade > 10) {
        increase = int(dataMax_this_decade/4)/2*2;
      }
      else if (dataMax_this_decade > 4) {
        increase = int(dataMax_this_decade/4);
      }
      else {
        increase = 1;
      }
      drawBar(currentFilter[whichGraph], NUMBER_OF_CLUSTERS[currentFilter[whichGraph]], whichGraph, plot_data[currentFilter[whichGraph]+whichGraph*6], increase);
      drawLegend(currentFilter[whichGraph], NUMBER_OF_CLUSTERS[currentFilter[whichGraph]], whichGraph);// plot_data[currentFilter[whichGraph]+whichGraph*6]);
    }
    else if (mode == TABULAR_MODE) {
      drawTable(currentFilter[whichGraph], NUMBER_OF_CLUSTERS[currentFilter[whichGraph]], whichGraph, plot_data[currentFilter[whichGraph]+whichGraph*6]);
    }
  }

  private void drawPlot(int whichFilter, int howManyClusters, int whichGraph, ArrayList<Instance> li, int increase) {

    pushStyle();

    fill(PLOT_BG_COLOR);
    strokeWeight(OUTLINE_WIDTH);
    stroke(PLOT_LINE_COLOR);
    rectMode(CORNERS);
    rect(plotX1, plotY1, plotX2, plotY2);

    if (whichGraph == 0) {
      drawAxisLabels();
    }
    
    drawVolumeLabels(increase);

    drawYearLabels(whichGraph);


    noFill();
    strokeWeight(INLINE_WIDTH);

    //////////BEGIN OF VOLUME

    // change   

    //////////END OF VOLUME

    drawDataCurve(whichFilter, howManyClusters, whichGraph, li);

    popStyle();
  }

  private void drawBar(int whichFilter, int howManyClusters, int whichGraph, ArrayList<Instance> li, int increase) {
    pushStyle();

    fill(PLOT_BG_COLOR);
    strokeWeight(OUTLINE_WIDTH);
    stroke(PLOT_LINE_COLOR);
    rectMode(CORNERS);
    rect(plotX1, plotY1, plotX2, plotY2);

    if (whichGraph == 0) {
      drawAxisLabels();
    }

    drawVolumeLabels(increase);

    drawDecadeLabels(whichGraph);

    noFill();
    strokeWeight(INLINE_WIDTH);
    drawDataBar(whichFilter, howManyClusters, whichGraph, li);

    popStyle();
  }

  private void drawTable(int whichFilter, int howManyClusters, int whichGraph, ArrayList<Instance> li) {
    pushStyle();

    rectMode(CORNER);
    textSize(14*scale);
    float yUp = (whichGraph == 0)? plotY1:plotY2;

    strokeWeight(2*scale);
    stroke(0); //change

    // lines
    for (int i=1;i<10;i++) {
      line(plotX1 + tableWidth * i, plotY1, plotX1 + tableWidth * i, plotY2);
    }

    // fill
    for (int i=0;i<NUMBER_OF_CLUSTERS[currentFilter[whichGraph]]+1;i++) {
      if (i % 2 == 0) fill(255);
      else fill(100);
      for (int j=0;j<11;j++) {
        rect(plotX1 + j*tableWidth, yUp+i*tableHeight, tableWidth, tableHeight);
      }
    }
    // data
      // upper-left
    textAlign(CENTER,CENTER);
    fill(100);
    text(FILTER_TYPE[whichFilter][LA].substring(1).toLowerCase(), plotX1 + 0.5*tableWidth, yUp + tableHeight*0.5);
      // year
    for (int j=1;j<11;j++) {
      text(showYearT+j-1, plotX1 + j*tableWidth + 0.5*tableWidth, yUp + tableHeight*0.5);
    }

      // title
    textAlign(LEFT,CENTER);
      float j = 0.5;
      switch (whichFilter){
        case BUDGET:
          fill(255);
          j = j+1;
          text(HIGH_TXT[LA], plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          fill(100);
          j = j+1;
          text(LOW_TXT[LA], plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          fill(255);
          j = j+1;
          text(NO_TXT[LA], plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          break;
        case CERTIFICATE:
          fill(255);
          j = j+1;
          text("   G", plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          fill(100);
          j = j+1;
          text("   PG", plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          fill(255);
          j = j+1;
          text("   R", plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          fill(100);
          j = j+1;
          text("   PG-13", plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          fill(255);
          j = j+1;
          text("   NC-17", plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          fill(100);
          j = j+1;
          text(OTHER_TXT[LA], plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          fill(255);
          j = j+1;
          text("   NR", plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          break;
        case COUNTRY:
          fill(255);
          j = j+1;
          text(USA_TXT[LA], plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          fill(100);
          j = j+1;
          text(UK_TXT[LA], plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          fill(255);
          j = j+1;
          text(FRA_TXT[LA], plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          fill(100);
          j = j+1;
          text(JP_TXT[LA], plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          fill(255);
          j = j+1;
          text(GER_TXT[LA], plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          fill(100);
          j = j+1;
          text(CA_TXT[LA], plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          fill(255);
          j = j+1;
          text(OTHER_TXT[LA], plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          break;
        case POPULARITY:
          fill(255);
          j = j+1;
          text(LOW_TXT[LA], plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          fill(100);
          j = j+1;
          text(MED_TXT[LA], plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          fill(255);
          j = j+1;
          text(HIGH_TXT[LA], plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          break;
        case QUALITY:
          fill(255);
          j = j+1;
          text(LOW_TXT[LA], plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          fill(100);
          j = j+1;
          text(MED_TXT[LA], plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          fill(255);
          j = j+1;
          text(HIGH_TXT[LA], plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          break;
        case FORMAT:
          fill(255);
          j = j+1;
          text(MOVIE_TXT[LA], plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          fill(100);
          j = j+1;
          text(TV_TXT[LA], plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          fill(255);
          j = j+1;
          text(VIDEO_TXT[LA], plotX1 + 0.05*tableWidth, yUp + j*tableHeight);
          break;
      }
    textAlign(RIGHT, CENTER);
    for (int i=1;i<=NUMBER_OF_CLUSTERS[currentFilter[whichGraph]];i++) {
      if (i % 2 == 0) fill(100);
      else fill(255);
      for (int qq=1;qq<11;qq++) {
        text(int(li.get(qq-1+showYearT-yearMin).getting(i-1)), plotX1 + qq*tableWidth + 0.9*tableWidth, yUp+i*tableHeight+tableHeight*0.5);
      }
    }
    popStyle();
  }

  private void drawAxisLabels() {
    pushStyle();
    fill(TEXT_COLOR);
    textSize(13*scale);
    textLeading(15);
    textAlign(CENTER, CENTER);
    text(Y_LABEL[LA], plotX1+30*scale, plotY1 - 15*scale);
    //textAlign(CENTER);
    //text("What the Y", (plotX1+plotX2)/2, labelY);
    popStyle();
  }

  private void drawYearLabels(int whichGraph) {
    pushStyle();

    fill(PLOT_LINE_COLOR);
    textSize(12*scale);
    textAlign(CENTER);

    stroke(100);
    strokeWeight(scale);


    float x = plotX1 + unitWidth*0.5;
    if (whichGraph == 0) {
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

  private void drawDecadeLabels(int whichGraph) {
    pushStyle();

    fill(PLOT_LINE_COLOR);
    textSize(12*scale);
    textAlign(CENTER);

    stroke(100);
    strokeWeight(scale);

    if (whichGraph == 0) {
      for (int i=1;i<11;i++) {
        line(plotX1+i*decadeWidth, plotY2 - OUTLINE_WIDTH*0.5, plotX1+i*decadeWidth, plotY1 + OUTLINE_WIDTH*0.5);
      }
      for (int i=1;i<12;i++) {
        text((showYearMin+(i-1)*10) + "'s", plotX1+(i-0.5)*decadeWidth, plotY2 + textAscent() + 5*scale);
      }
    }
    else {
      for (int i=1;i<11;i++) {
        line(plotX1+i*decadeWidth, plotY2 + OUTLINE_WIDTH*0.5, plotX1+i*decadeWidth, plotY1 - OUTLINE_WIDTH*0.5);
      }
    }

    popStyle();
  }

  private void drawVolumeLabels(int increase) {

    pushStyle();
    fill(PLOT_LINE_COLOR);
    textSize(12*scale);
    textAlign(RIGHT);

    stroke(100);
    strokeWeight(1);

    //for (float v = dataMin; v <= dataMax[i]; v += volumeInterval[i]) {
    if (ui.getFirstPage().displayMode == YEAR_MODE) {
      for (float v = dataMin; v < dataMax_this; v += increase) {

        float y = map(v, dataMin, dataMax_this, minimumY, plotY1);  
        float textOffset = textAscent()/2;  // Center vertically
        if (v == dataMin) {
        } 
        else if (v == dataMax_this) {
          text(round(v), plotX1 - 10*scale, y + textAscent());
        }
        else {
          text(round(v), plotX1 - 10*scale, y + textOffset);
        }
        line(plotX1, y, plotX2, y);     // Draw major tick
      }
    }
    else if (ui.getFirstPage().displayMode == DECADE_MODE) {
      for (float v = dataMin; v < dataMax_this_decade; v += increase) {

        float y = map(v, dataMin, dataMax_this_decade, minimumY, plotY1);  
        float textOffset = textAscent()/2;  // Center vertically
        if (v == dataMin) {
          //textOffset = 0;                   // Align by the bottom
        } 
        else if (v == dataMax_this_decade) {
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

  private void drawDataCurve(int whichFilter, int howManyCluters, int whichGraph, ArrayList<Instance> li) {
    pushStyle();

    //stroke(colors[colour]);
    strokeWeight(INLINE_WIDTH);

    // test function

    float left, right;

    for (int clust=howManyCluters-1;clust>=0;clust--) {
      left = plotX1;
      right = left+unitWidth;
      //fill(CLUSTER_COLOR_TRAN[clust]);
      fill(CLUSTER_COLOR[clust]);
      //noFill();
      //stroke(CLUSTER_COLOR_TRAN[clust]);
      noStroke();
      beginShape();
      //fill(CLUSTER_COLOR[clust]);

      for (int i=showYearMin;i<=showYearMax;i++) {
        if (true == true) {
          //float value = random(40,80);//(i+showYearMin)%100;//(i%10>4)?50:40; //change
          float value = 0;
          for (int j=0;j<=clust;j++) {
            value += li.get(i-yearMin).getting(j);
          }
          float x = (left+right)/2;
          float y = map(value, dataMin, dataMax_this, minimumY, plotY1);

          vertex(x, y);
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

  private void drawDataBar(int whichFilter, int howManyCluters, int whichGraph, ArrayList<Instance> li) {
    pushStyle();

    noStroke();//BAR_COLOR_TEMP);

    for (int i=0;i<11;i++) {

      float[] yy = new float[7];
      float value = 0;
      for (int k=0;k<howManyCluters;k++) {
        for (int j=(i*10);j<i*10+10 && j<yearCount;j++) {
          value += li.get(j).getting(k);
        }
        yy[k] = map(value, dataMin, dataMax_this_decade, minimumY, plotY1);
      }
      float xx1 = plotX1 + decadeWidth*(i+0.2);
      float xx2 = plotX1 + decadeWidth*(i+0.8);
      rectMode(CORNERS);
      for (int k=howManyCluters-1;k>=0;k--) {
        //fill(CLUSTER_COLOR_TRAN[k]);
        fill(CLUSTER_COLOR[k]);
        rect(xx1, yy[k], xx2, minimumY);
      }
    }

    popStyle();
  }

  private void drawLegend(int whichFilter, int howManyCluters, int whichGraph) {

    pushStyle();

    float x_ = Width - RIGHT_BAR_WIDTH+8*scale;
    float y_ = Height*0.5 *(1+whichGraph)- 60*scale;
    float y_t = y_ + LEGEND_HEIGHT + 10*scale;
    if (whichGraph == 0) {
      fill(#01b2f1);
    }
    else {
      fill(#29C567);
    }
    if (howManyCluters == 7) {
      for (int i=0;i<howManyCluters;i++) {
        //fill(CLUSTER_COLOR_TRAN[i]);
        fill(CLUSTER_COLOR[i]);
        noStroke();
        rectMode(CORNER);
        rect(x_ + i*(13*scale+LEGEND_WIDTH), y_,LEGEND_WIDTH,LEGEND_HEIGHT);
      }
    }
    else {
      for (int i=0;i<howManyCluters;i++) {
        fill(CLUSTER_COLOR[i]);
        noStroke();
        rectMode(CORNER);
        rect(x_ + i*(22*scale+LEGEND_WIDTH), y_,LEGEND_WIDTH,LEGEND_HEIGHT);
      }
    }
    textAlign(CENTER,CENTER);
    textSize(11*scale);
    fill(TEXT_COLOR);
    switch (whichFilter){
        case BUDGET:
          text(HIGH_TXT[LA].substring(3), x_ + LEGEND_WIDTH*0.5, y_t);
          text(LOW_TXT[LA].substring(3), x_ + LEGEND_WIDTH*1.5 + 22*scale, y_t);
          text(NO_TXT[LA].substring(3), x_ + LEGEND_WIDTH*2.5 + 44*scale, y_t);
          break;
        case CERTIFICATE:
          text("G", x_ + LEGEND_WIDTH*0.5 + 0*scale, y_t);
          text("PG", x_ + LEGEND_WIDTH*1.5 + 13*scale, y_t);
          text("R", x_ + LEGEND_WIDTH*2.5 + 26*scale, y_t);
          text("PG-13", x_ + LEGEND_WIDTH*3.5 + 39*scale, y_t);
          text("NC-17", x_ + LEGEND_WIDTH*4.5 + 52*scale, y_t);
          text(OTHER_TXT[LA].substring(3), x_ + LEGEND_WIDTH*5.5 + 65*scale, y_t);
          text("NR", x_ + LEGEND_WIDTH*6.5 + 78*scale, y_t);
          break;
        case COUNTRY:
          text(USA_TXT[LA].substring(3), x_ + LEGEND_WIDTH*0.5 + 0*scale, y_t);
          text(UK_TXT[LA].substring(3), x_ + LEGEND_WIDTH*1.5 + 13*scale, y_t);
          text(FRA_TXT[LA].substring(3), x_ + LEGEND_WIDTH*2.5 + 26*scale, y_t);
          text(JP_TXT[LA].substring(3), x_ + LEGEND_WIDTH*3.5 + 39*scale, y_t);
          text(GER_TXT[LA].substring(3), x_ + LEGEND_WIDTH*4.5 + 52*scale, y_t);
          text(CA_TXT[LA].substring(3), x_ + LEGEND_WIDTH*5.5 + 65*scale, y_t);
          text(OTHER_TXT[LA].substring(3), x_ + LEGEND_WIDTH*6.5 + 78*scale, y_t);
          break;
        case POPULARITY:
          text(LOW_TXT[LA].substring(3), x_ + LEGEND_WIDTH*0.5 + 0*scale, y_t);
          text(MED_TXT[LA].substring(3), x_ + LEGEND_WIDTH*1.5 + 22*scale, y_t);
          text(HIGH_TXT[LA].substring(3), x_ + LEGEND_WIDTH*2.5 + 44*scale, y_t);
          break;
        case QUALITY:
          text(LOW_TXT[LA].substring(3), x_ + LEGEND_WIDTH*0.5 + 0*scale, y_t);
          text(MED_TXT[LA].substring(3), x_ + LEGEND_WIDTH*1.5 + 22*scale, y_t);
          text(HIGH_TXT[LA].substring(3), x_ + LEGEND_WIDTH*2.5 + 44*scale, y_t);
          break;
        case FORMAT:
          text(MOVIE_TXT[LA].substring(3), x_ + LEGEND_WIDTH*0.5 + 0*scale, y_t);
          text(TV_TXT[LA].substring(3), x_ + LEGEND_WIDTH*1.5 + 22*scale, y_t);
          text(VIDEO_TXT[LA].substring(3), x_ + LEGEND_WIDTH*2.5 + 44*scale, y_t);
          break;
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

  public void switchSameY() {
    isSameY = !isSameY;
  }

  public void plusShowYearT(int i) {
    showYearT += i;
    if (showYearT > yearMax - 9) {
      showYearT = yearMax - 9;
    }
  }

  public void minusShowYearT(int i) {
    showYearT -= i;
    if (showYearT < yearMin) {
      showYearT = yearMin;
    }
  }
}