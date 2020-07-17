//
//  ProfileViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource, HomeCellDelegate>
@property double latitude;
@property double longitude;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.latitude = 0.0;
    self.longitude = 0.0;
    self.latitudes = [[NSMutableArray alloc]init];
    self.longitudes = [[NSMutableArray alloc]init];
    [User isFavoriteUser:self.user WithCompletion:^(BOOL completion) {
        if(completion){
            self.barButton.image = [UIImage systemImageNamed:@"star.fill"];
        }else{
            self.barButton.image = [UIImage systemImageNamed:@"star"];
        }
    }];
    self.barButton.image = [UIImage systemImageNamed:@"star"];
    self.screenameLabel.text = self.user.screenname;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@",self.user.username];
    self.cityLabel.text = self.user.location;
    self.profilePic.layer.cornerRadius = 20;
    self.profilePic.layer.masksToBounds = YES;
    self.profilePic.file = self.user.profilePic;
    [self.profilePic loadInBackground];
    if(self.user.isPerfomer)
    {
        self.isPerformer.alpha = 1;
        self.instaButton.alpha = 1;
    }
    else{
        self.isPerformer.alpha = 0;
        self.instaButton.alpha = 0;
    }
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:refreshControl atIndex:0];
    self.navigationItem.title = self.user.screenname;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = self.collectionView.frame.size.width / postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    [self fetchPost];
}
#pragma mark - Refresh Control
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self fetchPost];
    [refreshControl endRefreshing];
}

#pragma mark - Network
- (void)fetchPost {
    PFQuery *postQuery = [Post query];
    User *user = [PFUser currentUser];
    [postQuery includeKey:@"author"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery whereKey:@"author" equalTo:self.user];
    postQuery.limit = 20;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.posts = [posts mutableCopy];
            [self.collectionView reloadData];
            self.dataSkip = posts.count;
        }
    }];
}
- (void)fetchMorePost {
    PFQuery *postQuery = [Post query];
    User *user = [PFUser currentUser];
    [postQuery includeKey:@"author"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery whereKey:@"author" equalTo:self.user];
    postQuery.limit = 20;
    [postQuery setSkip:self.dataSkip];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            if (posts.count > 0)
            {
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
#pragma mark - InfiniteScrolling
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.collectionView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.collectionView.bounds.size.height;
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.collectionView.isDragging) {
            self.isMoreDataLoading = true;
            NSLog(@"More data");
            NSLog(@"%d",self.dataSkip);
            [self fetchMorePost];
        }
    }
}
#pragma mark - Favoriting
- (IBAction)onFavorite:(id)sender {
    if([self.barButton.image isEqual:[UIImage systemImageNamed:@"star"]]){
        [self favorite];
    }else{
        [self unfavorite];
    }
}
- (void) favorite{
    User *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"FavUsers"];
    [relation addObject:self.user];
    [user saveInBackground];
    self.barButton.image = [UIImage systemImageNamed:@"star.fill"];
}
- (void) unfavorite{
    User *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"FavUsers"];
    [relation removeObject:self.user];
    [user saveInBackground];
    self.barButton.image = [UIImage systemImageNamed:@"star"];
}
#pragma mark - Donations
- (IBAction)onDonate:(id)sender {
    [self showDropIn:@"sandbox_jy2p4xff_yxpkv9ztxt34tdkx"];
}
- (void)showDropIn:(NSString *)clientTokenOrTokenizationKey {
    BTDropInRequest *request = [[BTDropInRequest alloc] init];
    BTDropInController *dropIn = [[BTDropInController alloc] initWithAuthorization:clientTokenOrTokenizationKey request:request handler:^(BTDropInController * _Nonnull controller, BTDropInResult * _Nullable result, NSError * _Nullable error) {
        
        if (error != nil) {
            NSLog(@"ERROR");
        } else if (result.cancelled) {
            NSLog(@"CANCELLED");
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            BTPaymentMethodNonce *selectedNonce = result.paymentMethod;
            // Use the BTDropInResult properties to update your UI
            // result.paymentOptionType
            // result.paymentMethod
            // result.paymentIcon
            // result.paymentDescription
        }
    }];
    [self presentViewController:dropIn animated:YES completion:nil];
}
#pragma mark - CollectionView Delegate
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HomeCell *homeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCell" forIndexPath: indexPath];
    Post *post = self.posts[indexPath.item];
    homeCell.delegate = self;
    [homeCell loadPost:post];
    return homeCell;
}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

#pragma mark - HomeCell Delegate
- (void)homeCell:(HomeCell *)homeCell didTap:(Post *)post{
    self.post = post;
    [self performSegueWithIdentifier:@"profileToDetails" sender:nil];
}

- (IBAction)openInsta:(id)sender {
    NSString *urlString = [NSString stringWithFormat:@"instagram://user?username=%@", self.user.instagramName];
    NSURL *routeURL = [NSURL URLWithString:urlString];
    if([[UIApplication sharedApplication]canOpenURL:routeURL]){
        [[UIApplication sharedApplication] openURL:routeURL];
    }else{
        NSString *urlString = [NSString stringWithFormat:@"https://instagram.com/%@",self.user.instagramName];
        NSURL *newRouteURL = [NSURL URLWithString:urlString ];
        [[UIApplication sharedApplication] openURL:newRouteURL];
    }
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.post = self.post;
}

//- (void) fetchPostsAndPredict{
//    PFQuery *postQuery = [Post query];
//    User *user = [PFUser currentUser];
//    [postQuery whereKey:@"author" equalTo:self.user];
//    [postQuery orderByDescending:@"createdAt"];
//    postQuery.limit = 20;
//    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
//        if (posts) {
//            if([posts[0].category isEqual:@"Dancers"]){
//                self.isPerformer.tintColor = [UIColor systemPinkColor];
//            }else if(([posts[0].category isEqual:@"Singers"])){
//                self.isPerformer.tintColor = [UIColor yellowColor];
//            }
//            else if([posts[0].category isEqual:@"Magicians"]){
//                self.isPerformer.tintColor = [UIColor greenColor];
//            }
//            for(Post* post in posts)
//            {
//                [self.latitudes addObject:post.latitude];
//                [self.longitudes addObject:post.longitude];
//            }
//            //[self predictLocation];
//        }
//    }];
//}
//- (void)predictLocation {
//    for(NSNumber* num in self.latitudes)
//    {
//        self.latitude += [num doubleValue];
//    }
//    for(NSNumber* num in self.longitudes)
//    {
//        self.longitude += [num doubleValue];
//    }
//    self.latitude /= self.latitudes.count;
//    self.longitude /= self.longitudes.count;
//    NSLog(@"%f, %f", self.latitude, self.longitude);
//    NSError *error;
//    LocationPrediction2 *latitude2 = [[LocationPrediction2 alloc] init];
//    LocationPrediction2Output *result2 = [latitude2 predictionFromLatitude:120.289347 Longitude:90.504123 error:&error];
//    LocationPrediction3 *latitude3 = [[LocationPrediction3 alloc] init];
//    LocationPrediction3Output *result3 = [latitude3 predictionFromLatitude:120.2 Longitude:90. error:&error];
//    LocationPrediction1 *latitude = [[LocationPrediction1 alloc] init];
//    LocationPrediction1Output *resultLatitude = [latitude predictionFromLatitude:9000 error:&error];
//    LocationPrediction1copy *longitude = [[LocationPrediction1copy alloc] init];
//    LocationPrediction1copyOutput *resultLongitude = [longitude predictionFromLongitude:self.longitude error:&error];
//    NSLog(@"%f,%f, %f, %f", result3.Model_Latitude,result2.Model_Latitude, resultLatitude.Model_Latitude, resultLongitude.Model_Longitude);
//}


@end
