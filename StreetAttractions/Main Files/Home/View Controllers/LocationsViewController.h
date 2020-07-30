//
//  LocationsViewController.h
//  PhotoMap
//
//  Created by emersonmalca on 7/8/18.
//  Refactored by Xurxo Riesco on 7/13/20.
//

@import Parse;
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

// Views
#import "LocationCell.h"

// Models
#import "User.h"

@class LocationsViewController;

/*!
   @protocol LocationsViewControllerDelegate

   @brief Stores the coordinate of a location

   Used to save the latitude and longitude of a venue after being selected in the TableView
*/
@protocol LocationsViewControllerDelegate
- (void)locationsViewController:(LocationsViewController *)controller
    didPickLocationWithLatitude:(NSNumber *)latitude
                      longitude:(NSNumber *)longitude;
@end

@interface LocationsViewController : UIViewController

/**
   Delegate property
*/
@property (weak, nonatomic) id<LocationsViewControllerDelegate> delegate;

/**
    TableView that loads the venues matching the searchBar text
*/
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
   Search field to search for venues
*/
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

/**
   Array holding all venues that matched the search query
*/
@property (strong, nonatomic) NSArray *results;

/**
   User's location used as a query parameter so that the locations suggested are near him/her
*/
@property (strong, nonatomic) NSString *location;

@end
