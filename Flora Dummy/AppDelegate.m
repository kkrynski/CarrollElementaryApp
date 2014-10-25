//
//  AppDelegate.m
//  Flora Dummy
//
//  Created by Zach Nichols on 9/28/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeVC.h"
#import "LanguageArtsVC.h"
#import "MathVC.h"
#import "ScienceVC.h"
#import "SettingsVC.h"

@implementation AppDelegate

@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Get the stored data before the view loads
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *gradeNumber = [defaults objectForKey:@"gradeNumber"];
    NSString *primaryColor = [defaults objectForKey:@"primaryColor"];
    NSString *secondaryColor = [defaults objectForKey:@"secondaryColor"];
    NSString *backgroundColor = [defaults objectForKey:@"backgroundColor"];

    // If no grade is saved, assume kindergarten and save setting
    if (!gradeNumber || [gradeNumber isEqualToString:@""])
    {
        gradeNumber = [NSString stringWithFormat:@"Kindergarten"];
        
        [defaults setObject:gradeNumber forKey:@"gradeNumber"];
        [defaults synchronize];

    }
    
    // Note about colors:
    //
    // Primary color is the color of the text.
    // Secondary color is the color of outlines, shadows, etc.
    // Background color is the color of the background (obviously)
    
    // If no primary color is saved, assume black and save setting
    if (!primaryColor || [primaryColor isEqualToString:@""])
    {
        primaryColor = [NSString stringWithFormat:@"000000"];
        
        [defaults setObject:primaryColor forKey:@"primaryColor"];
        [defaults synchronize];

    }
    
    // If no secondary color is saved, assume gray/white and save setting
    if (!secondaryColor || [secondaryColor isEqualToString:@""])
    {
        secondaryColor = [NSString stringWithFormat:@"EBEBEB"];
        
        [defaults setObject:secondaryColor forKey:@"secondaryColor"];
        [defaults synchronize];

    }
    
    // If no backgroundColor color is saved, assume blue and save setting
    if (!backgroundColor || [backgroundColor isEqualToString:@""])
    {
        backgroundColor = [NSString stringWithFormat:@"7EA7D8"];
        
        [defaults setObject:backgroundColor forKey:@"backgroundColor"];
        [defaults synchronize];

    }
    

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
