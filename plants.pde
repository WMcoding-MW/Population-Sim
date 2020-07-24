class plants {
  int volume;
  int x;
  int y;

  plants() {
    volume = (int)random(100000, 500000);
  }
  //This functions checks if a point is contained inside a circle of radius r
  //Input: r for Radius
  //Output: returns the appopriate boolean value
  boolean inBox(int r, int dilate) {
    if (sqrt(pow(y-r-dilate, 2)+pow(x-r-dilate, 2))+dilate < r) {
      //println("*****Out of Box: ", sqrt(pow(r, 2)-pow(xCoord-r, 2)), yCoord-r);
      return true;
    }
    return false;
  }

}
