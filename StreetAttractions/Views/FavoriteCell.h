//
//  FavoriteCell.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTools.h"
//Models
#import "Post.h"
#import "User.h"

@import Parse;
NS_ASSUME_NONNULL_BEGIN
@protocol FavoriteCellDelegate;
@interface FavoriteCell : UITableViewCell <CLLocationManagerDelegate>
@property (strong, nonatomic)  CLLocationManager *locationManager;
@property (nonatomic, weak) id<FavoriteCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *borderView;
@property (weak, nonatomic) IBOutlet PFImageView *mediaView;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) Post *post;
@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;
- (void)loadPost:(Post *) post;
@end
@protocol FavoriteCellDelegate
- (void)favoriteCell:(FavoriteCell*) favoriteCell didTap: (Post *)post;
@end

NS_ASSUME_NONNULL_END
