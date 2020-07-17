//
//  FavoriteCell.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "FavoriteCell.h"
#import <CoreLocation/CoreLocation.h>

@implementation FavoriteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self startUserLocationSearch];
    UITapGestureRecognizer *userTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUser:)];
    userTap.numberOfTapsRequired = 1;
    [self.profilePic addGestureRecognizer:userTap];
    [self.profilePic setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
//Helper functions to get users location
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
//Loads all views in the cell
- (void)loadPost:(Post *) post{
    self.post = post;
    self.mediaView.layer.cornerRadius = 16;
    self.mediaView.layer.masksToBounds = YES;
    self.borderView.layer.cornerRadius = 16;
    self.borderView.layer.masksToBounds = YES;
    [self colorCode];
    self.mediaView.file = post.media;
    [self.mediaView loadInBackground];
    self.descriptionLabel.text = post.caption;
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
    CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:post.latitude.floatValue longitude:post.longitude.floatValue];
    CLLocationDistance distance = [startLocation distanceFromLocation:endLocation];
    self.dateLabel.text = post.createdAt.shortTimeAgoSinceNow;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi away",distance*0.000621371];
    self.profilePic.layer.masksToBounds = YES;
    self.profilePic.layer.cornerRadius = 15;
    User *user = post.author;
    self.profilePic.file = user.profilePic;
    [self.profilePic loadInBackground];
    self.usernameLabel.text = user.screenname;
}
//Colors the cell based on category
- (void) colorCode{
    self.borderView.alpha = 0.4;
    if([self.post.category isEqual:@"Dancers"]){
        self.borderView.backgroundColor = [UIColor systemPinkColor];
    }else if([self.post.category isEqual:@"Singers"]){
        self.borderView.backgroundColor =  [UIColor systemYellowColor];
    }else if([self.post.category isEqual:@"Magicians"]){
        self.borderView.backgroundColor = [UIColor systemGreenColor];
    }
}
#pragma mark - Delegate
// Delegate to segue to Profile View
- (void) didTapUser:(UITapGestureRecognizer *)sender{
    [self.delegate favoriteCell:self didTap:self.post];
}

@end
