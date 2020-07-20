//
//  CategoriesViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>

//View Controllers
#import "SearchViewController.h"
#import "CategoryFeedViewController.h"
#import "DetailsViewController.h"

//Views
#import "HomeCell.h"
#import "CategoryCell.h"

//Models
#import "Category.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoriesViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) NSMutableArray *categories;
@property (nonatomic, strong) Post *post;
@property (nonatomic, strong) NSString *text;


@end

NS_ASSUME_NONNULL_END
