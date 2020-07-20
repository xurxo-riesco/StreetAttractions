//
//  SignUpViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/PFUser.h"

//Models
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignUpViewController : UIViewController

/**
    Field for user's current location, should be a city
*/
@property (weak, nonatomic) IBOutlet UITextField *locationField;

/**
    Field to input a username, it needs to be unique
*/
@property (weak, nonatomic) IBOutlet UITextField *usernameField;

/**
    Field to input a screen name, does not need to  be unique
*/
@property (weak, nonatomic) IBOutlet UITextField *screennameField;

/**
    Field to choose a password
*/
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

/**
    Default profile image, can be tapped to choose a profile image
*/
@property (strong, nonatomic) UIImage *image;
@end

NS_ASSUME_NONNULL_END
