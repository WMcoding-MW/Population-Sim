int rIn = 200; //Do not let this value be smaller than rDif
int rOut = 250; //Default 500
int rDif = rOut - rIn;

int population = 20; //10 000, all on wander, will lag
int numLakes = 1;
int numJungles = 1;
int numPoison = 100;

int total = 100;
int dev = 20;
int spacing = 150;

int time = 0;
int test = 0;
int born = 0;
int b = 0;
int poisonVol;

boolean newWorldGen = true;

final int startYear = 0;
animal[] pop = new animal[population];
water[] lakes;
plants[] jungle;
poison[] poison;

void setup() {


  //Populates the arena/circle
  for (int i = 0; i < pop.length; i++) {
    int rand = (int)random(0, 100);
    pop[i] = new animal(rand);
    pop[i].start();
    pop[i].x = (int)random(0, rOut*2);
    pop[i].y = (int)random(0, rOut*2);
  }

  if (newWorldGen == false) {

    lakes = new water[numLakes];
    jungle = new plants[numJungles];
    poison = new poison[numPoison];

    //Fills the arena with lakes
    for (int i = 0; i < numLakes; i++) {
      lakes[i] = new water();
      while (lakes[i].inBox(rIn, rDif)==false) {
        lakes[i].x = (int)random(0, rOut*2);
        lakes[i].y = (int)random(0, rOut*2);
      }
    }
    //Fills the arena with jungles
    for (int i = 0; i < numJungles; i++) {
      jungle[i] = new plants();
      while (jungle[i].inBox(rIn, rDif)==false) {
        do {
          jungle[i].x = (int)random(0, rOut*2);
          jungle[i].y = (int)random(0, rOut*2);
        } while (inRange(lakes, jungle[i]) == true);
      }
    }
    //Fills the arena with poison
    for (int i = 0; i < numPoison; i++) {
      poison[i] = new poison();
      while (poison[i].inBox(rIn, rDif)==false) {
        do {
          poison[i].x = (int)random(0, rOut*2);
          poison[i].y = (int)random(0, rOut*2);
        } while (inRange(lakes, jungle, poison[i]) == true);
      }
    }
  } else {
    lakes = new water[total];
    jungle = new plants[total];
    poison = new poison[total];

    for (int i = 0; i < total; i++) {
      if (i == 0) {
        lakes[i] = new water();
        // println("New lake", i);
        while (lakes[i].inBox(rIn, rDif)==false) {
          lakes[i].x = (int)random(0, rOut*2);
          lakes[i].y = (int)random(0, rOut*2);
        }

        jungle[i] = new plants();
        //println("New jungle", i);
        while (jungle[i].inBox(rIn, rDif)==false) {
          do {
            jungle[i].x = (int)random(0, rOut*2);
            jungle[i].y = (int)random(0, rOut*2);
          } while (sqrt(pow(jungle[i].x-lakes[i].x, 2) + pow(jungle[i].y-lakes[i].y, 2)) < spacing);
        }

        poison[i] = new poison();
        // println("New poison", i);
        while (poison[i].inBox(rIn, rDif)==false) {
          do {
            poison[i].x = (int)random(0, rOut*2);
            poison[i].y = (int)random(0, rOut*2);
          } while (sqrt(pow(jungle[i].x-poison[i].x, 2) + pow(jungle[i].y-poison[i].y, 2)) < spacing || sqrt(pow(lakes[i].x-poison[i].x, 2) + pow(lakes[i].y-poison[i].y, 2)) < spacing);
        }
      } else {

        int tries;

        lakes[i] = new water();
        tries = 0;
        do {
          //println("New lake", i);
          lakes[i].x += (int)random(lakes[i-1].x-dev, lakes[i-1].x+dev);
          lakes[i].y += (int)random(lakes[i-1].y-dev, lakes[i-1].y+dev);
          tries++;
          //println(tries);
        } while (lakes[i].inBox(rIn, rDif) == false && tries < 10);

        jungle[i] = new plants();
        tries = 0;
        do {
          //println("New Jungle", i);
          jungle[i].x += (int)random(jungle[i-1].x-dev, jungle[i-1].x+dev);
          jungle[i].y += (int)random(jungle[i-1].y-dev, jungle[i-1].y+dev);
          tries++;
        } while (jungle[i].inBox(rIn, rDif) == false && tries < 10);

        poison[i] = new poison();
        tries = 0;
        do {
          //println("New poison", i);
          poison[i].x += (int)random(poison[i-1].x-(dev/2), poison[i-1].x+(dev/2));
          poison[i].y += (int)random(poison[i-1].y-(dev/2), poison[i-1].y+(dev/2));
          tries++;
        } while (poison[i].inBox(rIn, rDif) == false && tries < 10);
      }
      //Inital lakes, jungles, and poisons are spawned
    }
  }

  frameRate(60);
  stroke(12);
  size(1000, 500);
}

void draw() {

  pop = clean();

  if (pop.length > 2500) {
    println("Population exceeded 2500");
    exit();
  }

  if (pop.length < 1) {
    println("Population reduced to ashes");
    exit();
  }

  time++;

  //***Random Event 1 "Rain"
  if (random(0, 100) > 90 && time % 10 == 0)
    for (int i = 0; i < lakes.length; i++) {
      if (lakes[i].volume < 500000*2) {
        lakes[i].volume += 50000;
      }
    }

  //***Random Event 2 "Poison"
  if (random(0, 100) > 90 && time % 1 == 0) {
    //println(poison.length);
    for (int i = 0; i < poison.length; i++) {
      if (poison[i].volume < 500000*2) {
        poison[i].volume+=100;
        poisonVol = poison[i].volume;
      }
    }
  }

  //***Random Event 3 "Growth"
  if (random(0, 100) > 90 && time % 10 == 0)
    for (int i = 0; i < jungle.length; i++) {
      if (jungle[i].volume < 500000*2) {
        jungle[i].volume += 10000;
      }
    }


  //Refreshes the image background and arena
  background(255);
  fill(200, 200, 200);
  stroke(0);
  circle(rOut, rOut, rOut*2);

  fill(0);
  stroke(0);

  //Prints current population and time
  if (time % 60 == 0) {
    println(time/60);
    println("Curret population:", pop.length - 1);
  }
  text("Total population: " + (pop.length), 600, 200);
  text("Total year: " + (time/60 + startYear), 600, 250);

  //Draws the outer-lakes 
  //println("Length", lakes.length);
  for (int i = 0; i < lakes.length; i++) {
    stroke(#03B1FF);
    fill(#03B1FF);
    circle(lakes[i].x, lakes[i].y, (lakes[i].volume/7500)+15);
  }

  //Draws the inner-lakes 
  //println("Length", lakes.length);
  for (int i = 0; i < lakes.length; i++) {
    stroke(#2000FA);
    fill(#2000FA);
    circle(lakes[i].x, lakes[i].y, lakes[i].volume/7500);
  }

  //Draws the outer-jungles
  for (int i = 0; i < jungle.length; i++) {
    stroke(#39FF58);
    fill(#39FF58);
    circle(jungle[i].x, jungle[i].y, (jungle[i].volume/7500)+15);
  }

  //Draws the inner-jungles
  for (int i = 0; i < jungle.length; i++) {
    stroke(#0E9523);
    fill(#0E9523);
    circle(jungle[i].x, jungle[i].y, jungle[i].volume/7500);
  }

  //Draws the outer-circle
  for (int i = 0; i < poison.length; i++) {
    stroke(#B553F2);
    fill(#B553F2);
    circle(poison[i].x, poison[i].y, (poison[i].volume/5000)+15);
  }

  //Draws the inner-circle
  for (int i = 0; i < poison.length; i++) {
    stroke(#7E25B7);
    fill(#7E25B7);
    circle(poison[i].x, poison[i].y, poison[i].volume/5000);
  }

  //Draws the creatures
  for (int i = 0; i < pop.length; i++) {

    born = 0;
    //println("Health:", pop[i].health);
    //println("Thirst:", pop[i].thirst);
    //println("Hunger:", pop[i].hunger);

    if (pop[i].health > 0) {
      //Checks if the creature is in the circle
      if (pop[i].inBox(rOut) == false) {
        pop[i].toCenter(rOut);
      } else /*if (time % 5 == 0)*/ {
        pop[i].move();
      }
      //println("Coord x: ", pop[i].x, " Coord y: ", pop[i].y, " Poison x: ", poison[0].x, " Poison y: ", poison[0].y);

      //Checks if the creature is thirsty
      if (pop[i].thirst < 1000) {
        pop[i].findWater(lakes);
      } else if (pop[i].hunger < 1000) {  //Checks if the creature is hungry
        if (pop[i].nameInt == 1) {
          pop[i].hunt(pop);
        } else if (pop[i].nameInt == 0 || pop[i].nameInt == 2) {
          pop[i].graze(jungle);
        }
      }

      //Damage conditions
      if (pop[i].thirst < 0) {
        pop[i].health--;
      }
      if (pop[i].hunger < 0) {
        pop[i].health--;
      }
    }


    if (pop[i].hunger > 500 && pop[i].thirst > 500) {
      if (pop[i].nameInt == 0) {
        //The difference between an explosion in population and stabilization is like, 1-5-10
        if (pop[i].repo(pop, pop[i].nameInt) == true && random(1, 1000) < 5) {
          //println(pop[i].nameInt);
          pop = populate(pop[i].nameInt, pop[i].speed);
        }
      } else if (pop[i].nameInt == 1) {
        if (pop[i].repo(pop, pop[i].nameInt) == true && random(1, 1000) < 5) {
          //println(pop[i].nameInt);
          pop = populate(pop[i].nameInt, pop[i].speed);
        }
      } else if (pop[i].nameInt == 2) {
        if (pop[i].repo(pop, pop[i].nameInt) == true && random(1, 1000) < 5) {
          //println(pop[i].nameInt);
          pop = populate(pop[i].nameInt, pop[i].speed);
        }
      }
    }
    counter();
    pop = clean();
  }

  //Draws the individual critters
  for (int i = 0; i < pop.length; i++) {

    switch (pop[i].nameInt) {
    case 0: 
      pop[i].colourR = 0;
      pop[i].colourG = 255;
      pop[i].colourB = 0;
      break;
    case 1:
      pop[i].colourR = 255;
      pop[i].colourG = 0;
      pop[i].colourB = 0;
      break;
    case 2:
      pop[i].colourR = 0;
      pop[i].colourG = 0;
      pop[i].colourB = 255;
      break;
    }

    if (pop[i].inRange(poison) == true) {
      pop[i].health-=2;
      pop[i].colourR = 181;
      pop[i].colourG = 83;
      pop[i].colourB = 242;
    }


    if (pop[i].health > 0) {
      stroke(pop[i].outline);
      fill(pop[i].colourR, pop[i].colourG, pop[i].colourB);
      circle(pop[i].x, pop[i].y, 10-pop[i].speed);
    }
  }
}

//Creates a new array consisting of the previous population + the new amount of people added
animal[] populate(int parentType, float parentSpeed) {

  //println("Parent type",parentType);
  int i = 0;
  population++;

  animal[] popNew = new animal[population];

  for (i = 0; i < pop.length; i++) {
    /*int rand = (int)random(0, 100);
     if (pop[i].health <= 0) {
     pop[i] = new animal(rand);
     pop[i].x = (int)random(0, rOut*2);
     pop[i].y = (int)random(0, rOut*2);
     }*/

    popNew[i] = pop[i];
  }
  popNew[i] = new animal(parentType, true);
  do { 
    popNew[i].x = random(0, rOut*2);
    popNew[i].y = random(0, rOut*2);
  } while (popNew[i].inRange(poison));

  do {
    popNew[i].speed = random(1, parentSpeed+5);
  } while (popNew[i].speed > 10);
  //println(popNew[i].nameInt);


  return popNew;
}

animal[] clean() {

  for (int i = 0; i < pop.length; i++) {
    if (pop[i].health <= 0) {
      population--;
    }
  }

  animal[] popNew = new animal[population];

  for (int newA = 0, oldA = 0; oldA < pop.length; oldA++, newA++) {
    if (pop[oldA].health <= 0) {
      newA--;
    } else {
      popNew[newA] = pop[oldA];
    }
  }
  return popNew;
}

void counter() {
  int prey = 0, predator = 0, wanderer = 0;
  for (int i = 0; i < pop.length; i++) {
    if (pop[i].nameInt == 0)
      prey++;
    if (pop[i].nameInt == 1)
      predator++;
    if (pop[i].nameInt == 2)
      wanderer++;
  }

  //Total prey
  textSize(25);

  fill(0, 200, 0);
  text("Prey: " + prey, 600, 50);

  fill(200, 0, 0);
  text("Predator: " + predator, 600, 100);

  fill(0, 0, 200);
  text("Wanderer: " + wanderer, 600, 150);
}

//Applies only to water and plants
boolean inRange (water[] wa, plants pl) {

  for (int i = 0; i < wa.length; i++) {
    if (sqrt(pow(wa[i].x-pl.x, 2)+pow(wa[i].y-pl.y, 2)) < 10) {
      return true;
    }
  } 
  return false;
}

boolean inRange (water[] wa, plants[] pl, poison po) {

  for (int i = 0; i < wa.length; i++) {
    if (sqrt(pow(wa[i].x-po.x, 2)+pow(wa[i].y-po.y, 2)) < 100) {
      return true;
    }
  }

  for (int i = 0; i < pl.length; i++) {
    if (sqrt(pow(pl[i].x-po.x, 2)+pow(pl[i].y-po.y, 2)) < 100) {
      return true;
    }
  }

  return false;
}
