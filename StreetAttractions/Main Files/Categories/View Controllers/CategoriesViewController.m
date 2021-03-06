//
//  CategoriesViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "CategoriesViewController.h"

@interface CategoriesViewController ()<UITableViewDelegate,
                                       UITableViewDataSource,
                                       UICollectionViewDelegate,
                                       UICollectionViewDataSource,
                                       HomeCellDelegate,
                                       UISearchBarDelegate>
@end
@implementation CategoriesViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.collectionView.backgroundColor = [UIColor colorWithRed:239.0 / 255.0
                                                        green:235.0 / 255.0
                                                         blue:234.0 / 255.0
                                                        alpha:1];
  self.tableView.backgroundColor = [UIColor colorWithRed:239.0 / 255.0 green:235.0 / 255.0 blue:234.0 / 255.0 alpha:1];
  self.view.backgroundColor = [UIColor colorWithRed:239.0 / 255.0 green:235.0 / 255.0 blue:234.0 / 255.0 alpha:1];
  self.searchBar.backgroundColor = [UIColor colorWithRed:239.0 / 255.0 green:235.0 / 255.0 blue:234.0 / 255.0 alpha:1];
  // Search Bar Set Up
  self.searchBar.delegate = self;

  // CollectionView Set Up
  self.collectionView.delegate = self;
  self.collectionView.dataSource = self;

  // TableView Set Up
  self.tableView.dataSource = self;
  self.tableView.delegate = self;

  // MutableArray Set Up
  self.posts = [[NSMutableArray alloc] init];

  // Network Calls
  [self fetchRecommended];
  [self fetchCategories];
}

#pragma mark - Network
// Algorithm fetches all the user's followed by the current user and then fetches the liked posts of those user's
- (void)fetchRecommended
{
  PFRelation *relation = [[User currentUser] relationForKey:@"FavUsers"];
  PFQuery *favUsersQ = [relation query];
  favUsersQ.limit = 10;
  // Fetches user's liked users
  [favUsersQ findObjectsInBackgroundWithBlock:^(NSArray<User *> *users, NSError *_Nullable error) {
    for (User *user in users) {
      PFRelation *relation = [user relationForKey:@"LikedPost"];
      PFQuery *recommendedQ = [relation query];
      [recommendedQ includeKey:@"author"];
      [recommendedQ whereKey:@"city" equalTo:[User currentUser].location];
      [recommendedQ orderByDescending:@"created_At"];
      recommendedQ.limit = 10;
      // Fecthes liked post of user liked by current user
      [recommendedQ findObjectsInBackgroundWithBlock:^(NSArray<Post *> *posts, NSError *_Nullable error) {
        if (posts) {
          if (posts.count > 0) {
            int prevNumPost = self.posts.count;
            // Avoids loading repeated posts to the array
            for (Post *post in posts) {
              if ([self.posts containsObject:post]) {
                continue;
              } else {
                [self.posts addObject:post];
              }
            }
            NSMutableArray *newIndexPaths = [[NSMutableArray alloc] init];
            for (int i = prevNumPost; i < self.posts.count; i++) {
              [newIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
          }
          [self.collectionView reloadData];
        }
      }];
    }
  }];
}

- (void)fetchCategories
{
  PFQuery *categoriesQuery = [Category query];
  if (![Connection connectedToInternet]) {
    [categoriesQuery fromLocalDatastore];
  }
  categoriesQuery.limit = 10;
  [categoriesQuery
  findObjectsInBackgroundWithBlock:^(NSArray<Category *> *_Nullable categories, NSError *_Nullable error) {
    if (categories) {
      [PFObject pinAllInBackground:categories withName:@"Category"];
      self.categories = [categories mutableCopy];
      [self.tableView reloadData];
    }
  }];
}

#pragma mark - CollectionView Delegate
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView
                                   cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  HomeCell *homeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCell" forIndexPath:indexPath];
  Post *post = self.posts[indexPath.item];
  homeCell.delegate = self;
  [homeCell loadPost:post];
  return homeCell;
}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return self.posts.count;
}

#pragma mark - TableView Delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  Category *category = self.categories[indexPath.row];
  CategoryCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
  [categoryCell loadCategory:category];
  return categoryCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.categories.count;
}

#pragma mark - HomeCell Delegate
- (void)homeCell:(HomeCell *)homeCell didTap:(Post *)post
{
  self.post = post;
  [self performSegueWithIdentifier:@"recommendedToDetails" sender:nil];
}

#pragma mark - SearchBar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  if (searchText != 0) {
    self.text = searchText;
    [self performSegueWithIdentifier:@"searchSegue" sender:nil];
  }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  [self performSegueWithIdentifier:@"searchSegue" sender:nil];
}

- (IBAction)onQR:(id)sender
{
  DYQRCodeDecoderViewController *vc = [[DYQRCodeDecoderViewController alloc]
  initWithCompletion:^(BOOL succeeded, NSString *result) {
    if (succeeded) {
      PFQuery *queryUsers = [PFUser query];
      [queryUsers whereKey:@"username" equalTo:result];
      queryUsers.limit = 20;
      [queryUsers findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> *users, NSError *_Nullable error) {
        self.user = (User *)users[0];
        [self performSegueWithIdentifier:@"toProfile" sender:nil];
      }];

    } else {
      NSLog(@"Error");
    }
  }];
    
  [vc setTitle:@"Scan a QR!"];
  [[vc leftBarButtonItem] setTitle:@"Cancel"];
  [[vc rightBarButtonItem] setTitle:@"Album"];
  vc.rightBarButtonItem.tintColor = [UIColor blackColor];
  vc.leftBarButtonItem.tintColor = [UIColor blackColor];
  [vc setNeedsScanAnnimation:NO];
  [vc setNavigationBarTintColor:[UIColor colorWithRed:239.0 / 255.0 green:235.0 / 255.0 blue:234.0 / 255.0 alpha:1]];

  UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
  [self presentViewController:navVC animated:YES completion:NULL];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqual:@"recommendedToDetails"]) {
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.post = self.post;
  } else if ([segue.identifier isEqual:@"searchSegue"]) {
    SearchViewController *searchViewController = [segue destinationViewController];
    searchViewController.text = self.text;
  } else if ([segue.identifier isEqual:@"toProfile"]) {
    ProfileViewController *profileViewController = [segue destinationViewController];
    profileViewController.user = self.user;
  } else if ([segue.identifier isEqual:@"toReels"]) {
    ReelsViewController *reelsViewController = [segue destinationViewController];
  } else {
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    Category *category = self.categories[indexPath.row];
    CategoryFeedViewController *categoryFeedViewController = [segue destinationViewController];
    categoryFeedViewController.category = category;
  }
}

@end
