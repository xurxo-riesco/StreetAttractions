//
//  CollabViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/22/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "CollabViewController.h"

@interface CollabViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation CollabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // MutableArray Set Up
    self.users = [[NSMutableArray alloc] init];
    //TableView Set Up
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Visual Set Up
    self.titleLabel.text = [NSString stringWithFormat:@"Hey, %@! We think you would enjoy doing a collab with some of these performers", [User currentUser].screenname];
}

#pragma mark - Network
- (void)fetchUserCategory{
    PFQuery *postQuery = [Post query];
    [postQuery whereKey:@"author" equalTo:[User currentUser]];
    [postQuery includeKey:@"author"];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray <Post *>* _Nullable objects, NSError * _Nullable error) {
        self.category = objects[0].category;
    }];
}

- (void)fetchUsers{
    PFQuery *queryUsers = [PFUser query];
    [queryUsers whereKey:@"location" equalTo:[User currentUser].location];
    queryUsers.limit = 50;
    [queryUsers findObjectsInBackgroundWithBlock:^(NSArray<PFUser *>* users, NSError * _Nullable error) {
        for(User *user in users)
        {
            PFRelation *relation = [user relationForKey:@"favUsers"];
            PFQuery *relationQuery = [relation query];
            [relationQuery findObjectsInBackgroundWithBlock:^(NSArray <User*> * objects, NSError * _Nullable error) {
                self.likesUser = NO;
                for(User *user in objects)
                {
                    if ([user isEqual:[User currentUser]])
                    {
                        self.likesUser = YES;
                    }
                }
                if(self.likesUser)
                {
                   for(User *user in objects)
                   {
                       if(user.isPerfomer && (![user isEqual:[User currentUser]]))
                       {
                           PFQuery *postQuery = [Post query];
                           [postQuery whereKey:@"author" equalTo:user];
                           [postQuery includeKey:@"author"];
                           [postQuery findObjectsInBackgroundWithBlock:^(NSArray <Post*>* _Nullable objects, NSError * _Nullable error) {
                               if([objects[0].category isEqual:self.category])
                               {
                                   [self.users addObject:user];
                               }
                           }];
                       }
                   }
                }
                
            }];
        }
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
