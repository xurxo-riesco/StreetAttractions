//
//  CategoryCell.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "CategoryCell.h"
#import "NSString+ColorCode.h"

@implementation CategoryCell

- (void)awakeFromNib
{
  [super awakeFromNib];
}

- (void)loadCategory:(Category *)category
{
  self.category = category;
  self.nameLabel.text = category.name;
  self.mediaView.file = category.media;
  [self.mediaView loadInBackground];
  self.backgroundView.layer.cornerRadius = 16;
  self.backgroundView.layer.masksToBounds = YES;
    self.backgroundView.alpha = 0.3;
  self.backgroundView.backgroundColor = [self.category.name colorCode];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
}

@end
