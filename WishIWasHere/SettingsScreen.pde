// This class extends from the Screen class, which in turn extends from the Rectangle class, and so
// inherits methods and variables from both of these classes. This screen is displayed when a user
// wants to change their settings (i.e. turn on/off learning mode, turn on/off autosave mode or log
// out of their Twitter account.
public class SettingsScreen extends Screen {

  // Declaring two of this screen's icons as public variables, as they will need to be accessible
  // from the main Sketch class, so that their images can be updated accordingly if/when their
  // status changes. Normally, screen icons are only declared within the constructor of the class, as
  // they will be passed to the super class (Screen) and stored there as the icons for this screen.
  // By changing the scope of these variables, they can now be stored as the screen icons, but still
  // directly accessible when needed.
  public Icon learningModeIcon;
  public Icon autoSaveIcon;
  public Icon twitterAccountIcon;

  // Creating a public constructor for the class so that an instance of it can be declared in the main sketch
  public SettingsScreen() {

    super();

    // Creating temporary String variables, to store the relevant path to the icon image which should
    // be displayed on the autosave and learningMode icons on this screen, when the sketch first loads.
    // This will depend on the preferences stored by the user (which will have been loaded in in the main
    // sketch before this screen is created). Using ternary operators to configure the value for these
    // variables.
    String autoSaveToggleSwitchImage = autoSaveModeOn ? "toggleSwitchOnIconImage.png" : "toggleSwitchOffIconImage.png";
    String learningModeToggleSwitchImage = learningModeOn ? "toggleSwitchOnIconImage.png" : "toggleSwitchOffIconImage.png";

    // Creating the icon/s for this screen, using a locally scoped variable for the home icon, as this
    // icon will be only ever be referred to from the allIcons array. Initialising the two public
    // icons which were declare earlier in this class, as they will be accessible from all classes
    // so their background images can be updated when needed.
    // Setting their x, and y, based on percentages of the width and height (where icon positioning
    // variables are used, these were defined in the main  Not passing in any width or height,
    // so as to allow this icon to be set to the default size in the Icon class of the app. Passing in
    // a name for the icon, followed by a boolean to choose whether this name should be displayed on
    // the icon or not. Finally, passing in a linkTo value of the name of the screen or function they
    // will later link to.
    Icon homeIcon = new Icon(iconRightX, iconTopY, loadImage("homeIconImage.png"), "Home", false, "HomeScreen");
    learningModeIcon = new Icon(iconRightX * 0.9, iconCenterY * 0.5, smallIconSize * 1.8, smallIconSize * 0.9, loadImage(learningModeToggleSwitchImage), "Learning mode switch", false, "_switchLearningMode");
    autoSaveIcon = new Icon(iconRightX * 0.9, iconCenterY * 0.8, smallIconSize * 1.8, smallIconSize * 0.9, loadImage(autoSaveToggleSwitchImage), "Auto-save switch", false, "_switchAutoSaveMode");

    // Having to declare the allIcons array locally, as it cannot be initialised in this manner
    // unless it is part of the initial declaration
    Icon[] allIcons = {homeIcon, learningModeIcon, autoSaveIcon};

    // Calling the setScreenIcons() method of this screen's super class (Screen). This passes
    // the temporary allIcons array to the screenIcons array of the Screen class so that they
    // can be looped through by the showScreen() method, and methods inherited from the Icon
    // class (such as showIcon and checkMouseOver) can be called on them from within this array.
    // This reduces the need for each screen to have to loop through it's icons, or call the
    // same method on multiple icons.
    this.setScreenIcons(allIcons);

    // Setting the title of this screen in this class's super class (Screen), so that it can be accessed
    // when showing the screen (i.e can be displayed as the header text of the page).
    this.setScreenTitle("Settings");
  }

  // Creating a public showScreen method, which is called by the draw() function whenever this screen needs to be displayed
  public void showScreen() {

    // Calling the super class's (Screen) drawScreen() method, to display each of this screen's icons.
    // This method will then in turn call it's super class's (Rectangle) method, to generate the screen.
    this.drawScreen();

    // Adding text to go beside the icon that will be toggled in order label each setting for the users
    // convenience using the addText() method, as inherited from the Rectangle class, to add the following
    // lines of text to the screen. Using positioning values which will make this screen responsive
    // to the size of the device it is being displayed on. Using the iconLeftX and iconCenterY variables,
    // as defined in the main Sketch class. Setting the alignment of the text to left aligned.
    this.addText("Learning Mode", "LEFT", iconLeftX, iconCenterY * 0.5);
    this.addText("Autosave Image", "LEFT", iconLeftX, iconCenterY * 0.8);
  }
}