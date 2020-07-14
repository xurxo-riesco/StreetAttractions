//
//  CategoryFeedViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "CategoryFeedViewController.h"

@interface CategoryFeedViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
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
    [postQuery orderByDescending:@"createdAt"];
    [postQuery whereKey:@"city" equalTo:user.location];
    [postQuery whereKey:@"category" equalTo:self.category.name];
    postQuery.limit = 20;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.posts = [posts mutableCopy];
            [self.collectionView reloadData];
        }
    }];
}
#pragma mark - CollectionView Delegate
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HomeCell *homeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCell" forIndexPath: indexPath];
    Post *post = self.posts[indexPath.item];
    [homeCell loadPost:post];
    return homeCell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
