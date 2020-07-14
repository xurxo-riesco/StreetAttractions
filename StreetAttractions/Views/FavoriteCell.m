//
//  FavoriteCell.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "FavoriteCell.h"

@implementation FavoriteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)loadPost:(Post *) post{
    self.post = post;
    self.mediaView.file = post.media;
    [self.mediaView loadInBackground];
    self.descriptionLabel.text = post.caption;
}

@end
