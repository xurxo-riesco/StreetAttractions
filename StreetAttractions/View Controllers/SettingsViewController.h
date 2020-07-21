//
//  SettingsViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/14/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

@import Parse;
#import <UIKit/UIKit.h>

// Models
#import "User.h"

NS_ASSUME_NONNULL_BEGIN
/*!
   @protocol ComposeViewControllerDelegate

   @brief Triggers after any change in User's profile

   Used to refresh the SlideOut Views after updating user's profile
*/
@protocol SettingsViewControllerDelegate
- (void)didUpdate;
@end

@interface SettingsViewController : UIViewController

/**
  Delegate property
*/
@property (nonatomic, weak) id<SettingsViewControllerDelegate> delegate;

/**
  Button to select camera is the ImagePicker destination
*/
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

/**
  Button to select library is the ImagePicker destination
*/
@property (weak, nonatomic) IBOutlet UIButton *libraryButton;

/**
 Displays current profile picture, can be tapped to edit
*/
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;

/**
  Field to alter screen name
*/
@property (weak, nonatomic) IBOutlet UITextField *screenNameField;

/**
  Field to alter location
*/
@property (weak, nonatomic) IBOutlet UITextField *cityField;

/**
  Field to input old password in case of requesting a password change
*/
@property (weak, nonatomic) IBOutlet UITextField *oldPassField;

/**
  Field to input old password in case of requesting a password change
*/
@property (weak, nonatomic) IBOutlet UITextField *passField;

/**
  Holds the profile image to send to the server
*/
@property (strong, nonatomic) UIImage *image;

@end

NS_ASSUME_NONNULL_END
