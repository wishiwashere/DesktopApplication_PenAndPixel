// This class extends from the Screen class, which in turn extends from the Rectangle class, and so
// inherits methods and variables from both of these classes. This screen is displayed when a user
// returns to the home screen, and acts as the main navigation for the app i.e. users can choose to go
// to a random location, a specific location, view their favourites, read about the app or change their
// settings.
public class HomeScreen extends Screen {

    // Creating a private variable to store the instance of the main sketch which will be passed into
    // the constructors of this class when they are initialised. The purpose of this variable is so that
    // we can access the Processing library, along with other global methods and variables of the main
    // sketch class, from within this class. Every reference to a Processing method/variable, or a public
    // method/variable of the main sketch, must be prefixed with this object while within this class.
    private Sketch sketch;

    // Creating a public constructor for the class so that an instance of it can be declared in the main sketch
    public HomeScreen(Sketch _sketch) {

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
        Icon searchTravelIcon = new Icon(sketch, sketch.appWidth * 0.28, sketch.appHeight * 0.2, sketch.homeIconSize, sketch.homeIconSize, sketch.loadImage("searchPageIconImage.png"), "Search", true, "Below", "SearchScreen");
        Icon randomTravelIcon = new Icon(sketch, sketch.appWidth * 0.72, sketch.appHeight * 0.2, sketch.homeIconSize, sketch.homeIconSize, sketch.loadImage("randomPageIconImage.png"), "Random", true, "Below", "_getRandomLocation");
        Icon myFavouritesIcon = new Icon(sketch, sketch.appWidth * 0.28, sketch.appHeight * 0.5, sketch.homeIconSize, sketch.homeIconSize, sketch.loadImage("favouritesPageIconImage.png"), "My Favourites", true, "Below", "FavouritesScreen");
        Icon aboutIcon = new Icon(sketch, sketch.appWidth * 0.72, sketch.appHeight * 0.5, sketch.homeIconSize, sketch.homeIconSize, sketch.loadImage("aboutPageIconImage.png"), "About", true, "Below", "AboutScreen");
        Icon settingsIcon = new Icon(sketch, sketch.appWidth * 0.5, sketch.appHeight * 0.8, sketch.homeIconSize, sketch.homeIconSize, sketch.loadImage("settingsPageIconImage.png"), "Settings", true, "Below", "SettingsScreen");

        // Creating a temporary allIcons array to store the icon/s we have created above.
        Icon[] allIcons = {randomTravelIcon, searchTravelIcon, myFavouritesIcon, aboutIcon, settingsIcon};

        // Calling the setScreenIcons() method of this screen's super class (Screen). This passes
        // the temporary allIcons array to the screenIcons array of the Screen class so that they
        // can be looped through by the showScreen() method, and methods inherited from the Icon
        // class (such as showIcon and checkMouseOver) can be called on them from within this array.
        // This reduces the need for each screen to have to loop through it's icons, or call the
        // same method on multiple icons.
        this.setScreenIcons(allIcons);
    }

    // Creating a public showScreen method, which is called by the draw() function whenever this screen needs to be displayed
    public void showScreen() {

        // Calling the super class's (Screen) drawScreen() method, to display each of this screen's icons.
        // This method will then in turn call it's super class's (Rectangle) method, to generate the screen.
        this.drawScreen();

        // Resetting the About and Favourites screen's loaded values to false, so that the next time
        // they are opened they will reset to their original positions
        sketch.myAboutScreen.loaded = false;
        sketch.myFavouritesScreen.loaded = false;
    }
}