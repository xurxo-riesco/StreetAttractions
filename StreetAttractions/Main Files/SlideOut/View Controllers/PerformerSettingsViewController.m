//
//  PerformerSettingsViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/20/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "PerformerSettingsViewController.h"

@interface PerformerSettingsViewController ()

@end

@implementation PerformerSettingsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.totalLikes = 0;
  User *user = [User currentUser];

  // Live Set Up
  if (user.isLive) {
    [self.liveSwitch setOn:YES];
    self.streamField.text = user.liveURL;
  } else {
    [self.liveSwitch setOn:NO];
  }

  // Chart Set Up
  self.data01Array = [[NSMutableArray alloc] init];
  [self ratingChart];
}
- (IBAction)onLive:(id)sender
{
  User *user = [User currentUser];
  if (user.isLive) {
    // Finish live streaming and notifies the server
    user.isLive = false;
    user.liveURL = @"";
    self.streamField.text = @"";
    [user saveInBackground];
  } else {
    // Starts live streaming and notifies the server
    user.isLive = true;
    user.liveURL = self.streamField.text;
    [user saveInBackground];
  }
}
- (void)ratingChart
{
  PNLineChart *lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 400, SCREEN_WIDTH, 200.0)];
  [lineChart setXLabels:@[@"", @"", @"", @"", @""]];
  lineChart.yLabelFormat = @"%1.1f";
  lineChart.yFixedValueMax = 5;
  lineChart.showYGridLines = YES;
  PFQuery *postQuery = [Post query];
  postQuery.limit = 5;
  User *user = [User currentUser];
  [postQuery orderByDescending:@"created_At"];
  [postQuery whereKey:@"author" equalTo:user];
  // Fetches all user posts
  [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> *_Nullable posts, NSError *_Nullable error) {
    if (posts) {
      for (Post *post in posts) {
        if (post.rating != nil) {
          // Includes the rating data to the array to graph
          [self.data01Array addObject:post.rating];
          // Adds likesCount and rating to the total values
          self.totalRating += post.rating.floatValue;
          self.totalLikes += post.likeCount.intValue;
        }
      }
    }
    // Array is reversed to preserve chronological order
    NSArray *reversedArray = [[self.data01Array reverseObjectEnumerator] allObjects];
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNYellow;
    data01.itemCount = lineChart.xLabels.count;
    data01.showPointLabel = YES;
    data01.getData = ^(NSUInteger index) {
      CGFloat yValue = [reversedArray[index] floatValue];
      return [PNLineChartDataItem dataItemWithY:yValue];
    };
    lineChart.chartData = @[data01];
    [lineChart strokeChart];
    self.likesLabel.text = [NSString stringWithFormat:@"%d", self.totalLikes];
    self.ratingLabel.text = [NSString stringWithFormat:@"%1.1f", self.totalRating / self.data01Array.count];
    PFQuery *query = [User query];
    [query whereKey:@"objectId" equalTo:user.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *_Nullable objects, NSError *_Nullable error) {
      User *user = objects[0];
      self.followersLabel.text = [NSString stringWithFormat:@"%@", user.followersCount];
    }];
    [self.view addSubview:lineChart];
  }];
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
