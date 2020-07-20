//
//  LocationsViewController.h
//  PhotoMap
//
//  Created by emersonmalca on 7/8/18.
//  Refactored by Xurxo Riesco on 7/13/20.
//

@import Parse;
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

// Views
#import "LocationCell.h"

// Models
#import "User.h"

@class LocationsViewController;

@protocol LocationsViewControllerDelegate
- (void)locationsViewController:(LocationsViewController *)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude;
@end

@interface LocationsViewController : UIViewController

@property (weak, nonatomic) id<LocationsViewControllerDelegate> delegate;

@end
