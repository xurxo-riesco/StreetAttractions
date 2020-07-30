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
  self.contentView.backgroundColor = [UIColor colorWithRed:239.0 / 255.0
                                                     green:235.0 / 255.0
                                                      blue:234.0 / 255.0
                                                     alpha:1];
  self.post = post;
  self.mediaView.file = post.media;
  [self.mediaView loadInBackground];
  self.mediaView.layer.cornerRadius = 4;
  self.mediaView.layer.masksToBounds = YES;
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
  self.categoryLabel.textColor = [post.category colorCode];
  self.categoryLabel.text = [post.category substringToIndex:1];
  self.usernameLabel.text = user.screenname;
}

#pragma mark - Delegate
- (void)didTapUser:(UITapGestureRecognizer *)sender
{
  [self.delegate favoriteCell:self didTap:self.post];
}

@end
