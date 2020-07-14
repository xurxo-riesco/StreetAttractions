//
//  CategoriesViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryFeedViewController.h"
#import "HomeCell.h"
#import "CategoryCell.h"
#import "Category.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoriesViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) NSMutableArray *categories;


@end

NS_ASSUME_NONNULL_END
