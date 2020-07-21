//
//  CommentsViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/17/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

@import Parse;
#import <UIKit/UIKit.h>

// View Controllers
#import "ProfileViewController.h"

// Views
#import "CommentCell.h"

// Models
#import "Comment.h"
#import "Post.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentsViewController : UIViewController

/**
  TableView to display all comments
*/
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
  Holds all comments for a post
*/
@property (strong, nonatomic) NSMutableArray *comments;

/**
  Field to send a new comment
*/
@property (weak, nonatomic) IBOutlet UITextField *commentField;

/**
  Holds the post that the comments are attached to
*/
@property (strong, nonatomic) Post *post;

/**
  Temporarely holds the user of a comment (Used for seguing)
*/
@property (strong, nonatomic) User *user;

@end

NS_ASSUME_NONNULL_END
