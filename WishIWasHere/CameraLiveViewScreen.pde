// This class extends from the Screen class, which in turn extends from the Rectangle class, and so
// inherits methods and variables from both of these classes. This screen is displayed when a user
// is viewing themselves in a location, and offers them to option to take a picture, save the location
// as a favourite, as well as functionalities specific to this screen (such as switching between cameras)
public class CameraLiveViewScreen extends Screen {

    // Creating a private variable to store the instance of the main sketch which will be passed into
    // the constructors of this class when they are initialised. The purpose of this variable is so that
    // we can access the Processing library, along with other global methods and variables of the main
    // sketch class, from within this class. Every reference to a Processing method/variable, or a public
    // method/variable of the main sketch, must be prefixed with this object while within this class.
    private Sketch sketch;

    // Declaring two of this screen's icons as public variables, as they will need to be accessible
    // from the main Sketch class, so that their images can be updated accordingly if/when their
    // status changes. Normally, screen icons are only declared within the constructor of the class, as
    // they will be passed to the super class (Screen) and stored there as the icons for this screen.
    // By changing the scope of these variables, they can now be stored as the screen icons, but still
    // directly accessible when needed.
    public Icon favIcon;
    public Icon shakeIcon;

    /*-------------------------------------- Constructor() ------------------------------------------------*/
    // Creating a public constructor for the class so that an instance of it can be declared in the main sketch
    public CameraLiveViewScreen(Sketch _sketch) {

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

        // Creating a temporary String variable, to store the path to the icon image which should
        // be displayed on the switchViewIconImage on this screen, when the sketch first loads.
        // This will depend on whether or not there are multiple cameras available on this device.
        String switchViewIconImage = sketch.ketaiCamera.getNumberOfCameras() > 1 ? "switchViewIconImage.png" : "switchViewIconDisabledImage.png";

        // Creating the icon/s for this screen, using a locally scoped variable for the home, shutter and
        // switchView icons, as these icons will be only ever be referred to from the allIcons array.
        // Initialising the two public icons which were declare earlier in this class, as they will be
        // accessible from all classes so their background images can be updated when needed.
        // Setting their x, and y, based on percentages of the width and height (where icon positioning
        // variables are used, these were defined in the main sketch. Not passing in any width or height,
        // so as to allow this icon to be set to the default size in the Icon class of the app. Passing in
        // a name for the icon, followed by a boolean to choose whether this name should be displayed on
        // the icon or not. Finally, passing in a linkTo value of the name of the screen or function they
        // will later link to.
        Icon homeIcon = new Icon(sketch, sketch.iconRightX, sketch.iconTopY, sketch.loadImage("homeIconWhiteImage.png"), "Home", false, "HomeScreen");
        favIcon = new Icon(sketch, sketch.iconLeftX, sketch.iconTopY, sketch.loadImage("favIconImage.png"), "Add to Favourites", false, "_addToFavourites");
        shakeIcon = new Icon(sketch, sketch.iconLeftX, sketch.iconBottomY, sketch.loadImage("shakeIconOffImage.png"), "Turn on/off Shake", false, "_switchShakeMovement");
        Icon shutterIcon = new Icon(sketch, sketch.iconCenterX, sketch.iconBottomY, sketch.loadImage("shutterIconImage.png"), "Take a Picture", false, "_mergeImages");
        Icon switchViewIcon = new Icon(sketch, sketch.iconRightX, sketch.iconBottomY, sketch.loadImage(switchViewIconImage), "Switch View", false, "_switchCameraView");

        // Creating a temporary allIcons array to store the icon/s we have created above.
        Icon[] allIcons = {homeIcon, favIcon, shakeIcon, shutterIcon, switchViewIcon};

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

        // Checking if the mouse is pressed (i.e. the user wants to scroll around the background of this image)
        if (sketch.mousePressed) {

            // Calculating the amount scrolled on the x axis, based on the distance between the previous x position,
            // and the current x position, as well as the amount scrolled on the y axis based on the distance between
            // the previous y position and the current y position.
            float amountScrolledX = dist(0, sketch.pmouseX, 0, sketch.mouseX);
            float amountScrolledY = dist(0, sketch.pmouseY, 0, sketch.mouseY);

            // GENERAL NOTES ON HOW GOOGLE STREET VIEW IMAGE IS BEING PANNED
            // Heading refers to the left/right view of the image, between 0 and 360 degrees. Decrementing the googleImageHeading
            // by the amount scrolled on the relevant axis. Using a ternary operator to check that this will not
            // result in a value less than 0 or greater than 359 (the min/max values allowed for the heading of a Google
            // Street View image). If it does, then resetting the heading to the other end of the values, so the
            // user can continue turn around in that direction, otherwise allowing it to equal to the current heading
            // value minus/plus the amount scrolled on the relevant axis.
            // Pitch refers to the up/down view of the image, between -90 and 90 degrees. Incrementing the googleImagePitch
            // by the amount scrolled on the relevant axis. Using a ternary operator to check that this will not result in a
            // value less than -90 or greater than 90 (the min/max values allowed for the pitch). If it does, then stopping
            // the pitch at the min or max i.e. so the user cannot exceed these values, otherwise allowing it to equal to the
            // current pitch value minus/plus the amount scrolled on the relevant axis.
            // As the orientation of the device can change, determining which value to effect based on which axis below

            // Checking which direction the user has scrolled on the X axis based on the previous x position of the
            // mouse, in comparison with the current x position of the mouse.
            if (sketch.pmouseX > sketch.mouseX) {
                // The previous mouse X was further along than the current mouseX

                // Checking what the current orientation of the device is
                if(sketch.deviceOrientation == 90){
                    // Device is turned left - so the user wanted to scroll up
                    sketch.googleImagePitch = (sketch.googleImagePitch + amountScrolledX) > 90 ? 90 : sketch.googleImagePitch + amountScrolledX;

                    // Logging out the current pitch of the Google image (for TESTING purposes)
                    //println("Scrolled up. Device is turned left. Pitch is now " + sketch.googleImagePitch);

                } else if(sketch.deviceOrientation == -90){
                    // Device is turned right - so the user wanted to scroll down
                    sketch.googleImagePitch = (sketch.googleImagePitch - amountScrolledX) < -90 ? -90 : sketch.googleImagePitch - amountScrolledX;

                    // Logging out the current pitch of the Google image (for TESTING purposes)
                    //println("Scrolled down. Device is turned right. Pitch is now " + sketch.googleImagePitch);

                } else {
                    // Device is standing upright - so the user wanted to scroll right
                    sketch.googleImageHeading = (sketch.googleImageHeading + amountScrolledX) > 359 ? 0 : sketch.googleImageHeading + amountScrolledX;

                    // Logging out the current heading of the Google image (for TESTING purposes)
                    //println("Scrolled right. Device is upright. Heading is now " + googleImageHeading);
                }
            } else {
                // The previous mouse X is less than the current mouse X

                // Checking what the current orientation of the device is
                if(sketch.deviceOrientation == 90) {
                    // Device is turned left - so the user wanted to scroll down
                    sketch.googleImagePitch = (sketch.googleImagePitch - amountScrolledX) < -90 ? -90 : sketch.googleImagePitch - amountScrolledX;

                    // Logging out the current pitch of the Google image (for TESTING purposes)
                    //println("Scrolled down. Device is turned left. Pitch is now " + sketch.googleImagePitch);

                } else if(sketch.deviceOrientation == -90) {
                    // Device is turned right - so the user wanted to scroll up
                    sketch.googleImagePitch = (sketch.googleImagePitch + amountScrolledX) > 90 ? 90 : sketch.googleImagePitch + amountScrolledX;

                    // Logging out the current pitch of the Google image (for TESTING purposes)
                    //println("Scrolled up. Device is turned right. Pitch is now " + sketch.googleImagePitch);

                } else {
                    // Device is standing upright - so the user wanted to scroll left
                    sketch.googleImageHeading = (sketch.googleImageHeading - amountScrolledX) < 0 ? 359 : sketch.googleImageHeading - amountScrolledX;

                    // Logging out the current heading of the Google image (for TESTING purposes)
                    //println("Scrolled left. Device is upright. Heading is now " + sketch.googleImageHeading);
                }
            }

            // Checking if shakeMovementOn is currently false, because when shake movement is activated, the user will
            // not be controlling the pitch of the Google image by scrolling, but instead by moving their device around
            // to look "up" and "down".
            if(sketch.shakeMovementOn == false) {

                // Checking which direction the user has scrolled on the Y axis based on the previous y position of the
                // mouse, in comparison with the current y position of the mouse.
                if (sketch.pmouseY > sketch.mouseY) {
                    // The previous mouse Y was further along than the current mouse Y

                    // Checking what the current orientation of the device is
                    if(sketch.deviceOrientation == 90) {
                        // Device is turned left - so the user wanted to scroll left
                        sketch.googleImageHeading = (sketch.googleImageHeading + amountScrolledY) > 359 ? 0 : sketch.googleImageHeading + amountScrolledY;

                        // Logging out the current heading of the Google image (for TESTING purposes)
                        //println("Scrolled left. Device is turned left. Heading is now " + sketch.googleImageHeading);

                    } else if(sketch.deviceOrientation == -90) {
                        // Device is turned right - so the user wanted to scroll right
                        sketch.googleImageHeading = (sketch.googleImageHeading - amountScrolledY) < 0 ? 359 : sketch.googleImageHeading - amountScrolledY;

                        // Logging out the current heading of the Google image (for TESTING purposes)
                        //println("Scrolled right. Device is turned right. Heading is now " + sketch.googleImageHeading);

                    } else {
                        // Device is standing upright - so the user wanted to scroll up
                        sketch.googleImagePitch = (sketch.googleImagePitch - amountScrolledY) < -90 ? -90 : sketch.googleImagePitch - amountScrolledY;

                        // Logging out the current pitch of the Google image (for TESTING purposes)
                        //println("Scrolled up. Device is upright. Pitch is now " + sketch.googleImagePitch);

                    }
                } else {
                    // The previous mouse Y is less than the current mouse Y

                    // Checking what the current orientation of the device is
                    if(sketch.deviceOrientation == 90) {
                        // Device is turned left - so the user wanted to scroll right
                        sketch.googleImageHeading = (sketch.googleImageHeading - amountScrolledY) < 0 ? 359 : sketch.googleImageHeading - amountScrolledY;

                        // Logging out the current heading of the Google image (for TESTING purposes)
                        //println("Scrolled right. Device is turned left. Heading is now " + sketch.googleImageHeading);

                    } else if(sketch.deviceOrientation == -90) {
                        // Device is turned right - so the user wanted to scroll left
                        sketch.googleImageHeading = (sketch.googleImageHeading + amountScrolledY) > 359 ? 0 : sketch.googleImageHeading + amountScrolledY;

                        // Logging out the current heading of the Google image (for TESTING purposes)
                        //println("Scrolled left. Device is turned right. Heading is now " + sketch.googleImageHeading);

                    } else {
                        // Device is standing upright - so the user wanted to scroll down
                        sketch.googleImagePitch = (sketch.googleImagePitch + amountScrolledY) > 90 ? 90 : sketch.googleImagePitch + amountScrolledY;

                        // Logging out the current pitch of the Google image (for TESTING purposes)
                        //println("Scrolled down. Device is upright. Pitch is now " + sketch.googleImagePitch);
                    }
                }

                // Calling the loadGoogleImage method from the main Sketch class, so that a new google image will be
                // loaded in, with the new heading and pitch values specified above. The call to this function only
                // occurs within this class when the global shakeMovementOn variable is false, as otherwise the user
                // will be moving around the location using their device's accelerometer, and the loadGoogleImage()
                // method will be called from there instead (as it will need to be called more frequently)
                sketch.loadGoogleImage();
            }
        }

        // Adding the currentLocationImage to the CameraLiveViewScreen, so that the user can feel like they are taking a picture
        // in that location. Passing in the currentLocationImage, as sourced from the Google Street View Image API, using the
        // location specified by the user. Setting the rotation of this image to be equal to the orientationRotation of the
        // app, so that the image will be rotated based on which way the user is holding the device, so users can take pictures
        // in both landscape and portrait.
        this.addImage(sketch.currentLocationImage, sketch.googleImageWidth, sketch.googleImageHeight, sketch.deviceOrientation);

        // Adding the current keyed image to the CameraLiveViewScreen, so that the user can see themselves in the location added
        // above. Setting the scaleX of this image to be equal to the cameraScale, which accounts for and corrects the way in which
        // front facing cameras read in images in reverse (so they no longer appear reversed). Setting the rotation of this image
        // to be equal to the cameraRotation, which accounts for and corrects the way in which ketaiCamera reads in images, so the
        // image appears in the correct orientation.
        this.addImage(sketch.currentImage, sketch.appHeight, sketch.appWidth, sketch.cameraScale, sketch.cameraRotation);

        // Calling the super class's (Screen) drawScreen() method, to display each of this screen's icons.
        // This method will then in turn call it's super class's (Rectangle) method, to generate the screen. Calling this
        // method after the Google street view image, and the keyed image have been added to the sketch, so that the icons
        // of this screen will appear on top of these images.
        this.drawScreen();
    }

    // Private switchCameraView method, which allows users to switch between cameras on their device, using the icon on screen
    public void switchCameraView()
    {
        // Resetting the global callFunction variable, which was used to trigger this function, to and empty
        // string, so that this function won't be called again
        sketch.callFunction = "";

        // Checking if the ketaiCamera is already running
        if (sketch.ketaiCamera.isStarted())
        {
            // Checking if the device has more than one camera. If it does we want to toggle between them
            if (sketch.ketaiCamera.getNumberOfCameras() > 1)
            {
                // Using a ternary operator to toggle between cameras i.e. 1 is the camera facing away from the user
                // while 0 is the camera facing the user
                sketch.camNum = sketch.camNum == 0 ? 1 : 0;

                // Toggle the image rotation value between a plus and a minus i.e. -90 and 90, so that the resulting
                // image from the ketaiCamera can be rotated appropriately for display on the CameraLiveViewScreen, as
                // well as when it is being added to the compiled image when they are merged
                sketch.cameraRotation *= -1;

                // Toggling the scale of the camera image between 1 and -1 (depending on if the camera
                // is front or rear facing) so that the image can be scaled appropriately to avoid the mirror image
                // that the camera facing the user produces by default
                sketch.cameraScale *= -1;

                // Stopping the ketaiCamera so that no new frames will be read in, switching to the camera specified
                // by the camNum, then restarting the camera
                sketch.ketaiCamera.stop();
                sketch.ketaiCamera.setCameraID(sketch.camNum);
                sketch.ketaiCamera.start();
            }
        }
    }
}