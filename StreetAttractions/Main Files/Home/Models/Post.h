//
//  Post.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <Parse/Parse.h>

// Models
#import "Category.h"
//#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject<PFSubclassing>

/**
 Unique ID of the Post
*/
@property (nonatomic, strong) NSString *postID;

/**
 Unique ID of the author
*/
@property (nonatomic, strong) NSString *userID;

/**
 User object for the author
*/
@property (nonatomic, strong) PFUser *author;

/**
 Caption of the post
*/
@property (nonatomic, strong) NSString *caption;

/**
        Image corresponding to the post
*/
@property (nonatomic, strong) PFFileObject *media;

/**
        Video corresponding to the post
*/
@property (nonatomic, strong) PFFileObject *video;

/**
   Amount of likes a post has received
*/
@property (nonatomic, strong) NSNumber *likeCount;

/**
   Average of the ratings a post has received
*/
@property (nonatomic, strong) NSNumber *rating;

/**
   Times post has been rated (used to calculate average)
*/
@property (nonatomic, strong) NSNumber *timesRated;

/**
   Latitude for post's location
*/
@property (nonatomic, strong) NSNumber *latitude;

/**
   Longitude for post's location
*/
@property (nonatomic, strong) NSNumber *longitude;

/**
   Name of city the post is happening
*/
@property (nonatomic, strong) NSString *city;

/**
   Category of the post
*/
@property (nonatomic, strong) NSString *category;

/**
   Date of upload
*/
@property (nonatomic, strong) NSDate *createdAt;

/**
   Date of upload modifyable
*/
@property (nonatomic, strong) NSDate *created_At;

/**
   Date of the event if its in the future
*/
@property (strong, nonatomic) NSDate *upcomingDate;

/**
  Determines if event is happening now or it will happen in the future
*/
@property (nonatomic) BOOL isUpcoming;

/**
  Determines if event has video
*/
@property (nonatomic) BOOL hasVideo;

/*!
   @brief Send the post to the server
   @discussion Loads an object post to the server with the following all inputs as properties
   @param  image Image of the post,  caption description of the post, latitude latitude of post's location, longitude
   longitude of post's location category category of post, upcoming boolean value showing if the post is in the future,
   date date the event will happen if its upcoming.
*/
+ (void)postUserImage:(UIImage *_Nullable)image
          withCaption:(NSString *_Nullable)caption
          forLatitude:(NSNumber *)latitude
         forLongitude:(NSNumber *)longitude
           toCategory:(NSString *)category
           isUpcoming:(BOOL)upcoming
              forDate:(NSDate *)date
            withVideo:(BOOL)hasVideo
        withVideoFile:(PFFileObject *)video
       withCompletion:(PFBooleanResultBlock _Nullable)completion;
@end
NS_ASSUME_NONNULL_END
