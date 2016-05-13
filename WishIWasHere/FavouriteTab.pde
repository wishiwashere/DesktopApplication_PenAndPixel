// This class extends from the ClickableElement class, which in turn extends from the Rectangle class, and so
// inherits methods and variables from both of these classes.
public class FavouriteTab extends ClickableElement {

    // Creating a private variable to store the instance of the main sketch which will be passed into
    // the constructors of this class when they are initialised. The purpose of this variable is so that
    // we can access the Processing library, along with other global methods and variables of the main
    // sketch class, from within this class. Every reference to a Processing method/variable, or a public
    // method/variable of the main sketch, must be prefixed with this object while within this class.
    private Sketch sketch;

    // Creating private variables to store the location data for this tab. The data in these variables
    // will be passed in to the googleImageLatLng, googleImageHeading, googleImagePitch and currentLocationName
    // variables in this class's showFavourite() method, if this tab is clicked on. The location name will be used
    // as text on the tab to show what location it links to.
    public String favLocationName;
    public String favLocationLatLng;
    public float favLocationHeading;
    public float favLocationPitch;

    /*-------------------------------------- Constructor ------------------------------------------------*/
    public FavouriteTab(Sketch _sketch, String name, String locationLatLng, float locationHeading, float locationPitch) {

        // Calling the super class (ClickableElement) constructor, passing in the required
        // x value (which is centered), and defaulting the y value to 0, as this will be reset
        // everytime the FavouriteScreen's resetScreen() method is called, setting a relative
        // width and height, and the title of the location (for printing to the console to let
        // us know which tab was clicked on when a click occurs).
        super(_sketch, _sketch.width/2, 0, _sketch.width * 0.65, _sketch.height * 0.17, name);

        // Initialising this class's local sketch variable, with the instance which was passed to the
        // constructor of this class. The purpose of this variable is so that we can access the Processing
        // library, along with other global methods and variables of the main sketch class, from within
        // this class. Every reference to a Processing method/variable, or a public method/variable of
        // the main sketch, must be prefixed with this object while within this class.
        sketch = _sketch;

        // Calling the Rectangle class's setBackgroundColor() method, which is inherited from the
        // Rectangle class, through the ClickableElement class, to set the background color of all
        // instances of the FavouriteTabs class to have a semi-transparent white background
        this.setBackgroundColor(sketch.color(255, 255, 255, 100));

        // Initialising the tab's variables to store the location data for this tab. The data in these variables
        // will be passed in to the googleImageLatLng, googleImageHeading, googleImagePitch and currentLocationName
        // variables in this class's showFavourite() method, if this tab is clicked on. The location name will be used
        // as text on the tab to show what location it links to.
        this.favLocationName = name;
        this.favLocationLatLng = locationLatLng;
        this.favLocationHeading = locationHeading;
        this.favLocationPitch = locationPitch;
    }

    public void showFavourite() {

        // Showing this tab (Using the super Rectangle class's method show())
        this.show();

        // Adding the title text to this tab (as specified in the tab's constructor)
        this.addText(this.favLocationName, this.getX(), this.getY(), this.getWidth() * 0.1);

        // Checking if the mouse has been clicked
        if (sketch.mouseClicked) {

            // Checking the mouse was over this tab when the click occurred by using the super class
            // ClickableElement's checkMouseOver() method
            if (this.checkMouseOver()){

                // Setting the global googleImage variables, which will be used to generate the request
                // URL for the Google Street View Image API in the main Sketch class, to be equal
                // to the location data of this favourite tab
                sketch.googleImageLatLng = this.favLocationLatLng;
                sketch.googleImageHeading = this.favLocationHeading;
                sketch.googleImagePitch = this.favLocationPitch;
                sketch.currentLocationName = this.favLocationName;

                // Calling the loadGoogleImage() method from the main Sketch class, to load in a new
                // street view image with the location data specified by this tab
                sketch.loadGoogleImage();
            }
        }
    }

    // Public get method for getting the name of this tab's location. This will be used in the
    // main sketch to check if a location is a favourite or not.
    public String getFavLocationName(){
        return favLocationName;
    }
}