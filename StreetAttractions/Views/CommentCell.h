//
//  CommentCell.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/17/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;
//Models
#import "Comment.h"
#import "User.h"
NS_ASSUME_NONNULL_BEGIN
@protocol CommentCellDelegate;

@interface CommentCell : UITableViewCell
@property (nonatomic, weak) id<CommentCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (strong, nonatomic) Comment *comment;
@property (strong, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
- (void)loadComment:(Comment *)comment;
@end
@protocol CommentCellDelegate
- (void)commentCell:(CommentCell *) commentCell didTap: (User *)user;
@end

NS_ASSUME_NONNULL_END
