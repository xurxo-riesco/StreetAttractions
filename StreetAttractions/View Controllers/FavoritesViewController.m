//
//  FavoritesViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "FavoritesViewController.h"

@interface FavoritesViewController ()<UITableViewDelegate, UITableViewDataSource>
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
        [self fetchFavCategoryPosts];
    }];
    [User getFavoritesWithCompletion:^(NSArray<User *> * _Nonnull favorites) {
        self.userFavorites = favorites;
    }];
}
#pragma mark - Network
- (void)fetchFavCategoryPosts {
    PFQuery *postQuery = [Post query];
    User *user = [PFUser currentUser];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery whereKey:@"city" equalTo:user.location];
    [postQuery whereKey:@"category" containedIn:self.userCategories];
    postQuery.limit = 20;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.posts = [posts mutableCopy];
            [self fetchFavUserPosts];
            NSLog(@"%@ posts", self.posts);
        }
    }];
}
- (void)fetchFavUserPosts {
    PFQuery *postQuery = [Post query];
    User *user = [PFUser currentUser];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery whereKey:@"city" equalTo:user.location];
    [postQuery whereKey:@"author" containedIn:self.userFavorites];
    postQuery.limit = 20;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            [self.posts addObjectsFromArray:posts];
            NSLog(@"%@ posts", self.posts);
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
    [self fetchFavUserPosts];
    
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
    NSLog(@"%@", self.posts);
    return self.posts.count;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
