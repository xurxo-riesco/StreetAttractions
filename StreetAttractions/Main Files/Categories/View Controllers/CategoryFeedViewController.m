//
//  CategoryFeedViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "CategoryFeedViewController.h"
@interface CategoryFeedViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, HomeCellDelegate>
@end

@implementation CategoryFeedViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  // ColectionView Set Up
  self.collectionView.delegate = self;
  self.collectionView.dataSource = self;
  UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
  CGFloat postersPerLine = 2;
  CGFloat itemWidth = self.collectionView.frame.size.width / postersPerLine;
  CGFloat itemHeight = itemWidth;
  layout.itemSize = CGSizeMake(itemWidth, itemHeight);

  // RefreshControl Set Up
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
  [self.collectionView insertSubview:self.refreshControl atIndex:0];

  // NavigationBar Set Up
  UINavigationBar *navigationBar = self.navigationController.navigationBar;
  [UIView animateWithDuration:1
                   animations:^{
                     [navigationBar setBackgroundColor:[self.category.name colorCode]];
                     self.navigationItem.title = self.category.name;
                   }];
  // BarButton is set as empty in case as a placeholder until it is changed during the network request
  self.barButton.image = [UIImage systemImageNamed:@"star"];
  // Verifies if the current category is favorited in the user's backend and modifies the views accordingly
  [User isFavorite:self.category
    WithCompletion:^(BOOL completion) {
      if (completion) {
        self.barButton.image = [UIImage systemImageNamed:@"star.fill"];
      } else {
        self.barButton.image = [UIImage systemImageNamed:@"star"];
      }
    }];

  // Network Call
  [self.refreshControl beginRefreshing];
  [self fetchPost];
}

// Since the navigation bar is shared between all category views, the initial color must be resetted after the view for
// a current category dissapears
- (void)viewWillDisappear:(BOOL)animated
{
  UINavigationBar *navigationBar = self.navigationController.navigationBar;
  [navigationBar setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark - RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl
{
  [self fetchPost];
  [refreshControl endRefreshing];
}

#pragma mark - Network
- (void)fetchPost
{
  PFQuery *postQuery = [Post query];
  User *user = [User currentUser];
  [postQuery includeKey:@"author"];
  [postQuery orderByDescending:@"created_At"];
  [postQuery whereKey:@"city" equalTo:user.location];
  [postQuery whereKey:@"category" equalTo:self.category.name];
  postQuery.limit = 20;
  [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> *_Nullable posts, NSError *_Nullable error) {
    if (posts) {
      self.posts = [posts mutableCopy];
      [self.collectionView reloadData];
      self.dataSkip = (int)posts.count;
    }
    [self.refreshControl endRefreshing];
  }];
}

- (void)fetchMorePost
{
  PFQuery *postQuery = [Post query];
  User *user = [User currentUser];
  [postQuery includeKey:@"author"];
  [postQuery orderByDescending:@"created_At"];
  [postQuery whereKey:@"category" equalTo:self.category.name];
  [postQuery whereKey:@"city" equalTo:user.location];
  postQuery.limit = 20;
  [postQuery setSkip:self.dataSkip];
  [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> *_Nullable posts, NSError *_Nullable error) {
    if (posts) {
      if (posts.count > 0) {
        int prevNumPosts = (int)self.posts.count;
        self.posts = (NSMutableArray *)[self.posts arrayByAddingObjectsFromArray:posts];
        NSMutableArray *newIndexPaths = [NSMutableArray array];
        for (int i = prevNumPosts; i < self.posts.count; i++) {
          [newIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        self.dataSkip += (int)posts.count;
      }
      self.isMoreDataLoading = false;
      [self.collectionView reloadData];
    }
  }];
}

#pragma mark - InfiniteScrolling
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if (!self.isMoreDataLoading) {
    int scrollViewContentHeight = self.collectionView.contentSize.height;
    int scrollOffsetThreshold = scrollViewContentHeight - self.collectionView.bounds.size.height;
    if (scrollView.contentOffset.y > scrollOffsetThreshold && self.collectionView.isDragging) {
      self.isMoreDataLoading = true;
      [self fetchMorePost];
    }
  }
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

#pragma mark - HomeCell Delegate
- (void)homeCell:(HomeCell *)homeCell didTap:(Post *)post
{
  self.post = post;
  [self performSegueWithIdentifier:@"categoriesToDetails" sender:nil];
}

#pragma mark - Favoriting
- (IBAction)onFavorite:(id)sender
{
  if ([self.barButton.image isEqual:[UIImage systemImageNamed:@"star"]]) {
    [self favorite];
  } else {
    [self unfavorite];
  }
}
- (void)favorite
{
  // Sets the category as favorited by the user in the server
  User *user = [User currentUser];
  PFRelation *relation = [user relationForKey:@"FavCategories"];
  [relation addObject:self.category];
  [user saveInBackground];

  // Changes the favoriting button state to reflect the backend change
  self.barButton.image = [UIImage systemImageNamed:@"star.fill"];
}
- (void)unfavorite
{
  // Sets the category as unfavorited by the user in the server
  User *user = [User currentUser];
  PFRelation *relation = [user relationForKey:@"FavCategories"];
  [relation removeObject:self.category];
  [user saveInBackground];

  // Changes the favoriting button state to reflect the backend change
  self.barButton.image = [UIImage systemImageNamed:@"star"];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  DetailsViewController *detailsViewController = [segue destinationViewController];
  detailsViewController.post = self.post;
}

@end
