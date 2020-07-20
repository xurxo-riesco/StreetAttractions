//
//  HomeViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
//View Controllers
#import "DetailsViewController.h"
#import "ComposeViewController.h"
//Views
#import "HomeCell.h"
//Models
#import "User.h"
#import "Post.h"
#import "Category.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController

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

@end

NS_ASSUME_NONNULL_END
