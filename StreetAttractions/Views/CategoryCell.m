//
//  CategoryCell.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)loadCategory:(Category *) category{
    self.category = category;
    self.nameLabel.text = category.name;
    self.mediaView.file = category.media;
    [self.mediaView loadInBackground];
    self.mediaView.layer.cornerRadius = 16;
    self.mediaView.layer.masksToBounds = YES;
    [self colorCode];
    //self.imageView.file = ;
    //[self.imageView loadInBackground];
}
- (void) colorCode{
    self.mediaView.alpha = 0.6;
    if([self.category.name isEqual:@"Dancers"]){
        self.mediaView.backgroundColor = [UIColor systemPinkColor];
    }else if([self.category.name isEqual:@"Singers"]){
        self.mediaView.backgroundColor =  [UIColor systemYellowColor];
    }else if([self.category.name isEqual:@"Magicians"]){
        self.mediaView.backgroundColor = [UIColor systemGreenColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
