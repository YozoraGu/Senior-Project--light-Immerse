public class Cell {
 
  PVector pos;
  PVector vel = new PVector(0, 0);
  PVector acc = new PVector(0, 0);
  float friction = 0.99;
  float radius;
  boolean hasChildren = false;
  ArrayList<Cell> cellL;
  float col = 167;

  Cell(PVector _pos, float _radius) {
    pos = _pos.copy();
    radius = _radius;
    cellL = new ArrayList<Cell>();
    nbCell++;
  } //End Constructor
 
  Cell(PVector _pos, float _radius, float _col) {
    col = _col;
    pos = _pos.copy();
    radius = _radius;
    cellL = new ArrayList<Cell>();
    nbCell++;
  } //End Constructor
 
  void update() {
 
    if (!hasChildren) {
      if (frameCount % 20 == 0) {
        this.applyForce(new PVector(random(-1, 1), random(-1, 1)));
      }
 
      vel.add(acc);
      vel.mult(friction);
      pos.add(vel);
      acc.mult(0);
      this.collision();  
 
      if (dist(x2, y2, pos.x, pos.y) < radius) {
        this.mitosis();
      }
    } else {
      for (Cell c : cellL) {
        c.update();
      }
    }
  }
 
  void display() {
    if (!hasChildren) {
      ellipseMode(RADIUS);
      noStroke();
      //fill(92, 240, 209, 200);
      fill(col, 100, 100, 200);
      ellipse(pos.x, pos.y, radius, radius);
    } else {
      for (Cell c : cellL) {
        c.display();
      }
    }
  }
 
  void run() {
    this.update();
    this.display();
  }
 
  void mitosis() {
    //Create two children, half the size of the actual, and instead of
    //displaying the actual cell, display the children, ect
 
    PVector sep = new PVector(random(5), random(5));
 
    cellL.add(new Cell(pos, radius*0.8, col-1));
    //cellL.add(new Cell(pos, radius*0.8, random(360)));
    cellL.get(0).applyForce(new PVector(sep.x, sep.y));
    cellL.add(new Cell(pos, radius*0.8, col-1));
    //cellL.add(new Cell(pos, radius*0.8, random(360)));
    cellL.get(1).applyForce(new PVector(sep.x*-1, sep.y*-1));
 
    hasChildren = true;
  }
 
  void applyForce(PVector _force) {
    if (!hasChildren) {
      acc.add(_force);
    } else {
      for (Cell c : cellL) {
        c.applyForce(_force);
      }
    }
  }
 
  void collision() {
    if (pos.x - radius < 0) {
      pos.x = radius;
      vel.x*=-1;
    }
 
    if (pos.x + radius > width) {
      pos.x = width-radius;
      vel.x*=-1;
    }
 
    if (pos.y-radius < 0) {
      pos.y = radius;
      vel.y*=-1;
    }
 
    if (pos.y + radius > height) {
      pos.y = height-radius;
      vel.y*=-1;
    }
  }
 
  void slideTowardMouse() {
    if (!hasChildren) {
      PVector s = new PVector(pos.x, pos.y);
      PVector d = new PVector(mouseX, mouseY);
 
      PVector dir = PVector.sub(d, s);
      float speed = map(dir.mag(), 0, 300, 0, 20);
      dir.normalize();
      dir.mult(speed);
      pos.add(dir);
    } else {
      for (Cell c : cellL) {
        c.slideTowardMouse();
      }
    }
  }
  void Clear(){
    hasChildren = false;
    cellL.clear();
  }
} //End Cell