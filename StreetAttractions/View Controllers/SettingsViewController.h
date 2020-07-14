//
//  SettingsViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/14/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;
//Models
#import "User.h"
NS_ASSUME_NONNULL_BEGIN
@protocol SettingsViewControllerDelegate
- (void) didUpdate;
@end


@interface SettingsViewController : UIViewController
@property (nonatomic, weak) id<SettingsViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *libraryButton;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (weak, nonatomic) IBOutlet UITextField *screenNameField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *oldPassField;
@property (weak, nonatomic) IBOutlet UITextField *passField;
@property (strong, nonatomic) UIImage *image;

@end

NS_ASSUME_NONNULL_END
