//
//  Category.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Category : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *name;

@end

NS_ASSUME_NONNULL_END
