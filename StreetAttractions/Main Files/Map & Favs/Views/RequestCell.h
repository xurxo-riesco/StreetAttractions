//
//  RequestCell.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/31/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>

// Models
#import "PerformanceRequest.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

/*!
   @protocol RequestCellDelegate

   @brief Delegate to allow seguing to compose and messages

   Used to allow a performer to accept a request and compose a post, or contact the request author for more information
*/
@protocol RequestCellDelegate;

@interface RequestCell : UITableViewCell

/**
   Displais request description
*/
@property (weak, nonatomic) IBOutlet UILabel *briefLabel;

/**
   Displays author of the request
*/
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

/**
   Displays date of the request
*/
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

/**
   Stores the request object, used for delegates
*/
@property (strong, nonatomic) PerformanceRequest *request;

/**
   Delegate property
*/
@property (nonatomic, weak) id<RequestCellDelegate> delegate;

/*!
   @brief Loads all celll views
   @discussion Displays name and image corresponding to a request
   @param  request The request object to be displayed

*/
- (void)loadRequest:(PerformanceRequest *)request;

@end

@protocol RequestCellDelegate
- (void)requestCellDidAccept:(RequestCell *)requestCell;
- (void)requestCellMoreInfo:(RequestCell *)requestCell forUser:(User *)user;
@end

NS_ASSUME_NONNULL_END
