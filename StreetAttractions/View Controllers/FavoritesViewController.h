//
//  FavoritesViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
//Views
#import "FavoriteCell.h"
//Models
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface FavoritesViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *posts;

@end

NS_ASSUME_NONNULL_END
