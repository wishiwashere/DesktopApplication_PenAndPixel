// This class extends from the Rectangle class, and so inherits the methods and variables this class.
// This class acts as a super class for all screens in the app, and so they will all inherit the
// methods and variables from this class.
public class Screen extends Rectangle {

    // Creating a private variable to store the instance of the main sketch which will be passed into
    // the constructors of this class when they are initialised. The purpose of this variable is so that
    // we can access the Processing library, along with other global methods and variables of the main
    // sketch class, from within this class. Every reference to a Processing method/variable, or a public
    // method/variable of the main sketch, must be prefixed with this object while within this and all
    // other classes which extend from it.
    private Sketch sketch;

    // Declaring the screenIcons array, which will be used to store the
    // icons from each screen. This array will be initialised through the
    // setScreenIcons() method, where each screen will pass in an array
    // or the icons that are present on it's screen. The purpose of storing
    // this array within the Screen class, as opposed to in each instance's
    // own class, is that now we can deal with looping through, and calling
    // methods on multiple icons of a screen only when their screen is being
    // shown i.e. when showScreen() is being called
    private Icon[] screenIcons = {};

    // Creating and initialising the screenTitle property of the screen to be
    // equal to an empty string. Each instance of the Screen class can then
    // use the setScreenTitle() method to specify a custom title, which
    // will then be used as the header text on that instance of the screen.
    // If no title is specified, then header text will not be added to the
    // screen
    public String screenTitle = "";

  /*-------------------------------------- Constructor() ------------------------------------------------*/

    // Full Constructor
    // Creating a protected constructor for the Screen class, so that it can only be accessed by classes
    // which extend from this class
    protected Screen(Sketch _sketch) {

        // Calling this class's super class (Rectangle) to create a screen using the default settings i.e.
        // fullscreen, centered in the screen of the device. Also passing the instance of the Sketch class,
        // which was just passed to this constructor, so that the super class can also access the Processing
        // library, as well as the global methods and variables of the Sketch class.
        super(_sketch);

        // Initialising this class's local sketch variable, with the instance which was passed to the
        // constructor of this class. The purpose of this variable is so that we can access the Processing
        // library, along with other global methods and variables of the main sketch class, from within
        // this class. Every reference to a Processing method/variable, or a public method/variable of
        // the main sketch, must be prefixed with this object while within this class.
        sketch = _sketch;
    }

    /*-------------------------------------- drawScreen() ------------------------------------------------*/
    // Creating a public method so that this screen can be displayed from within the main sketch
    public void drawScreen() {

        // Calling the show() method (as inherited from the Rectangle class) to display this screen
        this.show();

        // Checking if this screen has been given a title (i.e. if the contents of the screenTitle has been set
        if (this.screenTitle.length() > 0) {
            // Setting the fill to black, so that the text will be black
            sketch.fill(0);

            // Using the addText() method (as inherited from the Rectangle class) to add this title to the screen.
            // Calculating the positioning and text size of this title based on the size of the device on which
            // it is being displayed, as well as through global variables declared in the main Sketch class.
            this.addText(this.screenTitle, sketch.appWidth / 2, sketch.screenTitleY, sketch.screenTitleTextSize);
        }

        // Checking if this screen has any icons to be displayed
        if (this.screenIcons.length > 0) {

            // Looping through each of the screen's icons
            for (int i = 0; i < this.screenIcons.length; i++) {

                // Checking if the user is currently on the CameraLiveViewScreen, or the CameraPreviewScreen as icons on this screen
                // will be rotated based on the device's orientation
                if(sketch.currentScreen.equals("CameraLiveViewScreen") || sketch.currentScreen.equals("ImagePreviewScreen")){

                    // Setting the rotation of this icon to be equal to the global deviceOrientation variable,
                    // which is updated within the onAccelerometerEvent() method of the main Sketch class
                    this.screenIcons[i].setRotation(sketch.deviceOrientation);
                } else {

                    // If the user is not on the CameraLiveViewScreen or the CameraPreviewScreen, resetting all icons rotations to 0
                    this.screenIcons[i].setRotation(0);
                }

                // Calling the showIcon() method (as inherited from the Icon class) to display the icon on screen
                this.screenIcons[i].showIcon();

                // Checking if the mouse is currently clicked i.e. if a click has been detected
                if (sketch.mouseClicked) {
                    // Calling the checkMouseOver() method (as inherited from the Icon class, to see if the mouse
                    // was over this icon when it was clicked
                    this.screenIcons[i].checkMouseOver();
                }
            }
        }
    }

    /*-------------------------------------- scrollScreen() ------------------------------------------------*/
    // Creating a protected method for scrolling the screen, and the elements within it, so that only classes
    // which are descendants of this class, can access it.
    protected float scrollScreen() {

        // Setting the global mouseClicked variable, as defined in the main Sketch class, to false, so that
        // while the user is scrolling, the cannot inadvertently click on an icon on the screen if they scroll
        // over it.
        sketch.mouseClicked = false;

        // Calculating the amount scrolled, based on the distance between the previous y position,
        // and the current y position. Not accounting for the x position (which is being defaulted
        // to 0) as this is irrelevant when scrolling up/down the screen)
        float amountScrolled = dist(0, sketch.pmouseY, 0, sketch.mouseY);

        // Looping through each of the screen's icons, which the screen would have passed to this class
        // when the screen was first created
        for (int i = 0; i < this.screenIcons.length; i++) {

            // Checking which direction the user scrolled, based on the previous and current Y positions
            if (sketch.pmouseY > sketch.mouseY) {
                // The user has scrolled UP

                // Setting the y position of the icon to it's current position, minus the amount scrolled i.e.
                // moving the icon up the screen
                this.screenIcons[i].setY(this.screenIcons[i].getY() - amountScrolled);
            } else {
                // The user has scrolled DOWN

                // Checking if the screen's y position is less than or equal to half of the height, minus the amount
                // scrolled i.e. so that the screen cannot be scrolled down any further once you reach the top
                if (this.getY() <= (sketch.appHeight / 2) - amountScrolled) {

                    // Setting the y position of the icon to it's current position, plus the amount scrolled i.e.
                    // moving the icon down the screen
                    this.screenIcons[i].setY(this.screenIcons[i].getY() + amountScrolled);
                }
            }
        }

        // Checking which direction the user scrolled (the reason we have to do this separately from above is
        // that including these lines within the icons loop above makes these elements move faster than the
        // page icons
        if (sketch.pmouseY > sketch.mouseY) {
            // The user has scrolled UP

            // Setting the screen's y position to it's current y position, minus the amount scrolled i.e. moving
            // the screen up
            this.setY(this.getY() - amountScrolled);

            // Setting the global positioning variable screenTitleY to be decremented by the amount scrolled. Note:
            // this variable gets reset everytime the page is changed (in the HomeScreen class)
            sketch.screenTitleY -= amountScrolled;
        } else {
            // The user has scrolled DOWN

            // Checking if the screen's y position is less than or equal to half of the height minus the amount
            // scrolled i.e. so that the screen cannot be scrolled down any further once you reach the top
            if (this.getY() <= (sketch.appHeight / 2) - amountScrolled) {

                // Setting the screen's y position to it's current y position, plus the amount scrolled i.e. moving
                // the screen down
                this.setY(this.getY() + amountScrolled);

                // Setting the global positioning variable screenTitleY to be incremented by the amount scrolled. Note:
                // this variable gets reset everytime the page is changed (in the Icon class's checkMouseOver function, when
                // an icon's link is passed in to change a page)
                sketch.screenTitleY += amountScrolled;
            }
        }

        // Returning the amount scrolled from this function, so that the screen which called it can use this value to
        // move other unique elements on it's screen based on the same amount
        return amountScrolled;
    }

  /*-------------------------------------- get() and set() ------------------------------------------------*/

    // Protected set method to change the screen title, which can only be called by descendants of this class
    protected void setScreenTitle(String title) {
        this.screenTitle = title;
    }

    // Protected get method which returns the array containing all of the icons belonging to this screen, which can
    // only be called by descendants of this class
    protected Icon[] getScreenIcons() {
        return this.screenIcons;
    }

    // Protected set method which sets this screen's icons array to containing all of the icons belonging to this screen,
    // which can only be called by descendants of this class. Each screen that contains icons will call this method when
    // their constructor has been called.
    protected void setScreenIcons(Icon[] icons) {
        this.screenIcons = icons;
    }
}