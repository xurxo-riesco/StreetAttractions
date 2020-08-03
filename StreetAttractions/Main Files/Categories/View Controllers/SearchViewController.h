//
//  SearchViewController.h
//  Instagram
//
//  Created by Xurxo Riesco on 7/10/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>

// View Controllers
#import "ProfileViewController.h"

// Views
#import "UserCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchViewController : UIViewController

/**
    Holds the text that is received from the Explore's page search bar
*/
@property (nonatomic, strong) NSString *text;
// This property is necessary since typing in the explore page search bar automatically segues to this controller
// Not having the property would decrease the quality in user experience as they would have to retype some of their
// search query characters

/**
    Search bar to find users
*/
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

/**
    Text from the search bar used to query users
*/
@property (nonatomic, strong) NSString *userString;

/**
    TableView to display all users matching a query
*/
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
    Stores all users that match the searchBar text
*/
@property (strong, nonatomic) NSArray *users;

/**
    Temporarely stores the user object of a cell (Used for seguing)
*/
@property (strong, nonatomic) User *user;


@end

NS_ASSUME_NONNULL_END
