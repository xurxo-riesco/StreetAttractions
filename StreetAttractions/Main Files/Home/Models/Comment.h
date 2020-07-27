//
//  Comment.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/17/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Comment : PFObject<PFSubclassing>

/**
  Text of the comment
*/
@property (nonatomic, strong) NSString *text;

/**
  Pointer to the author of the comment
*/
@property (nonatomic, strong) PFUser *author;

@end

NS_ASSUME_NONNULL_END
