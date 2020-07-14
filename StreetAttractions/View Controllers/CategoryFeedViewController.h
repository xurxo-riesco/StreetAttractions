//
//  CategoryFeedViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
//Views
#import "HomeCell.h"
//Models
#import "Category.h"
#import "Post.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoryFeedViewController : UIViewController

@property (strong, nonatomic) Category *category;
@property (strong, nonatomic) NSMutableArray *posts;
@end

NS_ASSUME_NONNULL_END
