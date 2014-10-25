//
//  AppDelegate.swift
//  Flora Dummy
//
//  Created by Michael Schloss on 10/25/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate
{
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool
    {
        let userDefaults = ["gradeNumber":"Kindergarten", "primaryColor":"000000", "secondaryColor":"EBEBEB", "backgroundColor":"7EA7D8"]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(userDefaults)
        
        return true
    }
}
