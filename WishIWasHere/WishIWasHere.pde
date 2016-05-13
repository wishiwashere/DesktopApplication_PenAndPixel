// Importing the Twitter4J library (for sending tweets to Twitter using a users's account, if they have logged in with Twitter)
import twitter4j.*;
import twitter4j.conf.*;

// Importing the Java library (to create File objects, and ArrayList arrays)
import java.io.File;
import java.util.ArrayList;

/*-------------------------------------- Navigation/Status Variables -------------------------*/
// Setting the default screen to be the LoadingScreen, so that when the app is loaded,
// this is the first screen that is displayed. Since this global variable is available
// throughout the sketch (i.e. within all classes as well as the main sketch) we will
// use this variable to pass in the value of "iconLinkTo" when the icon is clicked on
// within the checkMouseOver() method of the ClickableElement class. The variable will
// then be tested against each of the potential screen names (in the this class's
// switchScreens() function) to decide which class should have the showScreen() method
// called on it i.e. (which screen should be displayed).
public String currentScreen = "LoadingScreen";

// Creating a string to store the name of the screen to which an icon should return the
// user to i.e. if the user has arrived at screen B from screen A, then clicking
// cancel on this screen should return them to screen A. They may also have come
// to this screen from screen C screen, in which case the cancel button should
// return them there. Defaulting this to be equal to the home screen. This variable will
// be used in the Icon class's showIcon() method, to determine which screen to return a
// user to, if the icon's link begins with a "-". This is a naming convention we created
// so that it is clearer which icons link to an as of yet undetermined screen.
public String returnTo = "HomeScreen";

// Creating a global variable, which any icon can use to pass the name of the function
// they link to. The value of this variable is set in the Icon class when an icon is clicked
// on, and it's iconLinkTo value begins with a "_". This is a naming convention we created
// so that it is clearer which icons link to screens and which link to functions.
public String callFunction = "";

// Creating a global variable, which can be used to determine if a user has clicked on an
// element. Using a custom variable to store this, as opposed to using the Processing mousePressed
// variable, as we want to differentiate between a mouse being clicked and a mouse being pressed
// (i.e. clicking or scrolling). This variable will be set to true when a mousePressed() event
// occurs, and then reset to false when a element identifies itself as having been clicked on,
// or when a scrolling event is detected.
public Boolean mouseClicked = false;

// Creating public booleans, to monitor which functionalities are currently turned on/off.
// If a user has autoSaveModeOn turned on, as defined by their user preferences, this boolean
// will be true. They can then toggle this functionality on/off in the Settings screen, to choose
// whether saving will be automatically enabled for all images.
// If a user has learningModeOn turned on, as defined by their user preferences, this boolean
// will be true. They can then toggle this functionality on/off in the Settings screen, to choose
// whether they want to see the learning mode suggestions when they use the app or not.
// If a user is logged in to Twitter, then sendToTwitterOn will be changed to true. If they
// then decided to disable/enable sending to Twitter for individual images (in SaveShareScreenA)
// then this boolean will toggle on/off.
// If a user has autoSaveModeOn turned on, then saveThisImageOn will also be set to true. If a user
// then wants to turn off saving for an individual image, they can toggle this functionality on/off
// in SaveShareScreenA, while not affecting their overall autoSaveModeOn setting. Images will only
// ever save to the device when saveThisImageOn is set to true, regardless of whether autoSaveMode
// is on or off (to allow the user to make individual choices for each image).
public Boolean autoSaveModeOn = true;
public Boolean learningModeOn = false;
public Boolean sendToTwitterOn = false;
public Boolean saveThisImageOn = true;

// Creating public booleans, which result screens (such as ShareSaveSuccessfulScreen) will use to
// determine which actions were successfully completed i.e. if the image was shared, saved or
// both. These variables will only ever be set to true when the action has completed successfully
// and reset to false when the user goes back to the CameraLiveViewScreen
public Boolean imageShared = false;
public Boolean imageSaved = false;

// Creating a private boolean, to detect whether an image merge is currently being completed
// i.e. so no new images will be read in from the device's camera, or sent to the removeGreenScreen()
// thread (to reduce the risk of the memory of the device becoming overloaded
private Boolean imageMerging = false;

// Creating a private boolean, to detect whether an image is currently being read in and keyed by
// the removeGreenScreen() thread i.e. so no new images will be read in from the device's camera,
// or sent to the removeGreenScreen() thread (to reduce the risk of the memory of the device becoming
// overloaded
private Boolean readingImage = false;

/*-------------------------------------- Text Inputs -----------------------------------------*/
// Creating two private variables, which will contain the TextInput object, as well as it's
// value, that is currently in focus. These variables are initialised within the TextInput
// class when an input has been clicked on
public TextInput currentTextInput = null;
public String currentTextInputValue = "";

// Creating a global boolean, to determine if the keyboard is required. This value is set to
// true within the TextInput class if a text input has been clicked on. While this value is
// set to true, the draw function will call the KetaiKeyboard .show() method, to trigger the
// device to display it's keyboard. Each time a mousePressed event occurs, this variable
// is reset to false, so that if a user clicks anywhere else on the screen, the keyboard
// will automatically close
public Boolean keyboardRequired = false;

/*-------------------------------------- XML Data --------------------------------------------*/
// Creating an array of random locations based on the random location XML file in the
// assets folder. Storing these in a separate XML file to the user preferences, so that
// even if a user deletes all of their favourite locations, there will still be random
// locations available to them.
// Each location has a latLng attribute, which represents the latitude
// and longitude of the location, a heading attribute which represents the left/right
// positioning of the view (between 0 and 360) and a pitch attribute which represents
// the up/down angle of the view (between -90 and 90).
// In the original Google Street View URL (from the browser) i.e. the Colosseum
// url was https://www.google.ie/maps/@41.8902646,12.4905161,3a,75y,90.81h,95.88t/data=!3m6!1e1!3m4!1sR8bILL5qdsO7_m5BHNdSvQ!2e0!7i13312!8i6656!6m1!1e1
// the first two numbers after the @ represent the latitude and longitude, the number
// with the h after it represents the heading, and the number with the t after it
// seems to be to do with the pitch, but never works that way in this
// method so I just decided the pitch value based on what looks good
private XML[] randomLocations;

// Creating a variable to store the full XML which will be read in from the user_preferences.xml file
// so that it can later be resaved/reloaded as needed
private XML userPreferencesXML;

// Creating an array to store the XML elements which contain the favourite locations of the user, as
// sourced from the userPreferencesXML data which will be stored in the variable above
public XML[] favouriteLocationsData;

// Creating an array to store the XML elements which contain the settings of the user, such as autosaveModeOn,
// as sourced from the userPreferencesXML data which will be stored in the variable above
private XML[] settingsData;

/*-------------------------------------- Ketai Camera ----------------------------------------*/
// Creating a global variable to store the ketaiCamera object, so that we can access the live stream
// of images coming in from the device camera. The images from this camera will never be displayed
// in the app, but will instead be passed to the removeGreenScree() method, so any green
// background can be removed so the user can see themselves as if they are in the current location
public KetaiCamera ketaiCamera;

// Creating a global variable to store the number (identifier) of the device camera we want to view
// at any given time. The front facing camera (on a device with more than one camera)
// will be at index 1, and the rear camera will be at index 0. On a device with only
// 1 camera (such as the college Nexus tablets) this camera will always be at index
// 0, regardless of whether it is a front or back camera
public int camNum;

// Creating a variable to store a value of 1 or -1, to decide whether and image should be
// flipped i.e. when using the front facing camera, the x scale should always be -1 to
// avoid things being in reverse
public int cameraScale = -1;

// Creating a global variable, which will always be set to either 90 or -90 degrees, to ensure
// that the live stream images from the camera area always oriented in the right rotation.
// Initialising at -90 degrees, as we will be starting on the front facing camera
public int cameraRotation = -90;

/*-------------------------------------- KetaiSensor -----------------------------------------*/
// Declaring an instance of the ketaiSensore class, so that we can later access the sensors
// of this device i.e. the accelerometer.
private KetaiSensor sensor;

// Creating a public boolean to detect whether shakeMovementOn is enabled or not. When this functionality
// is enabled, the user can use the accelerometer in the device "look up and down" within the
// camera live view screen (in fact, they are just updating the heading and pitch values and then
// requests are being sent to the Google Street View Image API to request new images, so as to imitate
// the ability to "look around" them.
public Boolean shakeMovementOn = false;

// Creating a variable to store the current rotation of the device, based on the readings from
// the device's accelerometer
public int deviceOrientation = 0;

/*----------------------------------- Twitter ------------------------------------------------*/
// Creating variables to store the API keys required for accessing the Twitter API.
// Setting the Twitter consumer key and Twitter consumer secret key to be equal to our
// developer keys. Setting the Twitter access token, and access secret token to be equal
// to the user's tokens, as defined when they logged in using the TwitterLoginActivity.
// If the user has not logged in, then these will merely be equal to empty strings, but
// as the option to send the image to Twitter will not be available to them, this will
// never be an issue.
private String twitterOAuthConsumerKey = "huoLN2BllLtOzezay2ei07bzo";
private String twitterOAuthConsumerSecret = "k2OgK1XmjHLBMBRdM9KKyu86GS8wdIsv9Wbk9QOdzObXzHYsjb";
private String twitterOAuthAccessToken = TwitterLoginActivity.twitterUserAccessToken;
private String twitterOAuthAccessTokenSecret = TwitterLoginActivity.twitterUserSecretToken;

// Creating a new instance of the Twitter configuration builder, which will later have the
// above API keys stored within it, so that it can be passed to the TwitterFactory to generate
// a new instance of the Twitter class.
private ConfigurationBuilder cb = new ConfigurationBuilder();

// Declaring an instance of the Twitter class, which will be generated by the TwitterFactory class,
// using the above API keys, which will have been setup on the configuration builder class. We
// will then use the twitter instance to update the user's status i.e. send tweets on the user's
// account (if they are logged in with Twitter)
private Twitter twitter;

/*-------------------------------------- Images ----------------------------------------------*/
// Loading in the general background image, which will be used to "wipe" the screen each time the
// switchScreens method is called. The purpose of this is that individual screens do not need to
// contain their own backgrounds, and thus reduces the load on memory.
private PImage generalPageBackgroundImage;

// Creating a public compiledImage variable, which will store the PImage graphic which contains
// the Google Street View image of the background, the keyed image of the user (from the currentImage,
// as declared below), and the "Wish I Was Here" overlay image, which can then be saved and/or shared.
// This image will also be displayed on the ImagePreviewScreen and the SaveShareScreenA screens.
public PImage compiledImage;

// Creating a global image variable, to store the currentImage. Currently, this is
// used to return the keyed image of the user from the removeGreenScreen() thread.
// It is then used on the CameraLiveViewScreen as an image ontop of the Google Street View
// image, and eventually is added to the compiled image to create the final image the user
// will save/send to Twitter
public PImage currentImage;

// Creating a private variable to pass the image from the Ketai Camera into the removeGreenScreen
// thread. The purpose of using this variable, instead of accessing the image directly from the
// Ketai Camera in the removeGreenScreen thread, is that accessing the pixel array of the camera
// seems to produce unexpected results i.e. distortions in the image
private PImage currentFrame;

/*-------------------------------------- Sizing ----------------------------------------------*/
// Declaring global variables, which will contain the width and height of the device's
// display, so that these values can be reused throughout all classes (i.e. to calculate
// more dynamic position/width/height's so that the interface responds to different
// screen sizes
public int appWidth;
public int appHeight;

// Declaring the icon positioning X and Y variables, which will be used globally to ensure that
// the icons on each page all line up with one another. These measurements will all be based on
// percentages of the app's display, and are initialised in the setup function of this sketch
public float iconLeftX;
public float iconRightX;
public float iconCenterX;
public float iconTopY;
public float iconBottomY;
public float iconCenterY;
public float largeIconBottomY;
public float screenTitleY;

// Declaring the icon sizing variables, which will be used globally to ensure that there will be
// consistency between the sizes of icons throughout the app. These measurements will all be based on
// percentages of the app's display, and are initialised in the setup function of this sketch
public float largeIconSize;
public float smallIconSize;
public float homeIconSize;

// Declaring the default text size variables, so that there will be consistency with the sizing
// of all text within the app
float defaultTextSize;
float screenTitleTextSize;

/*-------------------------------------- Screens ---------------------------------------------*/
// Declaring a new instance of each screen in the application, so that they can be accessed by the
// draw function to be displayed when needed. The FavouritesScreen and the AboutScreen have been
// declared as public, as they will need to be accessed from the HomeScreen class, to reset
// their "loaded" boolean to false, so the scrolling of the screens can be reset before the user
// views them again
private HomeScreen myHomeScreen;
private CameraLiveViewScreen myCameraLiveViewScreen;
public FavouritesScreen myFavouritesScreen;
private SettingsScreen mySettingsScreen;
public AboutScreen myAboutScreen;
private SearchScreen mySearchScreen;
private SearchUnsuccessfulScreen mySearchUnsuccessfulScreen;
private ImagePreviewScreen myImagePreviewScreen;
private SaveShareScreenA mySaveShareScreenA;
private SaveShareScreenB mySaveShareScreenB;
private SharingScreen mySharingScreen;
private ShareSaveSuccessfulScreen myShareSaveSuccessfulScreen;
private ShareUnsuccessfulScreen myShareUnsuccessfulScreen;
private ShareSaveUnsuccessfulScreen myShareSaveUnsuccessfulScreen;
private SearchingScreen mySearchingScreen;
private SocialMediaLogoutScreen mySocialMediaLogoutScreen;
private LoadingScreen myLoadingScreen;


/*-------------------------------------- Saving ------------------------------------------------*/
// Creating a string that will hold the directory path of where the images will be saved to on the
// device's external storage
private String directory = "";

// Creating a string to store the full path, including the directory (declared above) and the
// filename of the most recent image. This path can then be used either to load the image back
// in to attach it as media for a tweet (to send it out to Twitter) or to create a sharing
// intent (so that the user can share the image with another app on their device).
private String saveToPath;

/*-------------------------------------- Google Street View Images ---------------------------*/
// Creating a variable to store the API keys required for accessing the Google Street View Image API,
// and the Google Geocoding API. Setting the key to be equal to our Google Developer browers developer key.
private String googleBrowserApiKey = "AIzaSyB1t0zfCZYiYe_xXJQhkILcXnfxrnUdUyA";

// Creating a String variable, to store the input value of the text box on the SearchScreen
private String searchAddress;

// Creating a string to store the searchAddress (as defined above) in the format required to add it
// as a parameter to the request URL for the Google Geocoding API, which allows us to search for an address
// and receive an XML response containing the relevant location details (latitude, longitude etc) so that
// we can then use these to request a new image from the Google Street View Image API
private String compiledSearchAddress;

// Creating the global googleImage variables, which will be used to generate the request
// URLs for the Google Geocoding API and the Google Street View Image API. Each location
// has a latLng attribute, which represents the latitude and longitude of the location,
// a heading attribute which represents the left/right positioning of the view (between
// 0 and 360) and a pitch attribute which represents the up/down angle of the view
// (between -90 and 90).
// In the original Google Street View URL (from the browser) i.e. the Colosseum
// url was https://www.google.ie/maps/@41.8902646,12.4905161,3a,75y,90.81h,95.88t/
// data=!3m6!1e1!3m4!1sR8bILL5qdsO7_m5BHNdSvQ!2e0!7i13312!8i6656!6m1!1e1
// the first two numbers after the @ represent the latitude and longitude, the number
// with the h after it represents the heading, and the number with the t after it
// seems to be to do with the pitch, but never works that way in this
// method so I just decided the pitch value based on what looks good
public String currentLocationName = "";
public String googleImageLatLng;
public float googleImagePitch;
public float googleImageHeading;
public int googleImageWidth;
public int googleImageHeight;

// Declaring the currentLocationImage variable, which will be initialised by loading in an image
// from a request to the Google Street View Image API, using the location data held in the variables
// above. It is then used on the CameraLiveViewScreen as an image below of the keyed image of the
// user (currentImage), and eventually is added to the compiled image to create the final image the user
// will save/send to Twitter
public PImage currentLocationImage = null;


/*-------------------------------------- Setup() ---------------------------------------------*/
public void setup() {
  // Setting the size of this sketch to be fullscreen, so that it will be responsive to the size
  // of the device it is running on
  fullScreen();

  // Locking the applications orientation to portrait, so that the image being read in from the
  // the camera is maintained, even when the device is rotated
  orientation(PORTRAIT);

  // Initialising the appWidth and appHeight variable with the width and height of the device's
  // display, so that these values can be reused throughout all classes (i.e. to calculate
  // more dynamic position/width/height's so that the interface responds to different
  // screen sizes
  appWidth = width;
  appHeight = height;

  println("Main Sketch is being reset");
  /*---------------------------------- XML Data --------------------------------------------*/
  // Initialising the array of random locations based on the random location XML file from our
  // GitHub.io site, so that we can update the random locations for all apps, without having to
  // create a new release for the app. Storing these in a separate XML file to the user preferences,
  // so that even if a user deletes all of their favourite locations, there will still be random
  // locations available to them.
  randomLocations = loadXML("https://wishiwashere.github.io/random_locations.xml").getChildren("location");

  // Loading in the user's preferences by calling this class's loadUserPreferencesXML() method, as this
  // process will need to be completed multiple times later on in the app (i.e. to save/delete favourite
  // locations, update settings such as autosave mode etc.
  loadUserPreferencesXML();

  /*---------------------------------- Ketai Camera ----------------------------------------*/
  // Calling the ketaiCamera constructor to initialise the camera with the same
  // width/height of the device, with a frame rate of 24.
  ketaiCamera = new KetaiCamera(this, appWidth, appHeight, 24);

  println("KetaiCamera size is: - " + appWidth + " x " + appHeight);
  // Printing out the list of available cameras i.e. front/rear facing
  println(ketaiCamera.list());

  // Printing out the number of available cameras
  println("There are " + ketaiCamera.getNumberOfCameras() + " camera/s available on this device");

  // Checking if the device has more than one camera i.e. does it have a front and a rear facing camera?
  if (ketaiCamera.getNumberOfCameras() > 1) {
    // If there is more than one camera, then default to the front camera
    // (which exists at index 1, when there is more than 1 camera)
    camNum = 1;
  } else {
    // If there is only one camera, then default to that camera
    // (which exists at index 0)
    camNum = 0;
  }

  // Setting the camera to default to the front camera
  ketaiCamera.setCameraID(camNum);

  /*----------------------------------- Ketai Sensor ---------------------------------------*/
  // Initialising the Ketai Sensor, passing in an instance of the PApplet, so that we can access
  // the device's sensors
  sensor = new KetaiSensor(this);

  // Enabling the accelerometer of the device, so that we can use it to detect the device orientation
  // and to allow the user to "look up and down" in the CameraLiveViewScreen
  sensor.enableAccelerometer();

  // Starting the sensors that have been enabled (i.e. the accelerometer) so that the relevant
  // events will be triggered e.g. on
  // ometerEvent()
  sensor.start();

  /*----------------------------------- Twitter --------------------------------------------*/
  // Checking if the user has logged in to the app using their Twitter account, by accessing
  // the twitterLoggedIn static variable of the TwitterLoginActivity class
  if (TwitterLoginActivity.twitterLoggedIn) {

    // If a user is logged in to Twitter, then senToTwitterOn will be changed to true. If they
    // then decided to disable/enable sending to Twitter for individual images (in SaveShareScreenA)
    // then this boolean will toggle on/off.
    sendToTwitterOn = true;

    // Setting the Twitter OAuth Consumer keys to our applications credentials, as sourced from
    // our Twitter developer account
    cb.setOAuthConsumerKey(twitterOAuthConsumerKey);
    cb.setOAuthConsumerSecret(twitterOAuthConsumerSecret);

    // Setting the oAuth Access tokens to be equal to those supplied by the user when they logged
    // into Twitter in the TwitterLoginActivity
    cb.setOAuthAccessToken(twitterOAuthAccessToken);
    cb.setOAuthAccessTokenSecret(twitterOAuthAccessTokenSecret);

    // Initialising a new instance of the Twitter class, by passing the configuration builder,
    // which has been set up with the relevant API keys, to the TwitterFactory class. We
    // will then use the twitter instance to update the user's status i.e. send tweets on the user's
    // account (if they are logged in with Twitter)
    twitter = new TwitterFactory(cb.build()).getInstance();
  }

  /*----------------------------------- Images ---------------------------------------------*/

  // Loading in the general background image, which will be used to "wipe" the screen each time the
  // switchScreens method is called. The purpose of this is that individual screens do not need to contain
  // their own backgrounds, and thus reduces the load on memory.
  generalPageBackgroundImage = loadImage("generalPageBackgroundImage.png");

  // Initialising the currentImage to be equal to a plain black image. This is so that if the
  // currentImage get's referred to before the camera has started, it will just contain a plain
  // black screen. Creating this black image by using createImage to make it the full size
  // of the screen, and then setting each pixel in the image to black. This image will be
  // used to return the keyed image of the user from the removeGreenScreen() thread.
  // It is then used on the CameraLiveViewScreen as an image ontop of the Google Street View
  // image, and eventually is added to the compiled image to create the final image the user
  // will save/send to Twitter
  currentImage = createImage(appWidth, appHeight, RGB);
  currentImage.loadPixels();
  for (int i = 0; i < currentImage.pixels.length; i++) {
    // Setting every pixel of the image to be transparent
    currentImage.pixels[i] = color(0, 0, 0, 0);
  }
  currentImage.updatePixels();

  /*---------------------------------- Sizing ----------------------------------------------*/
  // Initialising the icon positioning X and Y variables, which will be used globally to ensure that
  // the icons on each page all line up with one another. These measurements are all based on percentages
  // of the app's display width and height (as defined above)
  iconLeftX = (float) (appWidth * 0.15);
  iconRightX = (float) (appWidth * 0.85);
  iconCenterX = (float) (appWidth * 0.5);
  iconTopY = (float) (appHeight * 0.085);
  iconBottomY = (float) (appHeight * 0.87);
  iconCenterY = (float) (appHeight * 0.5);
  largeIconBottomY = iconBottomY - (largeIconSize / 2);
  screenTitleY = iconTopY;

  // Declaring the icon sizing variables, which will be used globally to ensure that there will be
  // consistency between the sizes of icons throughout the app. These measurements will all be based on
  // percentages of the app's display, and are initialised in the setup function of this sketch
  largeIconSize = (float) (appWidth * 0.25);
  smallIconSize = (float) (appWidth * 0.15);
  homeIconSize = (float) (largeIconSize * 1.3);

  // Declaring the default text size variables, so that there will be consistency with the sizing
  // of all text within the app
  defaultTextSize = (float) (appHeight * 0.032);
  screenTitleTextSize = (float) (appHeight * 0.07);

  /*---------------------------------- Screens ---------------------------------------------*/
  // Declaring a new instance of each screen in the application, so that they can be accessed by the
  // draw function to be displayed when needed. The FavouritesScreen and the AboutScreen have been
  // declared as public, as they will need to be accessed from the HomeScreen class, to reset
  // their "loaded" boolean to false, so the scrolling of the screens can be reset before the user
  // views them again. Passing the current instance of the Sketch class (this) to the constructors
  // of each screen, so that they can in turn pass it to their super class (Screen), which will
  // in turn pass it to it's super class (Rectangle). The purpose of this variable is so that
  // we can access the Processing library, along with other global methods and variables of the
  // main sketch class, from all other classes.
  myHomeScreen = new HomeScreen(this);
  myCameraLiveViewScreen = new CameraLiveViewScreen(this);
  myFavouritesScreen = new FavouritesScreen(this);
  mySettingsScreen = new SettingsScreen(this);
  myAboutScreen = new AboutScreen(this);
  mySearchScreen = new SearchScreen(this);
  mySearchUnsuccessfulScreen = new SearchUnsuccessfulScreen(this);
  myImagePreviewScreen = new ImagePreviewScreen(this);
  mySaveShareScreenA = new SaveShareScreenA(this);
  mySaveShareScreenB = new SaveShareScreenB(this);
  mySharingScreen = new SharingScreen(this);
  myShareSaveSuccessfulScreen = new ShareSaveSuccessfulScreen(this);
  myShareUnsuccessfulScreen = new ShareUnsuccessfulScreen(this);
  myShareSaveUnsuccessfulScreen = new ShareSaveUnsuccessfulScreen(this);
  mySearchingScreen = new SearchingScreen(this);
  mySocialMediaLogoutScreen = new SocialMediaLogoutScreen(this);
  myLoadingScreen = new LoadingScreen(this);

  /*---------------------------------- Saving ----------------------------------------------*/
  // Storing a string that tells the app where to store the images externally on the users device.
  // Using the Environment class to determine the path to the external storage directory, as well
  // as the Pictures directory, and then concatenating a name for a new directory ("WishIWasHere")
  // so that images saved from our app will be stored in their own folder.
  directory = Environment.getExternalStorageDirectory() + "/" + Environment.DIRECTORY_PICTURES + "/WishIWasHere/";

  // Creating a new File object, using the directory path specified above
  File wishIWasHereDirectory = new File(directory);

  // Checking if this directory already exists
  if (wishIWasHereDirectory.isDirectory() == false) {

    // Since the directory does not already exist, using the File mkdirs() method to create it
    wishIWasHereDirectory.mkdirs();

    println("New directory created - " + directory);
  } else {
    println("Directory already exists");
  }
}

/*-------------------------------------- Draw() ----------------------------------------------*/
public void draw() {
  // Clearing the background of the sketch by setting it to black
  background(0);

  // Calling the switchScreens() function to display the right screen by checking the
  // currentScreen variable and calling the showScreen() method on the appropriate screen.
  // The showScreen() method then calls the super class's (Screen) drawScreen() method,
  // which adds the icons and backgrounds to the screen. As each icon is displayed on each
  // call to it's showIcon() method, if a click occurs, it uses the checkMouseOver() method
  // it has inherited from the ClickableElement class, to see if the mouse was over it when
  // the click took place
  switchScreens();

  // Calling the checkFunctionCalls() method, to check if an icon in the sketch has requested
  // a function to be called. It does this by checking the callFunciton variable, and calling
  // the appropriate function if necessary.
  checkFunctionCalls();

  // Checking if the keyboard is required i.e. if a TextInput is currently in focus
  if (keyboardRequired) {
    KetaiKeyboard.show(this);
  } else {
    KetaiKeyboard.hide(this);
  }

  // Turning the camera on and off (if the current screen is the CameraLiveViewScreen and the
  // camera is not yet turned on, then start the camera, otherwise, if you are on any other screen,
  // stop the camera
  if (currentScreen.equals("CameraLiveViewScreen")) {
    if (!ketaiCamera.isStarted()) {
      ketaiCamera.start();
      println("Starting Ketai Camera");
    }
  } else {
    if (ketaiCamera.isStarted()) {
      ketaiCamera.stop();
      MainActivity.greenScreenWarning.cancel();
    }
  }

  // Forcing the onCameraPreviewEvent() to be called, as ketaiCamera does not seem to be
  // calling it implicitly (as it would have done in Processing).
  if (currentScreen.equals("CameraLiveViewScreen") && imageMerging == false) {
    onCameraPreviewEvent();
  }
}

/*-------------------------------------- mousePressed() --------------------------------------*/
public void mousePressed() {
  // Setting mouseClicked to true, so that clicks can be dealt with separate to scrolling events
  mouseClicked = true;

  // Resetting keyboardRequired to false, so that the device's keyboard will be hidden (so that
  // users can click anywhere on the screen to hide the keyboard
  keyboardRequired = false;
}

/*-------------------------------------- keyPressed() ----------------------------------------*/
public void keyPressed() {
  if (currentTextInput != null) {

    // Getting the current input value of this text input (i.e. so that if a user clicks between different
    // text fields, they can resume their input instead of the TextInput becoming empty)
    currentTextInputValue = currentTextInput.getInputValue();

    // Checking if the key pressed is a coded value i.e. backspace etc
    if (key == CODED) {
      //println(key);
      // Checking if the key pressed was the backspace key
      if (keyCode == 67) {
        // Checking that the length of the current currentTextInputValue string is greater than 0 (i.e.
        // if the string is empty, don't try to delete anything)
        if (currentTextInputValue.length() > 0) {
          //println("BACKSPACE");
          // Removing the last character from currentTextInputValue string, by creating a substring
          // of currentTextInputValue, that is one shorter than the current currentTextInputValue string
          currentTextInputValue = currentTextInputValue.substring(0, currentTextInputValue.length() - 1);
        }
      }
    } else {
      // This is a character key
      // Checking if the current length of the text in this TextInput exceeds it's maximum character length,
      // i.e. if this is the TextInput for adding a message to a tweet, then the maximum length will be set
      // to ensure that a user cannot exceed this
      if (currentTextInputValue.length() < currentTextInput.getMaxTextLength() - 1) {
        // Adding the character to currentTextInputValue string
        currentTextInputValue += key;
      } else {
        println("This text is too long");
      }
    }

    // Passing the currentTextInputValue string into the setInputValue of the currentTextInput field
    currentTextInput.setInputValue(currentTextInputValue);
  }
}

public void onStop() {
  ketaiCamera.stop();
  println("STOP - Sketch Stopped");
}

/*-------------------------------------- Ketai Camera ----------------------------------------*/
// Normally, this method would be implicitly called by the Ketai library, to alert the sketch
// of the availability of a new frame. For some reason, this is not happening in Android Studio,
// so instead explicitly calling this method from the draw() method in this class, only if we are
// on the CameraLiveViewScreen.
public void onCameraPreviewEvent() {

  // Checking if the Sketch is currently reading in and keying an image (as we only want to handle
  // one image at a time to avoid memory overload
  if (this.readingImage == false) {

    // Setting the readingImage variable to true so that no more images can be read in until
    // this one has been completed
    this.readingImage = true;

    // Adding a try/catch statement around the following, as loading in the image from the Ketai
    // camera, and then calling the removeGreenScreen thread, tends to cause a crash on it's first
    // attempt (because of the spike in memory, an out of memory error occurs). Once the first
    // frame has been keyed successfully, this no longer seems to occur, as the app will have
    // been allocated more memory.
    try {
      // Reading in the newest frame from the Ketai Camera
      ketaiCamera.read();

      // Getting the current image from the Ketai Camera and storing it in the currentFrame
      // variable, so that it can be read from within the removeGreenScreen thread. The purpose
      // of using this variable, instead of accessing the image directly from the Ketai Camera
      // in the removeGreenScreen thread, is that accessing the pixel array of the camera seems
      // to produce unexpected results i.e. distortions in the image
      currentFrame = ketaiCamera.get();

      // Calling the removeGreenScreen thread, to remove the green background from the current
      // frame of Ketai Camera, and pass it back to the sketch by setting currentImage to be
      // equal to it's contents
      thread("removeGreenScreen");
    } 
    catch (OutOfMemoryError e) {

      println("Unable to initiate the removeGreenScreen thread - " + e);

      // Resetting the readingImage variable to false, so that even if this frame was unsuccessful
      // in being keyed, the app can continue to try and read in more frames
      readingImage = false;
    }
  }
}

/*-------------------------------------- Ketai Sensor ----------------------------------------*/
// This event is implicitly called by the Ketai library every time an accelerometer event occurs
// i.e. every time the device moves
public void onAccelerometerEvent(float accelerometerX, float accelerometerY, float accelerometerZ) {

  // Checking if we are currently on the CameraLiveViewScreen, as we are not using the accelerometer
  // information on any other screen
  if (currentScreen.equals("CameraLiveViewScreen")) {

    // Creating a local boolean to determine if we need to load a new image in from Google, based
    // on whether the user has moved around their environment or not. Defaulting it to false,
    // to avoid loading in new images everytime the onAccelerometerEvent() is called
    Boolean newGoogleImageRequired = false;

    // Checking if shakeMovementOn is true i.e. has the user clicked the shakeMovementIcon, so that
    // they can now move their device to "look up and down" within the location they are currently
    // in
    if (shakeMovementOn) {

      // Checking if the device is standing upright, as we can only allow the user to use the shake
      // movement functionality when the device is standing upright due to restrictions with the
      // accelerometer
      if (deviceOrientation == 0) {
        // Device is upright

        // Setting the image pitch to be equal to the accelerometerZ value, mapped from a range
        // of 10 to -10, to a larger range of -90 to 90, as these are the maximum allowed values
        // for the pitch of a Google Street View
        googleImagePitch = map(round(accelerometerZ), 10, -10, -90, 90);

        // Since the user is using the shake movement functionality, a new image is required,
        // as they will be "looking around" the environment they are in, and so by loading in
        // new images with the imagePitch values specified above, they will feel like this is
        // a smooth transition, as opposed to a series of images
        newGoogleImageRequired = true;
      } else {
        // Device is in landscape mode

        if (shakeMovementOn) {
          // Turning off shake movement, as this functionality is not possible when the device
          // is turned sideways, due to restrictions in the accelerometer's ability to detect
          // the difference between the user being turned sideways, and trying to look up and
          // down around the image
          switchShakeMovement();
        }
      }
    }

    // Using modulus to slow down how often the following code is called (i.e. it will currently
    // be called on every 4th frame)
    if (frameCount % 4 == 0) {

      // Determining the orientation of the device based on the value
      // of it's accelerometer on the X axis
      if (accelerometerX > 7) {
        // The device is being turned to the left

        // Setting the device orientation to be 90 degrees, if it doesn't already equal this
        if (deviceOrientation != 90) {
          deviceOrientation = 90;
          // Since the device's orientation has changed, a new image is needed from Google,
          // so that it's aspect ratio will match that of the user's viewpoint
          newGoogleImageRequired = true;
          //MainActivity.greenScreenWarning.getView().setRotation(deviceOrientation);
          MainActivity.greenScreenWarning.getView().setAlpha(0);
        }
      } else if (accelerometerX < -7) {
        // The device is being turned to the right

        // Setting the device orientation to be -90 degrees, if it doesn't already equal this
        if (deviceOrientation != -90) {
          deviceOrientation = -90;
          // Since the device's orientation has changed, a new image is needed from Google,
          // so that it's aspect ratio will match that of the user's viewpoint
          newGoogleImageRequired = true;
          //MainActivity.greenScreenWarning.getView().setRotation(deviceOrientation);
          MainActivity.greenScreenWarning.getView().setAlpha(0);
        }
      } else {
        // The device is standing straight up

        // Setting the device orientation to be 0 degrees, if it doesn't already equal this
        if (deviceOrientation != 0) {
          deviceOrientation = 0;
          // Since the device's orientation has changed, a new image is needed from Google,
          // so that it's aspect ratio will match that of the user's viewpoint
          newGoogleImageRequired = true;
          //MainActivity.greenScreenWarning.getView().setRotation(deviceOrientation);
          MainActivity.greenScreenWarning.getView().setAlpha(1);
        }
      }

      if (newGoogleImageRequired) {
        // Calling the loadGoogleImage() method in a thread, to load in a new version of the
        // current location's image, with the relevant properties altered to reflect the new values assigned
        // above. Only loading in a new image if a change is required to the background of the
        // environment the user is viewing (i.e. through scrolling or accelerometer movement of the screen
        thread("loadGoogleImage");
      }
    }
  } else {
    if (shakeMovementOn) {
      // Since we are not currently on the CameraLiveViewScreen, resetting shakeMovementOn to false
      switchShakeMovement();
    }
  }
}

/*-------------------------------------- SwitchScreens() -------------------------------------*/
public void switchScreens() {
  // Adding the general background image. The purpose of this is that individual screens do not
  // need to contain their own backgrounds, and thus reduces the load on memory.
  image(generalPageBackgroundImage, appWidth / 2, appHeight / 2, appWidth, appHeight);

  // Checking if the String that is stored in the currentScreen variable
  // (which gets set in the ClickableElement class when an icon is clicked on) is
  // equal to a series of class Names (i.e. HomeScreen), and if it is, then show that screen.
  // The showScreen() method of the current screen needs to be called repeatedly,
  // as this is where additional functionality (such as checking of icons being
  // clicked on etc) are called.
  if (currentScreen.equals("HomeScreen")) {
    myHomeScreen.showScreen();
  } else if (currentScreen.equals("CameraLiveViewScreen")) {
    // Resetting imageSaved, imageShared and compiledImage, in case they have not already
    // been reset
    imageSaved = false;
    imageShared = false;
    compiledImage = null;
    myCameraLiveViewScreen.showScreen();
  } else if (currentScreen.equals("FavouritesScreen")) {
    myFavouritesScreen.showScreen();
  } else if (currentScreen.equals("SettingsScreen")) {
    // Setting the global returnTo variable to be equal to the current screen,
    // so that if user goes to the SocialMediaLogoutScreen, that screen's icons
    // can determine which screen to return the user to after they have completed
    // their changes (as they may have come in from another screen)
    returnTo = currentScreen;
    mySettingsScreen.showScreen();
  } else if (currentScreen.equals("AboutScreen")) {
    myAboutScreen.showScreen();
  } else if (currentScreen.equals("SearchScreen")) {
    mySearchScreen.showScreen();
  } else if (currentScreen.equals("SearchUnsuccessfulScreen")) {
    mySearchUnsuccessfulScreen.showScreen();
  } else if (currentScreen.equals("ImagePreviewScreen")) {
    myImagePreviewScreen.showScreen();
  } else if (currentScreen.equals("SaveShareScreenA")) {
    // Setting the global returnTo variable to be equal to the current screen,
    // so that if user goes to the SaveShareScreenA, that screen's icons
    // can determine which screen to return the user to after they have completed
    // their changes (as they may have come in from another screen)
    returnTo = currentScreen;
    mySaveShareScreenA.showScreen();
  } else if (currentScreen.equals("SaveShareScreenB")) {
    mySaveShareScreenB.showScreen();
  } else if (currentScreen.equals("SharingScreen")) {
    mySharingScreen.showScreen();
  } else if (currentScreen.equals("ShareSaveSuccessfulScreen")) {
    myShareSaveSuccessfulScreen.showScreen();
  } else if (currentScreen.equals("ShareUnsuccessfulScreen")) {
    myShareUnsuccessfulScreen.showScreen();
  } else if (currentScreen.equals("ShareSaveUnsuccessfulScreen")) {
    myShareSaveUnsuccessfulScreen.showScreen();
  } else if (currentScreen.equals("SearchingScreen")) {
    mySearchingScreen.showScreen();
  } else if (currentScreen.equals("SocialMediaLogoutScreen")) {
    mySocialMediaLogoutScreen.showScreen();
  } else if (currentScreen.equals("LoadingScreen")) {
    myLoadingScreen.showScreen();
    // Calling the fadeToScreen method, so that if a click occurs while on this screen, the
    // user will be taken to the "HomeScreen"
    fadeToScreen("HomeScreen");
  } else {
    println("This screen doesn't exist");
  }
}

/*-------------------------------------- CheckFunctionCalls() --------------------------------*/
public void checkFunctionCalls() {

  // Checking if any screen's icons are trying to trigger any functions (by passing their
  // iconLinkTo values to the global callFunction variable). In order for an icon to link
  // to a function, as opposed to a Screen, the link must start with "_"
  if (callFunction.equals("")) {
    // No function needs to be called
  } else if (callFunction.equals("_keepImage")) {
    keepImage();
  } else if (callFunction.equals("_toggleSavingOfCurrentImage")) {
    toggleSavingOfCurrentImage();
  } else if (callFunction.equals("_switchSendToTwitter")) {
    switchSendToTwitter();
  } else if (callFunction.equals("_switchCameraView")) {
    myCameraLiveViewScreen.switchCameraView();
  } else if (callFunction.equals("_addToFavourites")) {
    thread("addToFavourites");
  } else if (callFunction.equals("_switchLearningMode")) {
    switchLearningMode();
  } else if (callFunction.equals("_switchAutoSaveMode")) {
    switchAutoSaveMode();
  } else if (callFunction.equals("_sendTweet")) {
    sendTweet();
  } else if (callFunction.equals("_mergeImages")) {
    mergeImages();
  } else if (callFunction.equals("_disgardImage")) {
    disgardImage();
  } else if (callFunction.equals("_searchForLocation")) {
    searchForLocation();
  } else if (callFunction.equals("_getRandomLocation")) {
    getRandomLocation();
  } else if (callFunction.equals("_checkTwitterLogin")) {
    checkTwitterLogin();
  } else if (callFunction.equals("_switchShakeMovement")) {
    switchShakeMovement();
  } else if (callFunction.equals("_shareImageToDeviceApps")) {
    shareImageToDeviceApps();
  } else if (callFunction.equals("_removeTwitterAccount")) {
    removeTwitterAccount();
  } else {
    println(callFunction + " - This function does not exist / cannot be triggered by this icon");
  }

  // Resetting the callFunction variable so that functions do not get called repeatedly
  callFunction = "";
}

/*-------------------------------------- KeepImage() -----------------------------------------*/
public void keepImage() {

  // Checking if the saveThisImageOn boolean is true. If a user has autoSaveModeOn turned on,
  // then saveThisImageOn will also be set to true. If a user then wants to turn off saving for
  // an individual image, they can toggle this functionality on/off in SaveShareScreenA, while
  // not affecting their overall autoSaveModeOn setting. Images will only ever save to the device
  // when saveThisImageOn is set to true, regardless of whether autosaveMode is on or off (to
  // allow the user to make individual choices for each image).
  if (saveThisImageOn) {

    println("KEEP IMAGE - This image was saved. autoSaveModeOn = " + autoSaveModeOn + " and saveThisImageOn = " + saveThisImageOn);

    // Chec0king if Storage is available. This method will return a boolean value, to
    // indicate whether external storage is mounted and writable
    if (isExternalStorageWritable()) {

      // Saving the image to the photo gallery of the user's device, using the saveImageToPhotoGallery
      // method. This method returns a boolean value, to indicate whether the image was saved
      // successfully or not
      if (saveImageToPhotoGallery()) {

        // Determining which screen to redirect the user to, based on whether they also want
        // to send this image to Twitter or not. If a user is logged in to Twitter, then
        // sendToTwitterOn will be changed to true. If they then decided to disable/enable
        // sending to Twitter for individual images (in SaveShareScreenA) then this boolean
        // will toggle on/off. If the user is also sending the image to Twitter, then taking
        // them to SaveShareScreenB, so they can add a message to their tweet, otherwise
        // taking them to the ShareSaveSuccessfulScreen, where the imageShared and imageSaved
        // booleans will determine which tasks have been successfully completed, in order to
        // display the appropriate confirmation text on screen
        currentScreen = sendToTwitterOn ? "SaveShareScreenB" : "ShareSaveSuccessfulScreen";
      } else {
        println("Failed to save image");

        // Determining which screen to redirect the user to, based on whether they also want
        // to send this image to Twitter or not. If a user is logged in to Twitter, then
        // sendToTwitterOn will be changed to true. If they then decided to disable/enable
        // sending to Twitter for individual images (in SaveShareScreenA) then this boolean
        // will toggle on/off. If the user is also sending the image to Twitter, then taking
        // them to SaveShareScreenB, so they can add a message to their tweet, otherwise
        // taking them to the ShareSaveUnsuccessfulScreen, where the imageShared and imageSaved
        // booleans will determine which tasks have been unsuccessfully completed, in order to
        // display the appropriate options on screen
        currentScreen = sendToTwitterOn ? "SaveShareScreenB" : "ShareSaveUnsuccessfulScreen";
      }
    }
  } else {
    // The user does not want to save the image

    println("KEEP IMAGE - This image was not saved. autoSaveModeOn = " + autoSaveModeOn + " and saveThisImageOn = " + saveThisImageOn);

    // Determining which screen to redirect the user to, based on whether they also want
    // to send this image to Twitter or not. If a user is logged in to Twitter, then
    // sendToTwitterOn will be changed to true. If they then decided to disable/enable
    // sending to Twitter for individual images (in SaveShareScreenA) then this boolean
    // will toggle on/off. If the user is sending the image to Twitter, then taking
    // them to SaveShareScreenB, so they can add a message to their tweet, otherwise
    // taking them back to the CameraLiveViewScreen, as they have decided not to save
    // or share this image
    currentScreen = sendToTwitterOn ? "SaveShareScreenB" : "CameraLiveViewScreen";
  }
}

/*-------------------------------------- IsExternalStorageWritable()--------------------------*/
public Boolean isExternalStorageWritable() {

  // Creating a local boolean, to store the result of checking if the external storage on this device
  // is writable, so that it can be returned from this method. Defaulting it to false, so that we
  // assume that the storage is not writable, unless proved otherwise
  Boolean answer = false;

  // Creating a string to store the state of the external storage,
  String state = Environment.getExternalStorageState();

  // Testing the string value of the environment property media_mounted, against the
  // string value of the state (as declared above). If the media is mounted, then storage
  // is available to be written/read, and all permissions are in place
  if (Environment.MEDIA_MOUNTED.equals(state)) {

    // Logging out the current state of the external storage
    println("External Storage is writable: " + state);

    // Setting the result of this method to be true, so that it can be returned from this funciton
    answer = true;
  } else {

    // Logging out the current state of the external storage
    println("External Storage is writable: " + state);
  }

  // Returning the result, of whether or not external storage is writable, to this method
  return answer;
}

/*-------------------------------------- SaveImageToPhotoGallery() ---------------------------*/
public Boolean saveImageToPhotoGallery() {

  // Creating a local boolean, to store the result of whether or not this attempt to save the image
  // to the user's photo gallery has been successful or not, so that it can be returned from this method
  Boolean successfull = false;

  // Checking if it will be possible to write to external storage, by calling the isExternalStorageWritable()
  // method, which returns a boolean value
  if (isExternalStorageWritable()) {
    // Creating temporary strings, to store the current date and time values, with a zero preceeding them
    // if they are less then 10 (for naming consistency)
    String currentDay = day() < 10 ? "0" + day() : "" + day();
    String currentMonth = month() < 10 ? "0" + month() : "" + month();
    String currentHour = hour() < 10 ? "0" + hour() : "" + hour();
    String currentMinute = minute() < 10 ? "0" + minute() : "" + minute();
    String currentSecond = second() < 10 ? "0" + second() : "" + second();

    // Generating a new filename for this image, based on the current time. Storing this path in the saveToPath
    // variable, so that this can be used to save the image, and also used to pass to the share intent, should
    // the user choose to share this image with another app on their device
    saveToPath = directory + "WishIWasHere-" + currentDay + currentMonth + year() + "-" + currentHour + currentMinute + currentSecond + ".jpg";

    // Saving the compiledImage to the path specified above
    if (compiledImage.save(saveToPath)) {

      println("Successfully saved image to - " + saveToPath);

      // Setting the result of this method to be true. The result will then be returned from this method
      successfull = true;

      // Setting the global imageSaved boolean to true, so that the screens that follow can determine
      // whether or not the image has been saved
      imageSaved = true;
    } else {
      println("Failed to save image");

      // Setting the global imageSaved boolean to false, so that the screens that follow can determine
      // whether or not the image has been saved
      imageSaved = false;
    }
  }

  // Returning the result of this method i.e. to specify whether the image has been successfully saved to the
  // user's photo gallery
  return successfull;
}

/*-------------------------------------- SaveImageLocally() ----------------------------------*/
public Boolean saveImageLocally() {

  // Creating a local boolean, to store the result of whether or not this attempt to save the image
  // to the locally to the app's internal storage has been successful or not, so that it can be
  // returned from this method
  Boolean successful = false;

  // Saving the compiledImage to using the filename "twitterImage", as Twitter will only ever need
  // to access the most recently saved image (in order to attach it to a Tweet)
  if (compiledImage.save(sketchPath("twitterImage.jpg"))) {

    println("Successfully saved image locally - " + sketchPath("twitterImage.jpg"));

    // Setting the result of this method to be true. The result will then be returned from this method
    successful = true;
  } else {

    println("Failed to save image locally - " + sketchPath("twitterImage.jpg"));
  }

  // Returning the result of this method i.e. to specify whether the image has been successfully saved to the
  // app's internal storage
  return successful;
}

/*-------------------------------------- FadeToScreen() --------------------------------------*/
public void fadeToScreen(String nextScreen) {
  // This method is used by Screen's that do not inherently have any interactions associated with
  // them, so that the next screen can be triggered the next time a mouse click occurs or will
  // otherwise disappear after 50 frames
  if (frameCount % 50 == 0 || mouseClicked) {

    // Setting the instance of the LoadingScreen to null, as this screen can only ever be accessed
    // once in any app session
    myLoadingScreen = null;

    // Setting the global currentScreen method to be equal to the nextScreen (passed into this function)
    currentScreen = nextScreen;

    // Resetting the mouse clicked and pressed booleans to false, so that no accidental clicks can
    // occur while the screen is being changed
    mouseClicked = false;
    mousePressed = false;
  }
}

/*-------------------------------------- AddToFavourites() -----------------------------------*/
public void addToFavourites() {

  // Creating a local boolean, to reflect if the currentLocation is a favourite or not, by the end of
  // this method (for TESTING purposes)
  Boolean favouriteLocation = false;

  // Getting the index value of the currently location, by checking if it is currently a favourite location
  int favLocationIndex = checkIfFavourite(currentLocationName);

  // If the current location is already a favourite, then it will have an index value greater than
  // minus 1. If this is a favourite location, then the user is trying to remove it from their favourites.
  if (favLocationIndex > -1) {

    // Looping through the favouriteLocationsData XML elements, as loaded in from the user_preferences.xml
    for (int i = 0; i < favouriteLocationsData.length; i++) {

      // Finding the location whose name matches the current location name
      if (favouriteLocationsData[i].getString("name").equals(currentLocationName)) {

        // Removing this XML element from the XML variable, which contains all preferences for this user
        userPreferencesXML.removeChild(favouriteLocationsData[i]);

        // Removing this location from the favourite tabs on the Favourites screen, using the index value
        // returned from the checkIfFavourite() method above
        myFavouritesScreen.favTabs.remove(favLocationIndex);

        // Saving the user_preferences.xml file to the app's internal storage, so the user's updated preferences
        // can persist between app sessions
        saveUserPreferencesXML();

        // Setting the local favourite location variable to false, as this is no longer a favourite location
        favouriteLocation = false;
      }
    }
  } else {

    // Creating a new XML location element in the userPreferencesXML variable
    XML newChild = userPreferencesXML.addChild("location");

    // Storing the current location data as attributes on the new XML element
    newChild.setString("name", currentLocationName);
    newChild.setString("latLng", googleImageLatLng);
    newChild.setString("heading", String.valueOf(googleImageHeading));
    newChild.setString("pitch", String.valueOf(googleImagePitch));

    // Saving the user_preferences.xml file to the app's internal storage, so the user's updated preferences
    // can persist between app sessions
    saveUserPreferencesXML();

    // Creating a new favourite tab, passing in the values of the current location's data
    FavouriteTab newFavTab = new FavouriteTab(this, currentLocationName, googleImageLatLng, googleImageHeading, googleImagePitch);

    // Adding this new favourite tab to the favTabs array of the FavouritesScreen, so that it can be
    // displayed on this screen
    myFavouritesScreen.favTabs.add(newFavTab);

    // Setting the local favourite location variable to true, as this now a favourite location
    favouriteLocation = true;
  }

  // Calling the checkFavIcon() method to check if this location is stored as a favourite, so that the right
  // favIcon image can be displayed on the camera live view screen
  checkFavIcon();

  // Logging out the favourite status of the current location (for TESTING purposes)
  println("Favourite location " + currentLocationName + " is now " + favouriteLocation);
}

/*-------------------------------------- SwitchLearningMode() --------------------------------*/
public void switchLearningMode() {
  // Toggling the value of learningModeOn between true and false i.e. making it equal to the
  // opposite of what it currently is
  learningModeOn = !learningModeOn;

  // Saving the user_preferences.xml file to the app's internal storage, so the user's updated preferences
  // can persist between app sessions
  saveUserPreferencesXML();

  // Checking what the current status of learningModeOn is
  if (learningModeOn) {
    // Since learning mode is now on, setting it's toggle switch to on
    mySettingsScreen.learningModeIcon.setImage(loadImage("toggleSwitchOnIconImage.png"));
  } else {
    // Since learning mode is now off, setting it's toggle switch to off
    mySettingsScreen.learningModeIcon.setImage(loadImage("toggleSwitchOffIconImage.png"));
  }

  println("LRN - Learning mode is now: " + learningModeOn);
}

/*-------------------------------------- SwitchAutoSaveMode() --------------------------------*/
public void switchAutoSaveMode() {

  // Toggling the value of autoSaveModeOn between true and false i.e. making it equal to the
  // opposite of what it currently is. Also resetting the saveThisImageOn boolean to match this
  // new setting.
  autoSaveModeOn = !autoSaveModeOn;
  saveThisImageOn = autoSaveModeOn;

  saveUserPreferencesXML();

  // Checking what the current status of autoSaveModeOn is
  if (autoSaveModeOn) {

    // Since autosave mode is now on, setting it's toggle switch to on
    mySettingsScreen.autoSaveIcon.setImage(loadImage("toggleSwitchOnIconImage.png"));

    // Since autosave mode is now on, also setting the Save icon on SaveShareScreenA to on
    mySaveShareScreenA.saveIcon.setImage(loadImage("saveIconOnImage.png"));
  } else {

    // Since autosave mode is now off, setting it's toggle switch to off
    mySettingsScreen.autoSaveIcon.setImage(loadImage("toggleSwitchOffIconImage.png"));

    // Since autosave mode is now off, also setting the Save icon on SaveShareScreenA to off
    mySaveShareScreenA.saveIcon.setImage(loadImage("saveIconOffImage.png"));
  }

  println("Auto-save is now: " + autoSaveModeOn);
}

/*-------------------------------------- ToggleSavingOfCurrentImage() ------------------------*/
public void toggleSavingOfCurrentImage() {

  // Toggling the value of saveThisImageOn between true and false i.e. making it equal to the
  // opposite of what it currently is.
  saveThisImageOn = !saveThisImageOn;

  // Checking the current status saveThisImageOn
  if (saveThisImageOn) {

    // Since saveThisImageOn is now on, setting the Save icon on SaveShareScreenA to on
    mySaveShareScreenA.saveIcon.setImage(loadImage("saveIconOnImage.png"));
  } else {

    // Since saveThisImageOn is now off, setting the Save icon on SaveShareScreenA to off
    mySaveShareScreenA.saveIcon.setImage(loadImage("saveIconOffImage.png"));
  }

  println("SaveThisImageOn is now: " + saveThisImageOn);
}

/*-------------------------------------- SwitchShakeMovement() -------------------------------*/
public void switchShakeMovement() {

  // Checking if the device is standing upright, as we can only allow the user to use the shake
  // movement functionality when the device is standing upright due to restrictions with the
  // accelerometer
  if (deviceOrientation == 0) {
    // Toggling the value of shakeMovementOn between true and false i.e. making it equal to the
    // opposite of what it currently is.
    shakeMovementOn = !shakeMovementOn;

    // Checking the current status of shakeMovementOc
    if (shakeMovementOn) {

      // Since shakeMovementOn is now on, setting the shake icon on CameraLiveViewScreen to on
      myCameraLiveViewScreen.shakeIcon.setImage(loadImage("shakeIconOnImage.png"));
    } else {

      // Since shakeMovementOn is now off, setting the shake icon on CameraLiveViewScreen to off
      myCameraLiveViewScreen.shakeIcon.setImage(loadImage("shakeIconOffImage.png"));
    }
  } else {
    // Resetting switch movement to false, as the user's device is turned sideways
    shakeMovementOn = false;

    // Since shakeMovementOn is now off, setting the shake icon on CameraLiveViewScreen to off
    myCameraLiveViewScreen.shakeIcon.setImage(loadImage("shakeIconOffImage.png"));
  }
}

/*-------------------------------------- SwitchSentToTwitter() -------------------------------*/
public void switchSendToTwitter() {

  // This functionality is only possible if the user has already logged in to Twitter. Checking
  // if they have by accessing the twitterLoggedIn static variable from the TwitterLoginActivity class
  if (TwitterLoginActivity.twitterLoggedIn) {

    // Toggling the value of sendToTwitterOn between true and false i.e. making it equal to the
    // opposite of what it currently is.
    sendToTwitterOn = !sendToTwitterOn;

    // Checking the current status of sendToTwitterOn
    if (sendToTwitterOn) {

      // Since sendToTwitterOn is now on, setting the Twitter icon on SaveShareScreenA to on
      mySaveShareScreenA.twitterIcon.setImage(loadImage("twitterAccountIconOnImage.png"));
    } else {

      // Since sendToTwitterOn is now off, setting the Twitter icon on SaveShareScreenA to off
      mySaveShareScreenA.twitterIcon.setImage(loadImage("twitterAccountIconOffImage.png"));
    }
  } else {
    println("This user can not turn on Twitter, as they have not previously logged in with Twitter");

    // Resetting sendToTwitterOn to false, so that none of the Twitter funcitonalities of the app
    // will be available
    sendToTwitterOn = false;

    // Since sendToTwitterOn is now off, setting the Twitter icon on SaveShareScreenA to off
    mySaveShareScreenA.twitterIcon.setImage(loadImage("twitterAccountIconOffImage.png"));
  }
}

/*-------------------------------------- SendTweet() -----------------------------------------*/
public void sendTweet() {

  // Checking if the user want to send this image to Twitter or not. This variable will only ever
  // be set to true if the user has already logged in with their Twitter account. A user can then
  // toggle this functionality on/off for each image they take in the app (i.e. so not all images
  // have to be shared online
  if (TwitterLoginActivity.twitterLoggedIn && sendToTwitterOn) {

    // Setting the currentScreen to be equal to the SharingScreen, so that this will be displayed while the
    // relevant requests are being made to setup and send this image out to Twitter, using the user's account.
    // Calling the switchScreens() method, so that this screen will be displayed immediately
    currentScreen = "SharingScreen";
    mySharingScreen.showScreen();

    // Acessing the current value of the TextInput on SaveShareScreenB i.e. the message the user would
    // like to add to their tweet
    String message = mySaveShareScreenB.messageInput.getInputValue();

    // Wrapping the sending of this tweet in a try/catch, to catch any TwitterExceptions that may be thrown
    try {

      // Creating a new status object, which will contain the user's message (as declared above) along with the
      // #WishIWasHere hashtag. The user's input into the TextInput on SaveShareScreenB had a maximum character
      // length applied to it, so that this message will never exceed the Twitter limit of 144 characters (including
      // the hashtag we are concatenating)
      StatusUpdate status = new StatusUpdate(message + " #WishIWasHere");

      // Calling the saveImageLocally() method, to temporarily store the image in the app's internal storage
      if (saveImageLocally()) {

        // Loading the image we just saved to the app's internal storage, back in as a File object,
        // as this is the required method to attach an image to a tweet
        File twitterImage = new File(sketchPath("twitterImage.jpg"));

        // Setting the media of the Twitter status to be equal to the image we just loaded back in
        status.setMedia(twitterImage);
      }

      // Calling the updateStatus() method on the Twitter object, which was generated by the TwitterFactory class
      // when this app was loaded. All of the consumer keys (of our app) and access tokens (of the user's account)
      // were passed to the constructor of this class, so that the Twitter API will accept tweets coming from this
      // app on behalf of the user
      twitter.updateStatus(status);

      // Setting the global imageShared variable to true, so that the screens which appear following this will
      // be able to determine if the user shared the image or not
      this.imageShared = true;

      // Switching the currentScreen to the ShareSaveSuccessfulScreen
      currentScreen = "ShareSaveSuccessfulScreen";

      // Clearing the input value of the message input on the SaveShareScreenB, as the value
      // of the message is not longer needed
      mySaveShareScreenB.messageInput.clearInputValue();
    } 
    catch (TwitterException te) {

      println("Unable t send tweet " + te);

      // Setting the global imageShared variable to false, so that the screens which appear following this will
      // be able to determine if the user shared the image or not
      this.imageShared = true;

      //Changing the current screen to be the ShareUnsuccessfulScreen
      currentScreen = "ShareUnsuccessfulScreen";
    }
  } else {
    println("Twitter - No twitter account logged in");

    // Since this user does not want to send this image to Twitter (or is not currently logged in to their
    // Twitter account) determining which screen to send them to
    if (imageSaved == false) {

      // Since the user has chosen not to save or share this image, returning them to the CameraLiveViewScreen
      currentScreen = "CameraLiveViewScreen";
    } else {

      // Since the user has already chosen to save this image, sending them on to the ShareSaveSuccessfulScreen,
      // where the global imageSaved and imageShared variables will be used to determine the appropriate message
      // and options to the user
      currentScreen = "ShareSaveSuccessfulScreen";
    }
  }
}

/*-------------------------------------- RemoveGreenScreen() ---------------------------------*/
public void removeGreenScreen() {
  int greenPixels = 0;

  // Creating a local keyedImage variable, within which the image of the user, minus the green
  // screen background, will be created below
  PImage keyedImage;

  try {
    println("Starting removing Green Screen at frame " + frameCount);

    // Changing the colour mode to HSB, so that I can work with the hue, satruation and
    // brightness of the pixels. Setting the maximum hue to 360, and the maximum saturation
    // and brightness to 100.
    colorMode(HSB, 360, 100, 100);

    // Defaulting the keyedImage the full currentFrame image, so that only green pixels have to
    // be individually altered and unaffected pixels will already exist in the keyed image
    keyedImage = currentFrame.get();

    // Loading in the pixel arrays of the keyed image
    keyedImage.loadPixels();

    // Looping through each pixel of keyedImage, to check for any green and remove it
    for (int i = 0; i < keyedImage.pixels.length; i++) {

      // Getting the hue, saturation and brightness values of the current pixel
      float pixelHue = hue(currentFrame.pixels[i]);

      // If the hue of this pixel falls anywhere within the range of green in the colour spectrum,
      // then this pixel may be green
      if (pixelHue > 60 && pixelHue < 180) {

        // Since we do not yet know if this is a green pixel, accessing the saturation and brightness
        // of it's color so that we can carry out more specific checks on this pixel
        float pixelSaturation = saturation(currentFrame.pixels[i]);
        float pixelBrightness = brightness(currentFrame.pixels[i]);

        // If the saturation and brightness are above 30, then this is a green pixel
        if (pixelSaturation > 30 && pixelBrightness > 20) {

          // Set this pixel in the keyedImage to be transparent (Removing the main areas of the green)
          keyedImage.pixels[i] = color(0, 0, 0, 0);
        } else {

          // Even though this pixel falls within the green range of the colour spectrum, it's saturation and brightness
          // are low enough that it is unlikely to be a part of the green screen, but may just be an element of the scene
          // that is picking up a glow off the green screen. Lowering the hue and saturation to remove the green tinge
          // from this pixel.
          keyedImage.pixels[i] = color((int) (pixelHue * 0.6), (int) (pixelSaturation * 0.3), (int) (pixelBrightness));
        }

        if (learningModeOn) {
          greenPixels++;
        }
      }
    }

    // Updating the pixel arrays of the keyed image
    keyedImage.updatePixels();

    // Resetting the color mode to RGB. Resetting each of the colour channels to 8bits each i.e. true color (24bit)
    colorMode(RGB, 255, 255, 255);

    // Passing the keyed image back to the main thread by setting the currentImage to be equal to the
    // resulting image of the green screen keying above
    currentImage = keyedImage.get();

    // Resetting the keyedImage and currentFrame to null, as they are no longer needed
    keyedImage = null;
    currentFrame = null;

    // Resetting the readingImage variable to false, so that the next frame can be read in from the device camera
    readingImage = false;

    if ((greenPixels < (appWidth * appHeight * 0.10)) && learningModeOn) {
      // Triggering the Toast pop up (declared in the main activity) to encourage the user to reframe the
      // image as it currently has less that 10% green in it
      MainActivity.greenScreenWarning.show();

      println("Not enough green in the image");
      println("Threshold = " + (appWidth * appHeight * 0.10) + "; greenPixels = " + greenPixels);
    } else {
      println("Plenty of green in the image");
      println("Threshold = " + (appWidth * appHeight * 0.10) + "; greenPixels = " + greenPixels);
    }

    println("Finished removing Green Screen at frame " + frameCount);
  } 
  catch (OutOfMemoryError e) {

    println("Green screen keying could not be completed - " + e);

    // Resetting the keyedImage and currentFrame to null, as they are no longer needed
    keyedImage = null;
    currentFrame = null;

    // Resetting the readingImage variable to false, so that even if this frame failed to be processing,
    // the next frame can be read in from the device camera and the thread can attempt the keying again
    this.readingImage = false;
  }
}

/*-------------------------------------- MergeImages() ---------------------------------------*/
public void mergeImages() {
  try {
    // Setting imageMerging to true, so that no new frames will be read in while this process
    // is taking place (as the user has just taken a photo and so does not require any new
    // frames to be read in)
    imageMerging = true;

    // Creating a temporary PImage variable to load in the overlay graphic, which will be used to add
    // our app icon to the merged image.
    PImage overlayImage = loadImage("overlay.png");

    // Creating a new PGraphic, so that the relevant images can be "drawn" onto it, so that they
    // can be compiled into one image (for saving and sharing). Up until now, these images
    // were only displayed on top of one another, so the user could preview the final output.
    // Initialising this graphic to match the width and height of the Google street view image,
    // as this will have been determined (in the loadGoogleImage() method) to fill the device's
    // screen, based on the current orientation of the device.
    PGraphics mergedImage = createGraphics(googleImageWidth, googleImageHeight);

    // GOOGLE STREET VIEW IMAGE
    // Setting the imageMode of the merged image to be centered, so that the image can be "drawn" onto
    // it from a central point. Then adding the currentLocationImage (i.e. the Google Street View Image
    // of the current location) to the mergedImage graphic, with an x and y position, which is centered
    // based on half of the width and height of the googleImageWidth and googleImageHeight variables.
    mergedImage.beginDraw();
    mergedImage.imageMode(CENTER);
    mergedImage.image(currentLocationImage, googleImageWidth / 2, googleImageHeight / 2, googleImageWidth, googleImageHeight);

    // KEYED IMAGE OF USER
    // pushMatrix() - Storing the current state of the matrix, as we will be translating, scaling and rotating it in order to
    // to add the image in the correct position and orientation within the mergedImage PGraphic.
    // By pushing the matrix, we can revert it back to it's original state once this method has been completed
    // (by using the .popMatrix() method).
    // translate() - Translating the matrix of the mergedImage graphic, to be equal to the center of the image, based on half
    // of the width and height of the googleImageWidth and googleImageHeight variables, so that the image will
    // be centered within this new graphic, regardless of it's rotation.
    // scale() - Scaling the currentImage on the X axis, using the cameraScale, which will contain a value of 1 or -1
    // (based on whether the image should be flipped horizontally i.e. when using the front facing camera, the
    // x scale should always be -1 to avoid things being viewed in reverse)
    // rotate() - Calculating the appropriate rotation of the currentImage by multiplying the deviceOrientation, which
    // will contain a value of -90, 0 or 90, and is updated in the onAccelerometerEvent() when the device is rotated,
    // by the cameraScale (as described above). Taking the result of this, and subtracting it from the cameraRotation,
    // which will either be set to 90 or -90 degrees (to ensure that the live stream images from the camera area always
    // oriented in the right direction, as the Ketai Camera reads them in sideways, depending on which device
    // camera is being used). Then casting the result of this to be a radian value, so that the image will be
    // rotated in the right direction.
    // image() - adding the currentImage (i.e. the keyed image of the user) to the mergedImage graphic, with an x and
    // y position of 0, as the position of the image within the mergedImage will have been determined by the translate()
    // method. Setting the width and height of the image to be equal to the device's width and height, as unlike the Google
    // Street View Image, the currentImage does not change dimensions based on the device's orientation.
    // popMatrix() - Restoring the matrix of the mergedImage to it's previous state (which was stored when we called the
    // .pushMatrix() method at the start of this function)
    mergedImage.pushMatrix();
    mergedImage.translate(googleImageWidth / 2, googleImageHeight / 2);
    mergedImage.scale(cameraScale, 1);
    mergedImage.rotate(radians(cameraRotation - (deviceOrientation * cameraScale)));
    mergedImage.image(currentImage, 0, 0, appHeight, appWidth);
    mergedImage.popMatrix();

    // OVERLAY "WISH I WAS HERE" ICON IMAGE
    // Adding the overlayImage, which contains our app logo, to the mergedImage. This logo will always appear in the lower
    // right hand corner of the final image, in both portrait and landscape mode, so determining it's x and y positions
    // based on the mergedImage width and height, minus a percentage of the device width, to provide a margin around the
    // edge of the icon
    mergedImage.image(overlayImage, (float) (mergedImage.width - (appWidth * 0.3)), (float) (mergedImage.height - (appWidth * 0.2)), (float) (appWidth * 0.55), (float) (appWidth * 0.3));
    mergedImage.endDraw();

    // Setting the compiled image to be equal to the image stored in the PImage graphic created above. This contains
    // the Google Street View image of the background, the keyed image of the user, and the "Wish I Was Here" overlay
    // image, which can then be saved and/or shared. This image will also be displayed on the ImagePreviewScreen and
    // the SaveShareScreenA screens.
    compiledImage = mergedImage.get();

    // Resetting the local mergedImage and overlayImage variables to null as they are no longer needed
    mergedImage = null;
    overlayImage = null;

    // Sending the user to the image preview screen, so that they can see their image before choosing to save and/or
    // share it (in the screens that follow)
    currentScreen = "ImagePreviewScreen";
  } 
  catch (OutOfMemoryError e) {
    println("Could not save image - " + e);

    // Resetting image merging to false, as this image was not able to be merged
    imageMerging = false;

    // Sending the user back to the camera live view screen, as the device is unable to merge
    // their current view into an image at this time
    currentScreen = "CameraLiveViewScreen";
  }

  // Resetting imageMerging and readingImage to false, so that when the user returns to the CameraLiveViewScreen
  // later on, the camera will immediately being reading in new frames
  imageMerging = false;
  readingImage = false;
}

/*-------------------------------------- DisgardImage() --------------------------------------*/
public void disgardImage() {

  // Setting the compiled image variable to null, as the user wishes to dispose of this image,
  // following an unsuccessful attempt to save and/or share it (in the ShareSaveUnsuccessfulScreen
  compiledImage = null;

  // Returning the user to the CameraLiveViewScreen
  currentScreen = "CameraLiveViewScreen";
}

/*-------------------------------------- SearchForLocation() ---------------------------------*/
public void searchForLocation() {

  // Setting the currentScreen to be equal to the SearchingScreen, so that this will be displayed while the
  // relevant requests are being made to the Google Geocoding API (to source the location data of the address
  // specified) and then to the loadGoogleImage() method, to request a new Google Street View Image, based
  // on this location. Calling the switchScreens() method, so that this screen will be displayed immediately
  currentScreen = "SearchingScreen";
  switchScreens();

  // Getting the current input value of this text input (i.e. the most recent text input will have been the search box)
  searchAddress = currentTextInputValue;

  // Storing the searchAddress (as defined above) in the format required to add it as a parameter to the request
  // URL for the Google Geocoding API, which allows us to search for an address and receive an XML response
  // containing the relevant location details (latitude, longitude etc) so that we can then use these to request
  // a new image from the Google Street View Image API. Replacing all spaces in the string with +, so it can be
  // passed to the request URL below
  compiledSearchAddress = searchAddress.replace(" ", "+");

  println("Searching for " + searchAddress);

  // Defaulting the latitude, longitude and pitch of the image to 0
  googleImageLatLng = "0,0";
  googleImagePitch = 0;

  // Using the Google Maps Geocoding API to query the address the user has specified, and return the relevant XML containing
  // the location data of the place - https://developers.google.com/maps/documentation/geocoding/intro
  XML locationXML = loadXML("https://maps.googleapis.com/maps/api/geocode/xml?address=" + compiledSearchAddress + "&key=" + googleBrowserApiKey);

  // Checking if a result was found for the location specified by the user
  if (locationXML.getChild("status").getContent().equals("OK")) {

    // Getting the latitude and longitude data from the search result XML file
    String latitude = locationXML.getChildren("result")[0].getChild("geometry").getChild("location").getChild("lat").getContent();
    String longitude = locationXML.getChildren("result")[0].getChild("geometry").getChild("location").getChild("lng").getContent();

    // Concatenating the latitude and longitude, seperated by a comma, so that they can be stored in the googleImageLatLng,
    // to later be passed into the Google Street View Image API request
    googleImageLatLng = latitude + "," + longitude;

    // Getting the name of the current location from the "long_name" element of teh search result XML file
    currentLocationName = locationXML.getChildren("result")[0].getChildren("address_component")[0].getChild("long_name").getContent();

    println("Latitude, Longitude = " + googleImageLatLng);

    // Calling the loadGoogleImage() method, to load in the random location's image, with the relevant
    // properties using the location data from the user's search results, as specified above
    loadGoogleImage();

    // Clearing the input value of the search TextInput on the Search screen, as this is no longer needed
    currentTextInput.clearInputValue();
  } else {

    // The search was unsuccessful, so sending the user to the SearchUnsuccessfulScreen
    currentScreen = "SearchUnsuccessfulScreen";
  }
}

/*-------------------------------------- GetRandomLocation() ---------------------------------*/
public void getRandomLocation() {

  // Setting the currentScreen to be equal to the SearchingScreen, so that this will be displayed while a
  // random location is found, and a request is made to the loadGoogleImage() method, to request a new Google
  // Street View Image, based on this location. Calling the switchScreens() method, so that this screen will
  // be displayed immediately
  currentScreen = "SearchingScreen";
  switchScreens();

  println("Getting a random location");

  // Determing a random index value, based on the amount of locations stored in the randomLocations XML file
  int randomIndex = round(random(randomLocations.length - 1));

  // Setting the google image location variables, based on the relevant values from the random location
  // we are accessing, using the random index generated above
  googleImageLatLng = randomLocations[randomIndex].getString("latLng");
  googleImageHeading = Float.parseFloat(randomLocations[randomIndex].getString("heading"));
  googleImagePitch = Float.parseFloat(randomLocations[randomIndex].getString("pitch"));
  currentLocationName = randomLocations[randomIndex].getString("name");

  println("Random location selected: " + currentLocationName);

  // Calling the loadGoogleImage() method, to load in the random location's image, with the relevant
  // properties using the new values assigned above.
  loadGoogleImage();
}

/*-------------------------------------- LoadGoogleImage() -----------------------------------*/
public void loadGoogleImage() {

  // Using ternary operators to determine the width and height of the google image we are about to load in.
  // If the device orientation is equal to 0, then the device is standing upright, and the image will need
  // to be the width of the app, and the height of the app. Conversely, if the device orientation is equal to
  // anything else (which will only ever be -90 or 90 degrees) then the user is trying to take a landscape
  // picture, and so the width of the background image will need to be equal to the height of the device,
  // and the height of the image will be equal to the width of the device, as the background will be rotated
  // to accomodate the user's change in orientation, and will need to change dimensions in order to fill the
  // screen
  googleImageWidth = deviceOrientation == 0 ? appWidth : appHeight;
  googleImageHeight = deviceOrientation == 0 ? appHeight : appWidth;

  // Loading in a new Google Street view image, by making a request to the Google Street View Image API, which
  // includes the location's latitude, longitude, heading (left to right viewpoint), pitch (up and down viewpoint)
  // our browser API key (so that we have permission to access this API) along with the required width and height
  // for the resulting image (as defined above, based on the device's current orientation)
  currentLocationImage = loadImage("https://maps.googleapis.com/maps/api/streetview?location=" + googleImageLatLng + "&pitch=" + googleImagePitch + "&heading=" + googleImageHeading + "&key=" + googleBrowserApiKey + "&size=" + googleImageWidth + "x" + googleImageHeight);

  println("Image successfully loaded");

  // Checking if the user is currently on the camera live view screen, and if not, then sending them there,
  // so they can view themselves in front  of the new background image which was just loaded in
  if (currentScreen.equals("CameraLiveViewScreen") == false) {

    // Calling the checkFavIcon() method to check if this location is stored as a favourite, so that the right
    // favIcon image can be displayed on the camera live view screen
    checkFavIcon();

    // Sending the user to the CameraLiveViewScreen
    currentScreen = "CameraLiveViewScreen";
  }
}

/*-------------------------------------- CheckFavIcon() --------------------------------------*/
public void checkFavIcon() {

  // Calling the checkIfFavourite() method, to see if the current location is stored as
  // a favourite location. This method will return an int, specifying the index position
  // of the location in the favouriteTabs array int the FavouritesScreen. If the index
  // position returned is greater than -1, then this location if a favourite
  if (checkIfFavourite(currentLocationName) > -1) {

    // Since this location is a favourite, changing the image displayed in the favIcon
    // in the CameraLiveViewScreen to be the solid star (to show the user that this
    // is currently a favourite location)
    myCameraLiveViewScreen.favIcon.setImage(loadImage("favIconYesImage.png"));
  } else {

    // Since this location is not a favourite, changing the image displayed in the favIcon
    // in the CameraLiveViewScreen to be the empty star (to show the user that this
    // is a not currently a favourite location)
    myCameraLiveViewScreen.favIcon.setImage(loadImage("favIconNoImage.png"));
  }
}

/*-------------------------------------- CheckIfFavourite() ----------------------------------*/
public int checkIfFavourite(String currentFavTitle) {

  println("FAV - Checking if " + currentFavTitle + " is a favourite location");

  // Creating a local favIndex variable, to store the index of the favourite tab
  // which contains the location passed into this method, if this location is a
  // favourite. Defaulting this to -1, as this will be the value returned from
  // this function, and -1 is not a possible index position. This will then be used
  // to either determine if this is a favourite location, or to remove this location
  // from the favouriteTabs array (as well as the user_preferences.xml file)
  int favIndex = -1;

  // Creating a local ArrayList to store the favourite tabs from the Favourites
  // screen
  ArrayList<FavouriteTab> favouriteTabs = myFavouritesScreen.getFavTabs();

  // Looping through each of the favourite tabs from the Favourites screen
  for (int i = 0; i < favouriteTabs.size(); i++) {
    // Checking if each tab's location name is equal to the location name which
    // was passed in to this method
    if (favouriteTabs.get(i).getFavLocationName().equals(currentFavTitle)) {
      // Since the location name passed in to this method, matches with
      // this favouriteTab's location name, then this favourite already
      // exists, so setting the local favIndex variable to be equal to
      // this tab's index number, so that it can be returned from this method
      // and will either be used to determine if this is currently a favourite
      // location, or to remove this location from the favouriteTabs array
      // (as well as the user_preferences.xml file)
      favIndex = i;
    }
  }

  // Returing the index value from this method. If the favIndex is greater than
  // minus 1, then the location passed into this method is a favourite location
  return favIndex;
}

/*-------------------------------------- CheckTwitterLogin() ---------------------------------*/
public void checkTwitterLogin() {
  println("Checking if Twitter logged in");

  // Accessing the static twitterLoggedIn variable of the TwitterLoginActivity class, to see if
  // the user has logged in to the app using their Twitter account
  if (TwitterLoginActivity.twitterLoggedIn) {

    // Logging out the current values of the user's login credentials (for TESTING purposes)
    println("Twitter already logged in");
    println("In SKETCH - Twitter username = " + TwitterLoginActivity.twitterUserUsername);
    println("In SKETCH - Twitter userid = " + TwitterLoginActivity.twitterUserUserId);
    println("In SKETCH - Twitter access token = " + TwitterLoginActivity.twitterUserAccessToken);
    println("In SKETCH - Twitter secret token = " + TwitterLoginActivity.twitterUserSecretToken);

    // Taking the user to the Social Media Logout screen, so that they can log out of their
    // Twitter account
    currentScreen = "SocialMediaLogoutScreen";
  } else {
    // If we could resolve the OutOfMemory issues, this code would allow the user to go
    // to the Twitter login screen to log in after they were already in the app

    /*
            // Creating a new intent, to take the user from this Activity, to the TwitterLoginActivity,
     // where the user can login to their twitter account
     Intent intent = new Intent(getActivity(), TwitterLoginActivity.class);
     
     // Starting the new activity
     startActivity(intent);
     
     // Finishing the current activity
     getActivity().finish();
     */
  }
}

/*-------------------------------------- LoadUserPreferencesXML() ----------------------------*/
public void loadUserPreferencesXML() {

  // Creating a new File object, which contains the path to where the user's preferences will
  // have been stored locally within the app
  File localUserPreferencesPath = new File(sketchPath("user_preferences.xml"));

  // Checking if this path already exists i.e. does the user already have preferences stored within
  // the app, or is this their first time using the app
  if (localUserPreferencesPath.exists()) {
    // Since this path already exists, then loading in the user's previously saved preferences
    // from the app's local files
    userPreferencesXML = loadXML(sketchPath("user_preferences.xml"));
  } else {
    // Since the user does not already have preferences stored within the app, loading in the
    // preferences from the default user_preferences.xml file, on our GitHub.io site, so that
    // we can update the user's default favourite locations remotely. This file will only
    // be loaded in the first time the user opens the app so that it can be used to generate the
    // default preferences for this user, and will be the template for their locally stored
    // preferences within the app
    userPreferencesXML = loadXML("https://wishiwashere.github.io/user_preferences.xml");
  }

  // Logging out the current contents of the user preferences XML file (for TESTING purposes)
  println("USER PREFERENCES = " + userPreferencesXML);

  // Setting the global favouriteLocationsData array to store all of the location elements
  // stored in the user preferences file
  favouriteLocationsData = userPreferencesXML.getChildren("location");

  // Setting the settingsData array to store all of the setting elements stored in the user
  // preferences file (such as autoSaveMode and learningMode on/off)
  settingsData = userPreferencesXML.getChildren("setting");

  // Looping through all of the settingsData elements from the user preferences XML file
  for (int i = 0; i < settingsData.length; i++) {

    // Finding the relevant elements which contain the value for the autoSaveMode and
    // learningMode settings, so that their values can be used to initialise (or update)
    // the current settings in the app
    if (settingsData[i].getString("name").equals("autoSaveMode")) {

      // Parsing in the "on" value of this element as a boolean, and updating the status
      // of the autoSaveModeOn global variable
      autoSaveModeOn = Boolean.parseBoolean(settingsData[i].getString("on"));

      // Also updating the status of the saveThisImageOn global variable, so that a user can
      // then toggle this variable on/off to make individual choices about saving or not saving
      // each image, without effecting their autoSaveModeOn setting
      saveThisImageOn = autoSaveModeOn;
    } else if (settingsData[i].getString("name").equals("learningMode")) {

      // Parsing in the "on" value of this element as a boolean, and updating the status
      // of the learningModeOn global variable
      learningModeOn = Boolean.parseBoolean(settingsData[i].getString("on"));
    }
  }
  println("LRN - Loaded user preferences - learningMode = " + learningModeOn);
}

/*-------------------------------------- SaveUserPreferencesXML() ----------------------------*/
public void saveUserPreferencesXML() {

  // Looping through all of the settings data of the app
  for (int i = 0; i < userPreferencesXML.getChildren("setting").length; i++) {

    // Finding the relevant elements which contain the value for the autoSaveMode and learningMode settings,
    // so that it's value can be updated to reflect the current setting in the app. Looping through all of
    // the settings data of the app (from within the userPreferences XML file
    if (userPreferencesXML.getChildren("setting")[i].getString("name").equals("autoSaveMode")) {

      // Storing the current "on" value of this element an attribute on the autoSaveModeOn element
      userPreferencesXML.getChildren("setting")[i].setString("on", autoSaveModeOn.toString());

      println("LRN - Settings updated - autoSaveMode = " + userPreferencesXML.getChildren("setting")[i]);
    } else if (userPreferencesXML.getChildren("setting")[i].getString("name").equals("learningMode")) {

      // Storing the current "on" value of this element an attribute on the learningModeOn element
      userPreferencesXML.getChildren("setting")[i].setString("on", learningModeOn.toString());

      println("LRN - Settings updated - learningMode = " + userPreferencesXML.getChildren("setting")[i]);
    }
  }

  // Saving the current userPreferencesXML variable in the app's local user_preferences.xml file
  // so that the user's settings (and favourite locations) can be persisted between app sessions
  saveXML(userPreferencesXML, sketchPath("user_preferences.xml"));

  // Loading the XML data back in, so that the changes that have just been made to the user_preferences.xml
  // file will also be reflected in the relevant variable within the app aswell
  loadUserPreferencesXML();
}

/*-------------------------------------- ShareImageToDeviceApps() ----------------------------*/
public void shareImageToDeviceApps() {

  // Checking if the user has already saved the current compiledImage to their photo gallery
  if (imageSaved == false) {

    // Since the user has not already saved the current compiledImage to their photo gallery,
    // calling the saveImageToPhotoGallery() method. Ideally, we would prefer to just save the
    // image to the internal storage of the app temporarily, as we do with the images before
    // they are sent to Twitter, but the only way that apps outside of this app can access the
    // image is if it exists in an external storage directory
    saveImageToPhotoGallery();
  }

  // Create a new sharing intent, using the send action. This will trigger the device's default
  // "share to" menu, which will offer the user a list of all the apps currently installed on their
  // device, to which they can share their image
  Intent share = new Intent(Intent.ACTION_SEND);

  // Setting the MIME type of this intent to be an image (so the device can display the apps which
  // are appropriate for this type of media
  share.setType("image/*");

  // Creating a new File object, passing in the path to the most recently saved image
  File imageFile = new File(saveToPath);

  // Creating a URI (uniform resource identifier) to represent the image's location within the device
  // using the new File object created above
  Uri imageFileURI = Uri.fromFile(imageFile);

  // Adding the image file's URI to the intent, as an extra stream element
  share.putExtra(Intent.EXTRA_STREAM, imageFileURI);

  // Broadcasting the intent by starting it as an Activity, passing in the shareable media (as declared
  // above) along with the title that the sharing menu should display
  startActivity(Intent.createChooser(share, "Share your Wish I Was Here image to"));
  this.getActivity().finish();
}

/*-------------------------------------- removeTwitterAccount() ------------------------------*/
public void removeTwitterAccount() {

  // Looping through all of the settingsData XML elements from the user's preferences XML file
  for (int i = 0; i < settingsData.length; i++) {

    // Finding the Twitter setting element in the XML
    if (settingsData[i].getString("name").equals("twitter")) {

      println("Logging the  @" + TwitterLoginActivity.twitterUserUsername + " Twitter account out of the app");
      // Removing this XML element from the XML variable, which contains all the twitter login
      // details for this user
      userPreferencesXML.removeChild(settingsData[i]);

      // Resetting all of the TwitterLoginActivity's static variables, so that the user's Twitter details
      // will be removed from the app
      TwitterLoginActivity.twitterLoggedIn = false;
      TwitterLoginActivity.twitterUserUsername = "";
      TwitterLoginActivity.twitterUserSecretToken = "";
      TwitterLoginActivity.twitterUserAccessToken = "";
      TwitterLoginActivity.twitterUserUserId = 0;

      // Saving the user_preferences.xml file to the app's internal storage, so the user's updated preferences
      // can persist between app sessions
      saveUserPreferencesXML();

      mySettingsScreen.twitterAccountIcon.setImage(loadImage("twitterAccountIconOffImage.png"));

      // Calling the switchSendToTwitter method, which will ensure that the sending to Twitter functionality
      // is turned off throughout the app (now that TwitterLoginActivity's static twitterLoggedIn variable
      // is false)
      switchSendToTwitter();

      // Returning the user to the settings screen
      currentScreen = "SettingsScreen";
    }
  }
}