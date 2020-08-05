//
//  CustomButton.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/29/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "CustomButton.h"

// Margins Colors

@implementation CustomButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    [self setBackgroundColor:[UIColor colorWithRed:239.0 / 255.0 green:235.0 / 255.0 blue:234.0 / 255.0 alpha:1]];
    [self setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    self.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
  }
  return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
