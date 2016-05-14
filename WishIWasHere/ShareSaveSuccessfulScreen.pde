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
    // in the main Sketch class. Specifying which method/s have been successful, using the string generated 
    // above, based on which tasks were completed
    this.addText("Your postcard has been successfully " + methodUsed, iconCenterX, appHeight * 0.1);

    // Adding this screen's private shareSaveSuccessfulScreenImage, using the addImage() method, as inherited
    // from the Rectangle class, so it will appear as part of this screen. Calculating the x, y, width and height
    // based on the current width and height of the device this app is running on.
    this.addImage(this.shareSaveSuccessfulScreenImage, appWidth / 2, appHeight * 0.5, appWidth * 0.8, appWidth * 0.4);
  }
}