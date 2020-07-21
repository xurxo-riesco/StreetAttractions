//
//  SlideOutViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "SlideOutViewController.h"

@interface SlideOutViewController ()<SettingsViewControllerDelegate>

@end

@implementation SlideOutViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  // Displays the button to performer settings based on the isPerformer user's property
  if ([User currentUser].isPerfomer) {
    self.performerButton.alpha = 1;
  } else {
    self.performerButton.alpha = 0;
  }

  [self loadProfile];
}

// Loads all labels and views of the controller with the current user's information
- (void)loadProfile
{
  User *user = [User currentUser];
  self.usernameLabel.text = [NSString stringWithFormat:@"@%@", user.username];
  self.screennameLabel.text = user.screenname;
  self.cityLabel.text = user.location;
  self.profilePic.layer.cornerRadius = 71;
  self.profilePic.layer.masksToBounds = YES;
  self.profilePic.file = user.profilePic;
  [self.profilePic loadInBackground];
}

- (IBAction)onLogOut:(id)sender
{
  // Log outs from Facebook if user has logged in using that option
  if ([FBSDKAccessToken currentAccessToken]) {
    [FBSDKAccessToken setCurrentAccessToken:nil];
  }

  // Returns to the login page
  AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  LoginViewController *loginViewController = [storyboard
  instantiateViewControllerWithIdentifier:@"LoginViewController"];
  appDelegate.window.rootViewController = loginViewController;

  // Logs the user out of the back end
  [PFUser logOutInBackgroundWithBlock:^(NSError *_Nullable error){
  }];
}

#pragma mark - SettingsViewController Delegate
// Reloads all views and levels if the user has changed any of them in their settings
- (void)didUpdate
{
  [self loadProfile];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqual:@"soToProfile"]) {
    ProfileViewController *profileViewController = [segue destinationViewController];
    profileViewController.user = [User currentUser];
  } else if ([segue.identifier isEqual:@"toPerformerSettings"]) {
    PerformerSettingsViewController *perfomerSettingsViewController = [segue destinationViewController];
  } else {
    SettingsViewController *settingsViewController = [segue destinationViewController];
    settingsViewController.delegate = self;
  }
}

@end
