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
    self.starView.allowsHalfStars = YES;
    [User hasLiked:self.post WithCompletion:^(BOOL completion) {
        if(completion){
            self.barButton.image = [UIImage systemImageNamed:@"heart.fill"];
        }else{
            self.barButton.image = [UIImage systemImageNamed:@"heart"];
        }
    }];
    [User hasRated:self.post WithCompletion:^(BOOL completion) {
        if(completion)
        {
            [self setRating];
        }
    }];
    self.barButton.image = [UIImage systemImageNamed:@"heart"];
    self.mapView.delegate = self;
    self.user = self.post.author;
    self.profilePic.layer.cornerRadius = 20;
    self.profilePic.layer.masksToBounds = YES;
    self.mediaView.layer.cornerRadius = 20;
    self.mediaView.layer.masksToBounds = YES;
    self.mediaView.file = self.post.media;
    [self.mediaView loadInBackground];
    self.profilePic.file = self.user.profilePic;
    [self.profilePic loadInBackground];
    self.userLabel.text = self.user.screenname;
    self.dateLabel.text = self.post.createdAt.timeAgoSinceNow;
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
- (IBAction)onRate:(id)sender {
    self.post.timesRated = [NSNumber numberWithInt:([self.post.timesRated intValue] + 1)];
    if(self.post.rating != nil){
    NSNumber *newRating = [NSNumber numberWithFloat:(self.starView.value  + (self.post.rating.floatValue * (self.post.timesRated.intValue-1)))/ self.post.timesRated.intValue];
    self.post.rating = newRating;
    }
    else{
        self.post.rating = [NSNumber numberWithFloat:self.starView.value];
    }
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded)
        {
            [self setRating];
        }
    }];
}

- (void)setRating{
    self.starView.userInteractionEnabled = NO;
    self.starView.value = 0;
    PFRelation *relation = [[User currentUser] relationForKey:@"RatedPosts"];
    [relation addObject:self.post];
    [[User currentUser] saveInBackground];
    [UIView animateWithDuration:5 animations:^{
        self.starView.value = self.post.rating.floatValue;
        if([self.post.category isEqual:@"Dancers"]){
        self.starView.tintColor = [UIColor systemPinkColor];
            NSLog(@"Pink");
        }else if([self.post.category isEqual:@"Singers"]){
            self.starView.tintColor = [UIColor systemYellowColor];
            NSLog(@"Yellow");
        }else if([self.post.category isEqual:@"Magicians"]){
            self.starView.tintColor = [UIColor systemGreenColor];
            NSLog(@"Green");
        }
    }];
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
 #pragma mark - Share
- (IBAction)onShare:(id)sender {
    NSString *shareString = [NSString stringWithFormat:@"Download StreetAttractions and check out this awesome street %@ in %@", self.post.category, self.post.city];
    NSArray* sharedObjects=[NSArray arrayWithObjects:shareString,  nil];
           UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:sharedObjects applicationActivities:nil];
           activityViewController.popoverPresentationController.sourceView = self.view;
           [self presentViewController:activityViewController animated:YES completion:nil];
}
- (IBAction)onLike:(id)sender {
    if([self.barButton.image isEqual:[UIImage systemImageNamed:@"heart"]]){
        [self like];
    }else{
        [self unlike];
    }
}
- (void) like{
    User *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"LikedPost"];
    [relation addObject:self.post];
    [user saveInBackground];
    self.post.likeCount = [NSNumber numberWithInt:([self.post[@"likeCount"] intValue] + 1)];
    [self.post saveInBackground];
    self.barButton.image = [UIImage systemImageNamed:@"heart.fill"];
}
- (void) unlike{
    User *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"LikedPost"];
    [relation removeObject:self.post];
    [user saveInBackground];
    self.post.likeCount = [NSNumber numberWithInt:([self.post[@"likeCount"] intValue] - 1)];
    [self.post saveInBackground];
    self.barButton.image = [UIImage systemImageNamed:@"heart"];
}
#pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     ProfileViewController *profileViewController = [segue destinationViewController];
     profileViewController.user = self.post.author;
 }
 

@end
