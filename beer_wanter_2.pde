PImage biertje = null;
int biertje_x = 0;
int biertje_y = 0;

PImage handje;
int handje_x = 0;
int handje_y = 0;
int handje_dx = 0;
int handje_dy = 0;

int z = 0;
boolean key_up_pressed = false;
boolean key_right_pressed = false;
boolean key_down_pressed = false;
boolean key_left_pressed = false;

int level = 0;

boolean DoCollide()
{
  final int left1 = biertje_x; 
  final int right1 = biertje_x + biertje.width; 
  final int top1 = biertje_y; 
  final int bottom1 = biertje_y + biertje.height; 
  
  final int left2 = handje_x; 
  final int right2 = handje_x + handje.width; 
  final int top2 = handje_y; 
  final int bottom2 = handje_y + handje.height; 
  
  //Top-left of handje is in
  if (left2 > left1 && left2 < right1 && top2 > top1 && top2 < bottom1) { return true; }

  //Top-right of handje is in
  if (right2 > left1 && right2 < right1 && top2 > top1 && top2 < bottom1) { return true; }


  //Bottom-left of handje is in
  if (left2 > left1 && left2 < right1 && bottom2 > top1 && bottom2 < bottom1) { return true; }

  //Top-right of handje is in
  if (right2 > left1 && right2 < right1 && bottom2 > top1 && bottom2 < bottom1) { return true; }
 
  //Top of handje is in
  if (left2 < left1 && right2 > right1 && top2 > top1 && top2 < bottom1) { return true; }

    //Bottom of handje is in
  if (left2 < left1 && right2 > right1 && bottom2 > top1 && bottom2 < bottom1) { return true; }

  //Too bad
  return false;
}

void setup() 
{
  fullScreen();
  biertje = loadImage("PicBeer.png");
  biertje_x = (width  / 2) - (biertje.width / 2);
  biertje_y = (height / 2) - (biertje.height / 2);
  handje = loadImage("PicHand.png");
  handje_x = (width  / 4) - (handje.width / 2);
  handje_y = (height / 4) - (handje.height / 2);
}

void draw() 
{
  if (key_up_pressed   ) { --handje_dy; }
  if (key_right_pressed) { ++handje_dx; }
  if (key_down_pressed ) { ++handje_dy; }
  if (key_left_pressed ) { --handje_dx; }
  handje_x += handje_dx;
  handje_y += handje_dy;
  
  ++z;
  background(255,255,z % 128);
  image(biertje,biertje_x,biertje_y);
  image(handje,handje_x,handje_y);
  
  biertje_x += random(-level,level+1);
  biertje_y += random(-level,level+1);
  if (biertje_x < 0) biertje_x = 0;
  else if (biertje_x + biertje.width > width) biertje_x = width - biertje.width;
  if (biertje_y < 0) biertje_x = 0;
  else if (biertje_y + biertje.height > height) biertje_y = height - biertje.height;
}

void keyReleased()
{
  if (key == CODED)
  {
    switch (keyCode)
    {
      case UP   : key_up_pressed    = false; return;
      case RIGHT: key_right_pressed = false; return;
      case DOWN : key_down_pressed  = false; return;
      case LEFT : key_left_pressed  = false; return;
    }
    return;
  }
  if (key == ' ')
  {
    if (DoCollide())
    {
      ++level;      
      biertje_x = (int)random(0,width - biertje.width);
      biertje_y = (int)random(0,height - biertje.height);
    }
  }
}

void keyPressed()
{
  if (key == CODED)
  {
    switch (keyCode)
    {
      case UP   : key_up_pressed    = true; return;
      case RIGHT: key_right_pressed = true; return;
      case DOWN : key_down_pressed  = true; return;
      case LEFT : key_left_pressed  = true; return;
    }
  }
}