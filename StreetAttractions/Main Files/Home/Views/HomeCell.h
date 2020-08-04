//
//  HomeCell.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

#import "DateTools.h"
#import "NSString+ColorCode.h"
@import Parse;
// Models
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

/*!
    @protocol HomeCellDelegate

    @brief Delegate to allow seguing to details

    Used to allow double tapping on a cell's image to trigger a segue to the detailed view of the post
 */
@protocol HomeCellDelegate;

@interface HomeCell : UICollectionViewCell<CLLocationManagerDelegate>

/**
   Delegate property
*/
@property (nonatomic, weak) id<HomeCellDelegate> delegate;

/**
   Used to fetch user's current location
*/
@property (strong, nonatomic) CLLocationManager *locationManager;

/**
    User's current latitude
*/
@property (nonatomic) CGFloat latitude;

/**
    User's current longitude
*/
@property (nonatomic) CGFloat longitude;

/**
    Displays time since posted
*/
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

/**
    Displays distance from user
*/
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

/**
    Displays post's description
*/
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

/**
    View to allow the preview of a post details
*/
@property (weak, nonatomic) IBOutlet UIImageView *descriptionView;

/**
    Displays a fire next to a post if it has received more than 10 likes
*/
@property (weak, nonatomic) IBOutlet UIImageView *popularView;

/**
    Displays post's image
*/
@property (weak, nonatomic) IBOutlet PFImageView *mediaView;

/**
    Hosts the post of the current cell
*/
@property (strong, nonatomic) Post *post;

/**
    Displays the color of the category
*/
@property (weak, nonatomic) IBOutlet UIView *categoryView;

/**
    Displayed while loading post's image
*/
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

/**
    Displays that the post has been claimed by a performer
*/
@property (weak, nonatomic) IBOutlet UIImageView *claimedView;

/*!
   @brief Loads all celll views
   @discussion Simply display the media corresponding to the post.
   @param  post The post object to be displayed

*/
- (void)loadPost:(Post *)post;

/*!
   @brief Shows description view over the cell
   @discussion Loads a translucent view over the cell containing the post with the following info:
                - Description of the post
                - Distance from the user
                - Color of the category
                - Time since posting
   @param  post The post for which to display the previewed detail information
*/
- (void)showDescription:(Post *)post;

/*!
   @brief Displays a bookmark for claimed posts
   @discussion Avalaible only on profile view, displayed if the user posted but the post was claimed

*/
- (void)bookmark;

@end

@protocol HomeCellDelegate
- (void)homeCell:(HomeCell *)homeCell didTap:(Post *)post;
@end

NS_ASSUME_NONNULL_END
