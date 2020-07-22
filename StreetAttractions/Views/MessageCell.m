//
//  MessageCell.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/9/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib
{
  [super awakeFromNib];
}

- (void)loadOwnMessage:(Message *)message
{
  [self.bubbleView setHidden:YES];
  [self.bubbleView setAlpha:0.0f];
  self.ownBubbleView.layer.cornerRadius = 16;
  self.ownBubbleView.clipsToBounds = true;
  self.ownMessageLabel.text = message.text;
}

- (void)loadMessage:(Message *)message
{
  self.ownBubbleView.alpha = 0;
  self.bubbleView.layer.cornerRadius = 16;
  self.bubbleView.clipsToBounds = true;
  self.messageLabel.text = message.text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
}

@end
