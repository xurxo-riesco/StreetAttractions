//
//  PerformanceRequest.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/30/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <Parse/Parse.h>

// Models
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface PerformanceRequest : PFObject<PFSubclassing>

/**
  Category of the request
*/
@property (nonatomic, strong) NSArray *category;

/**
  Date for the request
*/
@property (nonatomic, strong) NSString *date;

/**
  Brief description of the request
*/
@property (nonatomic, strong) NSString *brief;

/**
  City for the request
*/
@property (nonatomic, strong) NSString *city;

/**
  Latitude of the request
*/
@property (nonatomic, strong) NSNumber *latitude;

/**
  Longitude of the request
*/
@property (nonatomic, strong) NSNumber *longitude;

/**
  Pointer to the author of the request
*/
@property (nonatomic, strong) User *author;

@end

NS_ASSUME_NONNULL_END
