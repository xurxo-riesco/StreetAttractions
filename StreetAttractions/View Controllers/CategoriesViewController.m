//
//  CategoriesViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "CategoriesViewController.h"

@interface CategoriesViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, HomeCellDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation CategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.collectionView.delegate = self;
    self.tableView.delegate = self;
    self.collectionView.dataSource = self;
    self.tableView.dataSource = self;
    [self fetchCategories];
    [self fetchPost];
}

#pragma mark - Network
- (void)fetchPost {
    PFQuery *postQuery = [Post query];
    postQuery.limit = 20;
    [postQuery includeKey:@"author"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.posts = [posts mutableCopy];
            [self.collectionView reloadData];
        }
    }];
}
- (void) fetchRecommended{
    PFQuery *postQuery = [Post query];
       postQuery.limit = 20;
       [postQuery includeKey:@"author"];
       [postQuery orderByDescending:@"likeCount"];
       [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
           if (posts) {
               self.posts = [posts mutableCopy];
               [self.collectionView reloadData];
           }
       }];
}
- (void) fetchCategories{
    PFQuery *categoriesQuery = [Category query];
    categoriesQuery.limit = 10;
    [categoriesQuery findObjectsInBackgroundWithBlock:^(NSArray <Category*>* _Nullable categories, NSError * _Nullable error) {
        if (categories) {
            self.categories = [categories mutableCopy];
            [self.tableView reloadData];
        }
    }];
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
#pragma mark - TableView Delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Category *category = self.categories[indexPath.row];
    CategoryCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell" ];
    [categoryCell loadCategory:category];
    return categoryCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}
 #pragma mark - HomeCell Delegate
- (void)homeCell:(HomeCell *)homeCell didTap:(Post *)post
{
    self.post = post;
    [self performSegueWithIdentifier:@"recommendedToDetails" sender:nil];
    
}
#pragma mark - SearchBar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText !=0){
        self.text = searchText;
        NSLog(@"%@", searchText);
        [self performSegueWithIdentifier:@"searchSegue" sender:nil];
    }
    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"SEGUEEE");
    [self performSegueWithIdentifier:@"searchSegue" sender:nil];
}
 #pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([segue.identifier isEqual:@"recommendedToDetails"])
     {
         DetailsViewController *detailsViewController = [segue destinationViewController];
         detailsViewController.post = self.post;
     }else if([segue.identifier isEqual:@"searchSegue"]){
         SearchViewController *searchViewController = [segue destinationViewController];
         searchViewController.text = self.text;
     }else{
     UITableViewCell *tappedCell = sender;
     NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
     Category *category = self.categories[indexPath.row];
     CategoryFeedViewController *categoryFeedViewController = [segue destinationViewController];
     categoryFeedViewController.category = category;
     }
 }

@end
