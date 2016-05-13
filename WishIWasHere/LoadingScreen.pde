// This class extends from the Screen class, which in turn extends from the Rectangle class, and so
// inherits methods and variables from both of these classes. This screen is displayed when the user
// comes back from logging in to Twitter, or chooses not to log in to Twitter. It acts as a welcome
// screen for the app.
public class LoadingScreen extends Screen {

    // Creating a private variable to store the instance of the main sketch which will be passed into
    // the constructors of this class when they are initialised. The purpose of this variable is so that
    // we can access the Processing library, along with other global methods and variables of the main
    // sketch class, from within this class. Every reference to a Processing method/variable, or a public
    // method/variable of the main sketch, must be prefixed with this object while within this class.
    private Sketch sketch;

    // Creating a private variable to store the image which will be displayed as part of this screen
    private PImage loadingScreenImage;

    // Creating a public constructor for the class so that an instance of it can be declared in the main sketch
    public LoadingScreen(Sketch _sketch) {

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

        // Initialising this class's private loadingScreenImage variable by loading the image in from the assets
        // folder, so that it can be displayd when this screen is called.
        loadingScreenImage = sketch.loadImage("loadingScreenImage.jpg");
    }

    // Creating a public showScreen method, which is called by the draw() funciton whenever this
    // screen needs to be displayed
    public void showScreen() {

        // Calling the super class's (Screen) drawScreen() method, to display each of this screen's icons.
        // This method will then in turn call it's super class's (Rectangle) method, to generate the screen.
        this.drawScreen();

        // Setting the image mode to center, so the image will appear centered on screen
        sketch.imageMode(sketch.CENTER);

        // Adding this screen's private loadingScreenImage, so it will appear as part of this screen. Calculating
        // the x, y, width and height based on the current width and height of the device this app is running on.
        sketch.image(this.loadingScreenImage, sketch.appWidth/2, sketch.appHeight/2, sketch.appWidth, sketch.appHeight);
    }
}