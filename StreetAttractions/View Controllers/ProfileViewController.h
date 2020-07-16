//
//  ProfileViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BraintreeVenmo.h"
#import "BraintreeCore.h"
#import "BraintreeDropIn.h"
#import <CoreML/CoreML.h>
//#import "LocationPrediction1.h"
//#import "LocationPrediction2.h"
//#import "LocationPrediction3.h"
//#import "LocationPrediction1copy.h"
@import Parse;
//View Controllers
#import "DetailsViewController.h"
//Views
#import "HomeCell.h"
//Models
#import "User.h"
#import "Post.h"
NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) NSMutableArray *posts;
@property (assign, nonatomic) int dataSkip;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (weak, nonatomic) IBOutlet UIButton *isPerformer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *screenameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIButton *instaButton;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) NSMutableArray *latitudes;
@property (strong, nonatomic) NSMutableArray *longitudes;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

NS_ASSUME_NONNULL_END
