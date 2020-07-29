//
//  CategoryFeedViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSString+ColorCode.h"

// View Controllers
#import "DetailsViewController.h"

// Views
#import "HomeCell.h"

// Models
#import "Category.h"
#import "Post.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoryFeedViewController : UIViewController

/**
   Holds the category of the feed
*/
@property (strong, nonatomic) Category *category;

/**
   Temporarely holds the post of a cell (Used for seguing)
*/
@property (strong, nonatomic) Post *post;

/**
   Array of posts within a category
*/
@property (strong, nonatomic) NSMutableArray *posts;

/**
   Holds the number of fetched post to send as query parameter when fetching more posts via infinite scrolling
*/
@property (assign, nonatomic) int dataSkip;

/**
   Helper bool used for infinite scrolling
*/
@property (assign, nonatomic) BOOL isMoreDataLoading;

/**
   Bar button used for favoriting a category
*/
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

/**
   Collection View of posts pertaining to a category
*/
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

/**
   Refresh Control
*/
@property (strong, nonatomic) UIRefreshControl *refreshControl;

// Favorites the category in the backend
- (void)favorite;

// Unfavorites the category in the backend
- (void)unfavorite;

@end

NS_ASSUME_NONNULL_END
