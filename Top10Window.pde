class Top10Window {
  float cenX, cenY;
  float w, h;

  float minimumLine;
  float maximumLine;
  float maximumNumber = 40; // will be decided by maximum value
  float barWidth = 50*scale;

  ArrayList<monsterNode> topMonsters;
  ArrayList<StringCountPair> numberMovies;
  float nodeDiameterFather, nodeDiameterChild;
  cc_DatabaseManager db;
  boolean init;


  Top10Window(float _x, float _y, float _w, float _h) {
    cenX = _x;
    cenY = _y;
    w = _w;
    h = _h;

    minimumLine = cenY + h * 0.4; // 0.9
    maximumLine = cenY - h * 0.02; // 0.38

    nodeDiameterFather = h/5;
    nodeDiameterChild = h/5;

    topMonsters = new ArrayList<monsterNode>();

    numberMovies = new ArrayList();
    db=new cc_DatabaseManager(context);
    init=true;
  }

  void initImages(){
    topMonsters.clear();
    for(StringCountPair s: numberMovies){
      topMonsters.add(new monsterNode(s.getString(),cenX,cenY,nodeDiameterChild,loadImage(MatchTaxonomy.matchImage(s.getString()))));
    }
  }

  void initDb(int min){
    numberMovies=db.getMonsterTOP10(min,min+10);
    if(numberMovies.size()>0){
      maximumNumber=numberMovies.get(0).getCount();
    }

  }

  void initDbOverall(int min){
    numberMovies=db.getMonsterTOP10Overall();
    if(numberMovies.size()>0){
      maximumNumber=numberMovies.get(0).getCount();

    }
  }

  void setInit(){
    init=true;
  }

  void render(int yearX) {
    pushStyle();

    // bg color
    fill(POP_UP_WINDOW_BG_COLOR);
    strokeWeight(BOARD_WEIGHT);
    stroke(WINDOW_BOARD_COLOR);
    rectMode(CENTER);
    rect(cenX, cenY, w, h);


    // white box
    fill(255);
    rectMode(CORNERS);
    noStroke();
    rect(cenX - w*0.5 + 4*scale, cenY-h*0.35, cenX + w*0.5 - 4 * scale, minimumLine);

    fill(POP_UP_WINDOW_TEXT_COLOR);
    textAlign(LEFT, CENTER);
    textSize(22*scale);
    int yearr = yearX/10*10;
    if(init & yearr!=10000){
      initDb(yearr);
      initImages();
      init=false;
    }
    if(init & yearr==10000){
      initDbOverall(yearr);
      initImages();
      init=false;
    }

    // Overall
    if (yearr == 10000) {
      text(TOP_10_ALL_TITLE[LA], cenX - w*0.5, cenY-h*0.4225);
    }
    else {
      if (LA == 0) {
        text("     Top 10 Monsters of "+yearr+"'s", cenX - w*0.5, cenY-h*0.4225);
      }
      else if (LA == 1) {
        text("     出镜率最高的10种怪物 ("+yearr+"'s)", cenX - w*0.5, cenY-h*0.4225);
      }
    }

    for (int i=0;i<this.numberMovies.size();i++) {
      float value=map(numberMovies.get(i).getCount(), 0, maximumNumber, minimumLine, maximumLine);

      rectMode(CORNERS);
      fill(0);
      noStroke();
      rect(cenX-w/11/2-w/11*this.numberMovies.size()/2+w/11*(i+1)-this.barWidth/2, value, 
      cenX-w/11/2-w/11*this.numberMovies.size()/2+w/11*(i+1)+this.barWidth/2, minimumLine);
      //((monsterNode)this.topMonsters.get(i)).setCenter(cenX-w/11/2-w/11*this.topMonsters.size()/2+w/11*(i+1), value-nodeDiameterChild/2);
      ((monsterNode)this.topMonsters.get(i)).setCenter(cenX-w/11/2-w/11*this.numberMovies.size()/2+w/11*(i+1), value-nodeDiameterChild/2);
      ((monsterNode)this.topMonsters.get(i)).draw();

      textSize(20*scale); //change
      textAlign(CENTER, BOTTOM);
      String stt = numberMovies.get(i).getString();
      if (LA == 1) {
        for (int qq = 0;qq<FILTER_MONSTER_NUM;qq++) {
          if (stt.equals(MONSTER_TYPE[qq][0].substring(1)) == true) {
            stt = MONSTER_TYPE[qq][1].substring(1);
            break;
          }
        }
      }
      text(stt, cenX-w/11/2-w/11*this.numberMovies.size()/2+w/11*(i+1), value-nodeDiameterChild*1.3);
      text((int(this.numberMovies.get(i).getCount())), cenX-w/11/2-w/11*this.numberMovies.size()/2+w/11*(i+1), value-nodeDiameterChild*1.05);
    }

    popStyle();
  }
}



