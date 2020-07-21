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

// Models
#import "User.h"

// ViewControllers
#import "LoginViewController.h"
#import "PerformerSettingsViewController.h"
#import "ProfileViewController.h"
#import "SettingsViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SlideOutViewController : UIViewController

/**
    Button to access performance settings (Only displayed if the user has the isPerformer property)
*/
@property (strong, nonatomic) IBOutlet UIView *performerButton;

/**
    Shows the user's current profile pic
*/
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;

/**
    Shows the user's current screenname
*/
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;

/**
    Displays the username
*/
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

/**
    DIsplays the user's current city
*/
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@end

NS_ASSUME_NONNULL_END
