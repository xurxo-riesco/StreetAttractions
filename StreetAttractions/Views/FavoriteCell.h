//
//  FavoriteCell.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DateTools.h"

// Models
#import "Post.h"
#import "User.h"

@import Parse;
NS_ASSUME_NONNULL_BEGIN

/*!
   @protocol FavoriteCellDelegate

   @brief Delegate to allow seguing to details

   Used to allow double tapping on a cell's image to trigger a segue to the detailed view of the post
*/
@protocol FavoriteCellDelegate;

@interface FavoriteCell : UITableViewCell<CLLocationManagerDelegate>

/**
   Used to fetch user's current location
*/
@property (strong, nonatomic) CLLocationManager *locationManager;

/**
   Delegate property
*/
@property (nonatomic, weak) id<FavoriteCellDelegate> delegate;

/**
    Hosts the post of the current cell
*/
@property (strong, nonatomic) Post *post;

/**
    Displays a border around the post color coded based on cell's category
*/
@property (weak, nonatomic) IBOutlet UIImageView *borderView;

/**
    Displays post's image
*/
@property (weak, nonatomic) IBOutlet PFImageView *mediaView;

/**
    Displays post's description
*/
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
/**
    Displays distance from user
*/
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

/**
    Displays time since posted
*/

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

/**
    Displays the screen name of the post's author
*/
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

/**
    Displays the profile picture of the post's author
*/
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;

/**
    User's current latitude
*/
@property (nonatomic) CGFloat latitude;

/**
    User's current longitude
*/
@property (nonatomic) CGFloat longitude;

/*!
   @brief Loads all views and labels with post information
   @discussion Loads the cell with the following info
                - Image of the post
                - Description of the post
                - Distance from the user
                - Border color coded based on post's category
                - Time since posting

   @param  post The post object to be displayed
*/
- (void)loadPost:(Post *)post;

@end

@protocol FavoriteCellDelegate
- (void)favoriteCell:(FavoriteCell *)favoriteCell didTap:(Post *)post;
@end

NS_ASSUME_NONNULL_END
