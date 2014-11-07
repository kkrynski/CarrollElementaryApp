//
//  CalculatorTransitionDelegate.swift
//  FloraDummy
//
//  Created by Michael Schloss on 11/7/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

//MARK: Deprecated File

class CalculatorTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate
{
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController?
    {
        print("Setting up presentationController")
        if presented.classForCoder === CalculatorVC.classForCoder()
        {
            return CalculatorPresentationController(presentedViewController: presented, presentingViewController: presenting)
        }
        else
        {
            return nil
        }
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        print("HI")
        if presented.classForCoder === CalculatorVC.classForCoder()
        {
            return CalculatorTransitionManager(isPresenting: true)
        }
        else
        {
            return nil
        }
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        print("BYE")
        if dismissed.classForCoder === CalculatorVC.classForCoder()
        {
            return CalculatorTransitionManager(isPresenting: false)
        }
        else
        {
            return nil
        }
    }
}
