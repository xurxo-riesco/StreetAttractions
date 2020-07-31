//
//  BottomSheetViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/31/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "BottomSheetViewController.h"

@interface BottomSheetViewController ()<UITableViewDelegate, UITableViewDataSource, RequestCellDelegate>

@end

@implementation BottomSheetViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  // TableView Set Up
  self.tableView.delegate = self;
  self.tableView.dataSource = self;

  // Initial Network Call
  PFQuery *helperQuery = [Post query];
  helperQuery.limit = 1;
  [helperQuery orderByDescending:@"createdAt"];
  [helperQuery whereKey:@"author" equalTo:[User currentUser]];
  [helperQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> *_Nullable objects, NSError *_Nullable error) {
    NSLog(@"%@", objects[0].category);
    [self fetchRequestsForCategory:objects[0].category];
  }];
}

#pragma mark - Network
- (void)fetchRequestsForCategory:(NSString *)category
{
  PFQuery *requestsQuery = [PerformanceRequest query];
  [requestsQuery orderByDescending:@"createdAt"];
  [requestsQuery includeKey:@"author"];
  [requestsQuery whereKey:@"category" equalTo:category];
  [requestsQuery whereKey:@"city" equalTo:[User currentUser].location];
  requestsQuery.limit = 10;
  [requestsQuery
  findObjectsInBackgroundWithBlock:^(NSArray<PerformanceRequest *> *_Nullable requests, NSError *_Nullable error) {
    if (requests) {
      self.requests = requests;
      NSLog(@"%@", requests);
      [self.tableView reloadData];
    }
  }];
}

#pragma mark - TableView Delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  PerformanceRequest *request = self.requests[indexPath.row];
  RequestCell *requestCell = [tableView dequeueReusableCellWithIdentifier:@"RequestCell"];
  requestCell.delegate = self;
  [requestCell loadRequest:request];
  return requestCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.requests.count;
}

// Sets the delegate to show the location of the request in the map view
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
  PerformanceRequest *request = self.requests[indexPath.row];
  [self.delegate didHighlight:request];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqual:@"toMessages"]) {
    MessageThreadViewController *messages = [segue destinationViewController];
    messages.user = self.user;
  } else {
  }
}

- (void)requestCellDidAccept:(RequestCell *)requestCell
{
  [self performSegueWithIdentifier:@"toCompose" sender:nil];
}

- (void)requestCellMoreInfo:(RequestCell *)requestCell forUser:(User *)user
{
  self.user = user;
  [self performSegueWithIdentifier:@"toMessages" sender:nil];
}

@end
