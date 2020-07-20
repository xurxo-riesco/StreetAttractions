//
//  SlideOutViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

@import Parse;
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

//Models
#import "User.h"

//ViewControllers
#import "LoginViewController.h"
#import "SettingsViewController.h"
#import "ProfileViewController.h"
#import "PerformerSettingsViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface SlideOutViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *performerButton;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;


@end

NS_ASSUME_NONNULL_END
