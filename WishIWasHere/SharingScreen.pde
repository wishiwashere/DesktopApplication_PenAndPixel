public class SharingScreen extends Screen {

    // Creating a private variable to store the image which will be displayed as part of this screen
    private PImage sharingScreenImage;

    // Creating a public constructor for the class so that an instance of it can be declared in the main sketch
    public SharingScreen() {

        super();

        // Initialising this class's private sharingScreenImage variable by loading the image in from the assets
        // folder, so that it can be displayd when this screen is called.
        sharingScreenImage = loadImage("sharingScreenImage.png");

        // Setting the title of this screen in this class's super class (Screen), so that it can be accessed
        // when showing the screen (i.e can be displayed as the header text of the page).
        this.setScreenTitle("Sharing...");
    }

    // Creating a public showScreen method, which is called by the draw() funciton whenever this
    // screen needs to be displayed
    public void showScreen() {

        // Calling the super class's (Screen) drawScreen() method, to display each of this screen's icons.
        // This method will then in turn call it's super class's (Rectangle) method, to generate the screen.
        this.drawScreen();

        // Adding this screen's private sharingScreenImage, using the addImage() method, as inherited from the
        // Rectangle class, so it will appear as part of this screen. Calculating the x, y, width and height
        // based on the current width and height of the device this app is running on.
        this.addImage(sharingScreenImage, appWidth/2, appHeight/2, appWidth * 0.8, appWidth * 0.4);
    }
}