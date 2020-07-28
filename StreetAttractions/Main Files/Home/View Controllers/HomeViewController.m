//
//  HomeViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "HomeViewController.h"
@interface HomeViewController ()<UICollectionViewDelegate,
                                 UICollectionViewDataSource,
                                 GreedoCollectionViewLayoutDataSource,
                                 UICollectionViewDelegateFlowLayout,
                                 ComposeViewControllerDelegate,
                                 HomeCellDelegate,
                                 TNTutorialManagerDelegate>

@end

@implementation HomeViewController

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  if (self.tutorialManager) {
    [self.tutorialManager updateTutorial];
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  // CollectionView Set Up
  self.collectionView.delegate = self;
  self.collectionView.dataSource = self;
  self.collectionViewSizeCalculator.rowMaximumHeight = CGRectGetHeight(self.collectionView.bounds) / 3;
  self.collectionViewSizeCalculator.fixedHeight = self.hasFixedHeight;
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.collectionView.backgroundColor = [UIColor whiteColor];
  // Configure spacing between cells
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  layout.minimumInteritemSpacing = 5.0f;
  layout.minimumLineSpacing = 5.0f;
  layout.sectionInset = UIEdgeInsetsMake(10.0f, 5.0f, 5.0f, 5.0f);
  self.collectionView.collectionViewLayout = layout;

  // Refresh Control Set Up
  UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
  [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
  [self.collectionView insertSubview:refreshControl atIndex:0];

  // Network Call
  [self fetchPost];

  // Tutorial Set Up
  if ([TNTutorialManager shouldDisplayTutorial:self]) {
    self.tutorialManager = [[TNTutorialManager alloc] initWithDelegate:self blurFactor:0.1];
  } else {
    self.tutorialManager = nil;
  }
}

#pragma mark - TNTutorialManagerDelegate
// Selects highlighted area during tutorial
- (NSArray<UIView *> *)tutorialViewsToHighlight:(NSInteger)index
{
  if (index == 1) {
  } else if (index == 2) {
    return @[self.collectionView];
  } else if (index == 3) {
    return @[self.tabBarView];
  }
  return nil;
}

// Texts used during tutorial
- (NSArray<NSString *> *)tutorialTexts:(NSInteger)index
{
  if (index == 0) {
    return @[@"Welcome the Street Attractions!"];
  } else if (index == 1) {
    return @[@"Swipe from the left to pull out your profile options"];
  } else if (index == 2) {
    return @[@"Highlight a cell to see a preview, double tap it to see more details"];
  } else if (index == 3) {
    return @[@"Use the tab bar to navigate to the Explore, Favorites, and Map Page"];
  }
  return nil;
}

- (NSArray<TNTutorialEdgeInsets *> *)tutorialViewsEdgeInsets:(NSInteger)index
{
  if (index == 1) {
    return @[TNTutorialEdgeInsetsMake(8, 8, 8, 8)];
  }

  return nil;
}

- (NSArray<NSNumber *> *)tutorialTextPositions:(NSInteger)index
{
  return @[@(TNTutorialTextPositionTop)];
}

- (CGFloat)tutorialDelay:(NSInteger)index
{
  return 0;
}

- (BOOL)tutorialShouldCoverStatusBar
{
  return YES;
}

- (void)tutorialWrapUp
{
  self.tutorialManager = nil;
}

- (NSInteger)tutorialMaxIndex
{
  return 4;
}

- (UIFont *)tutorialSkipButtonFont
{
  return [UIFont systemFontOfSize:25 weight:UIFontWeightBold];
}

- (NSArray<UIFont *> *)tutorialTextFonts:(NSInteger)index
{
  if (index == 0) {
    return @[[UIFont systemFontOfSize:35.f weight:UIFontWeightBold]];
  }

  return @[[UIFont systemFontOfSize:17.f]];
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

// Highlighting a cell loads a preview of the details
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
  HomeCell *homeCell = (HomeCell *)[collectionView cellForItemAtIndexPath:indexPath];
  Post *post = self.posts[indexPath.item];
  [homeCell showDescription:post];
}

// Removes the detail preview after unhighlighting the cell
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
  HomeCell *homeCell = (HomeCell *)[collectionView cellForItemAtIndexPath:indexPath];
  Post *post = self.posts[indexPath.item];
  [homeCell loadPost:post];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return self.posts.count;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return [self.collectionViewSizeCalculator sizeForPhotoAtIndexPath:indexPath];
}

#pragma mark - <GreedoCollectionViewLayoutDataSource>

- (CGSize)greedoCollectionViewLayout:(GreedoCollectionViewLayout *)layout
        originalImageSizeAtIndexPath:(NSIndexPath *)indexPath
{
  // Return the image size to GreedoCollectionViewLayout
  if (indexPath.item < self.posts.count) {
    Post *post = self.posts[indexPath.item];
    // NSLog (@"%@, %f", post.description, post.rating.floatValue);
    if (post.rating.floatValue > 4.0) {
      NSLog(@"YEEES, %f", post.rating.floatValue);
      return CGSizeMake((CGFloat)([self randomValueBetween:260 and:300]),
                        (CGFloat)([self randomValueBetween:165 and:200]));
    } else {
      return CGSizeMake((CGFloat)([self randomValueBetween:121 and:230]),
                        (CGFloat)([self randomValueBetween:150 and:165]));
    }
  }

  return CGSizeMake(0.1, 0.1);
}
- (NSInteger)randomValueBetween:(NSInteger)min and:(NSInteger)max
{
  return (NSInteger)(min + arc4random_uniform(max - min + 1));
}

#pragma mark - Lazy Loading

- (GreedoCollectionViewLayout *)collectionViewSizeCalculator
{
  if (!_collectionViewSizeCalculator) {
    _collectionViewSizeCalculator = [[GreedoCollectionViewLayout alloc] initWithCollectionView:self.collectionView];
    _collectionViewSizeCalculator.dataSource = self;
  }

  return _collectionViewSizeCalculator;
}

#pragma mark - RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl
{
  [self fetchPost];
  [refreshControl endRefreshing];
}

#pragma mark - Network
// Initial request to fetch post
- (void)fetchPost
{
  PFQuery *postQuery = [Post query];
  User *user = [User currentUser];
  [postQuery includeKey:@"author"];
  [postQuery orderByDescending:@"createdAt"];
  if (user.location != nil) {
    [postQuery whereKey:@"city" equalTo:user.location];
  } else {
    [self alertLocation];
  }
  postQuery.limit = 20;
  [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> *_Nullable posts, NSError *_Nullable error) {
    if (posts) {
      if (posts.count == 0) {
        [self alertEmpty];
      }
      self.posts = [posts mutableCopy];
      [self.collectionView reloadData];
      self.dataSkip = posts.count;
    }
  }];
}

// Request to fetch older post when infinite scrolling
- (void)fetchMorePost
{
  PFQuery *postQuery = [Post query];
  User *user = [User currentUser];
  [postQuery includeKey:@"author"];
  [postQuery orderByDescending:@"createdAt"];
  if (user.location != nil) {
    [postQuery whereKey:@"city" equalTo:user.location];
  } else {
    [self alertLocation];
  }
  postQuery.limit = 20;
  [postQuery setSkip:self.dataSkip];
  [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> *_Nullable posts, NSError *_Nullable error) {
    if (posts) {
      if (posts.count > 0) {
        int prevNumPosts = self.posts.count;
        self.posts = [self.posts arrayByAddingObjectsFromArray:posts];
        NSMutableArray *newIndexPaths = [NSMutableArray array];
        for (int i = prevNumPosts; i < self.posts.count; i++) {
          [newIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        self.dataSkip += posts.count;
      }
      self.isMoreDataLoading = false;
      [self.collectionView reloadData];
    }
  }];
}

- (void)alertLocation
{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Locaiton"
                                                                           message:@"Please input your location"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
  [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    textField.placeholder = @"City";
    textField.textColor = [UIColor blueColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.borderStyle = UITextBorderStyleRoundedRect;
  }];
  [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                      NSArray *textfields = alertController.textFields;
                                                      UITextField *locationField = textfields[0];
                                                      [User currentUser].location = locationField.text;
                                                      [[User currentUser] saveInBackgroundWithBlock:^(
                                                                          BOOL succeeded, NSError *_Nullable error) {
                                                        [self fetchPost];
                                                      }];
                                                    }]];
  [self presentViewController:alertController animated:YES completion:nil];
}

- (void)alertEmpty
{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No post near you D:"
                                                                           message:@"Please try changing your location"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
  [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    textField.placeholder = @"City";
    textField.text = [User currentUser].location;
    textField.textColor = [UIColor blueColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.borderStyle = UITextBorderStyleRoundedRect;
  }];
  [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                      NSArray *textfields = alertController.textFields;
                                                      UITextField *locationField = textfields[0];
                                                      [User currentUser].location = locationField.text;
                                                      [[User currentUser] saveInBackgroundWithBlock:^(
                                                                          BOOL succeeded, NSError *_Nullable error) {
                                                        [self fetchPost];
                                                      }];
                                                    }]];
  [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - InfiniteScrolling
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if (!self.isMoreDataLoading) {
    int scrollViewContentHeight = self.collectionView.contentSize.height;
    int scrollOffsetThreshold = scrollViewContentHeight - self.collectionView.bounds.size.height;
    if (scrollView.contentOffset.y > scrollOffsetThreshold && self.collectionView.isDragging) {
      self.isMoreDataLoading = true;
      NSLog(@"More data");
      NSLog(@"%d", self.dataSkip);
      [self fetchMorePost];
    }
  }
}

#pragma mark - ComposeViewController Delegate
// Updates the post in the feed after the user posts a new event
- (void)didPost
{
  [self fetchPost];
}

#pragma mark - HomeCell Delegate
// Double tapping a cell triggers this delegate to segue to the complete detail view
- (void)homeCell:(HomeCell *)homeCell didTap:(Post *)post
{
  self.post = post;
  [self performSegueWithIdentifier:@"homeToDetails" sender:nil];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqual:@"homeToDetails"]) {
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.post = self.post;
  } else {
    ComposeViewController *composeViewController = [segue destinationViewController];
    composeViewController.delegate = self;
  }
}
@end
