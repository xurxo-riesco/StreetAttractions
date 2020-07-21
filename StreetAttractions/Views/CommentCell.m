//
//  CommentCell.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/17/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)awakeFromNib
{
  [super awakeFromNib];
    
    // Visual Set Up
  self.commentView.layer.cornerRadius = 16;
  self.commentView.layer.masksToBounds = YES;
    
    // Gesture Recognizer Set Up
  UITapGestureRecognizer *userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapUser:)];
  userTap.numberOfTapsRequired = 1;
  [self.profilePic addGestureRecognizer:userTap];
  [self.profilePic setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
}

- (void)loadComment:(Comment *)comment
{
  self.comment = comment;
  User *user = (User *)comment.author;
  self.user = user;
  self.commentLabel.text = [NSString stringWithFormat:@"%@: %@", user.screenname, comment.text];
  self.profilePic.file = user.profilePic;
  [self.profilePic loadInBackground];
  self.profilePic.layer.cornerRadius = 16;
  self.profilePic.layer.masksToBounds = YES;
}

- (void)didTapUser:(UITapGestureRecognizer *)sender
{
  [self.delegate commentCell:self didTap:self.user];
}

@end
