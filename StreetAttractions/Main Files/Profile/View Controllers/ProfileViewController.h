//
//  ProfileViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

@import Parse;
#import <CoreML/CoreML.h>
#import <UIKit/UIKit.h>

#import "BraintreeCore.h"
#import "BraintreeDropIn.h"
#import "BraintreeVenmo.h"
#import "DatePredictor.h"
#import "DateTools.h"
#import "LatitudePredictor.h"
#import "LongitudePredictor.h"

// View Controllers
#import "DetailsViewController.h"
#import "MessageThreadViewController.h"

// Views
#import "HomeCell.h"

// Models
#import "Post.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

/**
   Holds the post of the user whose profile is displayed
*/
@property (strong, nonatomic) NSMutableArray *posts;

/**
   Holds the number of fetched post to send as query parameter when fetching more posts via infinite scrolling
*/
@property (assign, nonatomic) int dataSkip;

/**
   Helper bool used for infinite scrolling
*/
@property (assign, nonatomic) BOOL isMoreDataLoading;

/**
   Displays verified badge for performers
*/
@property (weak, nonatomic) IBOutlet UIButton *isPerformer;

/**
   Displays button for favoriting profile
*/
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

/**
  Displays map to see predicted location (isPerformer only)
*/
@property (weak, nonatomic) IBOutlet UIButton *mapButton;

/**
   Displays profile pic of the user
*/
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;

/**
   Displays screen name of the user
*/
@property (weak, nonatomic) IBOutlet UILabel *screenameLabel;

/**
   Displays username
*/
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

/**
   Displays user's location
*/
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

/**
  Button to open Instagram  (isPerformer only)
*/
@property (weak, nonatomic) IBOutlet UIButton *instaButton;

/**
  Holds the object for the user whose profile is being displayed
*/
@property (strong, nonatomic) User *user;

/**
  Temporarely holds the post of a cell (Used for seguing)
*/
@property (strong, nonatomic) Post *post;

/**
  Holds the latitude of all post's by the user
*/
@property (strong, nonatomic) NSMutableArray *latitudes;

/**
  Holds the longitude of all post's by the user
*/
@property (strong, nonatomic) NSMutableArray *longitudes;

/**
  Holds the dates of all post's by the user
*/
@property (strong, nonatomic) NSMutableArray *dates;

/**
  Button to access live video (isPerformer & isLive)
*/
@property (weak, nonatomic) IBOutlet UIButton *liveButton;

/**
  CollectionView for all the user posts
*/
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
