//
//  FloraTabBarController.swift
//  FloraDummy
//
//  Created by Michael Schloss on 11/28/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class FloraTabBarController: UITabBarController, UITabBarControllerDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.delegate = self
    }

    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        let reverse = tabBarController.selectedIndex > (tabBarController.viewControllers! as NSArray).indexOfObject(toVC)
        
        return TabBarTransitionManager(shouldReverse: reverse)
    }

}
