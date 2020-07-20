//
//  PerformerSettingsViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/20/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import "PNChart/PNChart.h"

//Models
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface PerformerSettingsViewController : UIViewController
@property (nonatomic) PNLineChart * lineChart;
@property (weak, nonatomic) IBOutlet UISwitch *liveSwitch;
@property (weak, nonatomic) IBOutlet UITextField *streamField;
@property (strong, nonatomic) NSMutableArray * data01Array;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (nonatomic) NSInteger totalLikes;
@property (nonatomic) float totalRating;

@end

NS_ASSUME_NONNULL_END
