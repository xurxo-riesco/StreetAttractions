//
//  LocationCell.h
//  PhotoMap
//
//  Created by emersonmalca on 7/8/18.
//  Refactored by Xurxo Riesco on 7/13/20.
//

#import <UIKit/UIKit.h>

@interface LocationCell : UITableViewCell

/**
    Displays image corresponding to a category of venue
*/
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;

/**
    Displays address of the venue
*/
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

/**
    Displays name of the venue
*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/**
    Stores all data corresponding to a venue;s location
*/
@property (strong, nonatomic) NSDictionary *location;

/*!
   @brief Displays a venue on the cell
   @discussion Used to load all views corresponding to a venue in the cell
   @param  location The location's infromation of a venue

*/
- (void)updateWithLocation:(NSDictionary *)location;

@end
