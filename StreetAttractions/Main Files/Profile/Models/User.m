//
//  User.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "User.h"

@implementation User
@dynamic password;
@dynamic username;
@dynamic screenname;
@dynamic profilePic;
@dynamic location;
@dynamic venmo;
@dynamic isPerfomer;
@dynamic instagramName;
@dynamic isLive;
@dynamic liveURL;
@dynamic followersCount;

+ (void)isFavorite:(Category *)category WithCompletion:(void (^)(BOOL))completion
{
  User *user = [User currentUser];
  PFRelation *relation = [user relationForKey:@"FavCategories"];
  PFQuery *query = [relation query];
  [query findObjectsInBackgroundWithBlock:^(NSArray<Category *> *_Nullable categories, NSError *_Nullable error) {
    for (Category *userCategory in categories) {
      if ([userCategory.name isEqual:category.name]) {
        completion(YES);
      }
    }
  }];
}

+ (void)isFavoriteUser:(User *)user WithCompletion:(void (^)(BOOL))completion
{
  User *currentUser = [User currentUser];
  PFRelation *relation = [currentUser relationForKey:@"FavUsers"];
  PFQuery *query = [relation query];
  [query findObjectsInBackgroundWithBlock:^(NSArray<User *> *_Nullable categories, NSError *_Nullable error) {
    for (User *userFavorite in categories) {
      if ([userFavorite.username isEqual:user.username]) {
        completion(YES);
      }
    }
  }];
}

+ (void)hasLiked:(Post *)post WithCompletion:(void (^)(BOOL))completion
{
  User *currentUser = [User currentUser];
  PFRelation *relation = [currentUser relationForKey:@"LikedPost"];
  PFQuery *query = [relation query];
  [query findObjectsInBackgroundWithBlock:^(NSArray<Post *> *_Nullable posts, NSError *_Nullable error) {
    for (Post *postLiked in posts) {
      if ([[post objectId] isEqual:[postLiked objectId]]) {
        completion(YES);
      }
    }
  }];
}

+ (void)hasRated:(Post *)post WithCompletion:(void (^)(BOOL))completion
{
  User *currentUser = [User currentUser];
  PFRelation *relation = [currentUser relationForKey:@"RatedPosts"];
  PFQuery *query = [relation query];
  [query findObjectsInBackgroundWithBlock:^(NSArray<Post *> *_Nullable posts, NSError *_Nullable error) {
    for (Post *postLiked in posts) {
      if ([[post objectId] isEqual:[postLiked objectId]]) {
        completion(YES);
      }
    }
  }];
}

+ (void)hasClaimed:(Post *)post WithCompletion:(void (^)(BOOL))completion
{
  User *currentUser = [User currentUser];
  PFRelation *relation = [currentUser relationForKey:@"ClaimedPosts"];
  PFQuery *query = [relation query];
  [query findObjectsInBackgroundWithBlock:^(NSArray<Post *> *_Nullable posts, NSError *_Nullable error) {
    for (Post *postLiked in posts) {
      if ([[post objectId] isEqual:[postLiked objectId]]) {
        completion(YES);
      }
    }
  }];
}

+ (void)getCategoriesWithCompletion:(void (^)(NSArray *categories, NSArray *categoryStrings))completion
{
  User *user = [User currentUser];
  NSMutableArray *categoryStrings = [[NSMutableArray alloc] init];
  PFRelation *relation = [user relationForKey:@"FavCategories"];
  PFQuery *query = [relation query];
  [query findObjectsInBackgroundWithBlock:^(NSArray<Category *> *_Nullable categories, NSError *_Nullable error) {
    if (categories) {
      for (Category *category in categories) {
        [categoryStrings addObject:category.name];
      }
      completion(categories, categoryStrings);
    }
  }];
}

+ (void)getFavoritesWithCompletion:(void (^)(NSArray<User *> *favorites))completion
{
  User *user = [User currentUser];
  PFRelation *relation = [user relationForKey:@"FavUsers"];
  PFQuery *query = [relation query];
  [query findObjectsInBackgroundWithBlock:^(NSArray<User *> *_Nullable favUsers, NSError *_Nullable error) {
    completion(favUsers);
  }];
}

@end
