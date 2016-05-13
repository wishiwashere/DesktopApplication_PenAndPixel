// This class extends from the Screen class, which in turn extends from the Rectangle class, and so
// inherits methods and variables from both of these classes. This screen is displayed when an image
// was unable to be shared.
public class ShareUnsuccessfulScreen extends Screen {

    // Creating a private variable to store the instance of the main sketch which will be passed into
    // the constructors of this class when they are initialised. The purpose of this variable is so that
    // we can access the Processing library, along with other global methods and variables of the main
    // sketch class, from within this class. Every reference to a Processing method/variable, or a public
    // method/variable of the main sketch, must be prefixed with this object while within this class.
    private Sketch sketch;

    // Creating a private variable to store the image which will be displayed as part of this screen
    private PImage shareUnsuccessfulScreen;

    // Creating a public constructor for the class so that an instance of it can be declared in the main sketch
    public ShareUnsuccessfulScreen(Sketch _sketch) {

        // Passing the instance of the Sketch class, which was passed to constructor of this class, to the
        // super class (Screen), which will in turn pass it to it's super class (Rectangle). The purpose
        // of this variable is so that we can access the Processing library, along with other global methods
        // and variables of the main sketch class, from all other classes.
        super(_sketch);

        // Initialising this class's local sketch variable, with the instance which was passed to the
        // constructor of this class. The purpose of this variable is so that we can access the Processing
        // library, along with other global methods and variables of the main sketch class, from within
        // this class. Every reference to a Processing method/variable, or a public method/variable of
        // the main sketch, must be prefixed with this object while within this class.
        sketch = _sketch;

        // Initialising this class's private shareUnsuccessfulScreen variable by loading the image
        // in from the assets folder, so that it can be displayed when this screen is called.
        shareUnsuccessfulScreen = sketch.loadImage("sharingScreenImage.png");

        // Creating the icon/s for this screen, using locally scoped variables, as these icons will be only
        // ever be referred to from the allIcons array. Setting their x, and y, based on percentages of the
        // width and height (where icon positioning variables are used, these were defined in the main sketch.
        // Not passing in any width or height, so as to allow this icon to be set to the default size in the
        // Icon class of the app. Passing in a name for the icon, followed by a boolean to choose whether this
        // name should be displayed on the icon or not. Finally, passing in a linkTo value of the name of the
        // screen or function they will later link to.
        Icon cancelIcon = new Icon(sketch, sketch.iconCenterX * 0.55, sketch.largeIconBottomY, sketch.largeIconSize, sketch.largeIconSize, sketch.loadImage("cancelIconImage.png"), "Cancel", true, "Below", "CameraLiveViewScreen");
        Icon retryIcon = new Icon(sketch, sketch.iconCenterX * 1.45, sketch.largeIconBottomY, sketch.largeIconSize, sketch.largeIconSize, sketch.loadImage("retryIconImage.png"), "Retry", true, "Below", "_sendTweet");
        Icon shareImageToDeviceAppsIcon = new Icon(sketch, sketch.iconCenterX, sketch.largeIconBottomY * 0.7, sketch.largeIconSize, sketch.largeIconSize, sketch.loadImage("shareImageToDeviceAppsImage.png"), "Share", true, "Below", "_shareImageToDeviceApps");

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
        this.addText("We're sorry :(", sketch.iconCenterX, sketch.appHeight * 0.1);
        this.addText("Your postcard", sketch.iconCenterX, sketch.appHeight * 0.18);
        this.addText("was not sent", sketch.iconCenterX, sketch.appHeight * 0.26);

        // Adding this screen's private shareUnsuccessfulScreen, using the addImage() method, as inherited from the
        // Rectangle class, so it will appear as part of this screen. Calculating the x, y, width and height
        // based on the current width and height of the device this app is running on.
        this.addImage(this.shareUnsuccessfulScreen, sketch.iconCenterX, sketch.appHeight * 0.4, sketch.appWidth * 0.5, sketch.appHeight * 0.16);

        // Checking if the image has been saved, before adding the following lines of text to the screen, using
        // the addText() method, as with the text above.
        if(this.imageSaved) {
            this.addText("But good news :)", sketch.iconCenterX, sketch.appHeight * 0.54);
            this.addText("We have still", sketch.iconCenterX, sketch.appHeight * 0.62);
            this.addText("saved it for you!", sketch.iconCenterX, sketch.appHeight * 0.7);
        }
    }
}