//
//  MessageThreadViewController.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/9/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "MessageThreadViewController.h"
#import "MessageCell.h"

@interface MessageThreadViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@end

@implementation MessageThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.user.screenname;
    
    // MutableArray Set Up
    self.messages = [[NSMutableArray alloc]init];
    
    // TableView Set Up
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // TextField Set Up
    self.messageField.delegate = self;
    
    // Initial network call
    [self fetchMessages];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(onTimer) userInfo:nil repeats:true];
}

- (void)onTimer {
    [self fetchMessages];
}

#pragma mark - Network
- (void) fetchMessages {
    User *user =[User currentUser];
    NSArray *users = [NSArray arrayWithObjects:user,self.user,nil];
    PFQuery *query = [Message query];
    [query whereKey:@"author" containedIn:users];
    [query includeKey:@"author"];
    [query whereKey:@"toUser" containedIn:users];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray<Message *> *messages, NSError *error) {
        if (messages != nil) {
            //NSLog(@"%@", messages);
            self.messages = messages;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}
- (IBAction)onSend:(id)sender {
    Message *message = [Message new];
    message.text = self.messageField.text;
    message.author = [PFUser currentUser];
    message.toUser = self.user;
    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded)
        {
            [self fetchMessages];
            self.messageField.text = @"";
        }
    }];
}

#pragma mark - TableView Delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Message *message = self.messages[indexPath.row];
    if([message.author.username isEqualToString:[PFUser currentUser].username])
    {
        MessageCell *messageCell = [ tableView dequeueReusableCellWithIdentifier:@"MessageCell" ];
        [messageCell loadOwnMessage:message];
        return messageCell;
    }else{
        MessageCell *messageCell = [ tableView dequeueReusableCellWithIdentifier:@"MessageCell" ];
        [messageCell loadMessage:message];
        return messageCell;
  }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

#pragma mark - TextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.messageField resignFirstResponder];
    return YES;
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
