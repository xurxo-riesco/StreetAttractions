//
//  DetailsViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

#import "DateTools.h"
#import "HCSStarRatingView.h"
// Models
#import "Post.h"
#import "User.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

/**
   Animated view for displaying rate and rating
*/
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starView;

/**
   Holds the post of which to display the details
*/
@property (nonatomic, strong) Post *post;

/**
   Displays time ago since posting
*/
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

/**
   Holds author of the post
*/
@property (nonatomic, strong) User *user;

/**
   Map View to display post location (Used to get directions as well)
*/
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

/**
   Displays the image corresponding to a post
*/
@property (weak, nonatomic) IBOutlet PFImageView *mediaView;

/**
   Displays post author profile pic
*/
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;

/**
   Displays screen name of post's author
*/
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

/**
   Displays description of the post
*/
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

/**
   Serves as an outlet to segue to comments
*/
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;

/**
   Button to like a post
*/
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

/**
   Button to send the rating to the server
*/
@property (weak, nonatomic) IBOutlet UIButton *rateButton;

/**
   Property for Video Player
*/
@property (nonatomic) AVPlayer *avPlayer;

/**
   Layer to display the Video Player in the UI
*/
@property (nonatomic) AVPlayerLayer *videoLayer;

/**
   Helper property to avoid double adding of layers
*/
@property (nonatomic) BOOL pinch;

@end

NS_ASSUME_NONNULL_END
