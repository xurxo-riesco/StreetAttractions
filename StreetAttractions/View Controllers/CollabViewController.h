//
//  CollabViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/22/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>

// View Controllers
#import "ProfileViewController.h"

// Views
#import "UserCell.h"

// Models
#import "User.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollabViewController : UIViewController
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSMutableArray *users;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *category;
@property (nonatomic) BOOL likesUser;

@end

NS_ASSUME_NONNULL_END
