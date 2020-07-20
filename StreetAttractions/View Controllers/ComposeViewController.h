//
//  ComposeViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGProgressHUD.h"

//View Controllers
#import "LocationsViewController.h"

//Models
#import "User.h"
#import "Category.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate
- (void) didPost;
@end

@interface ComposeViewController : UIViewController
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *mediaButton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UILabel *upcomingLabel;
@property (weak, nonatomic) IBOutlet UISwitch *upcomingSwitch;

@end

NS_ASSUME_NONNULL_END
