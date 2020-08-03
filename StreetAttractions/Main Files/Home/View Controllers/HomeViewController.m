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

// Notifications enabled or not
bool isGrantedNotificationAccess;
// Helper app to avoid notifications opening the app
bool first;
// Helper variables to determine when notifications should be sent
NSInteger messageCount;
NSInteger prevMessageCount;

@implementation HomeViewController

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  if (self.tutorialManager) {
    [self.tutorialManager updateTutorial];
  }
}
- (void)viewDidDisappear:(BOOL)animated
{
  self.timer.invalidate;
}
- (void)viewDidLoad
{
  [super viewDidLoad];

  // CollectionView Set Up
  self.collectionView.backgroundColor = [UIColor colorWithRed:239.0 / 255.0
                                                        green:235.0 / 255.0
                                                         blue:234.0 / 255.0
                                                        alpha:1];
  self.collectionView.delegate = self;
  self.collectionView.dataSource = self;
  self.collectionViewSizeCalculator.rowMaximumHeight = CGRectGetHeight(self.collectionView.bounds) / 2.5;
  self.collectionViewSizeCalculator.fixedHeight = self.hasFixedHeight;
  self.automaticallyAdjustsScrollViewInsets = YES;
  // self.collectionView.backgroundColor = [UIColor whiteColor];
  // Configure spacing between cells
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  layout.minimumInteritemSpacing = 2.0f;
  layout.minimumLineSpacing = 2.0f;
  layout.sectionInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
  self.collectionView.collectionViewLayout = layout;

  // Refresh Control Set Up
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl setTintColor:[UIColor blackColor]];
  [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
  [self.collectionView insertSubview:self.refreshControl atIndex:0];

  // Network Call
  [self.refreshControl beginRefreshing];
  [self fetchPost];

  // Tutorial Set Up
  if ([TNTutorialManager shouldDisplayTutorial:self]) {
    self.tutorialManager = [[TNTutorialManager alloc] initWithDelegate:self blurFactor:0.1];
  } else {
    self.tutorialManager = nil;
  }

  // Notification Set Up
  first = true;
  prevMessageCount = 0;
  messageCount = prevMessageCount;
  isGrantedNotificationAccess = false;
  self.timer = [NSTimer scheduledTimerWithTimeInterval:5
                                                target:self
                                              selector:@selector(onTimer)
                                              userInfo:nil
                                               repeats:true];
  UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
  UNAuthorizationOptions *options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;

  [center requestAuthorizationWithOptions:options
                        completionHandler:^(BOOL granted, NSError *_Nullable error) {
                          isGrantedNotificationAccess = granted;
                        }];
}

- (void)onTimer
{
  if (messageCount > prevMessageCount && !first) {
    prevMessageCount = messageCount;
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];

    content.title = @"Street Attractions";
    content.subtitle = @"New message!";
    NSString *body = [NSString stringWithFormat:@"You have a new message from %@", self.userMessage];
    content.body = body;
    content.sound = [UNNotificationSound defaultSound];

    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.5
                                                                                                    repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification"
                                                                          content:content
                                                                          trigger:trigger];
    [center addNotificationRequest:request withCompletionHandler:nil];
  }
  [self fetchMessages];
}

#pragma mark - Network
- (void)fetchMessages
{
  User *user = [User currentUser];
  PFQuery *query = [Message query];
  [query includeKey:@"author"];
  [query whereKey:@"toUser" equalTo:user];
  query.limit = 20;
  [query findObjectsInBackgroundWithBlock:^(NSArray<Message *> *messages, NSError *error) {
    if (messages != nil) {
      messageCount = messages.count;
      if (first) {
        prevMessageCount = messageCount;
        first = false;
      }
      if (messageCount > prevMessageCount) {
        User *user = messages[messages.count - 1].author;
        self.userMessage = user.screenname;
      }
    } else {
      NSLog(@"%@", error.localizedDescription);
    }
  }];
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
    if (indexPath.item == self.posts.count - 1) {
      return CGSizeMake((CGFloat)([self randomValueBetween:300 and:414]),
                        (CGFloat)([self randomValueBetween:165 and:201]));
    }
    // NSLog (@"%@, %f", post.description, post.rating.floatValue);
    if (post.rating.floatValue > 4.5) {
      NSLog(@"YEEES, %f", post.rating.floatValue);
      return CGSizeMake((CGFloat)([self randomValueBetween:200 and:260]),
                        (CGFloat)([self randomValueBetween:165 and:201]));
    } else {
      return CGSizeMake((CGFloat)([self randomValueBetween:121 and:200]),
                        (CGFloat)([self randomValueBetween:150 and:165]));
    }
  }

  return CGSizeMake(20.0, 0.0);
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
  [postQuery orderByDescending:@"created_At"];
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
      self.dataSkip = (int)posts.count;
    }
    [self.refreshControl endRefreshing];
  }];
}

// Request to fetch older post when infinite scrolling
- (void)fetchMorePost
{
  PFQuery *postQuery = [Post query];
  User *user = [User currentUser];
  [postQuery includeKey:@"author"];
  [postQuery orderByDescending:@"created_At"];
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
  if (isGrantedNotificationAccess) {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];

    content.title = @"Street Attractions";
    content.subtitle = @"New event!";
    content.body = @"There is a new event near you! Check it out!";
    content.sound = [UNNotificationSound defaultSound];

    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2
                                                                                                    repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification"
                                                                          content:content
                                                                          trigger:trigger];
    [center addNotificationRequest:request withCompletionHandler:nil];
  }

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
