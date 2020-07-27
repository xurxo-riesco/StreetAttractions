//
//  ComposeViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGProgressHUD.h"

// View Controllers
#import "LocationsViewController.h"

// Models
#import "Category.h"
#import "Post.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

/*!
   @protocol ComposeViewControllerDelegate

   @brief Triggers after new post is sent to the server

   Used to refresh the Home Feed TableView after posting
*/
@protocol ComposeViewControllerDelegate
- (void)didPost;
@end

@interface ComposeViewController : UIViewController

/**
  Delegate property
*/
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;

/**
  Button to access the ImagePicker
*/
@property (weak, nonatomic) IBOutlet UIButton *mediaButton;

/**
  Button to select post's location
*/
@property (weak, nonatomic) IBOutlet UIButton *locationButton;

/**
  Button to access the ImagePicker
*/
@property (nonatomic, strong) NSArray *categories;

/**
  Holds the chosen latitude for the post
*/
@property (nonatomic, strong) NSNumber *latitude;

/**
  Holds the chosen longitude for the post
*/
@property (nonatomic, strong) NSNumber *longitude;

/**
  Holds the chosen category for the post
*/
@property (nonatomic, strong) NSString *category;

/**
  Holds the chosen image for the post
*/
@property (nonatomic, strong) UIImage *image;

/**
 Displays option if user is performer
*/
@property (weak, nonatomic) IBOutlet UILabel *upcomingLabel;

/**
  Allows performers to mark a post as upcoming
*/
@property (weak, nonatomic) IBOutlet UISwitch *upcomingSwitch;

/**
  Stores date of upcoming performance
*/
@property (strong, nonatomic) NSDate *upcomingDate;

/**
  Allows performance to pick the date of the upcoming performance
*/
@property (strong, nonatomic)UIDatePicker *datePicker;

/**
  Helper field to host the Date Picker
*/
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;

@end

NS_ASSUME_NONNULL_END
