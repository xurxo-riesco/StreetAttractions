//
//  User.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <Parse/Parse.h>
#import "Category.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser<PFSubclassing>

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *venmo;
@property (nonatomic) BOOL *isPerfomer;
@property (nonatomic, strong) PFFileObject *profilePic;

+ (void)isFavorite: (Category*) category WithCompletion: (void(^)(BOOL))completion;
+ (void)getCategoriesWithCompletion: (void(^)(NSArray*))completion;
@end
NS_ASSUME_NONNULL_END
