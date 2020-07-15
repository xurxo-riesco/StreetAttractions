//
//  DetailsViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DateTools.h"
#import "HCSStarRatingView.h"
//View Controllers
#import "ProfileViewController.h"
//Models
#import "User.h"
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet HCSStarRatingView *starView;
@property (nonatomic, strong) Post *post;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) User *user;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet PFImageView *mediaView;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

@end

NS_ASSUME_NONNULL_END
