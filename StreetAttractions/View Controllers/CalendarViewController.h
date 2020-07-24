//
//  CalendarViewController.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/23/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//
@import Parse;
#import <UIKit/UIKit.h>

#import "FSCalendar.h"
#import "NSString+ColorCode.h"

// View Controllers
#import "DetailsViewController.h"

// Models
#import "Post.h"
#import "User.h"
NS_ASSUME_NONNULL_BEGIN

@interface CalendarViewController : UIViewController

/**
    Temporarely stores the post needed for seguing to details
*/
@property (strong, nonatomic) Post *post;

/**
    Calendar View displaying upcoming events
*/
@property (weak, nonatomic) IBOutlet FSCalendar *calendarView;

/**
    Format dates to strings in the format YYYY-MM-DD
*/
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

/**
    Dictionary holding the posts for the upcoming updates
*/
@property (strong, nonatomic) NSMutableDictionary *dates;

@end

NS_ASSUME_NONNULL_END
