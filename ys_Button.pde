class ys_Button {
	float x, y;
	float h; // height
	float w;
	int colour;
	String name; // title

	ys_Button(float _x, float _y, float _w, float _h, String _name) {
		x = _x;
		y = _y;
		w = _w;
		h = _h;
		name = _name;

		colour = BUTTON_COLOR;
	}

	void render() {

		pushStyle();
		noStroke();
		fill(colour);
		rectMode(CORNER);
		rect(x, y, w, h);
		fill(TEXT_COLOR);
		textAlign(CENTER, CENTER);
		text(name, x + w * 0.5, y + h * 0.5);

		popStyle();
	}

	public float getHeight() {
		return h;
	}

	void setPos(float _x, float _y) {
		x = _x;
		y = _y;
	}

	boolean checkIn(float _x, float _y) {
		if (_x > x && _x < x+w && _y > y && _y < y+h) {
			return true;
		}
		return false;
	}
}