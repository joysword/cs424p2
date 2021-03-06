class ys_HelpWindow
{
  float x, y; //left-top corner
  float w, h; // width and height

  boolean isDisplay; // whether this window is being displayed

  String[] content; // what to show in this window

  ys_HelpWindow(float _x, float _y, float _w, float _h, String[] helpContent)
  {
    x = _x;
    y = _y;
    w = _w;
    h = _h;

    content = new String[2];

    content[0] = helpContent[0];
    content[1] = helpContent[1];

    isDisplay = false;
  }

  public void render() {
    if (isDisplay)
    {
      pushStyle();
      fill(POP_UP_WINDOW_BG_COLOR); //change
      strokeWeight(BOARD_WEIGHT);
      stroke(WINDOW_BOARD_COLOR);
      rectMode(CORNER);
      rect(x, y, w, h);
      fill(POP_UP_WINDOW_TEXT_COLOR);
      textAlign(LEFT, CENTER);
      textSize(BOARD_WEIGHT*5);
      text(content[LA], x+w*0.04, y+h*0.5);
      popStyle();
    }
  }

  private void switchDisplay()
  {
    isDisplay = !isDisplay;
  }

  boolean getIsDisplay() {
    return isDisplay;
  }

  void setNotDisplay() {
    isDisplay = false;
  }
}

