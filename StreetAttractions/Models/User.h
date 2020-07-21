//
//  User.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <Parse/Parse.h>

// Models
#import "Category.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser<PFSubclassing>

/**
  Username for the user (Must be unique)
*/
@property (nonatomic, strong) NSString *username;

/**
 Screen name for the user. Used for display. Does not need to be unique
*/
@property (nonatomic, strong) NSString *screenname;

/**
 Name of the city the user is located in
*/
@property (nonatomic, strong) NSString *location;

/**
 Password for the user
*/
@property (nonatomic, strong) NSString *password;

/**
 Venmo tag for the user, only for performers, for donation
*/
@property (nonatomic, strong) NSString *venmo;

/**
 Instagram tag for the user, only for performers
*/
@property (nonatomic, strong) NSString *instagramName;

/**
 Stores if a user is a performer or not, used across the app to grant logged in performers access to advanced options
*/
@property (nonatomic) BOOL isPerfomer;

/**
 Stores if a performer is currently transmiting live
*/
@property (nonatomic) BOOL isLive;

/**
 URL of the live performance if it's happening
*/
@property (nonatomic, strong) NSString *liveURL;

/**
 Profile pic of the user
*/
@property (nonatomic, strong) PFFileObject *profilePic;

/**
 Follower count of the user
*/
@property (nonatomic, strong) NSNumber *followersCount;

/*!
   @brief Checks if a category is favorite
   @discussion Determines if the user has marked the input category as one of their favorites
   @param  category The category to check
   @note A test is written for this method
*/
+ (void)isFavorite:(Category *)category WithCompletion:(void (^)(BOOL))completion;

/*!
   @brief Checks if a user is favorite
   @discussion Determines if the user has marked the input user as one of their favorites
   @param  user The user to check
   @note A test is written for this method
*/
+ (void)isFavoriteUser:(User *)user WithCompletion:(void (^)(BOOL))completion;

/*!
   @brief Checks if a post is liked
   @discussion Determines if the user has liked the input post
   @param  post The post to check
   @note A test is written for this method
*/
+ (void)hasLiked:(Post *)post WithCompletion:(void (^)(BOOL))completion;

/*!
   @brief Checks if a post has been rated
   @discussion Determines if the user has rated the input post
   @param  post The post to check
   @note A test is written for this method
*/
+ (void)hasRated:(Post *)post WithCompletion:(void (^)(BOOL))completion;

/*!
   @brief Get favorite categories
   @discussion Gets all categories the user has marked as favorite
   @note A test is written for this method
*/
+ (void)getCategoriesWithCompletion:(void (^)(NSArray *categories, NSArray *categoryStrings))completion;

/*!

   @brief Get favorite users
   @discussion Gets all users the user has marked as favorite
   @note Test is written for this method
*/
+ (void)getFavoritesWithCompletion:(void (^)(NSArray<User *> *favorites))completion;

@end
NS_ASSUME_NONNULL_END
