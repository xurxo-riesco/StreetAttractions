//
//  CommentsViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/17/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

@import Parse;
#import <UIKit/UIKit.h>

//View Controllers
#import "ProfileViewController.h"

//Views
#import "CommentCell.h"

//Models
#import "Comment.h"
#import "Post.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *comments;
@property (weak, nonatomic) IBOutlet UITextField *commentField;
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) User *user;

@end

NS_ASSUME_NONNULL_END
