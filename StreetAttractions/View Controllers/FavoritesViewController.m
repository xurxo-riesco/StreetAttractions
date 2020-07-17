//
//  FavoritesViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "FavoritesViewController.h"

@interface FavoritesViewController ()<UITableViewDelegate, UITableViewDataSource, FavoriteCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    [User getCategoriesWithCompletion:^(NSArray * _Nonnull categories, NSArray * _Nonnull categoryStrings) {
        self.userCategories = categoryStrings;
        NSLog(@"%@", self.userCategories);
        [User getFavoritesWithCompletion:^(NSArray<User *> * _Nonnull favorites) {
            self.userFavorites = favorites;
            [self fetchFavCategoryPosts];
            NSLog(@"User FAVS: %@", self.userFavorites);
        }];
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
            [self.tableView reloadData];
        }
    }];
}
#pragma mark - InfiniteScrolling
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            //NSLog(@"More data");
            //NSLog(@"%d",self.dataSkip);
            //[self fetchMorePost];
        }
    }
}
#pragma mark - Network
- (void)fetchFavCategoryPosts {
    PFQuery *postQuery = [Post query];
    User *user = [PFUser currentUser];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery whereKey:@"city" equalTo:user.location];
    [postQuery whereKey:@"category" containedIn:self.userCategories];
    postQuery.limit = 20;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.posts = [posts mutableCopy];
            [self fetchFavUserPosts];
            //NSLog(@"%@ posts", self.posts);
        }
    }];
}
- (void)fetchFavUserPosts {
    PFQuery *postQuery = [Post query];
    User *user = [User currentUser];
    [postQuery includeKey:@"author"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery whereKey:@"city" equalTo:user.location];
    [postQuery whereKey:@"author" containedIn:self.userFavorites];
    postQuery.limit = 20;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post*>* _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            int prevNumPost = self.posts.count;
            for(Post *post in posts){
                if ([self.posts containsObject:post]){
                    NSLog(@"Repeated");
                    continue;
                }else{
                    [self.posts addObject:post];
                }
            }
            NSMutableArray *newIndexPaths = [[NSMutableArray alloc]init];
            for(int i = prevNumPost; i < self.posts.count; i++)
            {
                [newIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            self.dataSkip = self.posts.count;
            [self sortPosts];
        }
    }];
}
- (void)sortPosts{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt"
                                                 ascending:NO];
    self.posts = [self.posts sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self.tableView reloadData];
}
#pragma mark - RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self fetchFavCategoryPosts];
    [refreshControl endRefreshing];
}

#pragma mark - TableView Delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FavoriteCell *favoriteCell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteCell"];
    Post *post = self.posts[indexPath.row];
    [favoriteCell loadPost:post];
    return favoriteCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

#pragma mark - FavoriteCell Delegate
- (void)favoriteCell:(FavoriteCell *)favoriteCell didTap:(Post *)post{
    self.user = post.author;
    [self performSegueWithIdentifier:@"favToProfile" sender:nil];
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqual:@"favToProfile"]){
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.user = self.user;
    }else{
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.posts[indexPath.row];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    }
}

@end