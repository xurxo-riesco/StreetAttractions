//
//  PhotoMapViewController.m
//  PhotoMap
//
//  Original by emersonmalca on 7/8/18.
//  Refactored by Xurxo Riesco on 7/13/20.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "NSString+ColorCode.h"
#import "OWMWeatherAPI.h"
#import "PhotoMapViewController.h"

@interface PhotoMapViewController ()<UIImagePickerControllerDelegate, CLLocationManagerDelegate, BottomSheetVCDelegate>

@end

@implementation PhotoMapViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  // Visual Set Up
  self.weatherBorder.layer.cornerRadius = 8;
  self.weatherBorder.layer.masksToBounds = YES;

  // Request List Set Up
  if ([User currentUser].isPerfomer) {
    self.leftButton.tintColor = [UIColor blackColor];
    self.leftButton.enabled = YES;
  } else {
    self.leftButton.tintColor = [UIColor clearColor];
    self.leftButton.enabled = NO;
  }

  // Map Set Up
  [self startUserLocationSearch];
  self.mapView.delegate = self;

  // Initial network call
  [self fetchPost];
  [self fetchCategories];
}
#pragma mark - CLLocationManager Delegate
// Helper function to start retrieving user's location
- (void)startUserLocationSearch
{
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  self.locationManager.distanceFilter = kCLDistanceFilterNone;
  self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
  if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
    [self.locationManager requestWhenInUseAuthorization];
  }
  [self.locationManager startUpdatingLocation];
}

// Helper function to set weather and map camera after location is retrieved
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
  OWMWeatherAPI *weatherAPI = [[OWMWeatherAPI alloc] initWithAPIKey:@"e4720f67727286ea84123b9b759b4a54"];
  [self.locationManager stopUpdatingLocation];
  CGFloat usersLatitude = self.locationManager.location.coordinate.latitude;
  CGFloat usersLongidute = self.locationManager.location.coordinate.longitude;
  MKCoordinateRegion userRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(usersLatitude, usersLongidute),
                                                         MKCoordinateSpanMake(0.1, 0.1));
  [self.mapView setRegion:userRegion animated:false];
  CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(usersLatitude, usersLongidute);
  [weatherAPI
  currentWeatherByCoordinate:coordinate
                withCallback:^(NSError *error, NSDictionary *result) {
                  NSNumber *currentTemp = result[@"main"][@"temp"];
                  self.tempLabel.text = [NSString stringWithFormat:@"%2.0f C°", currentTemp.floatValue];
                  NSString *iconcode = result[@"weather"][0][@"icon"];
                  NSString *url = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png", iconcode];
                  NSURL *imageURL = [NSURL URLWithString:url];
                  [self.weatherImage setImageWithURL:imageURL];
                }];
  self.mapView.delegate = self;
}

#pragma mark - Annotations
- (AnnotationPin *)mapView:(MKMapView *)mapView viewForAnnotation:(Annotation *)annotation
{
  AnnotationPin *annotationView = (AnnotationPin *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
  if (annotationView == nil) {
    annotationView = [[AnnotationPin alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
    annotationView.canShowCallout = true;
    annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
  }
  Post *post = annotation.post;
  PFFileObject *data = post.media;
  [data getDataInBackgroundWithBlock:^(NSData *_Nullable data, NSError *_Nullable error) {
    if (error == nil) {
      UIImage *image = [UIImage imageWithData:data];
      UIImageView *imageView = (UIImageView *)annotationView.leftCalloutAccessoryView;
      imageView.image = image;
    } else {
      NSLog(@"Error");
    }
  }];
  UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  [detailButton setImage:[UIImage systemImageNamed:@"info.circle"] forState:UIControlStateNormal];
  annotationView.rightCalloutAccessoryView = detailButton;
  annotationView.pinTintColor = [post.category colorCode];
  annotationView.draggable = annotation.draggable;
  return annotationView;
}

// Anotation Delegate
- (void)mapView:(MKMapView *)mapView
               annotationView:(AnnotationPin *)view
calloutAccessoryControlTapped:(UIControl *)control
{
  Annotation *annotation = view.annotation;
  self.post = annotation.post;
  [self performSegueWithIdentifier:@"mapToDetails" sender:nil];
}

#pragma mark - Network
- (void)fetchPost
{
  PFQuery *postQuery = [Post query];
  postQuery.limit = 20;
  [postQuery includeKey:@"author"];
  User *user = [User currentUser];
  [postQuery orderByDescending:@"created_At"];
  [postQuery whereKey:@"city" equalTo:user.location];
  [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> *_Nullable posts, NSError *_Nullable error) {
    if (posts) {
      self.posts = [posts mutableCopy];
      for (Post *post in posts) {
        NSNumber *latitude = post.latitude;
        NSNumber *longitude = post.longitude;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue);
        Annotation *annotation = [Annotation new];
        annotation.coordinate = coordinate;
        annotation.title = [NSString stringWithFormat:@"%@ (%@)", post.category, post.created_At.shortTimeAgoSinceNow];
        annotation.post = post;
        annotation.draggable = NO;
        [self.mapView addAnnotation:annotation];
      }
    }
  }];
}

// Fetches all categories to display in the picker view when user wants to add a request
- (void)fetchCategories
{
  PFQuery *categoriesQuery = [Category query];
  categoriesQuery.limit = 10;
  [categoriesQuery
  findObjectsInBackgroundWithBlock:^(NSArray<Category *> *_Nullable categories, NSError *_Nullable error) {
    if (categories) {
      self.categories = categories;
      [self.pickerView reloadAllComponents];
    }
  }];
}

#pragma mark - Request Flow

// Adds initial pin to be dragged for request
- (IBAction)onAddRequest:(id)sender
{
  Annotation *annotation = [Annotation new];
  CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude,
                                                                 self.locationManager.location.coordinate.longitude);
  annotation.coordinate = coordinate;
  annotation.title = @"New Request";
  annotation.draggable = YES;
  [self.mapView addAnnotation:annotation];
}

// Displays the list of request to performers
- (IBAction)onRequestList:(id)sender
{
  [self performSelector:@selector(PresentBottomSheet)];
}

- (void)PresentBottomSheet
{
  // View controller the bottom sheet will hold
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  NSString *identifier = @"BottomSheetVC";
  BottomSheetViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:identifier];

  // Initialize the bottom sheet with the view controller just created
  viewController.delegate = self;
  MDCBottomSheetController *bottomSheet = [[MDCBottomSheetController alloc]
  initWithContentViewController:viewController];
  bottomSheet.dismissOnDraggingDownSheet = YES;
  // Present the bottom sheet
  [self presentViewController:bottomSheet animated:true completion:nil];
}

// Call to add request after dropping the pin in new location
- (void)mapView:(MKMapView *)mapView
    annotationView:(MKAnnotationView *)view
didChangeDragState:(MKAnnotationViewDragState)newState
      fromOldState:(MKAnnotationViewDragState)oldState;
{
  if (newState == MKAnnotationViewDragStateEnding) {
    CLLocationCoordinate2D droppedAt = view.annotation.coordinate;

    CLLocation *draglocation = [[CLLocation alloc] initWithLatitude:droppedAt.latitude longitude:droppedAt.longitude];
    [self requestForAnnotation:view.annotation];
  }
}

// Present alert controller to input request information
- (void)requestForAnnotation:(Annotation *)annotation
{
  self.alertController = [UIAlertController alertControllerWithTitle:@"Add a Performance Request"
                                                             message:@""
                                                      preferredStyle:UIAlertControllerStyleAlert];

  // Text Field for Description
  [self.alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    textField.placeholder = @"Brief description";
    textField.textColor = [UIColor blackColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.borderStyle = UITextBorderStyleRoundedRect;
  }];

  // Text Field for Date
  [self.alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    textField.placeholder = @"Date";
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    // Done button after date selection
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(RequestDate)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space, doneBtn, nil]];
    [textField setInputAccessoryView:toolBar];
    [textField setInputView:self.datePicker];
    textField.textColor = [UIColor blackColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.borderStyle = UITextBorderStyleRoundedRect;
  }];

  // Text Field for Category
  [self.alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    textField.placeholder = @"Category";
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    // Done button after selection
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(RequestCategory)];

    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space, doneBtn, nil]];
    [textField setInputAccessoryView:toolBar];
    [textField setInputView:self.pickerView];
    textField.textColor = [UIColor blackColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.borderStyle = UITextBorderStyleRoundedRect;
  }];

  // OK Button to Submit the Request
  [self.alertController
  addAction:[UIAlertAction actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {
                                     PerformanceRequest *request = [PerformanceRequest new];
                                     request.brief = self.alertController.textFields[0].text;
                                     request.date = self.alertController.textFields[1].text;
                                     request.category = self.alertController.textFields[2].text;
                                     request.city = [User currentUser].location;
                                     request.latitude = [NSNumber numberWithFloat:annotation.coordinate.latitude];
                                     request.longitude = [NSNumber numberWithFloat:annotation.coordinate.longitude];
                                     request.author = [User currentUser];
                                     [request saveInBackground];
                                   }]];
  [self presentViewController:self.alertController animated:YES completion:nil];
}

// Creates a string from the Date Picker
- (void)RequestDate
{
  self.date = self.datePicker.date;
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

  [formatter setDateFormat:@"dd/MMM/YYYY"];
  self.alertController.textFields[1].text = [formatter stringFromDate:self.date];
  [self.alertController.textFields[1] resignFirstResponder];
}

// Dismiss the Category Picker after selection
- (void)RequestCategory
{
  [self.alertController.textFields[2] resignFirstResponder];
}

#pragma mark - BottomSheetVC Delegate
// Resets the MapView Camera to show the requests lcoation
- (void)didHighlight:(PerformanceRequest *)request
{
  // Removes the previous previewed annotation
  [self.mapView removeAnnotation:self.annotation];

  // Calculates the new camera position
  MKCoordinateRegion requestRegion = MKCoordinateRegionMake(
  CLLocationCoordinate2DMake((request.latitude.floatValue - 0.03), request.longitude.floatValue),
  MKCoordinateSpanMake(0.1, 0.1));
  [self.mapView setRegion:requestRegion animated:false];

  // Adds annotation for that position
  self.annotation = [Annotation new];
  CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.latitude.floatValue,
                                                                 request.longitude.floatValue);
  self.annotation.coordinate = coordinate;
  self.annotation.title = @"Request";
  self.annotation.draggable = NO;
  [self.mapView addAnnotation:self.annotation];
}

#pragma mark - PickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView
{
  return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  return self.categories.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  Category *category = self.categories[row];
  return category.name;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
  return 30;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  Category *category = self.categories[row];
  self.alertController.textFields[2].text = category.name;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqual:@"mapToDetails"]) {
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.post = self.post;
  } else {
    LocationsViewController *locationsViewController = [segue destinationViewController];
    locationsViewController.delegate = self;
  }
}

@end
