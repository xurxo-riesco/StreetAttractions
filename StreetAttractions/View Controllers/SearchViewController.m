//
//  SearchViewController.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/10/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "SearchViewController.h"


@interface SearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSString *userString;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *users;
@property (strong, nonatomic) User *user;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TableView Set Up
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // SearchBar Set Up
    [self.searchBar becomeFirstResponder];
    self.searchBar.text = self.text;
}

#pragma mark - SearchBar Delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.userString = searchBar.text;
    [self fetchUsers];
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText !=0){
        self.userString = searchBar.text;
        [self fetchUsers];
    }
    [self.tableView reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - Network
- (void)fetchUsers{
    PFQuery *queryUsers = [PFUser query];
    [queryUsers whereKey:@"username" containsString:self.userString];
    queryUsers.limit = 20;
    [queryUsers findObjectsInBackgroundWithBlock:^(NSArray<PFUser *>* users, NSError * _Nullable error) {
        self.users = users;
        [self.tableView reloadData];
    }];
}

#pragma mark - TableView Delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PFUser *user = self.users[indexPath.row];
    UserCell *userCell = [ tableView dequeueReusableCellWithIdentifier:@"UserCell" ];
    userCell.delegate = self;
    [userCell loadUser:user];
    return userCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

#pragma mark - UserCell Delegate
- (void) userCell:(UserCell *)userCell didTap:(PFUser *)user{
    self.user = (User *)user;
    [self performSegueWithIdentifier:@"toProfile" sender:nil];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ProfileViewController *profileViewController = [segue destinationViewController];
    profileViewController.user = self.user;
}

@end
