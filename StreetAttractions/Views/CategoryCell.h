//
//  CategoryCell.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;
//Models
#import "Category.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *mediaView;
@property (strong, nonatomic) Category *category;
- (void)loadCategory:(Category *) category;
@end

NS_ASSUME_NONNULL_END
