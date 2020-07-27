//
//  AnnotationPin.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/15/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <MapKit/MapKit.h>
@import Parse;
// Models
#import "Post.h"
NS_ASSUME_NONNULL_BEGIN

@interface AnnotationPin : MKPinAnnotationView

/**
    Hosts the post of the current map pin
*/
@property (nonatomic, strong) Post *post;

/**
    Displays the image corresponding to the post (leftCallOutAccesory)
*/
@property (strong, nonatomic) PFImageView *image;

/**
    Coordinate corresponding to the post
*/
@property (nonatomic) CLLocationCoordinate2D coordinate;

/**
    Displays the pos't category and the time since posted as the pin's title
*/
@property (nonatomic, strong) NSString *title;

@end

NS_ASSUME_NONNULL_END
