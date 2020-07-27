//
//  LocationCell.m
//  PhotoMap
//
//  Created by emersonmalca on 7/8/18.
//  Refactored by Xurxo Riesco on 7/13/20.
//

#import <AFNetworking/UIImageView+AFNetworking.h>

#import "LocationCell.h"

@interface LocationCell ()

@end

@implementation LocationCell

- (void)awakeFromNib
{
  [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
}

- (void)updateWithLocation:(NSDictionary *)location
{
  self.nameLabel.text = location[@"name"];
  self.addressLabel.text = [location valueForKeyPath:@"location.address"];
  NSArray *categories = location[@"categories"];
  if (categories && categories.count > 0) {
    NSDictionary *category = categories[0];
    NSString *urlPrefix = [category valueForKeyPath:@"icon.prefix"];
    NSString *urlSuffix = [category valueForKeyPath:@"icon.suffix"];
    NSString *urlString = [NSString stringWithFormat:@"%@bg_32%@", urlPrefix, urlSuffix];
    NSURL *url = [NSURL URLWithString:urlString];
    [self.categoryImageView setImageWithURL:url];
  }
}

@end
