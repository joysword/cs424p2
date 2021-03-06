public class SingleMoviePane {

  private float centerX;
  private float centerY;
  private float widthS;
  private float heightS;
  private PShape ciack;

  private Keyboard keyboard;
  private Movie movie;
  private SuggestionBox suggestionBox;
  private String genre;
  private String certificate;
  private String budget;
  private String running;
  private String title;

  public SingleMoviePane(float centerX, float centerY, float widthS, float heightS, Movie movie) {
    this.centerX=centerX;
    this.centerY=centerY;
    this.widthS=widthS;
    this.heightS=heightS;

    this.keyboard=new Keyboard(this.centerX-this.widthS/2+this.widthS*0.8, this.centerY-this.heightS/2+this.heightS*0.5, this.heightS/15, color(255));
    this.movie=movie;
    this.suggestionBox= new SuggestionBox(this.centerX-this.widthS/2+this.widthS*0.95, this.centerY-this.heightS/2+this.heightS*0.2, this.widthS*0.2, this.heightS*0.08);
    this.ciack=loadShape("ciack2.svg");
  }

  public void draw() {
    rectMode(CENTER);
    fill(0);
    //stroke(0, 255, 0);
    rect(this.centerX, this.centerY, this.widthS, this.heightS);
    line(this.centerX-this.widthS/2+this.widthS*0.7, this.centerY-this.heightS/2, this.centerX-this.widthS/2+this.widthS*0.7, this.centerY+this.heightS/2);
    shapeMode(CENTER);
    shape(this.ciack, this.centerX-this.widthS/2+this.widthS*0.35, this.centerY, this.widthS*0.7, this.heightS*1.04);
    //rect(width/2,height/2,width/6*4,height*0.95);
    this.keyboard.draw();
    this.suggestionBox.draw();
    if(movie!=null){
    fill(255);
    textAlign(LEFT, CENTER);
    textSize(this.heightS/10);
    title=this.movie.title;
    if(title.length()>20)
      title=title.substring(0, 22)+"...";
    text(title, this.centerX-this.widthS/2+this.widthS*0.05, this.centerY-this.heightS/2+this.heightS*0.40);
    text("("+this.movie.year+")", this.centerX-this.widthS/2+this.widthS*0.05+textWidth(this.movie.title)+this.widthS/40, this.centerY-this.heightS/2+this.heightS*0.40);
    textSize(this.heightS/16);
    genre=this.movie.genre;
    if(genre.equals("")) genre="Comedy";
    text("Genre:  "+genre,this.centerX-this.widthS/2+this.widthS*0.05, this.centerY-this.heightS/2+this.heightS*0.55);
    running=this.movie.runtime;
    if(running.equals("")) running="UNKOWN";
    text("Running time:  "+running, this.centerX-this.widthS/2+this.widthS*0.05, this.centerY-this.heightS/2+this.heightS*0.65);
    //text("Plot: "+this.movie.description, this.centerX-this.widthS/2+this.widthS*0.05, this.centerY-this.heightS/2+this.heightS*0.70);
    certificate=this.movie.certificate;
        if(certificate.equals("")) certificate="NR";
    text("Certificate:  "+certificate, this.centerX-this.widthS/2+this.widthS*0.05, this.centerY-this.heightS/2+this.heightS*0.75);
    budget=this.movie.budget;
        if(budget.equals("")) budget="NO_BUDGET";
    text("Budget:  "+budget, this.centerX-this.widthS/2+this.widthS*0.05, this.centerY-this.heightS/2+this.heightS*0.85);
    }else{
    text("Genre:  ", this.centerX-this.widthS/2+this.widthS*0.05, this.centerY-this.heightS/2+this.heightS*0.55);
    text("Running time:  ", this.centerX-this.widthS/2+this.widthS*0.05, this.centerY-this.heightS/2+this.heightS*0.65);
    //text("Plot: "+this.movie.description, this.centerX-this.widthS/2+this.widthS*0.05, this.centerY-this.heightS/2+this.heightS*0.70);
    text("Certificate:  ", this.centerX-this.widthS/2+this.widthS*0.05, this.centerY-this.heightS/2+this.heightS*0.75);
    text("Budget:  ", this.centerX-this.widthS/2+this.widthS*0.05, this.centerY-this.heightS/2+this.heightS*0.85);
    
    }
  }
}

