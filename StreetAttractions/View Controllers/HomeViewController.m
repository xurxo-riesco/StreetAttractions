//
//  HomeViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "HomeViewController.h"
@interface HomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, ComposeViewControllerDelegate, HomeCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = self.collectionView.frame.size.width / postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:refreshControl atIndex:0];
    [self fetchPost];
}


#pragma mark - RefreshControl
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
    [postQuery whereKey:@"city" equalTo:user.location];
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

-(void) collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCell *homeCell = [collectionView cellForItemAtIndexPath:indexPath];
    Post *post = self.posts[indexPath.item];
    [homeCell showDescription:post];
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCell *homeCell = [collectionView cellForItemAtIndexPath:indexPath];
    Post *post = self.posts[indexPath.item];
    [homeCell loadPost:post];
}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}
#pragma mark - ComposeViewController Delegate
- (void)didPost{
    [self fetchPost];
}
#pragma mark - HomeCell Delegate
- (void)homeCell:(HomeCell *)homeCell didTap:(Post *)post{
    self.post = post;
    [self performSegueWithIdentifier:@"homeToDetails" sender:nil];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqual:@"homeToDetails"])
    {
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = self.post;
    }else{
        ComposeViewController *composeViewController = [segue destinationViewController];
        composeViewController.delegate = self;
    }
}


@end
