// This class extends from the Screen class, which in turn extends from the Rectangle class, and so
// inherits methods and variables from both of these classes. This screen is displayed while an image
// has been shared and/or shared successfully.
public class ShareSaveSuccessfulScreen extends Screen {

  // Creating a private variable to store the image which will be displayed as part of this screen
  private PImage shareSaveSuccessfulScreenImage;

  // Creating a public constructor for the class so that an instance of it can be declared in the main sketch
  public ShareSaveSuccessfulScreen() {

    super();

    // Initialising this class's private shareSaveSuccessfulScreenImage variable by loading the image
    // in from the assets folder, so that it can be displayed when this screen is called.
    shareSaveSuccessfulScreenImage = loadImage("sharingScreenImage.png");

    // Creating the icon/s for this screen, using locally scoped variables, as these icons will be only
    // ever be referred to from the allIcons array. Setting their x, and y, based on percentages of the
    // width and height (where icon positioning variables are used, these were defined in the main 
    // Not passing in any width or height, so as to allow this icon to be set to the default size in the
    // Icon class of the app. Passing in a name for the icon, followed by a boolean to choose whether this
    // name should be displayed on the icon or not. Finally, passing in a linkTo value of the name of the
    // screen or function they will later link to.
    Icon returnCameraLiveViewIcon = new Icon(iconCenterX * 0.55, iconCenterY * 1.5, largeIconSize, largeIconSize, loadImage("returnCameraLiveViewIcon.png"), "Return to \r\n camera view", true, "Below", "CameraLiveViewScreen");

    // Creating a temporary allIcons array to store the icon/s we have created above.
    Icon[] allIcons = {returnCameraLiveViewIcon};

    // Calling the setScreenIcons() method of this screen's super class (Screen). This passes
    // the temporary allIcons array to the screenIcons array of the Screen class so that they
    // can be looped through by the showScreen() method, and methods inherited from the Icon
    // class (such as showIcon and checkMouseOver) can be called on them from within this array.
    // This reduces the need for each screen to have to loop through it's icons, or call the
    // same method on multiple icons.
    this.setScreenIcons(allIcons);
  }

  // Creating a public showScreen method, which is called by the draw() function whenever this
  // screen needs to be displayed
  public void showScreen() {

    // Calling the super class's (Screen) drawScreen() method, to display each of this screen's icons.
    // This method will then in turn call it's super class's (Rectangle) method, to generate the screen.
    this.drawScreen();

    // Creating a local string, which will contain the value of the tasks that have been unsuccessful.
    // This will be based on the series of if statements below, and then used to add text to this screen
    // to give the user feedback on which issue occurred.
    String methodUsed = "";

    // Checking if this image has been saved, shared, or both, so as to determine which lines of text to
    // add to this screen
    if (imageSaved && imageShared) {
      methodUsed = "shared & saved";
    } else if (imageSaved) {
      methodUsed = "saved";
    } else if (imageShared) {
      methodUsed = "shared";
    }

    // Using the addText() method, as inherited from the Rectangle class, to add the following
    // lines of text to the screen. Using positioning values which will make this screen responsive
    // to the size of the device it is being displayed on. Using the iconCenterX variable, as defined
    // in the main Sketch class
    this.addText("Your postcard", iconCenterX, appHeight * 0.1);
    this.addText("has been", iconCenterX, appHeight * 0.18);
    this.addText("successfully", iconCenterX, appHeight * 0.26);

    // Specifying which method/s have been successful, using the string generated above, based on which
    // tasks were completed
    this.addText(methodUsed, iconCenterX, appHeight * 0.34);

    // Adding this screen's private shareSaveSuccessfulScreenImage, using the addImage() method, as inherited
    // from the Rectangle class, so it will appear as part of this screen. Calculating the x, y, width and height
    // based on the current width and height of the device this app is running on.
    this.addImage(this.shareSaveSuccessfulScreenImage, appWidth / 2, appHeight * 0.5, appWidth * 0.8, appWidth * 0.4);
  }
}