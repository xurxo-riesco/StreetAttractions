//
//  UserCell.h
//  Instagram
//
//  Created by Xurxo Riesco on 7/9/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;

// Models
#import "User.h"

NS_ASSUME_NONNULL_BEGIN
/*!
   @protocol UserCellDelegate

   @brief Delegate to allow seguing to user's profile

   Used to allow taping on a user's profile pic to triguer a segue to their profile
*/
@protocol UserCellDelegate;

@interface UserCell : UITableViewCell

/**
   Delegate property
*/
@property (nonatomic, weak) id<UserCellDelegate> delegate;

/**
    Hosts the user of the current cell
*/
@property (nonatomic, strong) User *user;

/**
    Displays the username of the user
*/
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

/**
    Displays the user's profile picture
*/
@property (weak, nonatomic) IBOutlet PFImageView *profileView;

/**
    Displays the user's location 
*/
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

/*!
   @brief Loads all celll views
   @discussion Simply display useraname and profile pic of a user
   @param  user The user object to be displayed
*/
- (void)loadUser:(PFUser *)user;

@end

@protocol UserCellDelegate
- (void)userCell:(UserCell *)userCell didTap:(User *)user;
@end

NS_ASSUME_NONNULL_END
