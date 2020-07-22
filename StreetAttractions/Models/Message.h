//
//  Message.h
//  Instagram
//
//  Created by Xurxo Riesco on 7/9/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Message : PFObject<PFSubclassing>

/**
 Stores the content of a message
*/
@property (nonatomic, strong) NSString *text;

/**
 Points to the sender of the message
*/
@property (nonatomic, strong) PFUser *author;

/**
 Points to the receiver of the message
*/
@property (nonatomic, strong) PFUser *toUser;

@end

NS_ASSUME_NONNULL_END
