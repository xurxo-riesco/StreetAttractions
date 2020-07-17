//
//  SlideOutViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "SlideOutViewController.h"

@interface SlideOutViewController () <SettingsViewControllerDelegate>

@end

@implementation SlideOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadProfile];
}
- (void) loadProfile{
    User *user = [PFUser currentUser];
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@",user.username];
    self.screennameLabel.text = user.screenname;
    self.cityLabel.text = user.location;
    self.profilePic.layer.cornerRadius = 71;
    self.profilePic.layer.masksToBounds = YES;
    self.profilePic.file = user.profilePic;
    [self.profilePic loadInBackground];
}
- (IBAction)onLogOut:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    }];
}
#pragma mark - SettingsViewController Delegate
- (void)didUpdate{
    [self loadProfile];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqual:@"soToProfile"]){
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.user = [PFUser currentUser];
    }else{
        SettingsViewController *settingsViewController = [segue destinationViewController];
        settingsViewController.delegate = self;
    }
}


@end
