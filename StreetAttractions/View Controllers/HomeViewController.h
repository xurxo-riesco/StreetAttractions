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

@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) Post *post;
@property (assign, nonatomic) int dataSkip;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

NS_ASSUME_NONNULL_END
