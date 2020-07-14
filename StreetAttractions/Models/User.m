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

+ (void)isFavorite: (Category*) category WithCompletion: (void(^)(BOOL))completion{
    User *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"FavCategories"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray<Category*>* _Nullable categories, NSError * _Nullable error) {
        for(Category *userCategory in categories)
        {
            if([userCategory.name isEqual:category.name]){
                completion(YES);
            }
        }
    }];
}
+ (void)getCategoriesWithCompletion: (void(^)(NSArray*))completion{
    User *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"FavCategories"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray<Category*>* _Nullable categories, NSError * _Nullable error) {
        if(!error){
            completion(categories);
        }
    }];
}
    

@end
