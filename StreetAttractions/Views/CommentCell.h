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

/*!
   @protocol CommentCellDelegate

   @brief Delegate to allow seguing to user's profile

   Used to allow taping on a user's profile pic to triguer a segue to their profile
*/
@protocol CommentCellDelegate;

@interface CommentCell : UITableViewCell

@property (nonatomic, weak) id<CommentCellDelegate> delegate;

/**
    Hosts the user of the current cell
*/
@property (strong, nonatomic) User *user;

/**
    Displays the profile pic of the comment's author
*/
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;

/**
    Hosts the cell;s comment
*/
@property (strong, nonatomic) Comment *comment;

/**
    Displays a bubble like border view for the comment
*/
@property (weak, nonatomic) IBOutlet UIView *commentView;

/**
    Displays the text of the comment alongside with the screen name of the author
*/
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

/*!
   @brief Loads all celll views
   @discussion Displays the following in the cell:
                - Comment bubble
                - Comment;s text
                - Comment's author screen name
                - Comment's author profile picture
   @param  comment The comment object to be displayed
*/
- (void)loadComment:(Comment *)comment;

@end

@protocol CommentCellDelegate
- (void)commentCell:(CommentCell *) commentCell didTap: (User *)user;
@end

NS_ASSUME_NONNULL_END
