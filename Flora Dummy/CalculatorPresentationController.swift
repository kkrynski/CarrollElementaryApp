//
//  CalculatorPresentation.swift
//  FloraDummy
//
//  Created by Michael Schloss on 11/7/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class CalculatorPresentationController: UIPresentationController, UIGestureRecognizerDelegate
{
    private var blurView : UIVisualEffectView?          //The background blur view
    
    private var infoView : UIView?                      //The container view for the arrows and dismiss button
    private var rightArrow : UIButton?                  //The right-facing arrow
    private var leftArrow : UIButton?                   //The left-facing arrow
    private var dismissButton : UIButton?               //The dismiss button
    
    private var calculatorHolderView : UIView?          //This view manages expanding and collapsing the calculator for special functions
    var calculatorExtension : UIView?                   //The extension view to slide in.
    private var oldCalculatorExtension : UIView?        //N/A
    
    private var dismissTap : UITapGestureRecognizer?    //The tap gesture for dismissal of calculator extension/calculator
    
    class func CalculatorWillIncreaseSizeNotification() -> String
    {
        return "CalculatorWillIncreaseSizeNotification"
    }
    
    class func CalculatorWillDecreaseSizeNotification() -> String
    {
        return "CalculatorWillDecreaseSizeNotification"
    }
    
    class func CalculatorShouldDecreaseSizeNotification() -> String
    {
        return "CalculatorShouldDecreaseSizeNotification"
    }

    
    //MARK: - Presentation
    
    //Present the calculator and the buttons
    //Blur the background
    override func presentationTransitionWillBegin()
    {
        infoView = UIView(frame: CGRectMake(0, 0, 260, 220))
        infoView!.alpha = 0.0
        infoView!.layer.cornerRadius = 10.0
        infoView!.layer.shadowOpacity = 0.85
        infoView!.layer.shadowOffset = CGSizeMake(0.0, 1.0)
        infoView!.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        infoView!.center = CGPointMake(containerView.frame.size.width/2.0, containerView.frame.size.height - 20 - 200)
        containerView.addSubview(infoView!)
        
        rightArrow = UIButton(frame: CGRectMake(0, 0, 100, 100))
        rightArrow!.setTitle("\u{21a6}", forState: .Normal)
        rightArrow!.titleLabel!.font = UIFont(name: "Marker Felt", size: 72)
        rightArrow!.setTitleColor(UIColor.blackColor(), forState: .Normal)
        rightArrow!.titleLabel!.textAlignment = .Left
        Definitions.outlineTextInLabel(rightArrow!.titleLabel!)
        rightArrow!.center = CGPointMake(infoView!.frame.size.width/2.0 - 20 - rightArrow!.frame.size.width/2.0, rightArrow!.frame.size.height/2.0 + 10)
        rightArrow!.alpha = 0.0
        rightArrow!.userInteractionEnabled = NO
        rightArrow!.addTarget(self, action: "moveToRight", forControlEvents: .TouchUpInside)
        infoView!.addSubview(rightArrow!)
        
        leftArrow = UIButton(frame: CGRectMake(0, 0, 100, 100))
        leftArrow!.setTitle("\u{21a4}", forState: .Normal)
        leftArrow!.titleLabel!.font = UIFont(name: "Marker Felt", size: 72)
        leftArrow!.setTitleColor(UIColor.blackColor(), forState: .Normal)
        leftArrow!.titleLabel!.textAlignment = .Right
        Definitions.outlineTextInLabel(leftArrow!.titleLabel!)
        leftArrow!.center = CGPointMake(infoView!.frame.size.width/2.0 + 20 + leftArrow!.frame.size.width/2.0, leftArrow!.frame.size.height/2.0 + 10)
        leftArrow!.alpha = 0.0
        leftArrow!.userInteractionEnabled = NO
        leftArrow!.addTarget(self, action: "moveToLeft", forControlEvents: .TouchUpInside)
        infoView!.addSubview(leftArrow!)
        
        dismissButton = UIButton(frame: CGRectMake(0, 0, 240, 100))
        dismissButton!.setTitle("Dismiss Calculator", forState: .Normal)
        dismissButton!.titleLabel!.font = UIFont(name: "Marker Felt", size: 32)
        dismissButton!.setTitleColor(UIColor.blackColor(), forState: .Normal)
        dismissButton!.titleLabel!.textAlignment = .Center
        Definitions.outlineTextInLabel(dismissButton!.titleLabel!)
        dismissButton!.center = CGPointMake(infoView!.frame.size.width/2.0, infoView!.frame.size.height - 10 - dismissButton!.frame.size.height/2.0)
        dismissButton!.alpha = 0.0
        dismissButton!.addTarget(self, action: "dismissCalculator", forControlEvents: .TouchUpInside)
        infoView!.addSubview(dismissButton!)
        
        dismissTap = UITapGestureRecognizer(target: self, action: "dismissCalculator:")
        dismissTap!.delegate = self
        containerView!.addGestureRecognizer(dismissTap!)
        
        presentedView().layer.shadowOpacity = 1.0
        presentedView().layer.shadowOffset = CGSizeMake(0, 1.0)
        presentedView().layer.shadowRadius = 5.0
        
        let transitionCoordinator = self.presentingViewController.transitionCoordinator()
        transitionCoordinator?.animateAlongsideTransition(
            {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.infoView!.alpha = 1.0
                self.dismissButton!.alpha = 1.0
                
                if NSUserDefaults.standardUserDefaults().stringForKey("calculatorPosition") == "Left"
                {
                    self.rightArrow!.alpha = 1.0
                    self.rightArrow!.userInteractionEnabled = YES
                }
                else
                {
                    self.leftArrow!.alpha = 1.0
                    self.leftArrow!.userInteractionEnabled = YES
                }
            }, completion:nil)
    }
    
    //Clean up after presenting
    override func presentationTransitionDidEnd(completed: Bool)
    {
        if completed == NO   //If for some reason the transition was cancelled, remove everything
        {
            rightArrow!.removeFromSuperview()
            leftArrow!.removeFromSuperview()
            dismissButton!.removeFromSuperview()
        }
        else                   //Register for the calculator expansion and collapse if it presented
        {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "increaseCalculatorSize", name: CalculatorPresentationController.CalculatorWillIncreaseSizeNotification(), object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "decreaseCalculatorSize", name: CalculatorPresentationController.CalculatorWillDecreaseSizeNotification(), object: nil)
        }
    }
    
    //MARK: - Dismissal
    
    //Remove the arrows and blur view
    override func dismissalTransitionWillBegin()
    {
        infoView!.userInteractionEnabled = NO
        let transitionCoordinator = self.presentingViewController.transitionCoordinator()
        transitionCoordinator?.animateAlongsideTransition(
            {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.infoView!.alpha = 0.0
            }, completion:nil)
    }
    
    //Clean up after dismissing
    override func dismissalTransitionDidEnd(completed: Bool)
    {
        if completed    //If we finished dismissal, remove all extraneous views and stop listening for calculator expansion and collapse
        {
            rightArrow!.removeFromSuperview()
            leftArrow!.removeFromSuperview()
            dismissButton!.removeFromSuperview()
            infoView!.removeFromSuperview()
            
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
        else         //If for some reason we didn't finish the dismissal, re-enable the proper buttons
        {
            if NSUserDefaults.standardUserDefaults().stringForKey("calculatorPosition") == "Left"
            {
                rightArrow!.userInteractionEnabled = YES
            }
            else
            {
                leftArrow!.userInteractionEnabled = YES
            }
            dismissButton!.userInteractionEnabled = YES
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
            self.rightArrow!.userInteractionEnabled = NO
            
            }, completion: nil)
        UIView.animateWithDuration(transitionLength, delay: 0.4, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .AllowUserInteraction | .AllowAnimatedContent, animations: { () -> Void in
            
            self.leftArrow!.alpha = 1.0
            self.leftArrow!.userInteractionEnabled = YES
            
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
            self.leftArrow!.userInteractionEnabled = NO
            
            }, completion: nil)
        UIView.animateWithDuration(transitionLength, delay: 0.4, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .AllowUserInteraction | .AllowAnimatedContent, animations: { () -> Void in
            
            self.rightArrow!.alpha = 1.0
            self.rightArrow!.userInteractionEnabled = YES
            
            }, completion: nil)
    }
    
    //Dismisses the calculator
    func dismissCalculator(tapGesture: UIGestureRecognizer)
    {
        println(tapGesture.view)
        presentedViewController.dismissViewControllerAnimated(YES, completion: nil)
    }
    
    func dismissCalculator()
    {
        presentedViewController.dismissViewControllerAnimated(YES, completion: nil)
    }
    
    //MARK: - Calculator Size Changing
    
    //Increases the calculator's width to show the special functions view
    func increaseCalculatorSize()
    {
        assert(calculatorExtension != nil, "Calculator Extension not set!")
        
        containerView!.removeGestureRecognizer(self.dismissTap!)
        
        if calculatorExtension != nil && oldCalculatorExtension != nil  //A calculator extension is already presented
        {
            calculatorHolderView!.insertSubview(calculatorExtension!, belowSubview: presentedView())
            calculatorHolderView!.userInteractionEnabled = NO
            
            calculatorExtension!.frame = CGRectMake(0, 0, frameOfPresentedViewInContainerView().size.width - presentedView().frame.size.width, frameOfPresentedViewInContainerView().size.height)
            calculatorExtension!.backgroundColor = presentedView().backgroundColor
            
            calculatorExtension!.alpha = 0.0
            if NSUserDefaults.standardUserDefaults().stringForKey("calculatorPosition") == "Left"
            {
                calculatorExtension!.center = CGPointMake((calculatorHolderView!.frame.size.width + calculatorHolderView!.frame.origin.x) - calculatorExtension!.frame.size.width/2.0 - 20, oldCalculatorExtension!.center.y)
            }
            else
            {
                calculatorExtension!.center = CGPointMake(calculatorExtension!.frame.size.width/2.0 + 20, oldCalculatorExtension!.center.y)
            }
            
            UIView.animateWithDuration(transitionLength, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                
                self.calculatorHolderView!.frame = self.frameOfPresentedViewInContainerView()
                self.calculatorExtension!.frame = CGRectMake(self.calculatorExtension!.frame.origin.x, self.calculatorExtension!.frame.origin.y, self.frameOfPresentedViewInContainerView().size.width - self.presentedView().frame.size.width, self.frameOfPresentedViewInContainerView().size.height)
                
                if NSUserDefaults.standardUserDefaults().stringForKey("calculatorPosition") == "Left"
                {
                    self.presentedView().center = CGPointMake(self.calculatorHolderView!.frame.size.width/2.0 - (self.calculatorHolderView!.frame.size.width - self.presentedView().frame.size.width)/2.0, self.calculatorHolderView!.frame.size.height/2.0)
                    self.calculatorExtension!.center = CGPointMake(self.presentedView().frame.size.width + self.calculatorExtension!.frame.size.width/2.0, self.calculatorExtension!.center.y)
                }
                else
                {
                    self.presentedView().center = CGPointMake(self.calculatorHolderView!.frame.size.width/2.0 + (self.calculatorHolderView!.frame.size.width - self.presentedView().frame.size.width)/2.0, self.calculatorHolderView!.frame.size.height/2.0)
                    self.calculatorExtension!.center = CGPointMake(self.calculatorExtension!.frame.size.width/2.0 + 20, self.calculatorExtension!.center.y)
                }
                
                self.calculatorExtension!.alpha = 1.0
                
                }, completion: { (finished) -> Void in
                    
                    self.oldCalculatorExtension!.removeFromSuperview()
                    self.oldCalculatorExtension = self.calculatorExtension!
                    self.calculatorExtension = nil
                    
                    self.calculatorHolderView!.userInteractionEnabled = YES
            })
        }
        else    //We are presenting the first calculator extension
        {
            infoView!.userInteractionEnabled = NO
            
            calculatorHolderView = UIView(frame: presentedView().frame)
            calculatorHolderView!.userInteractionEnabled = NO
            presentedView().center = CGPointMake(calculatorHolderView!.frame.size.width/2.0, calculatorHolderView!.frame.size.height/2.0)
            presentedView().layer.shadowOpacity = 0.0
            presentedView().layer.shadowRadius = 5.0
            calculatorHolderView!.layer.shadowOpacity = 1.0
            calculatorHolderView!.layer.shadowOffset = CGSizeMake(0, 1.0)
            calculatorHolderView!.layer.shadowRadius = 5.0
            calculatorHolderView!.backgroundColor = presentedView().backgroundColor
            
            calculatorHolderView!.addSubview(calculatorExtension!)
            
            calculatorExtension!.frame = CGRectMake(presentedView().frame.origin.x, presentedView().frame.origin.y, frameOfPresentedViewInContainerView().size.width - presentedView().frame.size.width, frameOfPresentedViewInContainerView().size.height)
            
            calculatorHolderView!.addSubview(presentedView())
            
            if NSUserDefaults.standardUserDefaults().stringForKey("calculatorPosition") == "Left"
            {
                calculatorExtension!.center = CGPointMake(presentedView().frame.size.width - calculatorExtension!.frame.size.width/2.0, calculatorExtension!.frame.size.height/2.0);
            }
            else
            {
                calculatorExtension!.center = CGPointMake(calculatorExtension!.frame.size.width/2.0, calculatorExtension!.frame.size.height/2.0);
            }
            
            containerView.addSubview(calculatorHolderView!)
            
            UIView.animateWithDuration(transitionLength, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                
                self.calculatorHolderView!.frame = self.frameOfPresentedViewInContainerView()
                self.calculatorExtension!.frame = CGRectMake(self.calculatorExtension!.frame.origin.x, self.calculatorExtension!.frame.origin.y, self.frameOfPresentedViewInContainerView().size.width - self.presentedView().frame.size.width, self.frameOfPresentedViewInContainerView().size.height)
                
                if NSUserDefaults.standardUserDefaults().stringForKey("calculatorPosition") == "Left"
                {
                    self.presentedView().center = CGPointMake(self.calculatorHolderView!.frame.size.width/2.0 - (self.calculatorHolderView!.frame.size.width - self.presentedView().frame.size.width)/2.0, self.calculatorHolderView!.frame.size.height/2.0)
                    self.calculatorExtension!.center = CGPointMake(self.presentedView().frame.size.width + self.calculatorExtension!.frame.size.width/2.0, self.calculatorExtension!.center.y)
                }
                else
                {
                    self.presentedView().center = CGPointMake(self.calculatorHolderView!.frame.size.width/2.0 + (self.calculatorHolderView!.frame.size.width - self.presentedView().frame.size.width)/2.0, self.calculatorHolderView!.frame.size.height/2.0)
                    self.calculatorExtension!.center = CGPointMake(self.calculatorExtension!.frame.size.width/2.0 + 20, self.calculatorExtension!.center.y)
                }
                
                self.infoView!.alpha = 0.0
                }, completion: { (finished) -> Void in
                    
                    self.oldCalculatorExtension = self.calculatorExtension!
                    self.calculatorExtension = nil
                    
                    self.calculatorHolderView!.userInteractionEnabled = YES
                    
                    self.dismissTap = UITapGestureRecognizer(target: self, action: "dismissTapDecreaseSize")
                    self.containerView.addGestureRecognizer(self.dismissTap!)
            })
        }
    }
    
    //Decrease the calculator's width when tapped on screen
    func dismissTapDecreaseSize()
    {
        NSNotificationCenter.defaultCenter().postNotificationName(CalculatorPresentationController.CalculatorShouldDecreaseSizeNotification(), object: nil)
        decreaseCalculatorSize()
    }
    
    //Decrease the calculator's width to hide the special functions view
    func decreaseCalculatorSize()
    {
        if oldCalculatorExtension == nil || calculatorHolderView!.isDescendantOfView(containerView) == NO    //Alread dismissed, do nothing
        {
            return
        }
        
        containerView.removeGestureRecognizer(self.dismissTap!)
        
        calculatorHolderView!.userInteractionEnabled = NO
        
        let widthDifference = calculatorHolderView!.frame.size.width - frameOfPresentedViewInContainerView().size.width
        
        UIView.animateWithDuration(transitionLength, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
            
            if self.frameOfPresentedViewInContainerView().width == self.calculatorHolderView!.frame.size.width
            {
                var rect = self.frameOfPresentedViewInContainerView()
                rect.size.width = self.presentedView().frame.size.width
                rect.size.width = max(self.presentedView().frame.size.width, rect.size.width)
                if NSUserDefaults.standardUserDefaults().stringForKey("calculatorPosition") == "Right"
                {
                    rect.origin.x += (self.frameOfPresentedViewInContainerView().size.width - self.presentedView().frame.size.width)
                }
                self.calculatorHolderView!.frame = rect
            }
            else
            {
                
                self.calculatorHolderView!.frame = CGRectMake(self.frameOfPresentedViewInContainerView().origin.x, self.frameOfPresentedViewInContainerView().origin.y, self.presentedView().frame.size.width, self.frameOfPresentedViewInContainerView().size.height)
            }
            
            self.presentedView().center = CGPointMake(self.calculatorHolderView!.frame.size.width/2.0, self.calculatorHolderView!.frame.size.height/2.0)
            if NSUserDefaults.standardUserDefaults().stringForKey("calculatorPosition") == "Left"
            {
                self.oldCalculatorExtension!.center = CGPointMake(self.oldCalculatorExtension!.center.x - widthDifference, self.oldCalculatorExtension!.center.y)
            }
            else
            {
                self.oldCalculatorExtension!.center = CGPointMake(self.presentedView().frame.origin.x + 20, self.oldCalculatorExtension!.center.y)
            }
            
            }, completion: { (finished) -> Void in
                
                self.dismissTap = UITapGestureRecognizer(target: self, action: "dismissCalculator:")
                self.dismissTap!.delegate = self
                self.containerView.addGestureRecognizer(self.dismissTap!)
                
                self.presentedView().center = self.containerView.convertPoint(self.presentedView().center, fromView: self.calculatorHolderView!)
                self.containerView.addSubview(self.presentedView())
                
                self.presentedView().layer.shadowOpacity = 1.0
                
                self.calculatorHolderView!.removeFromSuperview()
                self.oldCalculatorExtension!.removeFromSuperview()
                self.calculatorExtension = nil
                self.oldCalculatorExtension = nil
        })
        
        UIView.animateWithDuration(transitionLength, delay: transitionLength, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
            
            self.infoView!.alpha = 1.0
            self.infoView!.userInteractionEnabled = YES
            
            }, completion: nil)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool
    {
        if calculatorHolderView != nil
        {
            if CGRectContainsPoint(calculatorHolderView!.frame, touch.locationInView(containerView))
            {
                return NO
            }
        }
        else
        {
            if CGRectContainsPoint(presentedView().frame, touch.locationInView(containerView))
            {
                return NO
            }
        }
        
        if CGRectContainsPoint(infoView!.frame, touch.locationInView(containerView))
        {
            return NO
        }
        
        return YES
    }
}
