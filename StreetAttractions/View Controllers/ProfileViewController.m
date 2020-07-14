//
//  ProfileViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
