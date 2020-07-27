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

/**
 Stores temporarely the user of a cell (Used for seguing)
*/
@property (strong, nonatomic) User *user;

/**
 Array of recommended collab users
*/
@property (strong, nonatomic) NSMutableArray *users;

/**
 Title label for the view
*/
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 Displays the recommended users to collaborate with
*/
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 Displays the calculate performer's category
*/
@property (strong, nonatomic) NSString *category;

/**
 Temporarely holds the value representing if a user is followed by a user in his area
*/
@property (nonatomic) BOOL likesUser;

/**
 Holds the ranked usernames and their score values
*/
@property (strong, nonatomic) NSMutableDictionary *scoresDict;

/**
 Holds the object of the ranked users
*/
@property (strong, nonatomic) NSMutableArray *finalUsers;

@end

NS_ASSUME_NONNULL_END
