//
//  HomeCell.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "HomeCell.h"

@implementation HomeCell

- (void)awakeFromNib
{
  [super awakeFromNib];
  [self startUserLocationSearch];

  // Gesture Recognizer Set Up
  UITapGestureRecognizer *postTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapPost:)];
  postTap.numberOfTapsRequired = 2;
  [self addGestureRecognizer:postTap];
  [self setUserInteractionEnabled:YES];

}

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

// Helper function after location is retrieved
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
  [self.locationManager stopUpdatingLocation];
  self.latitude = self.locationManager.location.coordinate.latitude;
  self.longitude = self.locationManager.location.coordinate.longitude;
}

- (void)loadPost:(Post *)post
{
  self.post = post;
  self.descriptionView.alpha = 0;
  CGRect newFrame = self.mediaView.frame;

  newFrame.size.width = (CGRectGetWidth(self.bounds)) - 15;
  newFrame.size.height = (CGRectGetHeight(self.bounds)) - 15;
  [self.mediaView setFrame:newFrame];
  self.mediaView.layer.masksToBounds = YES;
  self.mediaView.layer.cornerRadius = 16;
  self.mediaView.file = post.media;
  [self.mediaView loadInBackground];
  self.distanceLabel.text = @"";
  self.descriptionLabel.text = @"";
  self.dateLabel.text = @"";
  if (self.post.likeCount.intValue >= 10) {
    self.popularView.alpha = 1;
  } else {
    self.popularView.alpha = 0;
  }
}

- (void)showDescription:(Post *)post
{
  self.descriptionView.alpha = 0.75;
  CGRect newFrame = self.mediaView.frame;

  NSLog(@" WIDTH %f", (CGRectGetWidth(self.bounds)));
  newFrame.size.width = (CGRectGetWidth(self.bounds)) - 15;
  newFrame.size.height = (CGRectGetHeight(self.bounds)) - 15;
  [self.descriptionView setFrame:newFrame];
  self.descriptionView.layer.masksToBounds = YES;
  self.descriptionView.layer.cornerRadius = 16;
  [self.descriptionView setBackgroundColor:[post.category colorCode]];
  CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
  CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:post.latitude.floatValue
                                                       longitude:post.longitude.floatValue];
  CLLocationDistance distance = [startLocation distanceFromLocation:endLocation];
  self.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi away", distance * 0.000621371];
  self.descriptionLabel.text = post.caption;
  if (self.post.upcomingDate.timeIntervalSinceNow >= 0 && self.post.isUpcoming) {
    self.dateLabel.text = @"Upc";
  } else {
    if (self.post.upcomingDate.timeIntervalSinceNow <= 0) {
      self.post.isUpcoming = false;
      [self.post saveInBackground];
    }
    self.dateLabel.text = post.createdAt.shortTimeAgoSinceNow;
  }
}

#pragma mark - Delegate
- (void)didTapPost:(UITapGestureRecognizer *)sender
{
  NSLog(@"Tapping");
  [self.delegate homeCell:self didTap:self.post];
}

@end
