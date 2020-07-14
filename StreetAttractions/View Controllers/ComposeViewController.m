//
//  ComposeViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "ComposeViewController.h"
#import "JGProgressHUD.h"



@interface ComposeViewController () <UIPickerViewDelegate, UIPickerViewDataSource, LocationsViewControllerDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchCategories];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.descriptionText.delegate = self;
    self.descriptionText.text = @"Write a description...";
    self.descriptionText.textColor = [UIColor lightGrayColor];
    self.mediaButton.layer.cornerRadius = 16;
    self.mediaButton.layer.masksToBounds = YES;
    self.locationButton.layer.cornerRadius = 16;
    self.locationButton.layer.masksToBounds = YES;
    
    self.image = [UIImage imageNamed:@"placeholder.png"];
    // Do any additional setup after loading the view.
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

- (IBAction)onAddMedia:(id)sender {
}
- (IBAction)onAddLocation:(id)sender {
    [self performSegueWithIdentifier:@"tagSegue" sender:nil];
}
- (IBAction)onPost:(id)sender {
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"Posting";
    [HUD showInView:self.view];
    if ([self.descriptionText.text isEqualToString:@"Write a description..."]) {
        self.descriptionText.text = @"";
    }
    [Post postUserImage:self.image withCaption:self.descriptionText.text forLatitude:self.latitude forLongitude:self.longitude toCategory:self.category withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"POSTED");
            [HUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}


#pragma mark - Network
- (void) fetchCategories{
    PFQuery *categoriesQuery = [Category query];
    categoriesQuery.limit = 10;
    [categoriesQuery findObjectsInBackgroundWithBlock:^(NSArray <Category*>* _Nullable categories, NSError * _Nullable error) {
        if (categories) {
            self.categories = categories;
            [self.pickerView reloadAllComponents];
        }
    }];
}
#pragma mark - LocationsViewController Delegate
- (void)locationsViewController:(LocationsViewController *)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude {
    self.latitude = latitude;
    self.longitude = longitude;    
    [self.navigationController popViewControllerAnimated:YES];
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LocationsViewController *locationsViewController = [segue destinationViewController];
    locationsViewController.delegate = self;
}
@end
