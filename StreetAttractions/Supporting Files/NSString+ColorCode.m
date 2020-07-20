//
//  NSString+ColorCode.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/17/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "NSString+ColorCode.h"

@implementation NSString (ColorCode)
- (UIColor *) colorCode{
    if([self isEqual:@"Dancers"])
    {
        return [UIColor systemPinkColor];
    }else if ([self isEqual:@"Singers"]){
    return [UIColor systemYellowColor];
    }else if ([self isEqual:@"Magicians"]){
        return [UIColor systemGreenColor];
    }
    return [UIColor whiteColor];
}
@end

