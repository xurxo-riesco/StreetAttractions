//
//  SignUpViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()<UIImagePickerControllerDelegate, UITextFieldDelegate>
@end

@implementation SignUpViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.passwordField.secureTextEntry = YES;

  // TextField Delegate Set Up
  self.passwordField.delegate = self;
  self.locationField.delegate = self;
  self.usernameField.delegate = self;
  self.screennameField.delegate = self;
}

// ImagePicker set up for profile pic
- (IBAction)onProfilePic:(id)sender
{
  UIImagePickerController *imagePickerVC = [UIImagePickerController new];
  imagePickerVC.delegate = self;
  imagePickerVC.allowsEditing = YES;
  imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark - ImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info
{
  UIImage *editedImage = info[UIImagePickerControllerEditedImage];
  UIImage *resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(960, 1440)];
  self.image = resizedImage;
  [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Image Manipulation
// Method is used to ensure that images sent to the backend don't exceed the maximun server size
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size
{
  UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
  resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
  resizeImageView.image = image;
  UIGraphicsBeginImageContext(size);
  [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return newImage;
}

// Calls to sign the user up in the backend after pressing the sign up button
- (IBAction)onSignUp:(id)sender
{
  [self registerUser];
}

// Registers a new user in the Parse server
- (void)registerUser
{
  // Loading HUD is shown while users is registered
  JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
  HUD.textLabel.text = @"Signing up...";
  [HUD showInView:self.view];
  User *newUser = [User user];
  newUser.username = self.usernameField.text;
  newUser.password = self.passwordField.text;
  newUser.location = self.locationField.text;

  // Adds a profile image as chosen by the user or the default one if no choice is made
  if (self.image != nil) {
    NSData *imageData = UIImagePNGRepresentation(self.image);
    PFFileObject *profilePicture = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
    newUser.profilePic = profilePicture;
  } else {
    NSData *imageData = UIImagePNGRepresentation([UIImage systemImageNamed:@"person.circle"]);
    PFFileObject *profilePicture = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
    newUser.profilePic = profilePicture;
  }

  // If the user tries to register without a screen name, the unique username will also be used as the screen name
  if (self.screennameField.text != 0) {
    newUser.screenname = self.screennameField.text;
  } else {
    newUser.screenname = self.usernameField.text;
  }

  // Saves the new user to the server
  [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (error != nil) {
      // Alert controller is presented specifying error in case of unsuccesfull sign up
      NSLog(@"Error: %@", error.localizedDescription);
      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                     message:error.localizedDescription
                                                              preferredStyle:(UIAlertControllerStyleAlert)];
      UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Retry"
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction *_Nonnull action){
                                                           }];
      [alert addAction:cancelAction];
      [self presentViewController:alert
                         animated:YES
                       completion:^{
                         [HUD dismiss];
                       }];
    } else {
      // Dismisses the hud and sends the user to the Home Page
      NSLog(@"User registered successfully");
      [HUD dismiss];
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

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  return YES;
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
