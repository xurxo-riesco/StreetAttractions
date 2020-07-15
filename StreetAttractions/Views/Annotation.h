//
//  Annotation.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/15/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <MapKit/MapKit.h>
@import Parse;
//Models
#import "Post.h"
NS_ASSUME_NONNULL_BEGIN

@interface Annotation : NSObject<MKAnnotation>
@property (strong, nonatomic) PFImageView *image;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) Post *post;
@property (nonatomic, strong) NSString *title;

@end

NS_ASSUME_NONNULL_END
