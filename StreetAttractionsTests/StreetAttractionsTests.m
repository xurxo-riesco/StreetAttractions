//
//  StreetAttractionsTests.m
//  StreetAttractionsTests
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>
#import <XCTest/XCTest.h>

#import "Category.h"
#import "CategoryFeedViewController.h"
#import "DatePredictor.h"
#import "Post.h"
#import "User.h"

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

- (void)setUp
{
  [super setUp];

  // Expectations to wait for network call
  XCTestExpectation *expectation = [self expectationWithDescription:@"Set Up"];
  XCTestExpectation *expectation2 = [self expectationWithDescription:@"Set Up Post"];
  PFQuery *categoriesQuery = [Category query];
  [categoriesQuery includeKey:@"Posts"];
  categoriesQuery.limit = 10;
  [categoriesQuery
  findObjectsInBackgroundWithBlock:^(NSArray<Category *> *_Nullable categories, NSError *_Nullable error) {
    if (categories) {
      User *user = [User currentUser];

      // Stores the category that will be liked (used in testCategoryIsFavorite)
      self.category = categories[0];

      // Adds a category to favorites (used in testRetrieveCategories)
      PFRelation *relation = [user relationforKey:@"FavCategories"];
      [relation addObject:self.category];

      // Adds a user to favorite (used in testRetrieveFavUsers and testUserIsFavorite)
      PFRelation *userRelation = [user relationForKey:@"FavUsers"];
      [userRelation addObject:[PFUser currentUser]];

      // Saves to backend
      [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *_Nullable error) {
        [expectation fulfill];
      }];
    }
  }];

  // Creates a new post
  Post *test = [Post new];
  self.post = test;
  [test saveInBackgroundWithBlock:^(BOOL succeeded, NSError *_Nullable error) {
    if (succeeded) {
      User *user = [User currentUser];
      // Adds the post to the user's rated (used in testHasRated)
      PFRelation *rateRelation = [user relationForKey:@"RatedPosts"];
      [rateRelation addObject:self.post];

      // Adds the post to the user's liked (used in testHasLiked)
      PFRelation *likeRelation = [user relationForKey:@"LikedPost"];
      [likeRelation addObject:self.post];

      // Adds the post to the user's claimed (used in hasClaimed)
      PFRelation *claimRelation = [user relationForKey:@"ClaimedPosts"];
      [claimRelation addObject:self.post];

      // Saves to backend
      [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *_Nullable error) {
        [expectation2 fulfill];
      }];
    }
  }];

  // Asserts that network calls are completed and can proceed with the tests
  [self waitForExpectationsWithTimeout:10
                               handler:^(NSError *_Nullable error) {
                                 XCTAssertTrue(0 == 0);
                               }];
}

- (void)tearDown
{
  // Removes all the relations created during the set up in the server side
  User *user = [User currentUser];
  PFRelation *relation = [user relationforKey:@"FavCategories"];
  [relation removeObject:self.category];
  PFRelation *userRelation = [user relationForKey:@"FavUsers"];
  [userRelation removeObject:[PFUser currentUser]];
  [user saveInBackground];
}

- (void)testRetrieveCategories
{
  // Expectation to wait for network call
  XCTestExpectation *expectation = [self expectationWithDescription:@"Retrieve Categories"];

  // Retrieves post from a favorite category, if the content retrieve is not nil, test passes
  [User getCategoriesWithCompletion:^(NSArray *_Nonnull categories, NSArray *_Nonnull categoryStrings) {
    if (categories.count != 0) {
      [expectation fulfill];
    }
  }];

  // Asserts based on the completion of the network call
  [self waitForExpectationsWithTimeout:5
                               handler:^(NSError *_Nullable error) {
                                 XCTAssertTrue(1 == 1);
                               }];
}

- (void)testCategoryIsFavorite
{
  // Expectation to wait for network call
  XCTestExpectation *expectation = [self expectationWithDescription:@"Is Favorite Category"];

  // Checks if the user has favorited another user, since the user was favorited in the setup, completion indicates the
  // test passed
  [User isFavorite:self.category
    WithCompletion:^(BOOL completion) {
      if (completion) {
        [expectation fulfill];
      }
    }];

  // Asserts based on the completion of the network call
  [self waitForExpectationsWithTimeout:10
                               handler:^(NSError *_Nullable error) {
                                 XCTAssertTrue(0 == 0);
                               }];
}

- (void)testRetrieveFavUsers
{
  // Expectation to wait for network call
  XCTestExpectation *expectation = [self expectationWithDescription:@"Retrieve Categories"];

  // Retrieves posts from a favorite user, if the content retrieve is not nil, test passes
  [User getFavoritesWithCompletion:^(NSArray<User *> *_Nonnull favorites) {
    if (favorites.count != 0) {
      [expectation fulfill];
    }
  }];

  // Asserts based on the completion of the network call
  [self waitForExpectationsWithTimeout:5
                               handler:^(NSError *_Nullable error) {
                                 XCTAssertTrue(1 == 1);
                               }];
}

- (void)testUserIsFavorite
{
  // Expectation to wait for network call
  XCTestExpectation *expectation = [self expectationWithDescription:@"Is Favorite User"];

  // Checks if the user has favorited another user, since the user was favorited in the setup, completion indicates the
  // test passed
  [User isFavoriteUser:[User currentUser]
        WithCompletion:^(BOOL completion) {
          if (completion) {
            [expectation fulfill];
          }
        }];

  // Asserts based on the completion of the network call
  [self waitForExpectationsWithTimeout:10
                               handler:^(NSError *_Nullable error) {
                                 XCTAssertTrue(0 == 0);
                               }];
}

- (void)testHasLiked
{
  // Expectation to wait for network call
  XCTestExpectation *expectation = [self expectationWithDescription:@"Has Liked"];

  // Checks if the user has liked a post, since the post was liked in the setup, completion indicates the test passed
  [User hasLiked:self.post
  WithCompletion:^(BOOL completion) {
    if (completion) {
      [expectation fulfill];
    }
  }];

  // Asserts based on the completion of the network call
  [self waitForExpectationsWithTimeout:10
                               handler:^(NSError *_Nullable error) {
                                 XCTAssertTrue(0 == 0);
                               }];
}

- (void)testHasRated
{
  // Expectation to wait for network call
  XCTestExpectation *expectation = [self expectationWithDescription:@"Has Rated"];

  // Checks if the user has rated a post, since the post was rated in the setup, completion indicates the test passed
  [User hasRated:self.post
  WithCompletion:^(BOOL completion) {
    if (completion) {
      [expectation fulfill];
    }
  }];

  // Asserts based on the completion of the network call
  [self waitForExpectationsWithTimeout:10
                               handler:^(NSError *_Nullable error) {
                                 XCTAssertTrue(0 == 0);
                               }];
}
- (void)testHasClaimed
{
  // Expectation to wait for network call
  XCTestExpectation *expectation = [self expectationWithDescription:@"Has Claimed"];

  // Checks if the user has claimed a post, since the post was claimed in the setup, completion indicates the test
  // passed
  [User hasClaimed:self.post
    WithCompletion:^(BOOL completion) {
      if (completion) {
        [expectation fulfill];
      }
    }];

  // Asserts based on the completion of the network call
  [self waitForExpectationsWithTimeout:10
                               handler:^(NSError *_Nullable error) {
                                 XCTAssertTrue(0 == 0);
                               }];
}

- (void)testNotifications
{
  // Starts a notification center
  UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
  UNAuthorizationOptions *options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
  [center requestAuthorizationWithOptions:options
                        completionHandler:^(BOOL granted, NSError *_Nullable error){
                        }];

  // Creates a notification
  UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
  content.title = @"Street Attractions";
  content.subtitle = @"Test";
  NSString *body = @"Testing User Notifications";
  content.body = body;
  content.sound = [UNNotificationSound defaultSound];
  UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
  UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification"
                                                                        content:content
                                                                        trigger:trigger];

  // Sends notification to the center, if action is completed test passes
  [center addNotificationRequest:request
           withCompletionHandler:^(NSError *_Nullable error) {
             if (!error) {
               XCTAssertTrue(0 == 0);
             }
           }];
}
- (void)testDateRegression
{
  NSError *error;

  // Array that holds the dates used for the prediction
  NSMutableArray *intDates = [[NSMutableArray alloc] init];

  // Sets up the reference date
  NSDateComponents *comps = [[NSDateComponents alloc] init];
  [comps setDay:23];
  [comps setMonth:12];
  [comps setYear:1899];
  NSDate *referenceDate = [[NSCalendar currentCalendar] dateFromComponents:comps];

  /*
   SETS UP THE FORMATTER
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd"];
   */

  // Creates an array of test dates (in integer value format)
  NSDate *testDate = [NSDate date];
  for (int i = 0; i < 5; i++) {
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDateComponents *daysToAdd = [[NSDateComponents alloc] init];
    daysToAdd.day = 1;
    testDate = [theCalendar dateByAddingComponents:daysToAdd toDate:testDate options:0];
    NSInteger days = [referenceDate daysFrom:testDate];
    [intDates addObject:[NSNumber numberWithInt:-(int)days]];

    // NSString *stringFromDate = [formatter stringFromDate:testDate];
    // NSLog(@"%d: %@, %d", i, stringFromDate, days);
  }

  /*
   Xurxo - Object ID = u5HWNLNhuJ
   WaffleCrew - Object ID = 0WyDOEKrYE
   */
  DatePredictor *dateModel = [[DatePredictor alloc] init];
  DatePredictorOutput *resultDate = [dateModel predictionFromUser:@"u5HWNLNhuJ"
                                                            Date1:[intDates[0] floatValue]
                                                            Date2:[intDates[1] floatValue]
                                                            Date3:[intDates[2] floatValue]
                                                            Date4:[intDates[3] floatValue]
                                                           Date_5:[intDates[4] floatValue]
                                                            error:&error];

  /*
   PRINTS THE PREDICTED DATE IN A READABLE FORMAT
  NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
  dayComponent.day = resultDate.Next_Date;
  NSLog(@"%f", resultDate.Next_Date);
  NSCalendar *theCalendar = [NSCalendar currentCalendar];
  NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:referenceDate options:0];

  NSString *stringFromDate = [formatter stringFromDate:nextDate];
  NSLog(@"%@", stringFromDate);
   */

  // If the predicted date is not before the date of the last performance, the prediction is deemed valid
  XCTAssertTrue(resultDate.Next_Date >= [intDates[4] floatValue]);
}

- (void)testPerformanceExample
{
  [self measureBlock:^{
  }];
}

@end
