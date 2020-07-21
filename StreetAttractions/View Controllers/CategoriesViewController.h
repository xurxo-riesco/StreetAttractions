//
//  CategoriesViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>

// View Controllers
#import "CategoryFeedViewController.h"
#import "DetailsViewController.h"
#import "SearchViewController.h"

// Views
#import "CategoryCell.h"
#import "HomeCell.h"

// Models
#import "Category.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoriesViewController : UIViewController

/**
    Array of posts recommended for user
*/
@property (nonatomic, strong) NSMutableArray *posts;

/**
    Array of categories
*/
@property (nonatomic, strong) NSMutableArray *categories;

/**
    Temporarely holds post of selected cell (Used for seguing)
*/
@property (nonatomic, strong) Post *post;

/**
    Temporarely holds search bar text (Used for seguing)
*/
@property (nonatomic, strong) NSString *text;

@end

NS_ASSUME_NONNULL_END
