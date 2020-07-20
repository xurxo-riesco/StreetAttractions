//
//  User.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <Parse/Parse.h>

//Models
#import "Category.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser<PFSubclassing>

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *venmo;
@property (nonatomic, strong) NSString *instagramName;
@property (nonatomic) BOOL isPerfomer;
@property (nonatomic) BOOL isLive;
@property (nonatomic, strong) NSString *liveURL;
@property (nonatomic, strong) PFFileObject *profilePic;
@property (nonatomic, strong) NSNumber *followersCount;

+ (void)isFavorite: (Category*) category WithCompletion: (void(^)(BOOL))completion;
+ (void)isFavoriteUser: (User*) user WithCompletion: (void(^)(BOOL))completion;
+ (void)hasLiked: (Post*) post WithCompletion: (void(^)(BOOL))completion;
+ (void)hasRated: (Post*) post WithCompletion: (void(^)(BOOL))completion;
+ (void)getCategoriesWithCompletion: (void(^)(NSArray *categories, NSArray *categoryStrings))completion;
+ (void)getFavoritesWithCompletion: (void(^)(NSArray<User*> *favorites))completion;
@end
NS_ASSUME_NONNULL_END
