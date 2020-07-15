//
//  Post.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) PFFileObject *media;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSNumber *timesRated;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSDate *createdAt;


+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption forLatitude:(NSNumber*)latitude forLongitude:(NSNumber *)longitude toCategory:(NSString*) category withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end
NS_ASSUME_NONNULL_END
