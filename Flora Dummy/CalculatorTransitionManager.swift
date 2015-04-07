//
//  CalculatorTransitionManager.swift
//  FloraDummy
//
//  Created by Michael Schloss on 11/7/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class CalculatorTransitionManager: NSObject, UIViewControllerAnimatedTransitioning
{
    let isPresenting : Bool
    
    init(isPresenting: Bool)
    {
        self.isPresenting = isPresenting
        
        super.init()
    }
    
    //Returns the duration of the transition
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval
    {
        return transitionLength
    }
    
    //Animates the transition based on whether we're presenting or not
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        if isPresenting
        {
            animatePresentationWithTransitionContext(transitionContext)
        }
        else
        {
            animateDismissalWithTransitionContext(transitionContext)
        }
    }
    
    //MARK: - Presentation
    
    func animatePresentationWithTransitionContext(transitionContext: UIViewControllerContextTransitioning)
    {
        let presentedController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let containerView = transitionContext.containerView()
        
        // Position the presented view off the top of the container view
        presentedControllerView.frame = transitionContext.finalFrameForViewController(presentedController!)
        
        if NSUserDefaults.standardUserDefaults().stringForKey("calculatorPosition") == "Left"
        {
            presentedControllerView.center.x -= 40 + presentedControllerView.frame.size.width
        }
        else
        {
            presentedControllerView.center.x += 40 + presentedControllerView.frame.size.width
        }
        
        containerView.addSubview(presentedControllerView)
        
        // Animate the presented view to it's final position
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 0.77, initialSpringVelocity: 0.0, options: .AllowUserInteraction, animations:
            {
                if NSUserDefaults.standardUserDefaults().stringForKey("calculatorPosition") == "Left"
                {
                    presentedControllerView.center.x += 40 + presentedControllerView.frame.size.width
                }
                else
                {
                    presentedControllerView.center.x -= 40 + presentedControllerView.frame.size.width
                }
            }, completion: {(completed: Bool) -> Void in
                transitionContext.completeTransition(completed)
        })
    }
    
    //MARK: - Dismissal
    
    func animateDismissalWithTransitionContext(transitionContext: UIViewControllerContextTransitioning)
    {
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let containerView = transitionContext.containerView()
        
        // Animate the presented view off the bottom of the view
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .AllowUserInteraction, animations:
            {
                if NSUserDefaults.standardUserDefaults().stringForKey("calculatorPosition") == "Left"
                {
                    presentedControllerView.center.x -= 40 + presentedControllerView.frame.size.width
                }
                else
                {
                    presentedControllerView.center.x += 40 + presentedControllerView.frame.size.width
                }
            }, completion: {(completed: Bool) -> Void in
                transitionContext.completeTransition(completed)
        })
    }
}
