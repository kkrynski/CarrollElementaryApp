//
//  AppDelegate.swift
//  Flora Dummy
//
//  Created by Michael Schloss on 10/25/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool
    {
        let userDefaults = ["gradeNumber":"Kindergarten", "primaryColor":"000000", "secondaryColor":"EBEBEB", "backgroundColor":"7EA7D8", "selectedBackgroundButton":7, "calculatorPosition":"Left"]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(userDefaults)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let storyBoard = UIStoryboard(name: "Main2", bundle: nil)
        let tabBarController = storyBoard.instantiateInitialViewController() as UITabBarController
        
        window!.rootViewController = tabBarController
        
        window!.makeKeyAndVisible()
        
        return YES
    }
}
