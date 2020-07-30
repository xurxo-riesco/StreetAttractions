//
//  MessageThreadViewController.h
//  Instagram
//
//  Created by Xurxo Riesco on 7/9/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

#import "Message.h"
#import "User.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface MessageThreadViewController : UIViewController

/*!
 Stores the user that current user is chatting with
*/
@property (nonatomic, strong) User *user;

/*!
 TableView that displays all messages on a thread
*/
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/*!
 Field to type a new message
*/
@property (weak, nonatomic) IBOutlet UITextField *messageField;

/*!
 Stores all messages of a conversation
*/
@property (strong, nonatomic) NSMutableArray *messages;

@end

NS_ASSUME_NONNULL_END
