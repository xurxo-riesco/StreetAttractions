//
//  AppDelegate.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "AppDelegate.h"
#import "FBSDKCoreKit.h"
@import GoogleMaps;
@import Braintree;
@import Parse;
@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ParseClientConfiguration *config = [ParseClientConfiguration   configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        
        configuration.applicationId = @"StreetAttractions";
        configuration.server = @"https://streetattractions.herokuapp.com/parse";
    }];
    [Parse initializeWithConfiguration:config];
    if (PFUser.currentUser) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
           UINavigationController *centerNav = [storyboard instantiateViewControllerWithIdentifier:@"tabBarViewController"];
           UINavigationController *leftNav = [storyboard instantiateViewControllerWithIdentifier:@"leftDrawer"];
           
           self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:centerNav leftDrawerViewController:leftNav];
           self.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModePanningCenterView;
           self.drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModePanningCenterView;
           self.drawerController.title = @"Timeline";
           
           
           _window.rootViewController = self.drawerController;
           [_window makeKeyAndVisible];
    }
    [GMSServices provideAPIKey:@"AIzaSyDG3oPYU_0G2P4WDBnwcwaPQBtuy5J2qNE"];
    [BTAppSwitch setReturnURLScheme:@"com.xurxor.StreetAttractions.payments"];
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    //[GMSPlacesClient provideAPIKey:@"AIzaSyDG3oPYU_0G2P4WDBnwcwaPQBtuy5J2qNE"];
    
    return YES;
}
#pragma mark - UISceneSession lifecycle


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.scheme localizedCaseInsensitiveCompare:@"com.xurxor.StreetAttractions.payments"] == NSOrderedSame) {
        return [BTAppSwitch handleOpenURL:url options:options];
    }
    return NO;
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
