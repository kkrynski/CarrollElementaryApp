//
//  CalculatorPresentation.swift
//  FloraDummy
//
//  Created by Michael Schloss on 11/7/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

//Notifications for calculator increasing and decrasing size
let CalculatorWillIncreaseSizeNotification = "CalculatorWillIncreaseSizeNotification"
let CalculatorWillDecreaseSizeNotification = "CalculatorWillDecreaseSizeNotification"

class CalculatorPresentationController: UIPresentationController
{
    var blurView : UIVisualEffectView?  //The background blur view
    
    var rightArrow : UIButton?          //The right-facing arrow
    var leftArrow : UIButton?           //The left-facing arrow
    var dismissButton : UIButton?       //The dismiss button
    
    var calculatorHolderView : UIView?  //This view manages expanding and collapsing the calculator for special functions
    
    //MARK: - Presentation
    
    //Present the calculator and the buttons
    //Blur the background
    override func presentationTransitionWillBegin()
    {
        let blur = UIBlurEffect(style: .Light)
        blurView = UIVisualEffectView(effect: blur)
        
        blurView!.frame = containerView.bounds
        blurView!.alpha = 0.0
        
        containerView.addSubview(blurView!)
        
        rightArrow = UIButton(frame: CGRectMake(0, 0, 100, 100))
        rightArrow!.setTitle("\u{21a6}", forState: .Normal)
        rightArrow!.titleLabel!.font = UIFont(name: "Marker Felt", size: 72)
        rightArrow!.setTitleColor(UIColor.blackColor(), forState: .Normal)
        rightArrow!.titleLabel!.textAlignment = .Left
        Definitions.outlineTextInLabel(rightArrow!.titleLabel!)
        rightArrow!.center = CGPointMake(containerView.frame.size.width/2.0 - 20 - rightArrow!.frame.size.width/2.0, containerView.frame.size.height - 20 - 200 - 10 - rightArrow!.frame.size.height/2.0)
        rightArrow!.alpha = 0.0
        rightArrow!.userInteractionEnabled = false
        rightArrow!.addTarget(self, action: "moveToRight", forControlEvents: .TouchUpInside)
        containerView.addSubview(rightArrow!)
        
        leftArrow = UIButton(frame: CGRectMake(0, 0, 100, 100))
        leftArrow!.setTitle("\u{21a4}", forState: .Normal)
        leftArrow!.titleLabel!.font = UIFont(name: "Marker Felt", size: 72)
        leftArrow!.setTitleColor(UIColor.blackColor(), forState: .Normal)
        leftArrow!.titleLabel!.textAlignment = .Right
        Definitions.outlineTextInLabel(leftArrow!.titleLabel!)
        leftArrow!.center = CGPointMake(containerView.frame.size.width/2.0 + 20 + leftArrow!.frame.size.width/2.0, containerView.frame.size.height - 20 - 200 - 10 - leftArrow!.frame.size.height/2.0)
        leftArrow!.alpha = 0.0
        leftArrow!.userInteractionEnabled = false
        leftArrow!.addTarget(self, action: "moveToLeft", forControlEvents: .TouchUpInside)
        containerView.addSubview(leftArrow!)
        
        dismissButton = UIButton(frame: CGRectMake(0, 0, 240, 100))
        dismissButton!.setTitle("Dismiss Calculator", forState: .Normal)
        dismissButton!.titleLabel!.font = UIFont(name: "Marker Felt", size: 32)
        dismissButton!.setTitleColor(UIColor.blackColor(), forState: .Normal)
        dismissButton!.titleLabel!.textAlignment = .Center
        Definitions.outlineTextInLabel(dismissButton!.titleLabel!)
        dismissButton!.center = CGPointMake(containerView.frame.size.width/2.0, containerView.frame.size.height - 20 - 200 + 10 + dismissButton!.frame.size.height/2.0)
        dismissButton!.alpha = 0.0
        dismissButton!.addTarget(self, action: "dismissCalculator", forControlEvents: .TouchUpInside)
        containerView.addSubview(dismissButton!)
        
        let transitionCoordinator = self.presentingViewController.transitionCoordinator()
        transitionCoordinator?.animateAlongsideTransition(
            {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.blurView!.alpha = 1.0
                self.dismissButton!.alpha = 1.0
                
                if NSUserDefaults.standardUserDefaults().stringForKey("calculatorPosition") == "Left"
                {
                    self.rightArrow!.alpha = 1.0
                    self.rightArrow!.userInteractionEnabled = true
                }
                else
                {
                    self.leftArrow!.alpha = 1.0
                    self.leftArrow!.userInteractionEnabled = true
                }
            }, completion:nil)
    }
    
    //Clean up after presenting
    override func presentationTransitionDidEnd(completed: Bool)
    {
        if completed == false   //If for some reason the transition was cancelled, remove everything
        {
            blurView!.removeFromSuperview()
            rightArrow!.removeFromSuperview()
            leftArrow!.removeFromSuperview()
            dismissButton!.removeFromSuperview()
        }
        else                   //Register for the calculator expansion and collapse if it presented
        {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "increaseCalculatorSize", name: CalculatorWillIncreaseSizeNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "decreaseCalculatorSize", name: CalculatorWillDecreaseSizeNotification, object: nil)
        }
    }
    
    //MARK: - Dismissal
    
    //Remove the arrows and blur view
    override func dismissalTransitionWillBegin()
    {
        rightArrow!.userInteractionEnabled = false
        leftArrow!.userInteractionEnabled = false
        dismissButton!.userInteractionEnabled = false
        let transitionCoordinator = self.presentingViewController.transitionCoordinator()
        transitionCoordinator?.animateAlongsideTransition(
            {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.blurView!.alpha = 0.0
                self.rightArrow!.alpha = 0.0
                self.leftArrow!.alpha = 0.0
                self.dismissButton!.alpha = 0.0
            }, completion:nil)
    }
    
    //Clean up after dismissing
    override func dismissalTransitionDidEnd(completed: Bool)
    {
        if completed    //If we finished dismissal, remove all extraneous views and stop listening for calculator expansion and collapse
        {
            blurView!.removeFromSuperview()
            rightArrow!.removeFromSuperview()
            leftArrow!.removeFromSuperview()
            dismissButton!.removeFromSuperview()
            
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
        else         //If for some reason we didn't finish the dismissal, re-enable the proper buttons
        {
            if NSUserDefaults.standardUserDefaults().stringForKey("calculatorPosition") == "Left"
            {
                rightArrow!.userInteractionEnabled = true
            }
            else
            {
                rightArrow!.userInteractionEnabled = true
            }
            dismissButton!.userInteractionEnabled = true
        }
    }
    
    //Returns the frame of the calculator depending on if we have it on the left or right side
    override func frameOfPresentedViewInContainerView() -> CGRect
    {
        if NSUserDefaults.standardUserDefaults().stringForKey("calculatorPosition") == "Left"
        {
            return CGRectMake(20, containerView.frame.size.height - 20 - presentedViewController.preferredContentSize.height, presentedViewController.preferredContentSize.width, presentedViewController.preferredContentSize.height)
        }
        else
        {
            return CGRectMake(containerView.frame.size.width - 20 - presentedViewController.preferredContentSize.width, containerView.frame.size.height - 20 - presentedViewController.preferredContentSize.height, presentedViewController.preferredContentSize.width, presentedViewController.preferredContentSize.height)
        }
    }
    
    //MARK: - Calculator Control Methods
    
    //Move the calculator to the right
    func moveToRight()
    {
        NSUserDefaults.standardUserDefaults().setObject("Right", forKey: "calculatorPosition")
        UIView.animateWithDuration(transitionLength, delay: 0.0, usingSpringWithDamping: 0.77, initialSpringVelocity: 0.1, options: .AllowUserInteraction | .AllowAnimatedContent, animations: { () -> Void in
            
            self.presentedView().frame = self.frameOfPresentedViewInContainerView()
            
            }, completion:nil)
        
        UIView.animateWithDuration(transitionLength, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .AllowUserInteraction | .AllowAnimatedContent, animations: { () -> Void in
            
            self.rightArrow!.alpha = 0.0
            self.rightArrow!.userInteractionEnabled = false
            
            }, completion: nil)
        UIView.animateWithDuration(transitionLength, delay: 0.4, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .AllowUserInteraction | .AllowAnimatedContent, animations: { () -> Void in
            
            self.leftArrow!.alpha = 1.0
            self.leftArrow!.userInteractionEnabled = true
            
            }, completion: nil)
    }
    
    //Move the calculator to the left
    func moveToLeft()
    {
        NSUserDefaults.standardUserDefaults().setObject("Left", forKey: "calculatorPosition")
        UIView.animateWithDuration(transitionLength, delay: 0.0, usingSpringWithDamping: 0.77, initialSpringVelocity: 0.1, options: .AllowUserInteraction | .AllowAnimatedContent, animations: { () -> Void in
            
            self.presentedView().frame = self.frameOfPresentedViewInContainerView()
            
            }, completion:nil)
        
        UIView.animateWithDuration(transitionLength, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .AllowUserInteraction | .AllowAnimatedContent, animations: { () -> Void in
            
            self.leftArrow!.alpha = 0.0
            self.leftArrow!.userInteractionEnabled = false
            
            }, completion: nil)
        UIView.animateWithDuration(transitionLength, delay: 0.4, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .AllowUserInteraction | .AllowAnimatedContent, animations: { () -> Void in
            
            self.rightArrow!.alpha = 1.0
            self.rightArrow!.userInteractionEnabled = true
            
            }, completion: nil)
    }
    
    //Dismisses the calculator
    func dismissCalculator()
    {
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Calculator Size Changing
    
    //Increases the calculator's width to show the special functions view
    func increaseCalculatorSize()
    {
        leftArrow!.userInteractionEnabled = true
        rightArrow!.userInteractionEnabled = true
        dismissButton!.userInteractionEnabled = true
        
        calculatorHolderView = UIView(frame: frameOfPresentedViewInContainerView())
        calculatorHolderView!.clipsToBounds = true
        presentedView().center = CGPointMake(calculatorHolderView!.frame.size.width/2.0 - (calculatorHolderView!.frame.size.width - presentedView().frame.size.width)/2.0, calculatorHolderView!.frame.size.height/2.0)
        calculatorHolderView!.addSubview(presentedView())
        containerView.addSubview(calculatorHolderView!)
        
        UIView.animateWithDuration(transitionLength, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
            self.presentedView().center = CGPointMake(self.calculatorHolderView!.frame.size.width/2.0 + (self.calculatorHolderView!.frame.size.width - self.presentedView().frame.size.width)/2.0, self.calculatorHolderView!.frame.size.height/2.0)
            
            self.leftArrow!.alpha = 0.0
            self.rightArrow!.alpha = 0.0
            self.dismissButton!.alpha = 0.0
            }, completion: nil)
    }
    
    //Decrease the calculator's width to hide the special functions view
    func decreaseCalculatorSize()
    {
        UIView.animateWithDuration(transitionLength, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
            self.presentedView().center = CGPointMake(self.calculatorHolderView!.frame.size.width/2.0 - (self.calculatorHolderView!.frame.size.width - self.presentedView().frame.size.width)/2.0, self.calculatorHolderView!.frame.size.height/2.0)
            
            self.leftArrow!.alpha = 1.0
            self.rightArrow!.alpha = 1.0
            self.dismissButton!.alpha = 1.0
            }, completion: { (finished) -> Void in
                self.presentedView().center = self.containerView.convertPoint(self.presentedView().center, fromView: self.calculatorHolderView!)
                self.containerView.addSubview(self.presentedView())
                
                self.calculatorHolderView!.removeFromSuperview()
                self.calculatorHolderView = nil
                
                self.leftArrow!.userInteractionEnabled = true
                self.rightArrow!.userInteractionEnabled = true
                self.dismissButton!.userInteractionEnabled = true
        })
    }
}
