//
//  Post.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "Post.h"
#import "User.h"
@implementation Post
@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic caption;
@dynamic media;
@dynamic likeCount;
@dynamic city;
@dynamic createdAt;
@dynamic latitude;
@dynamic longitude;
@dynamic category;
@dynamic rating;
@dynamic timesRated;
@dynamic isUpcoming;
@dynamic upcomingDate;
@dynamic hasVideo;
@dynamic video;

+ (nonnull NSString *)parseClassName
{
  return @"Post";
}

+ (void)postUserImage:(UIImage *_Nullable)image
          withCaption:(NSString *_Nullable)caption
          forLatitude:(NSNumber *)latitude
         forLongitude:(NSNumber *)longitude
           toCategory:(NSString *)category
           isUpcoming:(BOOL)upcoming
              forDate:(NSDate *)date
            withVideo: (BOOL) hasVideo
       withVideoFile : (PFFileObject *) video
       withCompletion:(PFBooleanResultBlock _Nullable)completion
{
  Post *newPost = [Post new];
  newPost.media = [self getPFFileFromImage:image];
  User *author = [User currentUser];
  newPost.author = author;
  newPost.city = author.location;
  newPost.caption = caption;
  newPost.likeCount = @(0);
  newPost.timesRated = @(0);
  newPost.latitude = latitude;
  newPost.longitude = longitude;
    newPost.hasVideo = hasVideo;
    if(hasVideo)
    {
        newPost.video = video;
    }else
    {
        newPost.video = nil;
    }
  newPost.category = category;
  if (upcoming) {
    newPost.isUpcoming = YES;
  } else {
    newPost.isUpcoming = NO;
  }
  newPost.upcomingDate = date;
  [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *_Nullable error) {
    if (succeeded) {
      [newPost addPost:newPost toCategory:category withCompletion:completion];
    }
  }];
}

// Turns an image in to a file for storage in server
+ (PFFileObject *)getPFFileFromImage:(UIImage *_Nullable)image
{
  if (!image) {
    return nil;
  }
  NSData *imageData = UIImagePNGRepresentation(image);
  if (!imageData) {
    return nil;
  }
  return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

// Adds the post object to a category object via a relation in the server
- (void)addPost:(Post *)post toCategory:(NSString *)name withCompletion:(PFBooleanResultBlock _Nullable)completion
{
  PFQuery *categoryQuery = [Category query];
  [categoryQuery whereKey:@"name" equalTo:name];
  categoryQuery.limit = 1;
  [categoryQuery findObjectsInBackgroundWithBlock:^(NSArray<Category *> *_Nullable objects, NSError *_Nullable error) {
    if (!error) {
      Category *category = objects[0];
      NSLog(@"%@", category);
      PFRelation *relation = [category relationForKey:@"Posts"];
      [relation addObject:post];
      [category saveInBackgroundWithBlock:^(BOOL succeeded, NSError *_Nullable error) {
        if (succeeded) {
          [post saveInBackgroundWithBlock:completion];
        }
      }];
    }
  }];
}

// Overwrites native function which does not work with custom PFObjects
- (BOOL)isEqual:(id)other
{
  if (other == self)
    return YES;
  if ([[self objectId] isEqual:[other objectId]])
    return YES;
  return NO;
}
@end
