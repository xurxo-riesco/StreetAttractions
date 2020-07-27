//
//  ComposeViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "ComposeViewController.h"

@interface ComposeViewController () <UIPickerViewDelegate, UIPickerViewDataSource, LocationsViewControllerDelegate, UITextViewDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchCategories];
    
    // PickerView Set Up
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    // TextView Set Up
    self.descriptionText.delegate = self;
    self.descriptionText.text = @"Write a description...";
    self.descriptionText.textColor = [UIColor lightGrayColor];
    
    // Initial UI Set Up
    self.mediaButton.layer.cornerRadius = 16;
    self.mediaButton.layer.masksToBounds = YES;
    self.locationButton.layer.cornerRadius = 16;
    self.locationButton.layer.masksToBounds = YES;
    self.image = [UIImage imageNamed:@"placeholder.png"];
    
    // Upcoming post option is user isPerfomer
    if([User currentUser].isPerfomer){
        self.upcomingLabel.alpha = 1;
        self.upcomingSwitch.alpha = 1;
    }else{
        self.upcomingLabel.alpha = 0;
        self.upcomingSwitch.alpha = 0;
    }
}

#pragma mark - TextField Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Write a description..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Write a description...";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - ImagePicker Deployment
- (IBAction)onAddMedia:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark - ImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    UIImage *resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(960, 1440)];
    self.image = resizedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Image Manipulation
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Posting
- (IBAction)onPost:(id)sender {
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"Posting";
    [HUD showInView:self.view];
    BOOL readyToPost = [self verify];
    if(readyToPost)
    {
        BOOL upcoming = NO;
        if(self.upcomingSwitch.on){
            upcoming = YES;
        }else{
            self.upcomingDate = [NSDate date];
        }
        // Sends post to the server after it is verified as valid locally
        [Post postUserImage:self.image withCaption:self.descriptionText.text forLatitude:self.latitude forLongitude:self.longitude toCategory:self.category isUpcoming:upcoming forDate:self.upcomingDate withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"POSTED");
                [HUD dismiss];
                [self.delegate didPost];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else{
        // Alert controller is presented specifying error in case of unsuccesfull posting
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Please make sure you complete all fields!"
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
}

// Verifies user has completed all inputs succesfully before sending the post to the backend
- (BOOL)verify {
    if ([self.descriptionText.text isEqualToString:@"Write a description..."]) {
        return NO;
    }
    if (self.latitude == nil){
        return NO;
    }
    if (self.category == nil){
        return NO;
    }
    return YES;
}

// Changes the template of the description if a post is marked as upcoming
- (IBAction)onUpcoming:(id)sender {
    if(self.upcomingSwitch.on){
        self.descriptionText.text = @"Upcoming performance! Time: Day:";
        self.datePicker=[[UIDatePicker alloc]init];

        self.datePicker.datePickerMode=UIDatePickerModeDate;

        [self.dateTextField setInputView:self.datePicker];

            UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];

            [toolBar setTintColor:[UIColor grayColor]];

        /* Here we are adding a done button so that we can close our picker after date selection */

            UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(ShowSelectedDate)];

            UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

            [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];

            [self.dateTextField setInputAccessoryView:toolBar];
                        [self.dateTextField becomeFirstResponder];

    }else{
        self.descriptionText.text = @"";
    }
}

-(void)ShowSelectedDate

{

    /* here we are adding the format which will be shown to the selected date */

    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];

    [formatter setDateFormat:@"dd/MMM/YYYY"];

    self.upcomingDate = self.datePicker.date;


      [self.dateTextField resignFirstResponder];

}
#pragma mark - LocationsViewController Delegate
- (void)locationsViewController:(LocationsViewController *)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude {
    self.latitude = latitude;
    self.longitude = longitude;    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Network
- (void)fetchCategories{
    PFQuery *categoriesQuery = [Category query];
    categoriesQuery.limit = 10;
    [categoriesQuery findObjectsInBackgroundWithBlock:^(NSArray <Category*>* _Nullable categories, NSError * _Nullable error) {
        if (categories) {
            self.categories = categories;
            [self.pickerView reloadAllComponents];
        }
    }];
}

#pragma mark - PickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.categories.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Category *category = self.categories[row];
    return category.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
     Category *category = self.categories[row];
    self.category = category.name;
}

#pragma mark - Navigation
- (IBAction)onAddLocation:(id)sender {
    [self performSegueWithIdentifier:@"tagSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LocationsViewController *locationsViewController = [segue destinationViewController];
    locationsViewController.delegate = self;
}

@end
