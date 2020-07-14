//
//  Post.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "Post.h"
#import "User.h"
#import "Category.h"

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
+ (nonnull NSString *)parseClassName {
    return @"Post";
}
+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption forLatitude:(NSNumber*)latitude forLongitude:(NSNumber *)longitude toCategory:(NSString*) category withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    Post *newPost = [Post new];
    newPost.media = [self getPFFileFromImage:image];
    User *author = [PFUser currentUser];
    newPost.author = author;
    newPost.city = author.location;
    newPost.caption = caption;
    newPost.likeCount = @(0);
    newPost.latitude = latitude;
    newPost.longitude = longitude;
    newPost.category = category;
    [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded)
        {
            [newPost addPost:newPost toCategory:category withCompletion:completion];
        }
    }];
}
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}
-(void) addPost: (Post *)post toCategory: (NSString*) name withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    PFQuery *categoryQuery = [Category query];
    [categoryQuery whereKey:@"name" equalTo:name];
    categoryQuery.limit = 1;
    [categoryQuery findObjectsInBackgroundWithBlock:^(NSArray <Category*> * _Nullable objects, NSError * _Nullable error) {
        if(!error)
        {
            Category *category = objects[0];
            NSLog(@"%@", category);
            PFRelation *relation = [category relationForKey:@"Posts"];
            [relation addObject:post];
            [category saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded){
                    [post saveInBackgroundWithBlock:completion];
                }
            }];
        }
    }];
}
@end

