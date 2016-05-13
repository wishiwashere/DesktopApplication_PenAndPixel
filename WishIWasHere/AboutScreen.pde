// This class extends from the Screen class, which in turn extends from the Rectangle class, and so
// inherits methods and variables from both of these classes. This screen is displayed when a user
// wants to read more about the app. This screen was a requirement based on the Google attribution
// requirements, which specify that their attribution must be clearly visible with a "legal" or "about"
// page, accessible from the main app.
public class AboutScreen extends Screen {

    // Creating a private variable to store the instance of the main sketch which will be passed into
    // the constructors of this class when they are initialised. The purpose of this variable is so that
    // we can access the Processing library, along with other global methods and variables of the main
    // sketch class, from within this class. Every reference to a Processing method/variable, or a public
    // method/variable of the main sketch, must be prefixed with this object while within this class.
    private Sketch sketch;

    // Creating a private string to contain the text we will display to briefly introduce us and our project
    private String aboutText = "We are 3rd Year Creative Multimedia students in Limerick Institute of Technology, Clonmel.\r\nWe have decided to design, create and build an application that will allow you to visit different locations around the world.\r\nOur aim is to make the world a little bit smaller, one click at a time. ";

    // Creating a private string to contain all of the attribution text we require for this screen. This
    // string will be initialised in the constructor of this screen, using the array declared below, so
    // that each line attribution will be displayed on it's own line.
    private String attributionText = "Attributions";

    // Creating a private array of Strings, so that attribution lines of text can easily be added/removed
    // from this screen as needed. This array will be used in the constructor of this class, to generate
    // the text which will be displayed on screen as one String.
    private String[] attributionTextLines ={
            "Laura Pigott, Copyright © 2016, www.pigottlaura.com",
            "Eiren McLoughlin, Copyright © 2016, eiren.projects.ie",
            "Google Maps Geolocation API, Copyright © 2016 , This program is licensed under a Creative Commons Attribution 3.0. It is attributed to Google Inc",
            "Google Street View Image API, Copyright © 2016 , This program is licensed under a Creative Commons Attribution 3.0. It is attributed to Google Inc",
            "Android Studio, Copyright © 2016 , This program is licensed under a Creative Commons Attribution 2.5 Generic. It is attributed to Google Inc and the Open Handset Alliance",
            "Ketai, Copyright © 2015, Licensed by Processing Foundation",
            "Processing, Copyright © 2004, Licensed by Processing Foundation",
            "Fabric.io, Copyright © 2016, Licensed by Twitter Inc"
    };

    // Creating a private boolean, which will be used to check if this page has be reloaded yet i.e.
    // so that when the user leaves this screen, it will be reset (using this class's resetScreen() method)
    // so that if the page was partially scrolled when they left it, it will reset when they come back to
    // this screen. Resetting this variable to false in the HomeScreen class.
    public Boolean loaded = false;

    /*-------------------------------------- Constructor() ------------------------------------------------*/

    // Creating a public constructor for the class so that an instance of it can be declared in the main sketch
    public AboutScreen(Sketch _sketch) {

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

        // Creating the icon/s for this screen, using locally scoped variables, as these icons will be only
        // ever be referred to from the allIcons array. Setting their x, and y, based on percentages of the
        // width and height (where icon positioning variables are used, these were defined in the main sketch.
        // Not passing in any width or height, so as to allow this icon to be set to the default size in the
        // Icon class of the app. Passing in a name for the icon, followed by a boolean to choose whether this
        // name should be displayed on the icon or not. Finally, passing in a linkTo value of the name of the
        // screen or function they will later link to.
        Icon homeIcon = new Icon(sketch, sketch.iconRightX, sketch.iconTopY, sketch.loadImage("homeIconImage.png"), "Home", false, "HomeScreen");
        Icon facebookIcon = new Icon(sketch, sketch.appWidth * 0.2, sketch.iconBottomY, sketch.loadImage("facebookAccountIconImage.png"), "Facebook", false, "https://www.facebook.com/wishiwashereapp");
        Icon twitterIcon = new Icon(sketch, sketch.appWidth * 0.5, sketch.iconBottomY, sketch.loadImage("twitterAccountIconImage.png"), "Twitter", false, "https://twitter.com/wishiwashere");
        Icon instagramIcon = new Icon(sketch, sketch.appWidth * 0.8, sketch.iconBottomY, sketch.loadImage("instagramAccountIconImage.png"), "Instagram", false, "https://www.instagram.com/wishiwashereapp/");

        // Creating a temporary allIcons array to store the icon/s we have created above, so that they can
        // be passed to the super class (Screen) to be stored as this screen's icons.
        Icon[] allIcons = {homeIcon, facebookIcon, twitterIcon, instagramIcon};

        // Calling the setScreenIcons() method of this screen's super class (Screen). This passes
        // the temporary allIcons array to the screenIcons array of the Screen class so that they
        // can be looped through by the showScreen() method, and methods inherited from the Icon
        // class (such as showIcon and checkMouseOver) can be called on them from within this array.
        // This reduces the need for each screen to have to loop through it's icons, or call the
        // same method on multiple icons.
        this.setScreenIcons(allIcons);

        // Setting the title of this screen in this class's super class (Screen), so that it can be accessed
        // when showing the screen (i.e can be displayed as the header text of the page).
        this.setScreenTitle("About");

        // Looping through all of the lines of attribution text, so that they can all be stored in the
        // one String variable (attributionText) to be added to the screen as text in the showScree()
        // method of this class.
        for (int i = 0; i < attributionTextLines.length; i++){

            // Concatenating this line of attribution text, to the attributionText variable, along with
            // the string delimiters for "return" and "new line" so that each line of text will be displayed
            // on it's own line.
            this.attributionText +=  "\r\n\r\n" + attributionTextLines[i];
        }
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

        // Adding the team image, using the addImage() method, as inherited from the Rectangle class through the
        // Screen class. Passing in the image, x, y, width and height
        this.addImage(sketch.loadImage("aboutPageTeamImage.jpg"), sketch.appWidth / 2, this.getY() + (sketch.appHeight * -0.25), sketch.appWidth * 0.7, sketch.appHeight * 0.2);

        // Adding the about text, using the addTextBox() method, as inherited from the Rectangle class through the
        // Screen class. Passing in the text, x1, y1, x2, y2, horizontal text alignment and vertical text alignment.
        // x1 and y1 will determine where the top left corner of the text box will be positioned, while x2 and y2
        // will determine where the bottom left corner of the text box will be positioned.
        this.addTextBox(this.aboutText, sketch.appWidth * 0.1, this.getY() + (sketch.appHeight * -0.1), sketch.appWidth * 0.95, sketch.appHeight * 0.9, sketch.LEFT, sketch.TOP);

        // Adding the about text, using the addTextBox() method, as inherited from the Rectangle class through the
        // Screen class. Passing in the text, x1, y1, x2, y2, horizontal text alignment and vertical text alignment.
        // x1 and y1 will determine where the top left corner of the text box will be positioned, while x2 and y2
        // will determine where the bottom left corner of the text box will be positioned.
        this.addTextBox(this.attributionText, sketch.appWidth * 0.1, this.getY() + (sketch.appHeight * 0.48), sketch.appWidth * 0.95, sketch.appHeight * 1.6, sketch.LEFT, sketch.TOP);

        // Checking if the page is being scrolled
        if (sketch.mousePressed) {
            if(sketch.mouseClicked && sketch.mouseY < sketch.iconTopY){
                resetScreen();
                sketch.mouseClicked = false;
            } else {
                // Calling the scrollScreen() method, as inherited from the Screen class, to scroll the elements on the screen
                this.scrollScreen();
            }
        }
    }

    // Private method to reset the positioning of the elements on the screen, either when the user leaves the
    // screen (in the HomeScreen class) or if the user reaches the top of the screen again
    private void resetScreen(){

        // Resetting the screenTitleY position to it's original value (as it may have been
        // incremented if the about screen was scrolled
        sketch.screenTitleY = sketch.iconTopY;

        // Resetting the screen to it's original position (i.e. centered vertically on the device screen)
        this.setY(sketch.appHeight / 2);

        // Resetting each of the screen icons individually, by accessing them from the screenIcons array
        // which this screen initialised in it's super class (Screen) when this screen was created.
        // Using global positioning values defined in the main Sketch class.
        this.getScreenIcons()[0].setY(sketch.iconTopY);
        this.getScreenIcons()[1].setY(sketch.iconBottomY);
        this.getScreenIcons()[2].setY(sketch.iconBottomY);
        this.getScreenIcons()[3].setY(sketch.iconBottomY);

        // Setting loaded to true. This value will be reset to false in the HomeScreen class, so that the
        // page will always be reset before a user views it again (incase they left the screen partially scrolled)
        this.loaded = true;
    }
}