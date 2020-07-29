//
//  LoginViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <UIKit/UIKit.h>

#import "HyLoginButton.h"
#import "HyTransitions.h"
#import "Parse/PFUser.h"

// View Controllers
#import "HomeViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController

/**
    Field for user's unique username
*/
@property (weak, nonatomic) IBOutlet UITextField *usernameField;

/**
    Field to enter user's password, secure text entry is enabled
*/
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

/**
    Controller enables slideout menu
*/
@property (strong, nonatomic) MMDrawerController *drawerController;

@end

NS_ASSUME_NONNULL_END
