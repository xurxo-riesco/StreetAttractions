//
//  StreetAttractionsTests.m
//  StreetAttractionsTests
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Category.h"
#import "User.h"
#import "Post.h"
#import "CategoryFeedViewController.h"

@import Parse;

@interface StreetAttractionsTests : XCTestCase
@property CategoryFeedViewController *categoryTest;
@property (strong, nonatomic) NSMutableArray *categories;
@property (strong, nonatomic) NSMutableArray *userCategories;
@property (nonatomic, strong) Category *category;
@property (nonatomic, strong) Post *post;
@property NSInteger favoriteCount;
@end

@implementation StreetAttractionsTests
- (void)setUp {
    [super setUp];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Set Up"];
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Set Up Post"];
    PFQuery *categoriesQuery = [Category query];
    [categoriesQuery includeKey:@"Posts"];
    categoriesQuery.limit = 10;
    [categoriesQuery findObjectsInBackgroundWithBlock:^(NSArray <Category*>* _Nullable categories, NSError * _Nullable error) {
        if (categories) {
            self.category = categories[0];
            User *user = [PFUser currentUser];
            PFRelation *relation = [user relationforKey:@"FavCategories"];
            [relation addObject:self.category];
            PFRelation *userRelation = [user relationForKey:@"FavUsers"];
            [userRelation addObject:[PFUser currentUser]];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [expectation fulfill];
            }];
        }
    }];
    Post *test = [Post new];
    self.post = test;
    [test saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded)
        {
            User *user = [PFUser currentUser];
            PFRelation *rateRelation = [user relationForKey:@"RatedPosts"];
            PFRelation *likeRelation = [user relationForKey:@"LikedPost"];
            [rateRelation addObject:self.post];
            [likeRelation addObject:self.post];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [expectation2 fulfill];
            }];
        }
    }];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        XCTAssertTrue(0==0);
    }];
}

- (void)tearDown {
    User *user = [PFUser currentUser];
    PFRelation *relation = [user relationforKey:@"FavCategories"];
    [relation addObject:self.category];
    PFRelation *userRelation = [user relationForKey:@"FavUsers"];
    [userRelation addObject:[PFUser currentUser]];
    [user saveInBackground];
}
- (void)testRetrieveCategories{
    NSLog(@"%@", [PFUser currentUser]);
    XCTestExpectation *expectation = [self expectationWithDescription:@"Retrieve Categories"];
    [User getCategoriesWithCompletion:^(NSArray * _Nonnull categories, NSArray * _Nonnull categoryStrings) {
        if(categories.count !=0)
        {
            [expectation fulfill];
        }
    }];
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        XCTAssertTrue(1==1);
    }];
}
- (void) testCategoryIsFavorite{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Is Favorite Category"];
    [User isFavorite:self.category WithCompletion:^(BOOL completion) {
        if(completion){
            [expectation fulfill];
        }
    }];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        XCTAssertTrue(0 ==0);
    }];
}
- (void)testRetrieveFavUsers{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Retrieve Categories"];
    [User getFavoritesWithCompletion:^(NSArray<User *> * _Nonnull favorites) {
        if(favorites.count != 0){
            [expectation fulfill];
        }
    }];
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        XCTAssertTrue(1==1);
    }];
}
- (void)testUserIsFavorite{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Is Favorite User"];
    [User isFavoriteUser:[PFUser currentUser] WithCompletion:^(BOOL completion) {
        if(completion){
            [expectation fulfill];
        }
    }];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        XCTAssertTrue(0 ==0);
    }];
}
- (void)testHasLiked{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Has Liked"];
    [User hasLiked:self.post WithCompletion:^(BOOL completion) {
        if(completion){
            [expectation fulfill];
        }
    }];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        XCTAssertTrue(0 ==0);
    }];
}
- (void)testHasRated{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Has Rated"];
    [User hasRated:self.post WithCompletion:^(BOOL completion){
        if(completion){
            [expectation fulfill];
        }
    }];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        XCTAssertTrue(0 ==0);
    }];
}
- (void)testPerformanceExample {
    [self measureBlock:^{
    }];
}

@end
