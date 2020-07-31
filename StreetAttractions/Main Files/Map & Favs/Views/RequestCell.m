//
//  RequestCell.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/31/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "RequestCell.h"

@implementation RequestCell

- (void)awakeFromNib
{
  [super awakeFromNib];
  // Initialization code
}

- (void)loadRequest:(PerformanceRequest *)request
{
  self.request = request;
  self.briefLabel.text = request.brief;
  User *user = request.author;
  NSString *userString = [NSString stringWithFormat:@"Requested by %@", user.screenname];
  self.userLabel.text = userString;
  self.dateLabel.text = request.date;
}
- (IBAction)onAccept:(id)sender
{
  [self.request deleteInBackground];
  [self.delegate requestCellDidAccept:self];
}
- (IBAction)onMoreInfo:(id)sender
{
  [self.delegate requestCellMoreInfo:self forUser:self.request.author];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
}

@end
