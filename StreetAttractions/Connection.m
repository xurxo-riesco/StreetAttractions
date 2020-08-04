//
//  Connection.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 8/4/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "Connection.h"

@implementation Connection

+ (BOOL)connectedToInternet{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}
@end
