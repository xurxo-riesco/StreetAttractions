//
//  AppDelegate.h
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

#import "MMDrawerController.h"

@interface AppDelegate : UIResponder<UIApplicationDelegate>

/**
  Main window property (Necessary due to Scene Delagate Removal)
*/
@property (strong, nonatomic) UIWindow *window;

/**
  Slide Out controller necessary property
*/
@property (strong, nonatomic) MMDrawerController *drawerController;

@end
