//
//  CommentsViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/17/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "CommentsViewController.h"

@interface CommentsViewController () <UITableViewDelegate, UITableViewDataSource, CommentCellDelegate>

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchComments];
    // Do any additional setup after loading the view.
}
#pragma mark - Network
- (void)fetchComments {
    PFRelation *relation = [self.post relationForKey:@"Comment"];
    PFQuery *query = [relation query];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray* _Nullable comments, NSError * _Nullable error) {
        if (comments) {
            self.comments = [comments mutableCopy];
            NSLog(@"%@", self.comments);
            [self.tableView reloadData];
        }
    }];
}

- (IBAction)onPost:(id)sender {
    Comment *newComment = [Comment new];
    newComment.author = [PFUser currentUser];
    newComment.text = self.commentField.text;
    [newComment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            PFRelation *relation = [self.post relationForKey:@"Comment"];
            [relation addObject:newComment];
            [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded){
                    [self fetchComments];
                }
            }];
        }
    }];
}

- (void) commentCell:(CommentCell *)commentCell didTap:(User *)user{
    self.user = user;
    [self performSegueWithIdentifier:@"toProfile" sender:nil];
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Comment *comment = self.comments[indexPath.row];
    CommentCell *commentCell = [ tableView dequeueReusableCellWithIdentifier:@"CommentCell" ];
    [commentCell loadComment:comment];
    return commentCell;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ProfileViewController *profileViewController = [segue destinationViewController];
    profileViewController.user = self.user;
}
@end