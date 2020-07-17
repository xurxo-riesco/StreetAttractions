//
//  LoginViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "Parse/PFUser.h"
#import "HyTransitions.h"
#import "HyLoginButton.h"

@interface LoginViewController ()<UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passwordField.secureTextEntry = true;
    [self createPresentControllerButton];
}
- (void)createPresentControllerButton{
    HyLoginButton *loginButton = [[HyLoginButton alloc] initWithFrame:CGRectMake(20, 450, [UIScreen mainScreen].bounds.size.width - 40, 40)];
    [loginButton setBackgroundColor:[UIColor colorWithRed:0.f/255.0f green:0.f/255.0f blue:1 alpha:1]];
    [loginButton setTitle:@"Log In" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(PresentViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
}
- (void)PresentViewController:(HyLoginButton *)button {
    typeof(self) __weak weak = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loginUserWithCompletion:^(BOOL success, NSError *error) {
            if (success) {
                [button succeedAnimationWithCompletion:^{
                    [self performSegueWithIdentifier:@"loginSegue" sender:nil];
                }];
            } else {
                [button failedAnimationWithCompletion:^{
                }];
                NSLog(@"User log in failed");
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                               message:error.localizedDescription
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Retry"
                                                                       style:UIAlertActionStyleCancel
                                                                     handler:^(UIAlertAction * _Nonnull action) {
                    [button removeFromSuperview];
                                        [self createPresentControllerButton];
                }];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:^{
                }];
            }
        }];
    });
}
- (void)loginUserWithCompletion:(void(^)(BOOL success, NSError *error))completion {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            completion(NO, error);
        } else {
            NSLog(@"User logged in successfully");
            completion(YES, nil);
        }
    }];
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
