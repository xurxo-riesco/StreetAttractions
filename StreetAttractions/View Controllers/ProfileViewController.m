//
//  ProfileViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@property double latitude;
@property double longitude;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.latitude = 0.0;
    self.longitude = 0.0;
    self.latitudes = [[NSMutableArray alloc]init];
    self.longitudes = [[NSMutableArray alloc]init];
    [User isFavoriteUser:self.user WithCompletion:^(BOOL completion) {
        if(completion){
            self.barButton.image = [UIImage systemImageNamed:@"star.fill"];
        }else{
            self.barButton.image = [UIImage systemImageNamed:@"star"];
        }
    }];
    self.barButton.image = [UIImage systemImageNamed:@"star"];
    self.screenameLabel.text = self.user.screenname;
    self.usernameLabel.text = self.user.username;
    self.cityLabel.text = self.user.location;
    self.profilePic.layer.cornerRadius = 20;
    self.profilePic.layer.masksToBounds = YES;
    self.profilePic.file = self.user.profilePic;
    [self.profilePic loadInBackground];
    if(self.user.isPerfomer)
    {
        self.isPerformer.alpha = 1;
    }
    else{
        self.isPerformer.alpha = 0;
    }
    //[self fetchPostsAndPredict];
    // Do any additional setup after loading the view.
}
- (IBAction)onFavorite:(id)sender {
    if([self.barButton.image isEqual:[UIImage systemImageNamed:@"star"]]){
        [self favorite];
    }else{
        [self unfavorite];
    }
}
- (IBAction)onDonate:(id)sender {
    [self showDropIn:@"sandbox_jy2p4xff_yxpkv9ztxt34tdkx"];
}
- (void)showDropIn:(NSString *)clientTokenOrTokenizationKey {
    BTDropInRequest *request = [[BTDropInRequest alloc] init];
    BTDropInController *dropIn = [[BTDropInController alloc] initWithAuthorization:clientTokenOrTokenizationKey request:request handler:^(BTDropInController * _Nonnull controller, BTDropInResult * _Nullable result, NSError * _Nullable error) {
        
        if (error != nil) {
            NSLog(@"ERROR");
        } else if (result.cancelled) {
            NSLog(@"CANCELLED");
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            BTPaymentMethodNonce *selectedNonce = result.paymentMethod;
            // Use the BTDropInResult properties to update your UI
            // result.paymentOptionType
            // result.paymentMethod
            // result.paymentIcon
            // result.paymentDescription
        }
    }];
    [self presentViewController:dropIn animated:YES completion:nil];
}

- (void) favorite{
    User *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"FavUsers"];
    [relation addObject:self.user];
    [user saveInBackground];
    self.barButton.image = [UIImage systemImageNamed:@"star.fill"];
}
- (void) unfavorite{
    User *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"FavUsers"];
    [relation removeObject:self.user];
    [user saveInBackground];
    self.barButton.image = [UIImage systemImageNamed:@"star"];
}
//- (void) fetchPostsAndPredict{
//    PFQuery *postQuery = [Post query];
//    User *user = [PFUser currentUser];
//    [postQuery whereKey:@"author" equalTo:self.user];
//    [postQuery orderByDescending:@"createdAt"];
//    postQuery.limit = 20;
//    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
//        if (posts) {
//            if([posts[0].category isEqual:@"Dancers"]){
//                self.isPerformer.tintColor = [UIColor systemPinkColor];
//            }else if(([posts[0].category isEqual:@"Singers"])){
//                self.isPerformer.tintColor = [UIColor yellowColor];
//            }
//            else if([posts[0].category isEqual:@"Magicians"]){
//                self.isPerformer.tintColor = [UIColor greenColor];
//            }
//            for(Post* post in posts)
//            {
//                [self.latitudes addObject:post.latitude];
//                [self.longitudes addObject:post.longitude];
//            }
//            //[self predictLocation];
//        }
//    }];
//}
//- (void)predictLocation {
//    for(NSNumber* num in self.latitudes)
//    {
//        self.latitude += [num doubleValue];
//    }
//    for(NSNumber* num in self.longitudes)
//    {
//        self.longitude += [num doubleValue];
//    }
//    self.latitude /= self.latitudes.count;
//    self.longitude /= self.longitudes.count;
//    NSLog(@"%f, %f", self.latitude, self.longitude);
//    NSError *error;
//    LocationPrediction2 *latitude2 = [[LocationPrediction2 alloc] init];
//    LocationPrediction2Output *result2 = [latitude2 predictionFromLatitude:120.289347 Longitude:90.504123 error:&error];
//    LocationPrediction3 *latitude3 = [[LocationPrediction3 alloc] init];
//    LocationPrediction3Output *result3 = [latitude3 predictionFromLatitude:120.2 Longitude:90. error:&error];
//    LocationPrediction1 *latitude = [[LocationPrediction1 alloc] init];
//    LocationPrediction1Output *resultLatitude = [latitude predictionFromLatitude:9000 error:&error];
//    LocationPrediction1copy *longitude = [[LocationPrediction1copy alloc] init];
//    LocationPrediction1copyOutput *resultLongitude = [longitude predictionFromLongitude:self.longitude error:&error];
//    NSLog(@"%f,%f, %f, %f", result3.Model_Latitude,result2.Model_Latitude, resultLatitude.Model_Latitude, resultLongitude.Model_Longitude);
//}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
