//
//  Message.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/9/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "Message.h"

@implementation Message
@dynamic text;
@dynamic author;
@dynamic toUser;

+ (nonnull NSString *)parseClassName
{
  return @"Message";
}
@end
