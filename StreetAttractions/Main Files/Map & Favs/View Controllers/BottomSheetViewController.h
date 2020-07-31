//
//  BottomSheetViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/31/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

@import Parse;
#import <UIKit/UIKit.h>

// ViewControllers
#import "MessageThreadViewController.h"

// Views
#import "RequestCell.h"

// Models
#import "PerformanceRequest.h"
#import "Post.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

/*!
   @protocol BottomSheetVCDelegate

   @brief Delegate to allow for display of request on the map

   Used to re center the map and add an annotation when a performer taps a request
*/
@protocol BottomSheetVCDelegate;

@interface BottomSheetViewController : UIViewController

/**
   Delegate property
*/
@property (nonatomic, weak) id<BottomSheetVCDelegate> delegate;

/**
   TableView containing requests that match the performers category and location
*/
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
   Stores all the request that match both of the requirements (same location as performer, and same category than their
   last performance)
*/
@property (strong, nonatomic) NSArray *requests;

/**
   Temporarely stores the author of a request, used for seguing
*/
@property (strong, nonatomic) User *user;

@end

@protocol BottomSheetVCDelegate
- (void)didHighlight:(PerformanceRequest *)request;
@end

NS_ASSUME_NONNULL_END
