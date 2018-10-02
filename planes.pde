// Parameters
double threshold = 60;
int num_planes = 200;
int lag = 15;
int lag_count = 0;

/// Jede hoeher der Wert desto eher aendert ein Flugzeug seine Flugrichtung
double random_move = 0.2;

Plane[] planes; 

void setup() {
  size(1800, 1000);
  
  // Aktualisierungsrate 
  frameRate(25);
  ellipseMode(RADIUS);
  
  // Erstelle die Flugzeuge
  planes = new Plane[num_planes];
  for (int i = 0; i < planes.length; i++) {
    int dx = int(random(1,5));
    int dy = int(random(1,5));
    if (random(1) < 0.5)
      dx *= -1;
    if (random(1) < 0.5)
      dy *= -1;  
    planes[i] = new Plane(int(random(width)), int(random(height)), dx, dy,2);
  }
  background(0);
  //noLoop();
}

void draw() {
  background(0);
  //if(lag_count >= lag){
  //  background(255);
  //  lag_count = 0;
  //} else {
  //  lag_count++;
  //}

  //background(255);
  for (Plane x : planes){
    x.move();
    x.draw();
  }
  
  // Pruefe die paarweise Distanz
  for (Plane p1 : planes){
    for (Plane p2 : planes){
      if (p1 == p2){
        continue;
      }
      double d = distance(p1,p2);
      if (d < threshold){
        strokeWeight(3);
        
        //Gelb
        stroke(#ecd510);
        
        if (d < threshold*0.66){
          // Orange
          stroke(#ec8810);
        }
        
        if (d < threshold*0.33){
          // Rot
          stroke(#ec1010);
        }
        line(p1.x,p1.y,p2.x,p2.y);
      }
    }
  }
        

}  

// Ein Flugzeug
class Plane{
  public float x = 50;
  public float y = 50;
  public float dx = 1;
  public float dy = 1;
  public float speed = 1;
  public PlaneSpot[] history;
  
  Plane(float x, float y, float dx, float dy, float speed){
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
    this.speed = speed;
    history = new PlaneSpot[lag];
    
    for (int i = 0; i < history.length; i++){
      history[i] = new PlaneSpot(x,y,0);
    }
  }
  
  // Bewege das Flugzeug um einen Schritt weiter und aktualisiere alle vergangenen Positionen
  public void move(){
    
    // Wuerfele, ob das Flugzeug seine Richtung aendert
    if (random(1) < random_move){
      if (random(1) < 0.5)
        dx += 0.1 * random(1);
      else
        dx += -0.1 * random(1);
    }
    
    if (random(1) < random_move){
      if (random(1) < 0.5)
        dy += 0.1 * random(1);
      else
        dy += -0.1 * random(1);
    }
    
    if (random(2) < 0.1){
      dx *= -1;
      dy *= -1;
    }
    
    float newx = (this.x + this.speed * this.dx) % width;
    float newy = (this.y + this.speed * this.dy) % height;
    this.x = newx;
    this.y = newy;
    
    PlaneSpot newSpot = new PlaneSpot(newx, newy, 0);
    
    // Updating history
    for(int i = 1; i < history.length; i++){
      history[history.length-i] = history[history.length - (i+1)];
    }
    
    history[0] = newSpot;
  }
  
  public void draw(){
    //Punkt
    // point(this.x, this.y);
    
    // Kreisscheiben
    
    int i = 0;
    for (PlaneSpot spot : history){
      stroke(#717171, (lag -i) * 50);
      fill(#717171, (lag -i) * 50);
      ellipse(spot.x,spot.y, 3, 3);
      i++;
    }
    
    // Aktueller Punkt
    stroke(#0fed52, 255);
    fill(#0fed52, 255);
    ellipse(this.x,this.y, 3, 3);
  }
}

class PlaneSpot{
  public float x;
  public float y;
  public int ago;
  
  PlaneSpot(float x, float y, int ago){
    this.x = x;
    this.y = y;
    this.ago = ago;
  }
}

double distance(Plane p1, Plane p2){
  return sqrt(pow(p1.x - p2.x,2) + pow(p1.y - p2.y,2));
}
