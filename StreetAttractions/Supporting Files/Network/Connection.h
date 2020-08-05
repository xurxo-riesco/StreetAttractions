//
//  Connection.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 8/4/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
NS_ASSUME_NONNULL_BEGIN

@interface Connection : NSObject
+ (BOOL)connectedToInternet;
@end

NS_ASSUME_NONNULL_END
