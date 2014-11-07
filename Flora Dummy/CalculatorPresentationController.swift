//
//  CalculatorPresentation.swift
//  FloraDummy
//
//  Created by Michael Schloss on 11/7/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class CalculatorPresentationController: UIPresentationController
{
    var blurView : UIVisualEffectView?
    
    //MARK: - Presentation
    
    override func presentationTransitionWillBegin()
    {
        let blur = UIBlurEffect(style: .Light)
        blurView = UIVisualEffectView(effect: blur)
        
        blurView!.frame = containerView.bounds
        blurView!.alpha = 0.0
        
        containerView.addSubview(blurView!)
        
        let transitionCoordinator = self.presentingViewController.transitionCoordinator()
        transitionCoordinator?.animateAlongsideTransition(
            {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.blurView!.alpha = 1.0
            }, completion:nil)
    }
    
    override func presentationTransitionDidEnd(completed: Bool)
    {
        if completed == false
        {
            blurView!.removeFromSuperview()
        }
    }
    
    //MARK: - Dismissal
    
    override func dismissalTransitionWillBegin()
    {
        let transitionCoordinator = self.presentingViewController.transitionCoordinator()
        transitionCoordinator?.animateAlongsideTransition(
            {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.blurView!.alpha = 0.0
            }, completion:nil)
    }
    
    override func dismissalTransitionDidEnd(completed: Bool)
    {
        if completed
        {
            blurView!.removeFromSuperview()
        }
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect
    {
        return CGRectMake(20, containerView.frame.size.height - 20 - 400, 300, 400)
    }
}
