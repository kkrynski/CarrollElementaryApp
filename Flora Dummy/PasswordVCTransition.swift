//
//  PasswordVCTransition.swift
//  FloraDummy
//
//  Created by Michael Schloss on 2/27/15.
//  Copyright (c) 2015 SGSC. All rights reserved.
//

import UIKit

class PasswordVCTransition: NSObject, UIViewControllerAnimatedTransitioning
{
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval
    {
        return 0.8
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        let presentedController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)! as PasswordVC
        let presentingController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let containerView = transitionContext.containerView()
        
        containerView.addSubview(presentedController.view)

        presentedController.infoView.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
            
            presentedController.backgroundView.alpha = 1.0
            
            }, completion: nil)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
            
            presentedController.infoView.transform = CGAffineTransformIdentity
            
            }, completion: nil)
        
        var timer : NSTimer?
        
        if presentedController.infoView.subviews.count > 0
        {
            for index in 0...presentedController.infoView.subviews.count - 1
            {
                timer?.invalidate()
                timer = NSTimer.scheduledTimerWithTimeInterval(transitionDuration(transitionContext) + transitionDuration(transitionContext) * 0.8 + (Double(index) * 0.15), target: self, selector: "finishTransition:", userInfo: ["TransitionContext":transitionContext], repeats: NO)
                
                UIView.animateWithDuration(transitionDuration(transitionContext), delay: transitionDuration(transitionContext) * 0.8 + (Double(index) * 0.15), usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                    
                    (presentedController.infoView.subviews as [UIView])[index].transform = CGAffineTransformIdentity
                    
                    }, completion: nil)
            }
        }
        
        
    }
    
    func finishTransition(timer: NSTimer)
    {
        let transitionContext = timer.userInfo!["TransitionContext"]! as UIViewControllerContextTransitioning
        
        transitionContext.completeTransition(YES)
    }
}

class PasswordVCDismissalTransition: NSObject, UIViewControllerAnimatedTransitioning
{
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval
    {
        return 0.8
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        let presentedController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let presentingController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! as PasswordVC
        let containerView = transitionContext.containerView()
        
        containerView.addSubview(presentingController.view)
        
        var timer : NSTimer?
        
        if presentingController.infoView.subviews.count > 0
        {
            for index in 0...presentingController.infoView.subviews.count - 1
            {
                UIView.animateWithDuration(transitionDuration(transitionContext), delay: transitionDuration(transitionContext) * 0.8 + (Double(index) * 0.15), usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                    
                    (presentingController.infoView.subviews as [UIView])[index].transform = CGAffineTransformMakeScale(1.4, 1.4)
                    (presentingController.infoView.subviews as [UIView])[index].alpha = 0.0
                    
                    }, completion: { (finished) -> Void in
                        
                        (presentingController.infoView.subviews as [UIView])[index].removeFromSuperview()
                        
                })
            }
        }
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: transitionDuration(transitionContext), usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
            
            presentingController.backgroundView.alpha = 0.0
            
            }, completion: nil)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: transitionDuration(transitionContext), usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
            
            presentingController.infoView.transform = CGAffineTransformMakeScale(1.2, 1.2)
            presentingController.infoView.alpha = 0.0
            
            }, completion: { (finished) -> Void in
                
                transitionContext.completeTransition(YES)
                
        })
    }
}