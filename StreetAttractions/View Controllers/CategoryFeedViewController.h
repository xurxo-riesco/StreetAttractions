//
//  CategoryFeedViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+ColorCode.h"

//View Controllers
#import  "DetailsViewController.h"

//Views
#import "HomeCell.h"

//Models
#import "Category.h"
#import "Post.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoryFeedViewController : UIViewController

@property (strong, nonatomic) Category *category;
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) NSMutableArray *posts;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (assign, nonatomic) int dataSkip;
@property (assign, nonatomic) BOOL isMoreDataLoading;
- (void) favorite;
- (void) unfavorite;
@end

NS_ASSUME_NONNULL_END
