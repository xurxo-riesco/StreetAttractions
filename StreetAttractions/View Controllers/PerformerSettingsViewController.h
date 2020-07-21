//
//  PerformerSettingsViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/20/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import "PNChart/PNChart.h"

// Models
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface PerformerSettingsViewController : UIViewController

/**
  Chart displaying the rating progression overtime
*/
@property (nonatomic) PNLineChart *lineChart;

/**
 Switch to go live
*/
@property (weak, nonatomic) IBOutlet UISwitch *liveSwitch;

/**
  Field to input live video url
*/
@property (weak, nonatomic) IBOutlet UITextField *streamField;

/**
  Stores the data used for graphing
*/
@property (strong, nonatomic) NSMutableArray *data01Array;

/**
  Displays the average rating within all posts
*/
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

/**
  Displays the total amount of likes
*/
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;

/**
  Displays the number of people that have marked the user as favorite
*/
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;

/**
  Stores the amount of likes summed from all the posts
*/
@property (nonatomic) NSInteger totalLikes;

/**
 Stores the average rating
*/
@property (nonatomic) float totalRating;

@end

NS_ASSUME_NONNULL_END
