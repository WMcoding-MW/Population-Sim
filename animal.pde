class animal extends Thread {

  //Constructor
  animal(int parentType, boolean filler) {
    switch(parentType) {
    case 0: 
      nameInt = parentType;
      speed = 8;
      health = 60 - (int)speed*2;
      thirst = 5000;
      hunger = 10000;
      colourR = 0;
      colourG = 255;
      colourB = 0;
      break;
    case 1: 
      nameInt = parentType;
      speed = 8;
      health = 60 - (int)speed*2;
      thirst = 5000;
      hunger = 10000;
      colourR = 255;
      colourG = 0;
      colourB = 0;
      break;
    case 2: 
      nameInt = parentType;
      speed = 5;
      health = 60 - (int)speed*2;
      thirst = 10000;
      hunger = 20000;
      colourR = 0;
      colourG = 0;
      colourB = 255;
      break;
    }
  }

  animal(int animalPick) {
    if (animalPick > 40) { //The animal is assigned as prey
      nameInt = 0;
      speed = 8;
      health = 60 - (int)speed*2;
      health = 50;
      thirst = 5000;
      hunger = 5000;
      colourR = 0;
      colourG = 255;
      colourB = 0;
    } else if (animalPick > 25) { //The animal is assigned as predator
      nameInt = 1;
      speed = 8;
      health = 60 - (int)speed*2;
      thirst = 5000;
      hunger = 5000;
      colourR = 255;
      colourG = 0;
      colourB = 0;
    } else { //The animal is assigned as wanderer
      nameInt = 2;
      speed = 5;
      health = 60 - (int)speed*2;
      thirst = 5000;
      hunger = 5000;
      colourR = 0;
      colourG = 0;
      colourB = 255;
    }
  }

  //Stats
  int health;
  float speed;
  int thirst;
  int hunger;
  int nameInt;

  //Colours of the unit depending on the assigned role
  int colourR;
  int colourG;
  int colourB;

  boolean inCircle = true;
  int outline = 255;

  //Coordinates of the critter
  float x;
  float y;
  int range = 5;

  boolean wander = true;

  //The creature wanders
  void wandering() {

    x += random(-speed, speed);
    y += random(-speed, speed);
  }

  //The critter searches for water and moves towards it
  void findWater(water[] lakes) {
    int shortestDistance = 1001;
    int i = 0;

    //Finds the closest lake and its index, if a closer index is found, the new index is logged
    for (int index = 0; index < lakes.length; index++) {
      if (sqrt(pow(lakes[index].x-x, 2)+pow(lakes[index].y-y, 2)) < shortestDistance && lakes[index].volume > 500) {
        shortestDistance = (int)sqrt(pow(lakes[index].x-x, 2)+pow(lakes[index].y-y, 2));
        i = index;
      }
    }

    //Ensures the lake found is has water
    if (lakes[i].volume > 0) {
      x += speed*((lakes[i].x-x)/sqrt(pow(lakes[i].x-x, 2)+pow(lakes[i].y-y, 2)));
      y += speed*((lakes[i].y-y)/sqrt(pow(lakes[i].x-x, 2)+pow(lakes[i].y-y, 2)));

      if (sqrt(pow(lakes[i].x-x, 2)+pow(lakes[i].y-y, 2)) < range) {
        thirst += 500;
        //health+=1;
        lakes[i].volume -= 100;
      }
    }
  }

  //Literally the same as findWater, but for green circles
  void graze(plants[] plant) {
    int shortestDistance = 1001;
    int i = 0;
    for (int index = 0; index < plant.length; index++) {
      if (sqrt(pow(plant[index].x-x, 2)+pow(plant[index].y-y, 2)) < shortestDistance && plant[index].volume > 500) {
        shortestDistance = (int)sqrt(pow(plant[index].x-x, 2)+pow(plant[index].y-y, 2));
        i = index;
      }
    }

    if (plant[i].volume > 0) {
      x += speed*((plant[i].x-x)/sqrt(pow(plant[i].x-x, 2)+pow(plant[i].y-y, 2)));
      y += speed*((plant[i].y-y)/sqrt(pow(plant[i].x-x, 2)+pow(plant[i].y-y, 2)));

      if (sqrt(pow(plant[i].x-x, 2)+pow(plant[i].y-y, 2)) < range) {
        hunger += 500;
        plant[i].volume -=100;
      }
    }
  }

  //This checks if the animal has gone overtop of the circle and if so they get poisoned.
  Boolean ill(poison[] poison, int poisonVol) {

    //checks if they're in the poison circle
    if (inRange(poison) == true) {
      //println("Poison: ", sqrt(pow(poison[i].x-x, 2)+pow(poison[i].y-y, 2)), " poison: ", poisonVol);
      return true;
    }
    return false;
  } 
  //}
  //The predator finds the closest prey and moves towards them
  void hunt(animal[] an) {
    int shortestDistance = 2000;
    int i = 0;

    // while (a != true) {
    //Finds the closest prey, similar to findWater
    for (int index = 0; index < an.length; index++) {

      //println("An x", an[index].x, "An y", an[index].y, "x", x, "y", y);

      //exit();
      if (sqrt(pow(an[index].x-x, 2)+pow(an[index].y-y, 2)) < shortestDistance) {
        shortestDistance = (int)sqrt(pow(an[index].x-x, 2)+pow(an[index].y-y, 2));
        i = index;
      }

      if (an[i].health > 0) {
        flee(i, an); //Work in progress

        an[i].x += speed*((x-an[i].x)/(sqrt(pow(x-an[i].x, 2)+pow(y-an[i].y, 2))+1));
        an[i].y += speed*((y-an[i].y)/(sqrt(pow(x-an[i].x, 2)+pow(y-an[i].y, 2))+1));
        if (sqrt(pow(an[i].x-x, 2)+pow(an[i].y-y, 2)) < 10) {
          if (an[i].nameInt == 0 || an[i].nameInt == 2) {
            //println("Prey", an[i].x, an[i].y, "Predator", x, y);
            hunger += 5000;
            an[i].health -= 10;
          }
        }
      }
    }
  }
  // }

  //Gets the prey to flee from predator once predator begins to chase the prey
  private void flee(int index, animal[] an) {
    int shortestDistance = 1001;
    int i = 0;

    for (index = 0; index < an.length; index++) {
      if (sqrt(pow(an[index].x-x, 2)+pow(an[index].y-y, 2)) < shortestDistance && an[i].health > 0 && nameInt == 0) {
        shortestDistance = (int)sqrt(pow(an[index].x-x, 2)+pow(an[index].y-y, 2));
        i = index;
      }
    }
    an[i].x += -speed*((x-an[i].x)/sqrt(pow(x-an[i].x, 2)+pow(y-an[i].y, 2)));
    an[i].y += -speed*((y-an[i].y)/sqrt(pow(x-an[i].x, 2)+pow(y-an[i].y, 2)));
  }

  //Moves the critters to the center of the circle if it is outside
  void toCenter(int r) {
    //More efficient movement thanks to vectors, thank you Marcus Dann
    x += 2*speed*((r-x)/sqrt(pow(r-x, 2)+pow(r-y, 2)));
    y += 2*speed*((r-y)/sqrt(pow(r-x, 2)+pow(r-y, 2)));
  }

  //Used only to call the wander function, too lazy to fix
  void move() {
    if (wander == true) {
      wandering();
      thirst -= 25;
      hunger -= 15;
    }
  }

  //Meant to find if two creatures touch, returns a number from 1 to 3, meant to represent children
  boolean repo(animal[] pp, int self) {

    int shortestDistance = 1001;
    int i = 0;
    for (int index = 0; index < pp.length; index++) {
      if (index != self) {
        if (sqrt(pow(pp[index].x-x, 2)+pow(pp[index].y-y, 2)) < shortestDistance) {
          //println("Jungle ", index);
          shortestDistance = (int)sqrt(pow(pp[index].x-x, 2)+pow(pp[index].y-y, 2));
          i = index;
        }
      }
    }

    //println("Dad type", nameInt, "Mom type", pp[i].nameInt);
    //println("Dad coord",x,y,"Mom coord",pp[i].x,pp[i].y);
    if (sqrt(pow(pp[i].x-x, 2)+pow(pp[i].y-y, 2)) < 10 && nameInt == pp[i].nameInt && i != self) {
      return true;
    }
    return false;
  }

  //This functions checks if a point is contained inside a circle of radius r
  //Input: r for Radius
  //Output: returns the appopriate boolean value
  boolean inBox(int r) {
    if (sqrt(pow(y-r, 2)+pow(x-r, 2)) < r) {
      outline = 0;
      inCircle = true;
      return true;
    }
    outline = 255;
    inCircle = false;
    return false;
  }


  boolean inRange (poison[] po) {

    for (int i = 0; i < po.length; i++) {
      if (sqrt(pow(po[i].x-x, 2)+pow(po[i].y-y, 2)) < (po[i].volume/5000)+15) {
        return true;
      }
    }

    return false;
  }
}
