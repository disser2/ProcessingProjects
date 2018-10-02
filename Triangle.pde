import java.util.LinkedList;

// Parameters
int count = 30;
int center_x = 400;
int center_y = 400;
int every = 20;
int every_count = 50;
int angle_offset = 0;

// Radii
int lower = 100;
int upper = 300;
int start = 100;
boolean increasing = true;

Dot d1;
Dot d2;
Dot d3;

LinkedList<Dot> dots;

void setup() {
  size(800, 800);
  
  // Aktualisierungsrate 
  frameRate(200);
  ellipseMode(RADIUS);

  // Schwarzer Hintergrund
  background(0);
  
  // Init
  dots = new LinkedList<Dot>();
  
  // Kleine Kreise
  for (int i = 0; i < count; i++){
    float angle = i * (360/count);
    
    float relx = cos(radians(angle)) * start;
    float rely = sin(radians(angle)) * start;
    
    dots.add(new Dot(center_x + relx, center_y + rely));
  }
  
  d1 = dots.get(0);
  d2 = dots.get(1);
  d3 = dots.get(2);
  
  //noLoop();
}

void draw() {
  // Schwarzer Hintergrund
  background(0);
  
  // Aendere den Radius
  if (increasing){
    start++;
    
    if (start >= upper){
      increasing = false;
    }
  } else {
    start--;
    if (start <= lower){
      increasing = true;
    }
  }
  
  angle_offset++;
  if (angle_offset >= 360){
    angle_offset = 0;
  }
  
  int i = 0;
  for (Dot d : dots){
    float angle = angle_offset + i * (360/count);
    float relx = cos(radians(angle)) * start;
    float rely = sin(radians(angle)) * start;
    d.x = center_x + relx;
    d.y = center_y + rely;
    i++;
  }
  
  // Zeichne die Kreise
  for (Dot d : dots){
    fill(#717171);
    ellipse(d.x, d.y, 5, 5);
  }
  
  every_count++;

  if (every_count >= every){
    every_count = 0;
    
    // Neue Knoten 
    d1 = dots.get(int(random(dots.size())));
    do{
      d2 = dots.get(int(random(dots.size())));
    } while (d1 == d2);
    do{
      d3 = dots.get(int(random(dots.size())));
    } while (d2 == d3);
    
    
  }
  
  // Zeichne Kanten
  stroke(#42f468);
  strokeWeight(4);
  line(d1.x, d1.y, d2.x, d2.y);
  line(d3.x, d3.y, d2.x, d2.y);
  line(d1.x, d1.y, d3.x, d3.y);
  
}  

public class Dot{
 
  public float x;
  public float y;
  
  public Dot(float x, float y){
    this.x = x;
    this.y = y;
  }
  
}
