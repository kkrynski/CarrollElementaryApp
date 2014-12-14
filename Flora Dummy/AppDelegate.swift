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
    
    private var tabBarController : UITabBarController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool
    {
        let userDefaults = ["gradeNumber":"Kindergarten", "primaryColor":"000000", "secondaryColor":"EBEBEB", "backgroundColor":"7EA7D8", "selectedBackgroundButton":7, "calculatorPosition":"Left", "showsDevTab":YES]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(userDefaults)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let storyBoard = UIStoryboard(name: "Main2", bundle: nil)
        tabBarController = storyBoard.instantiateInitialViewController() as? UITabBarController
        
        window!.rootViewController = tabBarController!
        
        var showsDevTab = NSUserDefaults.standardUserDefaults().boolForKey("showsDevTab")
        if showsDevTab == NO
        {
            let newTabs = NSMutableArray(array: tabBarController!.viewControllers!)
            newTabs.removeLastObject()
            tabBarController!.setViewControllers(newTabs, animated: NO)
        }
        
        window!.makeKeyAndVisible()
        
        DatabaseManager.databaseManagerForMainActivitiesClass().loadActivities()
        
        let plistPath = NSBundle.mainBundle().pathForResource("LoggedInUser", ofType: "plist")
        let userLoginInfo = NSArray(contentsOfFile: plistPath!)
        
        if userLoginInfo!.count != 1
        {
            NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "presentPasswordScreen", userInfo: nil, repeats: NO)
        }
        
        return YES
    }
    
    func presentPasswordScreen()
    {
        let passwordVC = PasswordVC(nibName: "PasswordVC", bundle: nil)
        passwordVC.modalPresentationStyle = .FormSheet
        
        tabBarController!.presentViewController(passwordVC, animated: YES, completion: nil)
    }
}
