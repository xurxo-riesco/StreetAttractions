//
//  CollabViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/22/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "CollabViewController.h"

@interface CollabViewController ()<UITableViewDelegate, UITableViewDataSource>
@end

@implementation CollabViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  // MutableArray Set Up
  self.users = [[NSMutableArray alloc] init];
  // TableView Set Up
  self.tableView.delegate = self;
  self.tableView.dataSource = self;

  // Visual Set Up
  self.titleLabel.text = [NSString
  stringWithFormat:@"Hey, %@! We think you would enjoy doing a collab with some of these performers",
                   [User currentUser].screenname];
  [self fetchUserCategory];
}

#pragma mark - Network
- (void)fetchUserCategory
{
  PFQuery *postQuery = [Post query];
  [postQuery whereKey:@"author" equalTo:[User currentUser]];
  [postQuery orderByDescending:@"created_At"];
  [postQuery includeKey:@"author"];
  [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> *_Nullable objects, NSError *_Nullable error) {
    self.category = objects[0].category;
    [self fetchUsers];
  }];
}

- (void)fetchUsers
{
  PFQuery *queryUsers = [PFUser query];
  [queryUsers whereKey:@"location" equalTo:[User currentUser].location];
  queryUsers.limit = 50;
  // Fetches all users in the area the performer is in
  [queryUsers findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> *users, NSError *_Nullable error) {
    // NSLog(@"USERS: %@", users);
    for (User *user in users) {
      PFRelation *relation = [user relationForKey:@"FavUsers"];
      PFQuery *relationQuery = [relation query];
      // Fecthes all the users that any of the user in the same location has favorited
      [relationQuery findObjectsInBackgroundWithBlock:^(NSArray<User *> *objects, NSError *_Nullable error) {
        self.likesUser = NO;
        // NSLog(@"USER: %@, FAV USERS: %@", user, objects);
        for (User *user in objects) {
          // Checks if the user has favorited the logged in performer
          if ([user.username isEqual:[User currentUser].username]) {
            // NSLog(@"YOU ARE A FAVORITE");
            self.likesUser = YES;
          }
        }
        if (self.likesUser) {
          // Checks for other users that the user also has favorited
          for (User *user in objects) {
            if (user.isPerfomer && (![user.username isEqual:[User currentUser].username])) {
              NSLog(@"MATCH FOUND");
              PFQuery *postQuery = [Post query];
              [postQuery whereKey:@"author" equalTo:user];
              [postQuery includeKey:@"author"];
              // Checks if the category of the user to recommend matches the category of the logged in performer
              [postQuery
              findObjectsInBackgroundWithBlock:^(NSArray<Post *> *_Nullable objects, NSError *_Nullable error) {
                // NSLog(@"POSTS: %@", objects);
                // NSLog(@"%@ vs %@", objects[0].category, self.category);
                  if(objects.count > 0){
                if ([objects[0].category isEqual:self.category]) {
                  // NSLog(@"CATEGORY MATCHED!!");
                  if ([self.users containsObject:user]) {
                  } else {
                    [self.users addObject:user];
                    [self score];
                  }
                }
                  }
              }];
            }
          }
        }
      }];
    }
  }];
}

- (void)score
{
  // Dictionary holds the name of the user and the number of users that follow them as well as the logged in user
  self.scoresDict = [[NSMutableDictionary alloc] init];
  for (User *user in self.users) {
    // Adds one to the count of each user if its repeated
    if ([self.scoresDict.allKeys containsObject:user.username]) {
      NSNumber *scoreSum = [NSNumber numberWithInt:[[self.scoresDict objectForKey:user.username] intValue] + 1];
      [self.scoresDict setObject:scoreSum forKey:user.username];
    } else {
      [self.scoresDict setObject:[NSNumber numberWithInt:1] forKey:user.username];
    }
  }
  // NSLog(@"%@", self.scoresDict);
  NSArray *myArray;
  // Sorts the dictionary by the values and returns an array of the names of the tamplates ranked
  myArray = [self.scoresDict keysSortedByValueUsingComparator:^(id obj1, id obj2) {
    if ([obj1 integerValue] < [obj2 integerValue]) {
      return (NSComparisonResult)NSOrderedDescending;
    }
    if ([obj1 integerValue] > [obj2 integerValue]) {
      return (NSComparisonResult)NSOrderedAscending;
    }

    return (NSComparisonResult)NSOrderedSame;
  }];
  // NSLog(@"ARRAY: %@", myArray);
  self.finalArray = myArray;
  [self getUserObjects];
  // Fetches the user object from the sorted usernames
}

- (void)getUserObjects
{
  self.finalUsers = [[NSMutableArray alloc] init];
  NSLog(@"FINAL ARRAY: %@", self.finalArray);
  PFQuery *queryUsers = [User query];
  [queryUsers whereKey:@"username" containedIn:self.finalArray];
  queryUsers.limit = self.finalArray.count;
  [queryUsers findObjectsInBackgroundWithBlock:^(NSArray<User *> *_Nullable objects, NSError *_Nullable error) {
    self.finalUsers = [objects mutableCopy];
    [self.tableView reloadData];
    // NSLog(@"COUNT: %d", self.finalUsers.count);
  }];
}
#pragma mark - TableView Delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  User *user = self.finalUsers[indexPath.row];
  UserCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
  userCell.delegate = self;
  [userCell loadUser:user];
  return userCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.finalUsers.count;
}

#pragma mark - UserCell Delegate
- (void)userCell:(UserCell *)userCell didTap:(PFUser *)user
{
  self.user = (User *)user;
  [self performSegueWithIdentifier:@"toProfile" sender:nil];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqual:@"toProfile"]) {
    ProfileViewController *profileViewController = [segue destinationViewController];
    profileViewController.user = self.user;
  } else {
    MessageThreadViewController *messageThreadViewController = [segue destinationViewController];
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    User *user = self.users[indexPath.row];
    messageThreadViewController.user = user;
  }
}

@end
