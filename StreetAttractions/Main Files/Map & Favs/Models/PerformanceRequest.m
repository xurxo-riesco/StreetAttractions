//
//  PerformanceRequest.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/30/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "PerformanceRequest.h"

@implementation PerformanceRequest

@dynamic latitude;
@dynamic longitude;
@dynamic brief;
@dynamic date;
@dynamic category;

+ (nonnull NSString *)parseClassName
{
  return @"PerformanceRequest";
}

@end
