//
//  UserCell.h
//  Instagram
//
//  Created by Xurxo Riesco on 7/9/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN
@protocol UserCellDelegate;
@interface UserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileView;
@property (nonatomic, weak) id<UserCellDelegate> delegate;
@property (nonatomic, strong) PFUser *user;
- (void)loadUser:(PFUser *)user;
@end

@protocol UserCellDelegate
- (void)userCell:(UserCell *) userCell didTap: (PFUser *)user;
@end


NS_ASSUME_NONNULL_END
