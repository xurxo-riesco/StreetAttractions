//
//  FavoritesViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>

//View Controllers
#import "DetailsViewController.h"

//Views
#import "FavoriteCell.h"

//Models
#import "Post.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface FavoritesViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) NSArray *userCategories;
@property (strong, nonatomic) NSArray *userFavorites;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (assign, nonatomic) int dataSkip;
@property (strong, nonatomic) User *user;

@end

NS_ASSUME_NONNULL_END
