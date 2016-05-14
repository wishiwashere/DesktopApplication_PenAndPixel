// This class extends from the Screen class, which in turn extends from the Rectangle class, and so
// inherits methods and variables from both of these classes. This screen is displayed when an image
// was unable to be shared.
public class ShareUnsuccessfulScreen extends Screen {

  // Creating a private variable to store the image which will be displayed as part of this screen
  private PImage shareUnsuccessfulScreen;

  // Creating a public constructor for the class so that an instance of it can be declared in the main sketch
  public ShareUnsuccessfulScreen() {

    super();

    // Initialising this class's private shareUnsuccessfulScreen variable by loading the image
    // in from the assets folder, so that it can be displayed when this screen is called.
    shareUnsuccessfulScreen = loadImage("sharingScreenImage.png");

    // Creating the icon/s for this screen, using locally scoped variables, as these icons will be only
    // ever be referred to from the allIcons array. Setting their x, and y, based on percentages of the
    // width and height (where icon positioning variables are used, these were defined in the main 
    // Not passing in any width or height, so as to allow this icon to be set to the default size in the
    // Icon class of the app. Passing in a name for the icon, followed by a boolean to choose whether this
    // name should be displayed on the icon or not. Finally, passing in a linkTo value of the name of the
    // screen or function they will later link to.
    Icon cancelIcon = new Icon(iconCenterX * 0.55, largeIconBottomY, largeIconSize, largeIconSize, loadImage("cancelIconImage.png"), "Cancel", true, "Below", "CameraLiveViewScreen");
    Icon retryIcon = new Icon(iconCenterX * 1.45, largeIconBottomY, largeIconSize, largeIconSize, loadImage("retryIconImage.png"), "Retry", true, "Below", "_sendTweet");
    Icon shareImageToDeviceAppsIcon = new Icon(iconCenterX, largeIconBottomY * 0.7, largeIconSize, largeIconSize, loadImage("shareImageToDeviceAppsImage.png"), "Share", true, "Below", "_shareImageToDeviceApps");

    // Creating a temporary allIcons array to store the icon/s we have created above.
    Icon[] allIcons = {cancelIcon, retryIcon, shareImageToDeviceAppsIcon};

    // Calling the setScreenIcons() method of this screen's super class (Screen). This passes
    // the temporary allIcons array to the screenIcons array of the Screen class so that they
    // can be looped through by the showScreen() method, and methods inherited from the Icon
    // class (such as showIcon and checkMouseOver) can be called on them from within this array.
    // This reduces the need for each screen to have to loop through it's icons, or call the
    // same method on multiple icons.
    this.setScreenIcons(allIcons);
  }

  // Creating a public showScreen method, which is called by the draw() funciton whenever this
  // screen needs to be displayed
  public void showScreen() {

    // Calling the super class's (Screen) drawScreen() method, to display each of this screen's icons.
    // This method will then in turn call it's super class's (Rectangle) method, to generate the screen.
    this.drawScreen();

    // Using the addText() method, as inherited from the Rectangle class, to add the following
    // lines of text to the screen. Using positioning values which will make this screen responsive
    // to the size of the device it is being displayed on. Using the iconCenterX variable, as defined
    // in the main Sketch class
    this.addText("We're sorry :(", iconCenterX, appHeight * 0.1);
    this.addText("Your postcard", iconCenterX, appHeight * 0.18);
    this.addText("was not sent", iconCenterX, appHeight * 0.26);

    // Adding this screen's private shareUnsuccessfulScreen, using the addImage() method, as inherited from the
    // Rectangle class, so it will appear as part of this screen. Calculating the x, y, width and height
    // based on the current width and height of the device this app is running on.
    this.addImage(this.shareUnsuccessfulScreen, iconCenterX, appHeight * 0.4, appWidth * 0.5, appHeight * 0.16);

    // Checking if the image has been saved, before adding the following lines of text to the screen, using
    // the addText() method, as with the text above.
    if (imageSaved) {
      this.addText("But good news :)", iconCenterX, appHeight * 0.54);
      this.addText("We have still", iconCenterX, appHeight * 0.62);
      this.addText("saved it for you!", iconCenterX, appHeight * 0.7);
    }
  }
}