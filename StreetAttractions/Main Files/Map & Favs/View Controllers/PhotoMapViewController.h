//
//  PhotoMapViewController.h
//  PhotoMap
//
//  Created by emersonmalca on 7/8/18.
//  Refactored by Xurxo Riesco on 7/13/20.
//

@import Parse;
#import <UIKit/UIKit.h>

#import "UIImageView+AFNetworking.h"

// View Controllers
#import "DetailsViewController.h"
#import "LocationsViewController.h"

// Views
#import "Annotation.h"
#import "AnnotationPin.h"

// Models
#import "Post.h"
#import "User.h"
#import "PerformanceRequest.h"

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

@end
