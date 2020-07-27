//
//  MessageCell.h
//  Instagram
//
//  Created by Xurxo Riesco on 7/9/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageCell : UITableViewCell

/**
 View serves as a border for messages received
*/
@property (weak, nonatomic) IBOutlet UIView *bubbleView;

/**
 Displays the text of a received message
*/
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

/**
 View serves as a border for messages sent
*/
@property (weak, nonatomic) IBOutlet UIView *ownBubbleView;

/**
 Displays the text of a sent message
*/
@property (weak, nonatomic) IBOutlet UILabel *ownMessageLabel;

/*!
   @brief Shows a received message
   @discussion Loads the border and the text of a received message
   @param  message The message to display
*/
- (void)loadMessage:(Message *)message;

/*!
   @brief Shows a sent message
   @discussion Loads the border and the text of a sent message
   @param  message The message to display
*/
- (void)loadOwnMessage:(Message *)message;

@end

NS_ASSUME_NONNULL_END
