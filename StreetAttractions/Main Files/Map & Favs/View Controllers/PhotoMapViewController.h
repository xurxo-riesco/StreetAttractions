//
//  PhotoMapViewController.h
//  PhotoMap
//
//  Created by emersonmalca on 7/8/18.
//  Refactored by Xurxo Riesco on 7/13/20.
//

@import Parse;
#import <UIKit/UIKit.h>

#import "MaterialBottomSheet.h"
#import "UIImageView+AFNetworking.h"

// View Controllers
#import "BottomSheetViewController.h"
#import "DetailsViewController.h"
#import "LocationsViewController.h"

// Views
#import "Annotation.h"
#import "AnnotationPin.h"

// Models
#import "PerformanceRequest.h"
#import "Post.h"
#import "User.h"

@interface PhotoMapViewController : UIViewController

/**
   Array holding all posts near user location
*/
@property (nonatomic, strong) NSMutableArray *posts;

/**
   Translucent view containing the weather info
*/
@property (weak, nonatomic) IBOutlet UIView *weatherBorder;

/**
   Displays the temperature in celsius (sorry Americans)
*/
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

/**
   Displays an image according to the weather (clouds, sun, rain, etc...)
*/
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;

/**
    Hosts the post of a selected annotation (Used for seguing purposes)
*/
@property (nonatomic, strong) Post *post;

/**
    Used to display requests
*/
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftButton;

/**
    Used to retrieve users location
*/
@property (strong, nonatomic) CLLocationManager *locationManager;

/**
    Map displaying pins for the performance
*/
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

/**
    Temporarely holds post image used to set it to the annotation
*/
@property (nonatomic, strong) UIImageView *image;

/**
    Used to request a performance on a desired date
*/
@property (nonatomic, strong) UIDatePicker *datePicker;

/**
    Temporarely holds the request date before sending to server
*/
@property (nonatomic, strong) NSDate *date;

/**
    Alert controller used to request a performance
*/
@property (strong, nonatomic) UIAlertController *alertController;

/**
    Holds all available categories for display in the picker for request
*/
@property (strong, nonatomic) NSArray *categories;

/**
    PickerView to choose a category when requesting
*/
@property (strong, nonatomic) UIPickerView *pickerView;

/**
    Temporarely holds the annotation for a request, so that it can be remove when the next request is displayed
*/
@property (strong, nonatomic) Annotation *annotation;

@end
