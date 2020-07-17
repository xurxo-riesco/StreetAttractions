//
//  PhotoMapViewController.m
//  PhotoMap
//
//  Original by emersonmalca on 7/8/18.
//  Refactored by Xurxo Riesco on 7/13/20.
//

#import "PhotoMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface PhotoMapViewController () <UIImagePickerControllerDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic)  CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) UIImageView *image;

@end

@implementation PhotoMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Commit");
    [self startUserLocationSearch];
    self.mapView.delegate = self;
    [self fetchPost];
}

#pragma mark - CLLocationManager Delegate
-(void)startUserLocationSearch{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [self.locationManager stopUpdatingLocation];
    CGFloat usersLatitude = self.locationManager.location.coordinate.latitude;
    CGFloat usersLongidute = self.locationManager.location.coordinate.longitude;
    MKCoordinateRegion userRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(usersLatitude, usersLongidute), MKCoordinateSpanMake(0.1, 0.1));
    [self.mapView setRegion:userRegion animated:false];
    self.mapView.delegate = self;
}

#pragma mark - Annotations
- (AnnotationPin *)mapView:(MKMapView *)mapView viewForAnnotation:(Annotation *)annotation {
    AnnotationPin *annotationView = (AnnotationPin*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    if (annotationView == nil) {
        annotationView = [[AnnotationPin alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        annotationView.canShowCallout = true;
        annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    }
    Post *post = annotation.post;
    PFFileObject *data = post.media;
    [data getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(error == nil){
            UIImage *image = [UIImage imageWithData:data];
            NSLog(@"%@", image);
            UIImageView *imageView = (UIImageView*)annotationView.leftCalloutAccessoryView;
            imageView.image = image;
        }else{
            NSLog(@"Error");
        }
    }];
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [detailButton setImage:[UIImage systemImageNamed:@"info.circle"] forState:UIControlStateNormal];
    annotationView.rightCalloutAccessoryView = detailButton;
    if([post.category isEqual:@"Dancers"]){
        annotationView.pinTintColor = [UIColor systemPinkColor];
    }else if ([post.category isEqual:@"Singers"]){
        annotationView.pinTintColor = [UIColor systemYellowColor];
    }else if ([post.category isEqual:@"Magicians"]){
           annotationView.pinTintColor = [UIColor systemGreenColor];
    }
    return annotationView;
}
- (void)mapView:(MKMapView *)mapView annotationView:(AnnotationPin *)view calloutAccessoryControlTapped:(UIControl *)control {
    Annotation *annotation = view.annotation;
    self.post = annotation.post;
    [self performSegueWithIdentifier:@"mapToDetails" sender:nil];
}

#pragma mark - Network
- (void)fetchPost {
    PFQuery *postQuery = [Post query];
    postQuery.limit = 20;
    [postQuery includeKey:@"author"];
    User *user = [PFUser currentUser];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery whereKey:@"city" equalTo:user.location];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.posts = [posts mutableCopy];
            for(Post *post in posts)
            {
                NSNumber *latitude = post.latitude;
                NSNumber *longitude = post.longitude;
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue);
                Annotation *annotation = [Annotation new];
                annotation.coordinate = coordinate;
                annotation.title = [NSString stringWithFormat:@"%@ (%@)", post.category, post.createdAt.shortTimeAgoSinceNow];
                annotation.post = post;
                [self.mapView addAnnotation:annotation];
            }
        }
    }];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqual:@"mapToDetails"])
    {
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = self.post;
    }else{
        LocationsViewController *locationsViewController = [segue destinationViewController];
        locationsViewController.delegate = self;
    }
}


@end