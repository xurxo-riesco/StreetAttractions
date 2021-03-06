//
//  SettingsViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/14/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate>

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  // TextView Set Up
  self.cityField.delegate = self;
  self.screenNameField.delegate = self;
  self.oldPassField.delegate = self;
  self.passField.delegate = self;

  // Initial UI Set Up
  self.cameraButton.alpha = 0;
  self.libraryButton.alpha = 0;
  User *user = [User currentUser];
  self.profilePic.layer.cornerRadius = 71;
  self.profilePic.layer.masksToBounds = YES;
  self.profilePic.file = user.profilePic;
  [self.profilePic loadInBackground];
  self.screenNameField.text = user.screenname;
  self.cityField.text = user.location;

  // Tap Gesture Set Up
  UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]
  initWithTarget:self
          action:@selector(didTapProfilePic:)];
  [self.profilePic addGestureRecognizer:profileTapGestureRecognizer];
  [self.profilePic setUserInteractionEnabled:YES];
}
- (void)didTapProfilePic:(UITapGestureRecognizer *)sender
{
  [UIView animateWithDuration:0.3
                   animations:^{
                     self.cameraButton.alpha = 1;
                     self.libraryButton.alpha = 1;
                   }];
}
#pragma mark - ImagePicker Options
- (IBAction)didTapLibrary:(id)sender
{
  UIImagePickerController *imagePickerVC = [UIImagePickerController new];
  imagePickerVC.delegate = self;
  imagePickerVC.allowsEditing = YES;
  imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)didTapCamera:(id)sender
{
  UIImagePickerController *imagePickerVC = [UIImagePickerController new];
  imagePickerVC.delegate = self;
  imagePickerVC.allowsEditing = YES;
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
  } else {
    NSLog(@"Camera not available so we will use photo library instead");
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  }
  [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark - ImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info
{
  UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
  UIImage *editedImage = info[UIImagePickerControllerEditedImage];
  UIImage *resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(960, 1440)];
  self.profilePic.image = resizedImage;
  [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Image Manipulation
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

- (IBAction)onUpdate:(id)sender
{
  User *user = [User currentUser];
  user.screenname = self.screenNameField.text;
  user.location = self.cityField.text;

  // Verifies old password before changing it
  if (self.oldPassField != 0) {
    if ([user.password isEqual:self.oldPassField.text]) {
      if (self.passField != 0) {
        user.password = self.passField.text;
      }
    }
  }
  self.image = self.profilePic.image;
  NSData *imageData = UIImagePNGRepresentation(self.image);
  PFFileObject *profilePicture = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
  user.profilePic = profilePicture;
  // Saves changes to the server
  [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!succeeded) {
      NSLog(@"Error: %@", error.localizedDescription);
    } else {
      // Alert controller is presented after all changes have succesfully reached the server
      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Profile"
                                                                     message:@"Changes updated succesfully"
                                                              preferredStyle:(UIAlertControllerStyleAlert)];
      UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok"
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction *_Nonnull action){
                                                           }];
      [alert addAction:cancelAction];
      [self presentViewController:alert
                         animated:YES
                       completion:^{
                         [self.navigationController popViewControllerAnimated:YES];
                       }];
      [self.delegate didUpdate];
    }
  }];
}
#pragma mark - TextField Delegate
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
