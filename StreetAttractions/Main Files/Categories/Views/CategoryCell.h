//
//  CategoryCell.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;
// Models
#import "Category.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoryCell : UITableViewCell

/**
    Displays background of the category
*/
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

/**
    Displays name of the category
*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/**
    Displays image corresponding to the category
*/
@property (weak, nonatomic) IBOutlet PFImageView *mediaView;

/**
    Hosts the category of the current cell
*/
@property (strong, nonatomic) Category *category;

/*!
   @brief Loads all celll views
   @discussion Displays name and image corresponding to a category
   @param  category The category object to be displayed

*/
- (void)loadCategory:(Category *)category;

@end

NS_ASSUME_NONNULL_END
