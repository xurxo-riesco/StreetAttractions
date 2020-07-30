//
//  Annotation.h
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

@interface Annotation : NSObject<MKAnnotation>

/**
 Stores annotation image
*/
@property (strong, nonatomic) PFImageView *image;

/**
 Stores annotation coordinate
*/
@property (nonatomic) CLLocationCoordinate2D coordinate;

/**
 Stores post corresponding to annotation
*/
@property (nonatomic, strong) Post *post;

/**
 Stores title of the annotation (Title is composed by category and time ago)
*/
@property (nonatomic, strong) NSString *title;


/**
 Allows annotation to be dragged (Used for request)
*/
@property (nonatomic) BOOL draggable;

@end

NS_ASSUME_NONNULL_END
