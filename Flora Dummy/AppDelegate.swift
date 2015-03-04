//
//  AppDelegate.swift
//  Flora Dummy
//
//  Created by Michael Schloss on 10/25/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIViewControllerTransitioningDelegate
{
    var window: UIWindow?
    private var tabBarController : UITabBarController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool
    {
        let userDefaults = ["selectedColor":"Blue", "calculatorPosition":"Left", "showsDevTab":YES, "defaultLogin":"Student"]
        NSUserDefaults.standardUserDefaults().registerDefaults(userDefaults)
        
        //TEMP TO CONVERT JSON STUFF
        CarollJSONConverterTemp()
        
        ColorManager.sharedManager().loadColorScheme()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        tabBarController = UIStoryboard(name: "Main2", bundle: nil).instantiateInitialViewController() as? UITabBarController
        window!.rootViewController = tabBarController!
        
        if NSUserDefaults.standardUserDefaults().boolForKey("showsDevTab") == NO
        {
            let newTabs = NSMutableArray(array: tabBarController!.viewControllers!)
            newTabs.removeLastObject()
            tabBarController!.setViewControllers(newTabs, animated: NO)
        }
        
        window!.makeKeyAndVisible()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadActivities", name: UserLoggedIn, object: nil)
        let plistPath = NSBundle.mainBundle().pathForResource("LoggedInUser", ofType: "plist")
        let userLoginInfo = NSArray(contentsOfFile: plistPath!)
        if userLoginInfo!.count != 6
        {
            NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "presentPasswordScreen", userInfo: nil, repeats: NO)
            
            //Debug
            //NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "presentMiniPasswordScreen", userInfo: nil, repeats: NO)
        }
        else
        {
            NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "presentMiniPasswordScreen", userInfo: nil, repeats: NO)
            loadActivities()
        }
        
        return YES
    }
    
    func loadActivities()
    {
        CESDatabase.databaseManagerForMainActivitiesClass().loadActivities()
    }
    
    //MARK: - Teacher Login
    
    func teacherLogin()
    {
        let storyboard = UIStoryboard(name: "ActivityCreation", bundle: nil)
        let initialVC = storyboard.instantiateInitialViewController() as UIViewController
        
        UIView.transitionWithView(window!, duration: 0.5, options: .TransitionCrossDissolve | .AllowAnimatedContent, animations: { () -> Void in
            
            self.window!.rootViewController = initialVC
            }, completion: { (finished) -> Void in
                
        })
    }
    
    //MARK: - Password Screen
    
    func presentPasswordScreen()
    {
        let passwordVC = PasswordVC()
        passwordVC.transitioningDelegate = self
        passwordVC.modalPresentationStyle = .Custom
        
        tabBarController!.presentViewController(passwordVC, animated: YES, completion: nil)
    }
    
    func presentMiniPasswordScreen()
    {
        MiniPasswordVC.presentInViewController(tabBarController!)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return PasswordVCTransition()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PasswordVCDismissalTransition()
    }
    
    
}
