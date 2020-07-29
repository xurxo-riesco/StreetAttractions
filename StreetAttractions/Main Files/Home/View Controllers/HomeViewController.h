//
//  HomeViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

@import Photos;
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#include <stdlib.h>

#import "AppDelegate.h"
#import "GreedoCollectionViewLayout.h"
#import "TNTutorialManager.h"

// View Controllers
#import "ComposeViewController.h"
#import "DetailsViewController.h"

// Views
#import "HomeCell.h"

// Models
#import "Category.h"
#import "Post.h"
#import "User.h"
#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController

@property (assign, nonatomic) BOOL hasFixedHeight;

/**
    Stores all fetched posts
*/
@property (nonatomic, strong) NSMutableArray *posts;

/**
    Temporarely stores the post needed for seguing to details
*/
@property (nonatomic, strong) Post *post;

/**
    Holds the total amount of fetched post so that it can serve as a query skip when fetching more
*/
@property (assign, nonatomic) int dataSkip;

/**
    Helper variable that allows for inifinity scrolling
*/
@property (assign, nonatomic) BOOL isMoreDataLoading;

/**
    View over the tab bar used for highlighting during the tutorial
*/
@property (weak, nonatomic) IBOutlet UIView *tabBarView;

/**
    Collection View displaying nearby posts
*/
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

/**
    Required tutorial property to allow for visual tutorial on first app use
*/
@property (strong, nonatomic) TNTutorialManager *tutorialManager;

/**
    Allows for dynamic collection view layout
*/
@property (strong, nonatomic) GreedoCollectionViewLayout *collectionViewSizeCalculator;

/**
    Refresh Control
*/
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

NS_ASSUME_NONNULL_END
