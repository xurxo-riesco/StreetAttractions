//
//  HomeCell.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "HomeCell.h"
#import <CoreLocation/CoreLocation.h>

@implementation HomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self startUserLocationSearch];
    /*
    UITapGestureRecognizer *postTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapPost:)];
    [self.mediaView addGestureRecognizer:postTap];
    [self.mediaView setUserInteractionEnabled:YES];
    */
    self.mediaView.layer.masksToBounds = YES;
    self.mediaView.layer.cornerRadius = 16;
}
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
    self.latitude = self.locationManager.location.coordinate.latitude;
    self.longitude = self.locationManager.location.coordinate.longitude;
}
- (void)loadPost:(Post *) post{
    self.post = post;
    self.descriptionView.alpha = 0;
    self.mediaView.file = post[@"media"];
    [self.mediaView loadInBackground];
    self.distanceLabel.text = @"";
    self.descriptionLabel.text = @"";
}
- (void)showDescription:(Post*) post{
    self.descriptionView.alpha = 0.9;
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
    //NSLog(@"%f latitude, %f longitude", self.latitude, self.longitude);
    CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:post.latitude.floatValue longitude:post.longitude.floatValue];
    //NSLog(@"%f latitude, %f longitude", post.latitude.floatValue, post.longitude.floatValue);
    CLLocationDistance distance = [startLocation distanceFromLocation:endLocation];
    //NSLog(@"%f miles", distance*0.000621371);
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi away",distance*0.000621371];
    self.descriptionLabel.text = post.caption;
}

@end
