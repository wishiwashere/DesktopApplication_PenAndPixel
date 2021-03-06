// This class extends from the Screen class, which in turn extends from the Rectangle class, and so
// inherits methods and variables from both of these classes. This screen is displayed when a search
// for a location has been unsuccessful.
public class SearchUnsuccessfulScreen extends Screen {

  // Creating a private variable to store the image which will be displayed as part of this screen
  private PImage searchUnsuccessfulScreenImage;

  // Creating a public constructor for the class so that an instance of it can be declared in the main sketch
  public SearchUnsuccessfulScreen() {

    super();

    // Initialising this class's private searchUnsuccessfulScreenImage variable by loading the image
    // in from the assets folder, so that it can be displayed when this screen is called.
    searchUnsuccessfulScreenImage = loadImage("searchUnsuccessfulScreenImage.png");

    // Creating the icon/s for this screen, using locally scoped variables, as these icons will be only
    // ever be referred to from the allIcons array. Setting their x, and y, based on percentages of the
    // width and height (where icon positioning variables are used, these were defined in the main 
    // Not passing in any width or height, so as to allow this icon to be set to the default size in the
    // Icon class of the app. Passing in a name for the icon, followed by a boolean to choose whether this
    // name should be displayed on the icon or not. Finally, passing in a linkTo value of the name of the
    // screen or function they will later link to.
    Icon homeIcon = new Icon(iconRightX, iconTopY, loadImage("homeIconImage.png"), "Home", false, "HomeScreen");
    Icon searchTravelIcon = new Icon(appWidth * 0.3, iconCenterY * 1.5, largeIconSize, largeIconSize, loadImage("searchPageIconImage.png"), "Search Again", true, "Below", "SearchScreen");
    Icon randomTravelIcon = new Icon(appWidth * 0.7, iconCenterY * 1.5, largeIconSize, largeIconSize, loadImage("randomPageIconImage.png"), "Random", true, "Below", "_getRandomLocation");

    // Creating a temporary allIcons array to store the icon/s we have created above.
    Icon[] allIcons = {homeIcon, searchTravelIcon, randomTravelIcon};

    // Calling the setScreenIcons() method of this screen's super class (Screen). This passes
    // the temporary allIcons array to the screenIcons array of the Screen class so that they
    // can be looped through by the showScreen() method, and methods inherited from the Icon
    // class (such as showIcon and checkMouseOver) can be called on them from within this array.
    // This reduces the need for each screen to have to loop through it's icons, or call the
    // same method on multiple icons.
    this.setScreenIcons(allIcons);
  }

  // Creating a public showScreen method, which is called by the draw() function whenever this screen needs to be displayed
  public void showScreen() {

    // Calling the super class's (Screen) drawScreen() method, to display each of this screen's icons.
    // This method will then in turn call it's super class's (Rectangle) method, to generate the screen.
    this.drawScreen();

    // Using the addText() method, as inherited from the Rectangle class, to add the following
    // lines of text to the screen. Using positioning values which will make this screen responsive
    // to the size of the device it is being displayed on. Using the iconCenterX variable, as defined
    // in the main Sketch class
    this.addText("We're sorry :(", iconCenterX, appHeight * 0.1);
    this.addText("We could not find what you were looking for...", iconCenterX, appHeight * 0.18);

    // Adding this screen's private searchUnsuccessfulScreenImage, using the addImage() method, as inherited from the
    // Rectangle class, so it will appear as part of this screen. Calculating the x, y, width and height
    // based on the current width and height of the device this app is running on.
    this.addImage(this.searchUnsuccessfulScreenImage, iconCenterX, appHeight * 0.5, appWidth * 0.6, appWidth * 0.3);
  }
}