/*
*/
import sprites.utils.*;
import sprites.maths.*;
import sprites.*;

PImage background;

// The dimensions of the monster grid.
int monsterCols = 10; //16;
int monsterRows = 2; 

long mmCounter = 0;
int mmStep = 1; 

int numBossHits = 0;
int buildBoss = 0;
int counter = 0;
int mm = 0;

static int numDead = 0;

int missileSpeed = 500;
double upRadians = 4.71238898;
double downRadians = -4.71238898;
double leftRadians = 3.14159265;
double rightRadians = 6.28318531;
double downLeftRadians = -3.92699082;
double downRightRadians = -5.49778714;
double upLeftRadians = 3.92699082;
double upRightRadians = 5.49778714;

// Lower difficulty values introduce a more 
// random falling monster descent. 
int difficulty = 100;
double fmRightAngle = 0.3490; // 20 degrees
double fmLeftAngle= 2.79253; // 160 degrees
double fmSpeed = 150;

boolean gameOver = false;
boolean youWin = false;
int score = 0;
int fallingMonsterPts = 20;
int gridMonsterPts = 10;

PImage backgr;
int numMissiles = 0;

Sprite ship, missile, planet, enemyPlanet, heart, heart1;
Sprite heart2, fallingMonster, explosion, gameOverSprite;
Sprite boss, enemyMissile, laserBeam;
Sprite bossMissile, bossMissile1, bossMissile2, bossMissile3;
Sprite bossMissile4, bossMissile5, bossMissile6, bossMissile7;
Sprite bossMissile8, bossMissile9, bossMissile10, bossMissile11;
Sprite monsters[] = new Sprite[monsterCols * monsterRows];
ArrayList<Sprite> monsterss = new ArrayList<Sprite>();


KeyboardController kbController;
SoundPlayer soundPlayer;
StopWatch stopWatch = new StopWatch();

int numReset = 0;

void setup() 
{
  kbController = new KeyboardController(this);
  soundPlayer = new SoundPlayer(this);  
  // register the function (pre) that will be called
  // by Processing before the draw() function.
  if (numDead == 0)
    registerMethod("pre", this);

  size(900, 900);
  background = loadImage("space.png");

  S4P.messagesEnabled(true);
  buildSprites();
  heart = buildLife1();
  heart1 = buildLife2();
  heart2 = buildLife3();
  resetMonsters(); 
  // Ship Explosion Sprite
  explosion= new Sprite(this, "explosion_strip16.png", 17, 1, 90);
  explosion.setScale(1);
  // Game Over Sprite
  gameOverSprite = new Sprite(this, "gameOver.png", 100);
  gameOverSprite.setDead(true);
}

void buildSprites()
{
  // The Ship
  ship = buildShip();

  // The Grid Monsters 
  buildMonsterGrid();

  //buildLivesGrid();

  // The Missile
  missile = buildMissile();
  enemyMissile = buildEnemyMissile();
  bossMissile = buildEnemyMissile();
  bossMissile1 = buildEnemyMissile();
  bossMissile2 = buildEnemyMissile();
  bossMissile3 = buildEnemyMissile();
  bossMissile4 = buildEnemyMissile();
  bossMissile5 = buildEnemyMissile();
  bossMissile6 = buildEnemyMissile();
  bossMissile7 = buildEnemyMissile();
  bossMissile8 = buildEnemyMissile();
  bossMissile9 = buildEnemyMissile();
  bossMissile10 = buildBossMissiles();
  bossMissile11 = buildBossMissiles();

  // Own planet

  boss = buildBoss();
}

Sprite buildShip()
{
  Sprite ship = new Sprite(this, "spaceship1.png", 50);
  ship.setXY(width/2, height );
  ship.setVelXY(0.0f, 0);
  ship.setScale(.047);
  // Domain keeps the moving sprite withing specific screen area
  ship.setDomain(0, 0, width, height, Sprite.HALT);

  return ship;
}

Sprite buildLife2()
{
  Sprite heart1 = new Sprite(this, "heart.png", 50);
  heart1.setXY(800, 20);
  heart1.setVelXY(0.0f, 0);
  heart1.setScale(.2);

  return heart1;
}

Sprite buildLife3()
{
  Sprite heart2 = new Sprite(this, "heart.png", 50);

  heart2.setXY(840, 20);
  heart2.setVelXY(0.0f, 0);
  heart2.setScale(.2);

  return heart2;
} 

Sprite buildBoss()
{
  Sprite boss = new Sprite(this, "boss.png", 50);
  boss.setXY(width/2, -200);
  boss.setVelXY(0.0f, 0);
  boss.setScale(1);
  boss.setDomain(0, -500, width, 2000, Sprite.HALT);

  return boss;
}

Sprite buildMissile()
{
  // The Missile
  Sprite sprite  = new Sprite(this, "rocket.png", 10);
  sprite.setScale(.3);
  sprite.setDead(true); // Initially hide the missile
  return sprite;
}

Sprite buildEnemyMissile()
{
  // The Missile
  Sprite sprite  = new Sprite(this, "enemyrocket.png", 10);
  sprite.setScale(.3);
  sprite.setDead(true); // Initially hide the missile
  return sprite;
}

Sprite buildBossMissiles()
{
  // The Missile
  Sprite sprite  = new Sprite(this, "enemyrocket.png", 10);
  sprite.setScale(1.2);
  sprite.setDead(true); // Initially hide the missile
  return sprite;
}

// Build individual monster
Sprite buildMonster() 
{
  Sprite monster = new Sprite(this, "monster.png", 30);
  monster.setXY(999, 960);
  monster.setScale(1.1);
  monster.setDead(false);

  return monster;
}


Sprite buildLife1()
{
  Sprite heart = new Sprite(this, "heart.png", 30);
  heart.setXY(760, 20);
  heart.setVelXY(0.0f, 0);
  heart.setScale(.2);
  heart.setDead(false);

  return heart;
}

// Populate the monsters grid 
void buildMonsterGrid() 
{
  for (int idx = 0; idx < monsters.length; idx++ ) 
  {
    //monsters[idx] = buildMonster();
    monsterss.add(buildMonster());
  }
}

// Arrange Monsters into a grid
void resetMonsters() 
{
  if (numReset < 5)
  {
    for (int idx = 0; idx < monsters.length; idx++ ) 
    {
      Sprite monster = monsterss.get(idx);
      //Sprite monster = monsters[idx];
      monster.setSpeed(0, 0);

      double mwidth = monster.getWidth() + 20;
      double totalWidth = mwidth * monsterCols;
      double start = (width - totalWidth)/2 + 20;
      double mheight = monster.getHeight();
      int xpos = (int)((((idx % monsterCols)*mwidth)+start));
      int ypos = (int)(((int)(idx / monsterCols)*mheight)+50);
      monster.setXY(xpos, ypos - 160);

      monster.setDead(false);
    }
    numReset++;
  } else if (buildBoss < 1)
  {
    buildBoss++;
  }
}

void stopMissile() 
{
  missile.setSpeed(0, upRadians);
  missile.setDead(true);
}

void stopEnemyMissile()
{
  enemyMissile.setSpeed(0, downRadians);
  enemyMissile.setDead(true);
}

void stopBossMissile(Sprite missile, double radians)
{
  missile.setSpeed(0, radians);
  missile.setDead(true);
}

// Pick the first monster on the grid that is not dead.
// Return null if they are all dead.
Sprite pickNonDeadMonster() 
{
  for (int idx = monsters.length - 1; idx >= 0; idx--) 
  {
    Sprite monster = monsterss.get(idx);
    //Sprite monster = monsters[idx];
    if (!monster.isDead()) 
    {
      return monster;
    }
  }
  return null;
}

void replaceFallingMonster() 
{
  if (fallingMonster != null) 
  {
    //monsterss.remove(monsterss.size()-1);
    fallingMonster.setDead(true);
    fallingMonster = null;
  }

  // select new falling monster 
  fallingMonster = pickNonDeadMonster();

  if (fallingMonster == null) 
  {
    return;
  }

  fallingMonster.setSpeed(fmSpeed, fmRightAngle);
  // Domain keeps the moving sprite within specific screen area 
  fallingMonster.setDomain(0, 0, width, height + 130, Sprite.REBOUND);
}

// Executed before draw() is called 
public void pre() 
{    
  checkKeys();
  processCollisions();
  moveMonsters();
  if (buildBoss > 0)
    moveBoss();
  // If missile flies off screen
  if (!missile.isDead() && !missile.isOnScreem())      
  {
    stopMissile();
  }
  if (!enemyMissile.isDead() && !enemyMissile.isOnScreem())      
  {
    stopEnemyMissile();
  }
  if (!bossMissile.isDead() && !bossMissile.isOnScreem())      
  {
    stopBossMissile(bossMissile, downRadians);
  }
  if (!bossMissile1.isDead() && !bossMissile1.isOnScreem())      
  {
    stopBossMissile(bossMissile1, downRadians);
  }
  if (!bossMissile2.isDead() && !bossMissile2.isOnScreem())      
  {
    stopBossMissile(bossMissile2, downRadians);
  }
  if (!bossMissile3.isDead() && !bossMissile3.isOnScreem())      
  {
    stopBossMissile(bossMissile3, downRadians);
  }
  if (!bossMissile4.isDead() && !bossMissile4.isOnScreem())      
  {
    stopBossMissile(bossMissile4, leftRadians);
  }
  if (!bossMissile5.isDead() && !bossMissile5.isOnScreem())      
  {
    stopBossMissile(bossMissile5, rightRadians);
  }
  if (!bossMissile6.isDead() && !bossMissile6.isOnScreem())      
  {
    stopBossMissile(bossMissile6, downLeftRadians);
  }
  if (!bossMissile7.isDead() && !bossMissile7.isOnScreem())      
  {
    stopBossMissile(bossMissile7, downRightRadians);
  }
  if (!bossMissile8.isDead() && !bossMissile8.isOnScreem())      
  {
    stopBossMissile(bossMissile8, upLeftRadians);
  }
  if (!bossMissile9.isDead() && !bossMissile9.isOnScreem())      
  {
    stopBossMissile(bossMissile9, upRightRadians);
  }
  if (!bossMissile10.isDead() && !bossMissile10.isOnScreem())      
  {
    stopBossMissile(bossMissile10, downRadians);
  }
  if (!bossMissile11.isDead() && !bossMissile11.isOnScreem())      
  {
    stopBossMissile(bossMissile11, downRadians);
  }

  if (pickNonDeadMonster() == null) 
  {
    resetMonsters();
  }
  // if falling monster is off screen
  if (fallingMonster == null || !fallingMonster.isOnScreem()) 
  {
    replaceFallingMonster();
  }
  S4P.updateSprites(stopWatch.getElapsedTime());
} 

void fireMissile() 
{
  if (missile.isDead() && !ship.isDead()) 
  {
    soundPlayer.playFire();
    missile.setPos(ship.getPos());
    missile.setSpeed(missileSpeed * 2, upRadians);
    missile.setDead(false);
  }
}

void fireEnemyMissile() 
{
  if (enemyMissile.isDead() && !fallingMonster.isDead()) 
  {
    soundPlayer.playFire();
    enemyMissile.setPos(fallingMonster.getPos());
    enemyMissile.setSpeed(missileSpeed, downRadians);
    enemyMissile.setDead(false);
    if (gameOver == true || youWin == true)
      soundPlayer.stopFire();
  }
}

void fireBossMissile(Sprite missile, double rotation, double xpos, double ypos, double radians)
{
  if (missile.isDead() && !boss.isDead())
  {
    soundPlayer.playFire();
    missile.setRot(rotation);
    missile.setXY(xpos, ypos);
    missile.setSpeed(missileSpeed, radians);
    missile.setDead(false);
    if (gameOver == true || youWin == true)
      soundPlayer.stopFire();
  }
}

void checkKeys() 
{
  if (focused) {
    if (kbController.isLeft()) {
      ship.setX(ship.getX()-10);
    }
    if (kbController.isRight()) {
      ship.setX(ship.getX()+10);
    }
    if (kbController.isDown())
    {
      ship.setY(ship.getY()+10);
    }
    if (kbController.isUp())
    {
      ship.setY(ship.getY()-10);
    }
    if (kbController.isSpace()) 
    {
      fireMissile();
    }
  }
}
int count;
void moveMonsters() 
{  
  // Move Grid Monsters
  for (int idx = 0; idx < monsters.length; idx++ ) 
  {
    //Sprite monster = monsters[idx];
    Sprite monster = monsterss.get(idx);
    double ypos = monster.getY();
    if (!monster.isDead()&& monster != fallingMonster) 
    {
      monster.setXY(monster.getX(), ypos += .33);
    }
  }
  // Move Falling Monster
  if (fallingMonster != null) 
  {
    if (int(random(difficulty)) == 1) 
    {
      // Change FM Speed
      fallingMonster.setSpeed(fallingMonster.getSpeed() + random(-40, 40));
      // Reverse FM direction.
      if (fallingMonster.getDirection() == fmRightAngle) 
        fallingMonster.setDirection(fmLeftAngle);
      else
        fallingMonster.setDirection(fmRightAngle);
    }
    if (fallingMonster.getY() <= height - 130 && fallingMonster.getY() >= 0)
      fireEnemyMissile();
  }
}

void moveBoss()
{
  if (boss.getY() < 240)
  {
    boss.setXY(width/2, boss.getY() + .8);
  }
  mmCounter++;
  counter++;
  if ((mmCounter % 230) == 0 && mm == 0)
  {
    mmStep *= -1;
    mm++;
    mmCounter = 0;
  } else if ((mmCounter % 640) == 0 && mm >= 0)
  {
    mmStep *= -1;
  }
  if (boss.getY() >= 240)
  {
    fireBossMissile(bossMissile, 0, boss.getX() + 10, boss.getY() + 170, downRadians);
    fireBossMissile(bossMissile1, 0, boss.getX() - 13, boss.getY() + 170, downRadians);
    fireBossMissile(bossMissile2, 0, boss.getX() + 33, boss.getY() + 170, downRadians);
    fireBossMissile(bossMissile3, 0, boss.getX() - 36, boss.getY() + 170, downRadians);
    fireBossMissile(bossMissile4, 1.570795, boss.getX(), boss.getY(), leftRadians);
    fireBossMissile(bossMissile5, 1.570795, boss.getX(), boss.getY(), rightRadians);
    fireBossMissile(bossMissile6, .785398, boss.getX(), boss.getY(), downLeftRadians);
    fireBossMissile(bossMissile7, -.785398, boss.getX(), boss.getY(), downRightRadians);
    fireBossMissile(bossMissile8, -.785398, boss.getX(), boss.getY(), upLeftRadians);
    fireBossMissile(bossMissile9, .785398, boss.getX(), boss.getY(), upRightRadians); 
    if (counter % 500 == 0)
    {
      fireBossMissile(bossMissile10, 0, boss.getX() + 67, boss.getY() + 170, downRadians);
      fireBossMissile(bossMissile11, 0, boss.getX() - 69, boss.getY() + 170, downRadians);
    } 
  }
  if (!boss.isDead()) 
  {
    boss.setXY(boss.getX() + mmStep, boss.getY());
  }
}

// Detect collisions between sprites
void processCollisions() 
{
  // Detect collisions between Grid Monsters and Missile
  for (int idx = 0; idx < monsters.length; idx++) 
  {
    //Sprite monster = monsters[idx];
    Sprite monster = monsterss.get(idx);
    if (!missile.isDead() && !monster.isDead() && monster != fallingMonster && missile.bb_collision(monster)) 
    {
      monster.setXY(1000, 1000);
      monsterHit(monster);
      missile.setDead(true);
      score += gridMonsterPts;
    }
    // Detect collisions between Grid Monsters and Ship
    if (!ship.isDead() && monster.bb_collision(ship))
    {
      explodeShip(numDead);
      monster.setXY(2000, 2000);
      monsterHit(monster);
      if (numDead >= 2)
      {
        heart.setXY(1000, 960);
        heart.setDead(true);
        heart = null;
        gameOver = true;
      }
      numDead++;
    }
    // Between Falling Monster and Missile
    if (!missile.isDead() && fallingMonster != null && missile.cc_collision(fallingMonster)) 
    {
      score += fallingMonsterPts;
      fallingMonster.setXY(999, 960);
      monsterHit(fallingMonster); 
      missile.setDead(true); 
      fallingMonster = null;
    }
    // Between enemy missile and ship
    if (!enemyMissile.isDead() && !ship.isDead()  && enemyMissile.cc_collision(ship)) 
    {
      explodeShip(numDead);
      enemyMissile.setDead(true);
      if (numDead >= 2)
      {
        heart.setXY(1000, 960);
        heart.setDead(true);
        heart = null;
        gameOver = true;
      }
      numDead++;
    }
    // Between boss missiles and ship
    if (!bossMissile.isDead() && !ship.isDead()  && bossMissile.cc_collision(ship)) 
    {
      explodeShip(numDead);
      bossMissile.setDead(true);
      if (numDead >= 2)
      {
        heart.setXY(1000, 960);
        heart.setDead(true);
        heart = null;
        gameOver = true;
      }
      numDead++;
    }
    if (!bossMissile1.isDead() && !ship.isDead()  && bossMissile1.cc_collision(ship)) 
    {
      explodeShip(numDead);
      bossMissile1.setDead(true);
      if (numDead >= 2)
      {
        heart.setXY(1000, 960);
        heart.setDead(true);
        heart = null;
        gameOver = true;
      }
      numDead++;
    }
    if (!bossMissile2.isDead() && !ship.isDead()  && bossMissile2.cc_collision(ship)) 
    {
      explodeShip(numDead);
      bossMissile2.setDead(true);
      if (numDead >= 2)
      {
        heart.setXY(1000, 960);
        heart.setDead(true);
        heart = null;
        gameOver = true;
      }
      numDead++;
    }
    if (!bossMissile3.isDead() && !ship.isDead()  && bossMissile3.cc_collision(ship)) 
    {
      explodeShip(numDead);
      bossMissile3.setDead(true);
      if (numDead >= 2)
      {
        heart.setXY(1000, 960);
        heart.setDead(true);
        heart = null;
        gameOver = true;
      }
      numDead++;
    }
    if (!bossMissile4.isDead() && !ship.isDead()  && bossMissile4.cc_collision(ship)) 
    {
      explodeShip(numDead);
      bossMissile4.setDead(true);
      if (numDead >= 2)
      {
        heart.setXY(1000, 960);
        heart.setDead(true);
        heart = null;
        gameOver = true;
      }
      numDead++;
    }
    if (!bossMissile5.isDead() && !ship.isDead()  && bossMissile5.cc_collision(ship)) 
    {
      explodeShip(numDead);
      bossMissile5.setDead(true);
      if (numDead >= 2)
      {
        heart.setXY(1000, 960);
        heart.setDead(true);
        heart = null;
        gameOver = true;
      }
      numDead++;
    }
    if (!bossMissile6.isDead() && !ship.isDead()  && bossMissile6.cc_collision(ship)) 
    {
      explodeShip(numDead);
      bossMissile6.setDead(true);
      if (numDead >= 2)
      {
        heart.setXY(1000, 960);
        heart.setDead(true);
        heart = null;
        gameOver = true;
      }
      numDead++;
    }
    if (!bossMissile7.isDead() && !ship.isDead()  && bossMissile7.cc_collision(ship)) 
    {
      explodeShip(numDead);
      bossMissile7.setDead(true);
      if (numDead >= 2)
      {
        heart.setXY(1000, 960);
        heart.setDead(true);
        heart = null;
        gameOver = true;
      }
      numDead++;
    }
    if (!bossMissile8.isDead() && !ship.isDead()  && bossMissile8.cc_collision(ship)) 
    {
      explodeShip(numDead);
      bossMissile8.setDead(true);
      if (numDead >= 2)
      {
        heart.setXY(1000, 960);
        heart.setDead(true);
        heart = null;
        gameOver = true;
      }
      numDead++;
    }
    if (!bossMissile9.isDead() && !ship.isDead()  && bossMissile9.cc_collision(ship)) 
    {
      explodeShip(numDead);
      bossMissile9.setDead(true);
      if (numDead >= 2)
      {
        heart.setXY(1000, 960);
        heart.setDead(true);
        heart = null;
        gameOver = true;
      }
      numDead++;
    }
    if (!bossMissile10.isDead() && !ship.isDead()  && bossMissile10.cc_collision(ship)) 
    {
      explodeShip(numDead);
      bossMissile10.setDead(true);
      if (numDead >= 2)
      {
        heart.setXY(1000, 960);
        heart.setDead(true);
        heart = null;
        gameOver = true;
      }
      numDead++;
    }
    if (!bossMissile11.isDead() && !ship.isDead()  && bossMissile11.cc_collision(ship)) 
    {
      explodeShip(numDead);
      bossMissile11.setDead(true);
      if (numDead >= 2)
      {
        heart.setXY(1000, 960);
        heart.setDead(true);
        heart = null;
        gameOver = true;
      }
      numDead++;
    }

    // Between missile and enemy missile
    if (!missile.isDead() && !enemyMissile.isDead() && missile.cc_collision(enemyMissile)) 
    {
      enemyMissile.setDead(true);
      missile.setDead(true);
    }
    if (!missile.isDead() && !bossMissile.isDead() && missile.cc_collision(bossMissile)) 
    {
      bossMissile.setDead(true);
      missile.setDead(true);
    }
    if (!missile.isDead() && !bossMissile1.isDead() && missile.cc_collision(bossMissile1)) 
    {
      bossMissile1.setDead(true);
      missile.setDead(true);
    }
    if (!missile.isDead() && !bossMissile2.isDead() && missile.cc_collision(bossMissile2)) 
    {
      bossMissile.setDead(true);
      missile.setDead(true);
    }
    if (!missile.isDead() && !bossMissile3.isDead() && missile.cc_collision(bossMissile3)) 
    {
      bossMissile3.setDead(true);
      missile.setDead(true);
    }
    if (!missile.isDead() && !bossMissile4.isDead() && missile.cc_collision(bossMissile4)) 
    {
      bossMissile4.setDead(true);
      missile.setDead(true);
    }
    if (!missile.isDead() && !bossMissile5.isDead() && missile.cc_collision(bossMissile5)) 
    {
      bossMissile5.setDead(true);
      missile.setDead(true);
    }
    if (!missile.isDead() && !bossMissile6.isDead() && missile.cc_collision(bossMissile6)) 
    {
      bossMissile6.setDead(true);
      missile.setDead(true);
    }
    if (!missile.isDead() && !bossMissile7.isDead() && missile.cc_collision(bossMissile7)) 
    {
      bossMissile7.setDead(true);
      missile.setDead(true);
    }
    if (!missile.isDead() && !bossMissile8.isDead() && missile.cc_collision(bossMissile8)) 
    {
      bossMissile8.setDead(true);
      missile.setDead(true);
    }
    if (!missile.isDead() && !bossMissile9.isDead() && missile.cc_collision(bossMissile9)) 
    {
      bossMissile9.setDead(true);
      missile.setDead(true);
    }
    if (!missile.isDead() && !bossMissile10.isDead() && missile.cc_collision(bossMissile10)) 
    {
      missile.setDead(true);
    }
    if (!missile.isDead() && !bossMissile11.isDead() && missile.cc_collision(bossMissile11)) 
    {
      missile.setDead(true);
    }
    // Between Falling Monster and Ship
    if (fallingMonster!= null && !ship.isDead() && fallingMonster.bb_collision(ship)) 
    {
      explodeShip(numDead);
      fallingMonster.setXY(1000, 960);
      monsterHit(fallingMonster);
      fallingMonster = null;
      if (numDead >= 2)
      {
        heart.setXY(1000, 960);
        heart.setDead(true);
        heart = null;
        gameOver = true;
      }
      numDead++;
    }

    // Between Boss and Ship
    if (boss!= null && !ship.isDead() && boss.bb_collision(ship)) 
    {
      explodeShip(numDead);
      if (numDead >= 2)
      {
        heart.setXY(1000, 960);
        heart.setDead(true);
        heart = null;
        gameOver = true;
      }
      numDead++;
    }
    // Between boss and Missile
    if (!missile.isDead() && boss != null && missile.cc_collision(boss)) 
    {
      if (numBossHits >= 50)
      {
        monsterHit(boss);
        boss.setXY(width/2, -500);
        fallingMonster = null;
        score += 2000;
        youWin = true;
      }
      missile.setDead(true); 
      numBossHits++;
    }
  }
}

void explodeShip(int numDead) 
{
  soundPlayer.playExplosion();
  explosion.setPos(ship.getPos());
  explosion.setFrameSequence(0, 16, 0.1, 1);
  ship.setDead(true);
  if (numDead < 2)
  {
    ship = buildShip();
    if (numDead == 0)
    {
      heart2.setXY(1000, 960);
      heart2.setDead(true);
      heart2 = null;
    } else if (numDead == 1)
    {
      heart1.setXY(1000, 960);
      heart1.setDead(true);
      heart1 = null;
    }
  }
}

void monsterHit(Sprite monster) 
{
  //soundPlayer.playPop();
  monster.setDead(true);
}

void drawGameOver() 
{
  gameOverSprite.setXY(width/2, height/2);
  gameOverSprite.setDead(false);
  textSize(64);
  String msg = "YOU LOSE!";
  text(msg, width/2 - 160, height/2 + 80);
  soundPlayer.playGameOver();
}

void drawYouWin()
{
  gameOverSprite.setXY(width/2, height/2);
  gameOverSprite.setDead(false);
  textSize(64);
  String msg = "YOU WIN!";
  text(msg, width/2 - 140, height/2 + 80);
  soundPlayer.playYouWin();
}

void drawScore() 
{
  textSize(32);
  String msg = "Score: " + score;
  text(msg, 10, 30);
}

public void draw() 
{
  background(background);
  drawScore();
  if (gameOver == true && youWin == false)
  {
    drawGameOver();
  }
  if (youWin == true)
    drawYouWin();
  S4P.drawSprites();
}