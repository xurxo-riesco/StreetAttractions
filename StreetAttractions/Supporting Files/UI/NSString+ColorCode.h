//
//  NSString+ColorCode.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/17/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ColorCode)

/*!
   @brief Used for color coding
   @discussion Compares the current category name to all category names to allow color coding
   @return UIColor corresponding to a category
*/
- (UIColor *)colorCode;

@end

NS_ASSUME_NONNULL_END
