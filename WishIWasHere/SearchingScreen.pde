// This class extends from the Screen class, which in turn extends from the Rectangle class, and so
// inherits methods and variables from both of these classes. This screen is displayed when a request
// has been made to the Google Geocoding API to search for a location.
public class SearchingScreen extends Screen {

  // Creating a private variable to store the image which will be displayed as part of this screen
  private PImage searchingImage;

  // Creating a public constructor for the class so that an instance of it can be declared in the main sketch
  public SearchingScreen() {

    super();

    // Initialising this class's private searchingImage variable by loading the image in from the assets
    // folder, so that it can be displayed when this screen is called.
    searchingImage = loadImage("searchingImage.png");

    // Setting the title of this screen in this class's super class (Screen), so that it can be accessed
    // when showing the screen (i.e can be displayed as the header text of the page).
    this.setScreenTitle("Searching...");
  }

  // Creating a public showScreen method, which is called by the draw() function whenever this
  // screen needs to be displayed
  public void showScreen() {

    // Calling the super class's (Screen) drawScreen() method, to display each of this screen's icons.
    // This method will then in turn call it's super class's (Rectangle) method, to generate the screen.
    this.drawScreen();

    // Adding this screen's private searchingImage, using the addImage() method, as inherited from the
    // Rectangle class, so it will appear as part of this screen. Calculating the x, y, width and height
    // based on the current width and height of the device this app is running on.
    this.addImage(this.searchingImage, appWidth/2, appHeight/2, appWidth * 0.4, appWidth * 0.4);
  }
}