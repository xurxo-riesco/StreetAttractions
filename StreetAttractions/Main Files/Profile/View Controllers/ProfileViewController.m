//
//  ProfileViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "ProfileViewController.h"
@interface ProfileViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, HomeCellDelegate>
@end

@implementation ProfileViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  // Mutable Array Set Up
  self.latitudes = [[NSMutableArray alloc] init];
  self.longitudes = [[NSMutableArray alloc] init];
  self.dates = [[NSMutableArray alloc] init];

  // Favoriting Set Up
  [User isFavoriteUser:self.user
        WithCompletion:^(BOOL completion) {
          if (completion) {
            self.barButton.image = [UIImage systemImageNamed:@"star.fill"];
          } else {
            self.barButton.image = [UIImage systemImageNamed:@"star"];
          }
        }];
  self.barButton.image = [UIImage systemImageNamed:@"star"];

  // Visual Set up
  self.screenameLabel.text = self.user.screenname;
  self.usernameLabel.text = [NSString stringWithFormat:@"@%@", self.user.username];
  self.cityLabel.text = self.user.location;
  self.profilePic.layer.cornerRadius = 20;
  self.profilePic.layer.masksToBounds = YES;
  self.profilePic.file = self.user.profilePic;
  [self.profilePic loadInBackground];

  // Performer Options Set Up
  if (self.user.isPerfomer) {
    self.isPerformer.alpha = 1;
    self.instaButton.alpha = 1;
    self.mapButton.alpha = 1;
    if (self.user.isLive) {
      self.liveButton.alpha = 1;
    } else {
      self.liveButton.alpha = 0;
    }
  } else {
    self.isPerformer.alpha = 0;
    self.instaButton.alpha = 0;
    self.liveButton.alpha = 0;
    self.mapButton.alpha = 0;
  }

  // CollectionView Set Up
  self.collectionView.delegate = self;
  self.collectionView.dataSource = self;
  UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
  CGFloat postersPerLine = 3;
  CGFloat itemWidth = self.collectionView.frame.size.width / postersPerLine;
  CGFloat itemHeight = itemWidth;
  layout.itemSize = CGSizeMake(itemWidth, itemHeight);

  // RefreshControl Set Up
  UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
  [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
  [self.collectionView insertSubview:refreshControl atIndex:0];
  self.navigationItem.title = self.user.screenname;
  [self fetchPost];
}

#pragma mark - Network
- (void)fetchPost
{
  PFQuery *postQuery = [Post query];
  [postQuery includeKey:@"author"];
  [postQuery orderByDescending:@"createdAt"];
  [postQuery whereKey:@"author" equalTo:self.user];
  postQuery.limit = 20;
  [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> *_Nullable posts, NSError *_Nullable error) {
    if (posts) {
      self.posts = [posts mutableCopy];
      [self.collectionView reloadData];
      self.dataSkip = posts.count;
    }
  }];
}

- (void)fetchMorePost
{
  PFQuery *postQuery = [Post query];
  User *user = [User currentUser];
  [postQuery includeKey:@"author"];
  [postQuery orderByDescending:@"createdAt"];
  [postQuery whereKey:@"author" equalTo:self.user];
  postQuery.limit = 20;
  [postQuery setSkip:self.dataSkip];
  [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> *_Nullable posts, NSError *_Nullable error) {
    if (posts) {
      if (posts.count > 0) {
        int prevNumPosts = (int) self.posts.count;
        self.posts = (NSMutableArray *)[self.posts arrayByAddingObjectsFromArray:posts];
        NSMutableArray *newIndexPaths = [NSMutableArray array];
        for (int i = prevNumPosts; i < self.posts.count; i++) {
          [newIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        self.dataSkip += (int) posts.count;
      }
      self.isMoreDataLoading = false;
      [self.collectionView reloadData];
    }
  }];
}

#pragma mark - Refresh Control
- (void)beginRefresh:(UIRefreshControl *)refreshControl
{
  [self fetchPost];
  [refreshControl endRefreshing];
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
  // Sets the user as favorited by the current user in the server
  User *user = [User currentUser];
  PFRelation *relation = [user relationForKey:@"FavUsers"];
  [relation addObject:self.user];
  [user saveInBackground];
  self.user.followersCount = [NSNumber numberWithInt:([self.user.followersCount intValue] + 1)];
  [self.user saveInBackground];

  // Changes the favoriting button state to reflect the backend change
  self.barButton.image = [UIImage systemImageNamed:@"star.fill"];
}
- (void)unfavorite
{
  // Sets the user as unfavorited by the current user in the server
  User *user = [User currentUser];
  PFRelation *relation = [user relationForKey:@"FavUsers"];
  [relation removeObject:self.user];
  [user saveInBackground];
  self.user.followersCount = [NSNumber numberWithInt:([self.user.followersCount intValue] - 1)];
  [self.user saveInBackground];

  // Changes the favoriting button state to reflect the backend change
  self.barButton.image = [UIImage systemImageNamed:@"star"];
}
#pragma mark - Donations
- (IBAction)onDonate:(id)sender
{
  [self showDropIn:@"sandbox_jy2p4xff_yxpkv9ztxt34tdkx"];
}
- (void)showDropIn:(NSString *)clientTokenOrTokenizationKey
{
  BTDropInRequest *request = [[BTDropInRequest alloc] init];
  BTDropInController *dropIn = [[BTDropInController alloc]
  initWithAuthorization:clientTokenOrTokenizationKey
                request:request
                handler:^(
                BTDropInController *_Nonnull controller, BTDropInResult *_Nullable result, NSError *_Nullable error) {
                  if (error != nil) {
                    NSLog(@"ERROR");
                  } else if (result.cancelled) {
                    NSLog(@"CANCELLED");
                    [self dismissViewControllerAnimated:YES completion:nil];
                  } else {
                    BTPaymentMethodNonce *selectedNonce = result.paymentMethod;
                  }
                }];
  [self presentViewController:dropIn animated:YES completion:nil];
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
  [self performSegueWithIdentifier:@"profileToDetails" sender:nil];
}

#pragma mark - Performer Profile Links
- (IBAction)openInsta:(id)sender
{
  NSString *urlString = [NSString stringWithFormat:@"instagram://user?username=%@", self.user.instagramName];
  NSURL *routeURL = [NSURL URLWithString:urlString];
  if ([[UIApplication sharedApplication] canOpenURL:routeURL]) {
    [[UIApplication sharedApplication] openURL:routeURL];
  } else {
    NSString *urlString = [NSString stringWithFormat:@"https://instagram.com/%@", self.user.instagramName];
    NSURL *newRouteURL = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:newRouteURL];
  }
}

- (IBAction)openLive:(id)sender
{
  NSURL *newRouteURL = [NSURL URLWithString:self.user.liveURL];
  NSLog(@"%@", self.user.liveURL);
  [[UIApplication sharedApplication] openURL:newRouteURL];
  NSLog(@"OPen live");
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqual:@"toMessages"]) {
    MessageThreadViewController *messageThreadViewController = [segue destinationViewController];
    messageThreadViewController.user = self.user;
  } else {
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.post = self.post;
  }
}

#pragma mark - Machine Learning
- (IBAction)onPredict:(id)sender
{
  [self fetchPostsAndPredict];
}

- (void)fetchPostsAndPredict
{
  PFQuery *postQuery = [Post query];
  [postQuery whereKey:@"author" equalTo:self.user];
  [postQuery orderByDescending:@"createdAt"];
  postQuery.limit = 20;
  [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> *_Nullable posts, NSError *_Nullable error) {
    if (posts) {
      for (Post *post in posts) {
        [self.latitudes addObject:post.latitude];
        [self.longitudes addObject:post.longitude];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:23];
        [comps setMonth:12];
        [comps setYear:1899];
        NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];
        NSInteger days = [date daysFrom:post.createdAt];
        [self.dates addObject:[NSNumber numberWithInt:days]];
      }
      [self predictLocation];
    }
  }];
}
- (void)predictLocation
{
  NSError *error;
  double latitude1 = [self.latitudes[0] doubleValue];
  double latitude2 = [self.latitudes[1] doubleValue];
  double latitude3 = [self.latitudes[2] doubleValue];
  double longitude1 = [self.longitudes[0] doubleValue];
  double longitude2 = [self.longitudes[1] doubleValue];
  double longitude3 = [self.longitudes[2] doubleValue];
  double date1 = [self.dates[0] doubleValue];
  double date2 = [self.dates[1] doubleValue];
  double date3 = [self.dates[2] doubleValue];
  double date4 = [self.dates[3] doubleValue];
  double date5 = [self.dates[4] doubleValue];

  LatitudePredictor *latitudeModel = [[LatitudePredictor alloc] init];
  LongitudePredictor *longitudeModel = [[LongitudePredictor alloc] init];
  DatePredictor *dateModel = [[DatePredictor alloc] init];
  LatitudePredictorOutput *resultLatitude = [latitudeModel predictionFromUser:self.user.objectId
                                                                    Latitude1:latitude1
                                                                    Latitude2:latitude2
                                                                    Latitude3:latitude3
                                                                        error:&error];
  LongitudePredictorOutput *resultLongitude = [longitudeModel predictionFromUser:self.user.objectId
                                                                      Longitude1:longitude1
                                                                      Longitude2:longitude2
                                                                      Longitude3:longitude3
                                                                           error:&error];
  DatePredictorOutput *resultDate = [dateModel predictionFromUser:self.user.objectId
                                                            Date1:date1
                                                            Date2:date2
                                                            Date3:date3
                                                            Date4:date4
                                                           Date_5:date5
                                                            error:&error];
  NSDateComponents *comps = [[NSDateComponents alloc] init];
  [comps setDay:23];
  [comps setMonth:12];
  [comps setYear:1899];
  NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];
  NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
  dayComponent.day = resultDate.Next_Date;
  NSCalendar *theCalendar = [NSCalendar currentCalendar];
  NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:date options:0];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd"];
  NSString *stringFromDate = [formatter stringFromDate:nextDate];
  NSString *performanceDate = [NSString stringWithFormat:@"Next performance should be on: %@", stringFromDate];
  NSString *routeString = [NSString stringWithFormat:@"https://www.google.com/maps/search/?api=1&query=%f,%f",
                                                     resultLatitude.Model_Latitude,
                                                     resultLongitude.Model_Longitude];
  NSURL *routeURL = [NSURL URLWithString:routeString];
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Prediction"
                                                                       message:performanceDate
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
  UIAlertAction *googleMaps = [UIAlertAction actionWithTitle:@"See location!"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *_Nonnull action) {
                                                       if ([[UIApplication sharedApplication] canOpenURL:routeURL]) {
                                                         [[UIApplication sharedApplication] openURL:routeURL];
                                                       }
                                                     }];
  [actionSheet addAction:googleMaps];
  [self presentViewController:actionSheet animated:YES completion:nil];
}

@end
