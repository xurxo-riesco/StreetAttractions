//
//  CategoryFeedViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "CategoryFeedViewController.h"

@interface CategoryFeedViewController () <UICollectionViewDataSource, UICollectionViewDelegate, HomeCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CategoryFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [User isFavorite:self.category WithCompletion:^(BOOL completion) {
        if(completion){
            self.barButton.image = [UIImage systemImageNamed:@"star.fill"];
        }else{
            self.barButton.image = [UIImage systemImageNamed:@"star"];
        }
    }];
    self.barButton.image = [UIImage systemImageNamed:@"star"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.navigationItem.title = self.category.name;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = self.collectionView.frame.size.width / postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:refreshControl atIndex:0];
    [self colorCode];
    [self fetchPost];
}
- (void)viewWillDisappear:(BOOL)animated{
     UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundColor:[UIColor whiteColor]];
}
#pragma mark - RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self fetchPost];
    [refreshControl endRefreshing];
}

#pragma mark - RefreshControl
- (void)colorCode{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    if([self.category.name isEqual:@"Dancers"]){
        [navigationBar setBackgroundColor:[UIColor systemPinkColor]];
    }else if([self.category.name isEqual:@"Singers"]){
        [navigationBar setBackgroundColor:[UIColor systemYellowColor]];
    }else if([self.category.name isEqual:@"Magicians"]){
        [navigationBar setBackgroundColor:[UIColor systemGreenColor]];
    }
}

#pragma mark - Network
- (void)fetchPost {
    PFQuery *postQuery = [Post query];
    User *user = [PFUser currentUser];
    [postQuery includeKey:@"author"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery whereKey:@"city" equalTo:user.location];
    [postQuery whereKey:@"category" equalTo:self.category.name];
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
    [postQuery whereKey:@"category" equalTo:self.category.name];
    [postQuery whereKey:@"city" equalTo:user.location];
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
    [self performSegueWithIdentifier:@"categoriesToDetails" sender:nil];
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
    PFRelation *relation = [user relationForKey:@"FavCategories"];
    [relation addObject:self.category];
    [user saveInBackground];
    self.barButton.image = [UIImage systemImageNamed:@"star.fill"];
}
- (void) unfavorite{
    User *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"FavCategories"];
    [relation removeObject:self.category];
    [user saveInBackground];
    self.barButton.image = [UIImage systemImageNamed:@"star"];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.post = self.post;
    
}

@end
