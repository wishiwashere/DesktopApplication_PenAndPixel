// Importing the java ArrayList class, so that the favourite tabs for this screen can be stored in
// an array which can be added to, removed from and updated.
import java.util.ArrayList;

// This class extends from the Screen class, which in turn extends from the Rectangle class, and so
// inherits methods and variables from both of these classes. This screen is displayed when users
// want to view or access their favourite locations, so they can quickly return to them.
public class FavouritesScreen extends Screen {

  // Creating a private boolean, which will be used to check if this page has be reloaded yet i.e.
  // so that when the user leaves this screen, it will be reset (using this class's resetScreen() method)
  // so that if the page was partially scrolled when they left it, it will reset when they come back to
  // this screen. Resetting this variable to false in the HomeScreen class.
  public Boolean loaded = false;

  // Declaring a private favTabs array, to store each of the favourite tabs we create,
  // so that they can be looped through in this class's showScreen() method, to display
  // the tabs, as well as checking if they are being clicked on.
  public ArrayList<FavouriteTab> favTabs;

  /*-------------------------------------- Constructor() ------------------------------------------------*/
  // Creating a public constructor for the class so that an instance of it can be declared in the main sketch
  public FavouritesScreen() {

    super();

    // Creating the favTabs array to store each of the favourite tabs that will be created below
    this.favTabs = new ArrayList<FavouriteTab>();

    // Looping through the favourites array, to create a new tab for each favourite location in the
    // user_preferences.xml file, so they can be displayed as a list of tabs on this screen
    for (int f = 0; f < favouriteLocationsData.length; f++) {

      // Creating temporary variables to store the data relating to this location from
      // the favourite locations xml file, so that they can be passed in to this favourite
      // tab's constructor. Parsing the heading and pitch data to floats, as they will have
      // been stored as strings in the XML file. The purpose of casting them back to floats is
      // that we want the user to be able to scroll around the location and therefore be able
      // to increment/decrement these values.
      String name = favouriteLocationsData[f].getString("name");
      String latLng = favouriteLocationsData[f].getString("latLng");
      float heading = Float.parseFloat(favouriteLocationsData[f].getString("heading"));
      float pitch = Float.parseFloat(favouriteLocationsData[f].getString("pitch"));

      // Creating a temporary variable to hold the new Favourite Tab, passing in the title
      // and location data for the current favourite.
      FavouriteTab newFavTab = new FavouriteTab(name, latLng, heading, pitch);

      // Adding the new FavTab to this class's favTabs array, so that we can loop through them
      // in the showScreen() method, to display them, as well as checking if they are being
      // clicked on.
      favTabs.add(newFavTab);
    }

    // Creating the icon/s for this screen, using locally scoped variables, as these icons will be only
    // ever be referred to from the allIcons array. Setting their x, and y, based on percentages of the
    // width and height (where icon positioning variables are used, these were defined in the main 
    // Not passing in any width or height, so as to allow this icon to be set to the default size in the
    // Icon class of the app. Passing in a name for the icon, followed by a boolean to choose whether this
    // name should be displayed on the icon or not. Finally, passing in a linkTo value of the name of the
    // screen or function they will later link to.
    Icon homeIcon = new Icon(iconRightX, iconTopY, loadImage("homeIconImage.png"), "Home", false, "HomeScreen");

    // Creating a temporary allIcons array to store the icon/s we have created above.
    Icon[] allIcons = {homeIcon};

    // Calling the setScreenIcons() method of this screen's super class (Screen). This passes
    // the temporary allIcons array to the screenIcons array of the Screen class so that they
    // can be looped through by the showScreen() method, and methods inherited from the Icon
    // class (such as showIcon and checkMouseOver) can be called on them from within this array.
    // This reduces the need for each screen to have to loop through it's icons, or call the
    // same method on multiple icons.
    this.setScreenIcons(allIcons);

    // Setting the title of this screen in this class's super class (Screen), so that it can be accessed
    // when showing the screen (i.e can be displayed as the header text of the page).
    this.setScreenTitle("Favourites");
  }

  /*-------------------------------------- showScreen() ------------------------------------------------*/

  // Creating a public showScreen method, which is called by the draw() function whenever this screen needs to be displayed
  public void showScreen() {

    // Checking if this page has be reloaded yet i.e. so that when the user leaves this screen. If the page
    // was partially scrolled when the user left it, it will reset when they come back to this screen.
    // Resetting this variable to false in the HomeScreen class.
    if (!this.loaded) {
      // Calling the resetScreen() method of this class, so that the layout and positioning of this
      // screen will be reset
      this.resetScreen();
    }

    // Calling the super class's (Screen) drawScreen() method, to display each of this screen's icons.
    // This method will then in turn call it's super class's (Rectangle) method, to generate the screen.
    // Calling this method after the above check has been done to see if the icons etc. on this screen have
    // been reset, so that the screen appears correctly, even on it's first load.
    this.drawScreen();

    // Looping through our array of favourite tabs, and calling the showFavourite() method (of
    // the FavouriteTab class) to display the tab on screen
    for (int f = 0; f < this.favTabs.size(); f++) {
      this.favTabs.get(f).showFavourite();
    }

    // Checking if the page is being scrolled
    if (mousePressed) {

      if (mouseClicked && mouseY < iconTopY) {
        resetScreen();
        mouseClicked = false;
      } else {

        // Calling the Screen class's scrollScreen() method, to scroll the icons, screen and screen
        // title. This method returns the amount the user has scrolled on the screen, so that it
        // can be used within this class to scroll the favourite tabs separately
        float amountScrolled = scrollScreen();

        // Looping through each of the favourite tabs, to change their positions according to the amount they
        // have been scrolled
        for (int i = 0; i < favTabs.size(); i++) {

          // Checking which direction the user scrolled, based on the previous and current mouse Y positions
          if (pmouseY > mouseY) {
            // The user has scrolled UP

            // Setting the y position of the icon to it's current position, minus the amount scrolled i.e.
            // moving the icon up the screen
            this.favTabs.get(i).setY(this.favTabs.get(i).getY() - amountScrolled);
          } else {
            // The user has scrolled DOWN

            // Checking if the screen's y position is less than or equal to half of the height i.e. is
            // so that the screen cannot be down any further once you reach the top
            if (this.getY() <= (appHeight / 2) - amountScrolled) {

              // Setting the y position of the icon to it's current position, plus the amount scrolled i.e.
              // moving the icon down the screen
              this.favTabs.get(i).setY(this.favTabs.get(i).getY() + amountScrolled);
            } else {
              // The user has reached the top of the screen, so calling this class's resetScreen() method,
              // to reset the Favourite icons, and other elements on screen, to their original positions
              this.resetScreen();
            }
          }
        }
      }
    }
  }

  // Private resetScreen() method, which can only be called from within this class, to reset all of the
  // elements on screen to their original positions. Called each time the screen is opened, or if the
  // user scrolls back up and reaches the top of the screen
  private void resetScreen() {

    // Resetting the screenTitleY position to it's original value (as it may have been
    // incremented if the about screen was scrolled
    screenTitleY = iconTopY;

    // Resetting the screen's y value to be centered on the device's screen
    this.setY(appHeight / 2);

    // Since there is only one icon on this screen (the home icon) just accessing the first icon
    // in this screen's allScreenIcons array, to be equal to the gloabl iconTopY position, as declared
    // in the main Sketch class
    this.getScreenIcons()[0].setY(iconTopY);

    // Looping through each of the favourite tabs, in reverse so the newest always appear at the top,
    // to reset their positions on screen
    for (int i = favTabs.size() - 1; i >=0; i--) {
      // Generating this tab's y position by taking the value of i away from the total number of favourite
      // tabs, and then multiplying it by 25% of the screen height, so that each tab will be spaced evenly
      // one below the other, with some spacing in between
      float tabYPosition = appHeight * 0.2 + ((favTabs.size() - i) * appHeight * 0.3);

      // Using the setY() method, as inherited from the Rectangle class, through the ClickableElement class,
      // to set the y position of this favourite tab, using the value generated above.
      favTabs.get(i).setY(tabYPosition);
    }

    // Setting loaded to true. This value will be reset to false in the HomeScreen class, so that the
    // page will always be reset before a user views it again (incase they left the screen partially scrolled)
    // or when the user reaches the top of the screen after scrolling down.
    this.loaded = true;
  }

  /*-------------------------------------- get() and set() ------------------------------------------------*/

  // Public get method which returns the ArrayList of all of the FavouriteTabs, so that they can be accessed
  // from the main Sketch class i.e. to check if a location is already a favourite before adding/removing it
  public ArrayList<FavouriteTab> getFavTabs() {
    return favTabs;
  }
}