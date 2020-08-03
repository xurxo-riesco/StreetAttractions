//
//  FavoritesViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>

// View Controllers
#import "DetailsViewController.h"
#import "ProfileViewController.h"
// Views
#import "FavoriteCell.h"

// Models
#import "Post.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface FavoritesViewController : UIViewController

/**
    Array of favorite posts
*/
@property (strong, nonatomic) NSMutableArray<Post *> *posts;

/**
    Array of categories favorited by the user
*/
@property (strong, nonatomic) NSArray *userCategories;

/**
    Array of users favorited by current user
*/
@property (strong, nonatomic) NSArray *userFavorites;

/**
   Helper bool used for infinite scrolling
*/
@property (assign, nonatomic) BOOL isMoreDataLoading;

/**
   Holds the number of fetched post to send as query parameter when fetching more posts via infinite scrolling
*/
@property (assign, nonatomic) int dataSkip;

/**
   Temporarely holds the user of a post author (Used for seguing)
*/
@property (strong, nonatomic) User *user;

/**
   Refresh Control
*/
@property (strong, nonatomic) UIRefreshControl *refreshControl;

/**
   TableView containing all posts under a favorited user or category
*/
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
