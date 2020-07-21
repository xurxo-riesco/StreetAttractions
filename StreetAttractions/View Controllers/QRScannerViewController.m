
//
//  QRScannerViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/21/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "QRScannerViewController.h"
#import "DYQRCodeDecoderViewController.h"

@interface QRScannerViewController ()

@end

@implementation QRScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DYQRCodeDecoderViewController *vc = [[DYQRCodeDecoderViewController alloc] initWithCompletion:^(BOOL succeeded, NSString *result) {
        if (succeeded) {
            NSLog(@"%@", result);
            
        } else {
            NSLog(@"failed");
        }
    }];
    [vc setTitle:@"string"];
    [vc setNeedsScanAnnimation:NO];

    [[vc leftBarButtonItem] setTitle:@"string"];
    [[vc leftBarButtonItem] setTitle:@"string"];

    [vc setNavigationBarTintColor:[UIColor lightGrayColor]];

    //[vc setFrameImage:[UIImage imageNamed:@"your image name"]];
    //[vc setLineImage:[UIImage imageNamed:@"your image name"]];

    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navVC animated:YES completion:NULL];
    // Do any additional setup after loading the view.
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
