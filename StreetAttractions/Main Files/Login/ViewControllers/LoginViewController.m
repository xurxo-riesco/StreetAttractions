//
//  LoginViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UIViewControllerTransitioningDelegate, FBSDKLoginButtonDelegate, UITextFieldDelegate>
@end

@implementation LoginViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.passwordField.secureTextEntry = true;

  // TextField Set Up
  self.passwordField.delegate = self;
  self.usernameField.delegate = self;

  // Loging button is added programatically to allow for complex animations
  [self createPresentControllerButton];

  // Adding Facebook LogIn Button Programatically
  FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
  loginButton.delegate = self;
  CGPoint point = CGPointMake(self.view.center.x, self.view.center.y + 360);
  loginButton.center = point;
  loginButton.permissions = @[@"user_location", @"email"];
  [self.view addSubview:loginButton];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  return YES;
}

// Visual Set Up for Login Button
- (void)createPresentControllerButton
{
  HyLoginButton *loginButton = [[HyLoginButton alloc]
  initWithFrame:CGRectMake(40, 400, [UIScreen mainScreen].bounds.size.width - 80, 40)];
  [loginButton setBackgroundColor:[UIColor colorWithRed:239.0 / 255.0 green:235.0 / 255.0 blue:234.0 / 255.0 alpha:1]];
  [loginButton setTitle:@"Log In" forState:UIControlStateNormal];
  [loginButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
  loginButton.layer.cornerRadius = 4;
  loginButton.layer.masksToBounds = YES;
  [loginButton addTarget:self action:@selector(PresentViewController:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:loginButton];
}

// Transition logic and animation after login
- (void)PresentViewController:(HyLoginButton *)button
{
  ;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    // User is logged in in the backend
    [self loginUserWithCompletion:^(BOOL success, NSError *error) {
      if (success) {
        [button succeedAnimationWithCompletion:^{
          [self segueToApp];
        }];
      } else {
        [button failedAnimationWithCompletion:^{
        }];
        NSLog(@"User log in failed");
        // Alert controller is presented specifying error in case of unsuccesfull log in
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:error.localizedDescription
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Retry"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *_Nonnull action) {
                                                               [button removeFromSuperview];
                                                               [self createPresentControllerButton];
                                                             }];
        [alert addAction:cancelAction];
        [self presentViewController:alert
                           animated:YES
                         completion:^{
                         }];
      }
    }];
  });
}

// Logging in the user to the server
- (void)loginUserWithCompletion:(void (^)(BOOL success, NSError *error))completion
{
  NSString *username = self.usernameField.text;
  NSString *password = self.passwordField.text;
  [PFUser logInWithUsernameInBackground:username
                               password:password
                                  block:^(PFUser *user, NSError *error) {
                                    if (error != nil) {
                                      completion(NO, error);
                                    } else {
                                      NSLog(@"User logged in successfully");
                                      completion(YES, nil);
                                    }
                                  }];
}

#pragma mark - FBSDKLoginButtonDelegate
- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error
{
  // Connects the User class from the Parse server with Facebook Log In
  [PFFacebookUtils
  logInInBackgroundWithReadPermissions:@[@"user_location", @"email"]
                                 block:^(PFUser *_Nullable user, NSError *_Nullable error) {
                                   if (user.isNew) {
                                     // Graph Request of necessary fields to create Parse User if it's first Facebook
                                     // Log In
                                     FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                     initWithGraphPath:@"/me"
                                            parameters:@{
                                              @"fields": @"id,name,location,email,short_name",
                                            }
                                            HTTPMethod:@"GET"];
                                     [request startWithCompletionHandler:^(
                                              FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                       NSLog(@"%@", result);
                                       User *newUser = (User *)user;
                                       NSArray *location = [result[@"location"][@"name"]
                                       componentsSeparatedByString:@","];
                                       newUser.location = location[0];
                                       newUser.screenname = result[@"short_name"];
                                       NSString *userId = result[@"id"];
                                       newUser.username = [NSString
                                       stringWithFormat:@"%@%@", result[@"short_name"], [userId substringToIndex:2]];
                                       NSData *imageData = UIImagePNGRepresentation(
                                       [UIImage systemImageNamed:@"person.circle"]);
                                       PFFileObject *profilePicture = [PFFileObject fileObjectWithName:@"image.png"
                                                                                                  data:imageData];
                                       newUser.profilePic = profilePicture;
                                       [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *_Nullable error) {
                                         [self segueToApp];
                                       }];
                                     }];
                                   } else if (user) {
                                     [self segueToApp];
                                   }
                                 }];
}

// Correct transition to the app since the slide out view controller needs to be instantiated programaticall
- (void)segueToApp
{
  AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  UINavigationController *centerNav = [storyboard instantiateViewControllerWithIdentifier:@"tabBarViewController"];
  UINavigationController *leftNav = [storyboard instantiateViewControllerWithIdentifier:@"leftDrawer"];
  self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:centerNav
                                                          leftDrawerViewController:leftNav];
  self.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModePanningCenterView;
  self.drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModePanningCenterView;
  self.drawerController.title = @"Timeline";
  appDelegate.window.rootViewController = self.drawerController;
  [appDelegate.window makeKeyAndVisible];
}

- (void)loginButtonDidLogOut:(nonnull FBSDKLoginButton *)loginButton
{
}

/*
 #pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 }
 */

@end
