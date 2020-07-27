//
//  FavoriteCell.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "FavoriteCell.h"
#import "NSString+ColorCode.h"

@implementation FavoriteCell

- (void)awakeFromNib
{
  [super awakeFromNib];
  [self startUserLocationSearch];
  UITapGestureRecognizer *userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapUser:)];
  userTap.numberOfTapsRequired = 1;
  [self.profilePic addGestureRecognizer:userTap];
  [self.profilePic setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
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
  self.mediaView.layer.cornerRadius = 16;
  self.mediaView.layer.masksToBounds = YES;
  self.borderView.layer.cornerRadius = 16;
  self.borderView.layer.masksToBounds = YES;
  self.mediaView.file = post.media;
  [self.mediaView loadInBackground];
  self.descriptionLabel.text = post.caption;
  CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
  CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:post.latitude.floatValue
                                                       longitude:post.longitude.floatValue];
  CLLocationDistance distance = [startLocation distanceFromLocation:endLocation];
  self.dateLabel.text = post.createdAt.shortTimeAgoSinceNow;
  self.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi away", distance * 0.000621371];
  self.profilePic.layer.masksToBounds = YES;
  self.profilePic.layer.cornerRadius = 15;
  User *user = (User *)post.author;
  self.profilePic.file = user.profilePic;
  [self.profilePic loadInBackground];
  self.borderView.alpha = 0.4;
  self.borderView.backgroundColor = [post.category colorCode];
  self.usernameLabel.text = user.screenname;
}

#pragma mark - Delegate
- (void)didTapUser:(UITapGestureRecognizer *)sender
{
  [self.delegate favoriteCell:self didTap:self.post];
}

@end
