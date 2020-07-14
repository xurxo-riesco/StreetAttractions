//
//  FavoriteCell.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
//Models
#import "Post.h"

@import Parse;
NS_ASSUME_NONNULL_BEGIN

@interface FavoriteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet PFImageView *mediaView;
@property (strong, nonatomic) Post *post;
- (void)loadPost:(Post *) post;
@end

NS_ASSUME_NONNULL_END
