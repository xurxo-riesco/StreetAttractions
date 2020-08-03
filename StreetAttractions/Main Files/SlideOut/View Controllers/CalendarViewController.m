//
//  CalendarViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/23/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()<FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance>
@end

@implementation CalendarViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  // Calendar Set Up
  self.calendarView.delegate = self;
  self.calendarView.dataSource = self;
  self.dateFormatter = [[NSDateFormatter alloc] init];
  self.dateFormatter.dateFormat = @"yyyy-MM-dd";

  // NSMutableDictionary Set Up
  self.dates = [[NSMutableDictionary alloc] init];

  // Initial Network Call
  [self fetchPost];
}

- (void)fetchPost
{
  PFQuery *postQuery = [Post query];
  User *user = [User currentUser];
  [postQuery includeKey:@"author"];
  [postQuery orderByDescending:@"created_At"];
  [postQuery whereKey:@"city" equalTo:user.location];
  postQuery.limit = 20;
  [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> *_Nullable posts, NSError *_Nullable error) {
    if (posts) {
      for (Post *post in posts) {
        if (post.isUpcoming) {
          NSString *dateString = [self.dateFormatter stringFromDate:post.upcomingDate];
          [self.dates setValue:post forKey:dateString];
        }
      }
      [self.calendarView reloadData];
    }
  }];
}

#pragma mark - FSCalendar DataSource
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
  NSString *dateString = [self.dateFormatter stringFromDate:date];
  NSLog(@"%@", dateString);
  if ([self.dates.allKeys containsObject:dateString]) {
    return 1;
  }
  return 0;
}

#pragma mark - FSCalendar Delegate Appearance

- (NSArray *)calendar:(FSCalendar *)calendar
               appearance:(FSCalendarAppearance *)appearance
eventDefaultColorsForDate:(NSDate *)date
{
  NSString *dateString = [self.dateFormatter stringFromDate:date];
  NSLog(@"%@", dateString);
  if ([self.dates.allKeys containsObject:dateString]) {
    Post *post = self.dates[dateString];
    return @[[post.category colorCode], appearance.eventDefaultColor, [UIColor blackColor]];
  }
  return nil;
}

- (UIColor *)calendar:(FSCalendar *)calendar
               appearance:(FSCalendarAppearance *)appearance
fillSelectionColorForDate:(NSDate *)date
{
  NSString *dateString = [self.dateFormatter stringFromDate:date];
  NSLog(@"%@", dateString);
  if ([self.dates.allKeys containsObject:dateString]) {
    Post *post = self.dates[dateString];
    return [post.category colorCode];
  }
  return appearance.selectionColor;
}

- (UIColor *)calendar:(FSCalendar *)calendar
             appearance:(FSCalendarAppearance *)appearance
fillDefaultColorForDate:(NSDate *)date
{
  NSString *dateString = [self.dateFormatter stringFromDate:date];
  NSLog(@"%@", dateString);
  if ([self.dates.allKeys containsObject:dateString]) {
    Post *post = self.dates[dateString];
    return [post.category colorCode];
  }
  return nil;
}

- (UIColor *)calendar:(FSCalendar *)calendar
               appearance:(FSCalendarAppearance *)appearance
borderDefaultColorForDate:(NSDate *)date
{
  NSString *dateString = [self.dateFormatter stringFromDate:date];
  NSLog(@"%@", dateString);
  if ([self.dates.allKeys containsObject:dateString]) {
    Post *post = self.dates[dateString];
    return [post.category colorCode];
  }
  return appearance.borderDefaultColor;
}

- (UIColor *)calendar:(FSCalendar *)calendar
                 appearance:(FSCalendarAppearance *)appearance
borderSelectionColorForDate:(NSDate *)date
{
  NSString *dateString = [self.dateFormatter stringFromDate:date];
  NSLog(@"%@", dateString);
  if ([self.dates.allKeys containsObject:dateString]) {
    Post *post = self.dates[dateString];
    return [post.category colorCode];
  }
  return appearance.borderSelectionColor;
}

- (CGFloat)calendar:(FSCalendar *)calendar
         appearance:(FSCalendarAppearance *)appearance
borderRadiusForDate:(nonnull NSDate *)date
{
  return 1.0;
}

#pragma mark - FSCalendarDelegate
- (void)calendar:(FSCalendar *)calendar
   didSelectDate:(NSDate *)date
 atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
  NSString *dateString = [self.dateFormatter stringFromDate:date];
  self.post = self.dates[dateString];
  if (self.post != nil) {
    [self performSegueWithIdentifier:@"toDetails" sender:nil];
  }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  DetailsViewController *detailsViewController = [segue destinationViewController];
  detailsViewController.post = self.post;
}

@end
