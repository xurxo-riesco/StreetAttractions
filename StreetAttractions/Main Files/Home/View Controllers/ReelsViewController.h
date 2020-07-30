//
//  ReelsViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/28/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

@import Parse;

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

#import "NSString+ColorCode.h"

// View Controllers
#import "DetailsViewController.h"

// Models
#import "Post.h"
#import "User.h"
NS_ASSUME_NONNULL_BEGIN

@interface ReelsViewController : UIViewController

/**
  Displays author of the post on screen
*/
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

/**
   Displays the profile picture of the author of the inscreen post
*/
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;

/**
   Holds the profile pic and username of the author of the inscreen post
*/

@property (weak, nonatomic) IBOutlet UIView *contentView;
/**
   Holds the array index corresponding to the post being displayed
*/
@property (nonatomic) NSInteger index;

/**
   Stores all post that contain videos
*/
@property (strong, nonatomic) NSMutableArray *posts;

/**
   Temporarely holds the post object being displayed (Used for seguing)
*/
@property (strong, nonatomic) Post *post;

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
@property (nonatomic) BOOL pan;

@end

NS_ASSUME_NONNULL_END
