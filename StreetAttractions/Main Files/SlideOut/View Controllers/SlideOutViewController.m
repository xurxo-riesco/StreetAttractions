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
    self.collabButton.alpha = 1;
    self.verifiedButton.alpha = 0;
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
  self.qrView.image = [UIImage DY_QRCodeImageWithString:[User currentUser].username size:300.f];
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

- (IBAction)onVerified:(id)sender
{
  if ([MFMailComposeViewController canSendMail]) {
    MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
    mailCont.mailComposeDelegate = self;

    NSString *subject = [NSString stringWithFormat:@"[VERIFICATION] Performer's account request for : %@ in %@",
                                                   [User currentUser].username,
                                                   [User currentUser].location];
    [mailCont setSubject:subject];
    [mailCont setToRecipients:[NSArray arrayWithObject:@"getverified@streetattractions.com"]];
    [mailCont setMessageBody:
              @"Write below your handle for any social media you use or attach videos or pictures of your performances "
              @"so our team can revise them and grant you access to the performer's features. After revision, you will "
              @"be contacted to set up in app payments for your account."
                      isHTML:NO];
    [self presentViewController:mailCont animated:YES completion:nil];
  }
}

#pragma mark - MailCompose Delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
  [self dismissViewControllerAnimated:YES completion:nil];
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
  } else if ([segue.identifier isEqual:@"toCollab"]) {
    CollabViewController *collabViewController = [segue destinationViewController];
  } else if ([segue.identifier isEqual:@"toCalendar"]) {
    CalendarViewController *calendarViewController = [segue destinationViewController];
  } else {
    SettingsViewController *settingsViewController = [segue destinationViewController];
    settingsViewController.delegate = self;
  }
}

@end
