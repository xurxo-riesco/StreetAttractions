//
//  SlideOutViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@import Parse;
//Models
#import "User.h"
//ViewControllers
#import "LoginViewController.h"
#import "SettingsViewController.h"
#import "ProfileViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface SlideOutViewController : UIViewController
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;


@end

NS_ASSUME_NONNULL_END
