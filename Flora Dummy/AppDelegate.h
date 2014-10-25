//
//  AppDelegate.h
//  Flora Dummy
//
//  Created by Zach Nichols on 9/28/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

// To keep track of tab actions,
// we need to keep track of our custom tab bar
@property (strong, nonatomic) UITabBarController *tabBarController;

@end
