//
//  DetailsViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    User *user = self.post.author;
    self.profilePic.layer.cornerRadius = 20;
    self.profilePic.layer.masksToBounds = YES;
    self.mediaView.layer.cornerRadius = 20;
    self.mediaView.layer.masksToBounds = YES;
    self.mediaView.file = self.post.media;
    [self.mediaView loadInBackground];
    self.profilePic.file = user.profilePic;
    [self.profilePic loadInBackground];
    self.userLabel.text = user.screenname;
    UITapGestureRecognizer *postTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapPost:)];
    postTap.numberOfTapsRequired = 1;
    [self.userLabel addGestureRecognizer:postTap];
    [self.userLabel setUserInteractionEnabled:YES];
    self.descriptionLabel.text = self.post.caption;
    MKCoordinateRegion postRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.post.latitude.floatValue, self.post.longitude.floatValue), MKCoordinateSpanMake(0.1, 0.1));
    [self.mapView setRegion:postRegion animated:false];
    [self loadMap];
    // Do any additional setup after loading the view.
}
- (void) didTapPost:(UITapGestureRecognizer *)sender{
    [self performSegueWithIdentifier:@"detailsToProfile" sender:nil];
}
- (void) loadMap{
    NSNumber *latitude = self.post.latitude;
    NSNumber *longitude = self.post.longitude;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue);
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = coordinate;
    annotation.title = self.post.category;
    [self.mapView addAnnotation:annotation];
}

#pragma mark - Annotations
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        annotationView.canShowCallout = true;
        annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    }
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [detailButton setImage:[UIImage systemImageNamed:@"info.circle"] forState:UIControlStateNormal];
    annotationView.rightCalloutAccessoryView = detailButton;
    return annotationView;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSString *routeString = [NSString stringWithFormat:@"https://www.google.com/maps/search/?api=1&query=%f,%f", self.post.latitude.floatValue, self.post.longitude.floatValue];
    NSURL *routeURL = [NSURL URLWithString:routeString];
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Directions" message:@"Choose an app to get directions" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *googleMaps = [UIAlertAction actionWithTitle:@"Google Maps" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([[UIApplication sharedApplication]canOpenURL:routeURL]){
            [[UIApplication sharedApplication] openURL:routeURL];
        }
    }];
    [actionSheet addAction:googleMaps];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     ProfileViewController *profileViewController = [segue destinationViewController];
     profileViewController.user = self.post.author;
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 

@end
