//
//  HomeCell.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DateTools.h"
@import Parse;
//Models
#import "Post.h"


NS_ASSUME_NONNULL_BEGIN
@protocol HomeCellDelegate;

@interface HomeCell : UICollectionViewCell <CLLocationManagerDelegate>
@property (nonatomic, weak) id<HomeCellDelegate> delegate;
@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;
@property (strong, nonatomic)  CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *descriptionView;
@property (weak, nonatomic) IBOutlet UIImageView *popularView;
@property (weak, nonatomic) IBOutlet PFImageView *mediaView;
@property (strong, nonatomic) Post *post;
- (void)loadPost:(Post *) post;
- (void)showDescription:(Post*) post;
@end

@protocol HomeCellDelegate
- (void)homeCell:(HomeCell*) homeCell didTap: (Post *)post;
@end

NS_ASSUME_NONNULL_END
