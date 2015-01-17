//
//  TabBarTransitionManager.swift
//  FloraDummy
//
//  Created by Michael Schloss on 11/28/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class TabBarTransitionManager: NSObject, UIViewControllerAnimatedTransitioning
{
    let reverse : Bool
    
    private let folds = 4
    private var animationNumber : UInt32?
    
    init(shouldReverse: Bool)
    {
        self.reverse = shouldReverse
        
        animationNumber = arc4random_uniform(0)
        
        super.init()
    }
    
    //Returns the duration of the transition
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval
    {
        switch animationNumber!
        {
        case 0, 2, 3, 4:
            return 0.6
            
        default:
            return transitionLength
        }
    }
    
    //Animates the transition based on whether we're presenting or not
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        animatePresentationWithTransitionContext(transitionContext)
    }
    
    //MARK: - Presentation
    
    func animatePresentationWithTransitionContext(transitionContext: UIViewControllerContextTransitioning)
    {
        let presentedController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let presentingController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let presentingControllerView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let containerView = transitionContext.containerView()
        
        switch animationNumber!
        {
        case 0: //Pan right-to-left or left-to-right
            
            // Position the presented view off the right side of the container view
            presentedControllerView.frame = transitionContext.finalFrameForViewController(presentedController)
            presentedControllerView.center = CGPointMake(reverse ? -presentedControllerView.frame.size.width/2.0 : containerView.frame.size.width + presentedControllerView.frame.size.width/2.0, containerView.frame.size.height/2.0)
            containerView.addSubview(presentedControllerView)
            
            // Animate the presented view to it's final position
            UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .AllowUserInteraction, animations:
                {
                    
                    presentingControllerView.center = CGPointMake(self.reverse ? containerView.frame.size.width + presentingControllerView.frame.size.width/2.0 : -presentingControllerView.frame.size.width/2.0, presentingControllerView.center.y)
                    presentedControllerView.center = CGPointMake(containerView.frame.size.width/2.0, presentedControllerView.center.y)
                }, completion:
                {(completed: Bool) -> Void in
                    transitionContext.completeTransition(completed)
            })
            break
            
        case 1: //Fade In
            containerView.addSubview(presentedControllerView)
            containerView.sendSubviewToBack(presentedControllerView)
            
            UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                presentingControllerView.alpha = 0.0
            }, completion: { (finished) -> Void in
                transitionContext.completeTransition(finished)
                presentingControllerView.alpha = 1.0
            })
            break
            
        case 2: //Explode in
            containerView.addSubview(presentedControllerView)
            containerView.sendSubviewToBack(presentedControllerView)
            
            let size = presentedControllerView.frame.size
            
            let snapshots = NSMutableArray()
            
            let xFactor = CGFloat(10.0)
            let yFactor = xFactor * size.height/size.width
            
            let fromViewSnapshot = presentingControllerView.snapshotViewAfterScreenUpdates(NO)
            
            for var x = CGFloat(0.0); x < size.width; x += size.width/xFactor
            {
                for var y = CGFloat(0.0); y < size.height; y += size.height/yFactor
                {
                    let snapshotRegion = CGRectMake(x, y, size.width/xFactor, size.height/yFactor)
                    let snapshot = fromViewSnapshot.resizableSnapshotViewFromRect(snapshotRegion, afterScreenUpdates: NO, withCapInsets: UIEdgeInsetsZero)
                    snapshot.frame = snapshotRegion
                    containerView.addSubview(snapshot)
                    snapshots.addObject(snapshot)
                }
            }
            
            containerView.sendSubviewToBack(presentingControllerView)
            
            UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, options: .AllowUserInteraction | .AllowAnimatedContent, animations: { () -> Void in
                
                for object in snapshots
                {
                    let snapshot = object as UIView
                    
                    let xOffset = OBJ_CDefinitions.randomFloatBetween(-100.0, and: 100.0)
                    let yOffset = OBJ_CDefinitions.randomFloatBetween(-100.0, and: 100.0)
                    
                    snapshot.frame = CGRectOffset(snapshot.frame, CGFloat(xOffset), CGFloat(yOffset))
                    snapshot.alpha = 0.0
                    
                    snapshot.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(CGFloat(OBJ_CDefinitions.randomFloatBetween(-10.0, and: 10.0))), CGFloat(0.0001), CGFloat(0.0001))
                }
            }, completion: { (finished) -> Void in
                for object in snapshots
                {
                    let snapshot = object as UIView
                    
                    snapshot.removeFromSuperview()
                }
                
                transitionContext.completeTransition(finished)
            })
            break
            
        case 3: //Flip right-to-left or left-to-right
            containerView.addSubview(presentedControllerView)
            containerView.sendSubviewToBack(presentedControllerView)
            
            var transform = CATransform3DIdentity
            transform.m34 = -0.002
            containerView.layer.sublayerTransform = transform
            
            let initialFrame = transitionContext.initialFrameForViewController(transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!)
            presentingControllerView.frame = initialFrame
            presentedControllerView.frame = initialFrame
            
            let toViewSnapshots = OBJ_CDefinitions.createSnapshots(presentedControllerView, afterScreenUpdates: YES)
            var flippedSectionOfToView = toViewSnapshots[reverse ? 0 : 1] as UIView
            
            let fromViewSnapshots = OBJ_CDefinitions.createSnapshots(presentingControllerView, afterScreenUpdates: NO)
            var flippedSectionOfFromView = fromViewSnapshots[reverse ? 1 : 0] as UIView
            
            flippedSectionOfFromView = OBJ_CDefinitions.addShadowToView(flippedSectionOfFromView, reverse:reverse)
            let flippedSectionOfFromViewShadow = flippedSectionOfFromView.subviews[1] as UIView
            flippedSectionOfFromViewShadow.alpha = 0.0
            
            flippedSectionOfToView = OBJ_CDefinitions.addShadowToView(flippedSectionOfToView, reverse:reverse)
            let flippedSectionOfToViewShadow = flippedSectionOfToView.subviews[1] as UIView
            flippedSectionOfToViewShadow.alpha = 1.0
            
            updateAnchorPointAndOffset(CGPointMake(reverse ? 0.0 : 1.0, 0.5), forView: flippedSectionOfFromView)
            updateAnchorPointAndOffset(CGPointMake(reverse ? 1.0 : 0.0, 0.5), forView: flippedSectionOfToView)
            
            flippedSectionOfToView.layer.transform = rotate(CGFloat(self.reverse ? M_PI_2 : -M_PI_2))
            
            UIView.animateKeyframesWithDuration(transitionDuration(transitionContext), delay: 0.0, options: .AllowUserInteraction, animations: { () -> Void in
                
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5, animations: { () -> Void in
                    flippedSectionOfFromView.layer.transform = self.rotate(CGFloat(self.reverse ? -M_PI_2 : M_PI_2))
                    flippedSectionOfFromViewShadow.alpha = 1.0
                })
                UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { () -> Void in
                    flippedSectionOfToView.layer.transform = self.rotate(self.reverse ? 0.001 : -0.001)
                    flippedSectionOfToViewShadow.alpha = 0.0
                })
                
            }, completion: { (finished) -> Void in
                
                if transitionContext.transitionWasCancelled() == YES
                {
                    self.removeOtherViews(presentingControllerView)
                }
                else
                {
                    self.removeOtherViews(presentedControllerView)
                }
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                
            })
            break
            
        case 4: //Fold
            
            presentedControllerView.frame = CGRectOffset(presentedControllerView.frame, presentedControllerView.frame.size.width, 0)
            containerView.addSubview(presentedControllerView)
            
            var transform = CATransform3DIdentity
            transform.m34 = -0.005
            containerView.layer.sublayerTransform = transform
            
            let size = presentedControllerView.frame.size
            
            let foldWidth = size.width/2.0/CGFloat(folds)
            
            let fromViewFolds = NSMutableArray()
            let toViewFolds = NSMutableArray()
            
            for var i = 0; i < folds; i++
            {
                let offset = Float(Float(i) * Float(foldWidth) * 2.0)
                
                let leftFromViewFold = OBJ_CDefinitions.createSnapshotFromView(presentingControllerView, afterUpdates: NO, location:CGFloat(offset), left: YES, withNumberOfFolds: Int32(folds))
                leftFromViewFold.layer.position = CGPointMake(CGFloat(offset), size.height/2)
                fromViewFolds.addObject(leftFromViewFold)
                (leftFromViewFold.subviews[1] as UIView).alpha = 0.0
                
                let rightFromViewFold = OBJ_CDefinitions.createSnapshotFromView(presentingControllerView, afterUpdates: NO, location:CGFloat(offset) + foldWidth, left: NO, withNumberOfFolds: Int32(folds))
                rightFromViewFold.layer.position = CGPointMake(CGFloat(offset) + foldWidth * 2.0, size.height/2)
                fromViewFolds.addObject(rightFromViewFold)
                (rightFromViewFold.subviews[1] as UIView).alpha = 0.0
                
                let leftToViewFold = OBJ_CDefinitions.createSnapshotFromView(presentedControllerView, afterUpdates: YES, location: CGFloat(offset), left: YES, withNumberOfFolds: Int32(folds))
                leftToViewFold.layer.position = CGPointMake(reverse == NO ? size.width : 0.0, size.height/2)
                leftToViewFold.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI_2), 0.0, 1.0, 0.0)
                toViewFolds.addObject(leftToViewFold)
                
                let rightToViewFold = OBJ_CDefinitions.createSnapshotFromView(presentedControllerView, afterUpdates: YES, location: CGFloat(offset) + foldWidth, left: NO, withNumberOfFolds: Int32(folds))
                rightToViewFold.layer.position = CGPointMake(reverse == NO ? size.width : 0.0, size.height/2)
                rightToViewFold.layer.transform = CATransform3DMakeRotation(CGFloat(-M_PI_2), 0.0, 1.0, 0.0)
                toViewFolds.addObject(rightToViewFold)
            }
            
            presentingControllerView.frame = CGRectOffset(presentingControllerView.frame, presentingControllerView.frame.size.width, 0)
            
            UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, options: .AllowUserInteraction, animations: { () -> Void in
                
                for var i = 0; i < self.folds; i++
                {
                    let offset = Float(Float(i) * Float(foldWidth) * 2.0)
                    
                    let leftFromView = fromViewFolds[i * 2] as UIView
                    leftFromView.layer.position = CGPointMake(self.reverse == NO ? 0.0 : size.width, size.height/2.0)
                    leftFromView.layer.transform = CATransform3DRotate(transform, CGFloat(M_PI_2), 0.0, 1.0, 0)
                    (leftFromView.subviews[1] as UIView).alpha = 1.0
                    
                    let rightFromView = fromViewFolds[i * 2 + 1] as UIView
                    rightFromView.layer.position = CGPointMake(self.reverse == NO ? 0.0 : size.width, size.height/2.0)
                    rightFromView.layer.transform = CATransform3DRotate(transform, CGFloat(-M_PI_2), 0.0, 1.0, 0)
                    (rightFromView.subviews[1] as UIView).alpha = 1.0
                    
                    let leftToView = toViewFolds[i * 2] as UIView
                    leftToView.layer.position = CGPointMake(CGFloat(offset), size.height/2)
                    leftToView.layer.transform = CATransform3DIdentity
                    (leftToView.subviews[1] as UIView).alpha = 0.0
                    
                    let rightToView = toViewFolds[i * 2 + 1] as UIView
                    rightToView.layer.position = CGPointMake(CGFloat(offset) + foldWidth * 2.0, size.height/2.0)
                    rightToView.layer.transform = CATransform3DIdentity
                    (rightToView.subviews[1]as UIView).alpha = 0.0
                }
                
            }, completion: { (finished) -> Void in
                for object in fromViewFolds
                {
                    let view = object as UIView
                    view.removeFromSuperview()
                }
                for object in toViewFolds
                {
                    let view = object as UIView
                    view.removeFromSuperview()
                }
                presentingControllerView.frame = containerView.bounds
                presentedControllerView.frame = containerView.bounds
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
            break
            
        default:
            break
        }
    }
    
    //MARK: - Other Methods
    
    private func removeOtherViews(viewToKeep: UIView)
    {
        let containerView = viewToKeep.superview
        
        for view in containerView!.subviews as Array<UIView>
        {
            if view != viewToKeep
            {
                view.removeFromSuperview()
            }
        }
    }
    
    private func updateAnchorPointAndOffset(anchorPoint: CGPoint, forView view: UIView)
    {
        view.layer.anchorPoint = anchorPoint
        let xOffset = anchorPoint.x - 0.5
        view.frame = CGRectOffset(view.frame, xOffset * view.frame.size.width, 0)
    }
    
    private func rotate(angle: CGFloat) -> CATransform3D
    {
        return CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0)
    }
}
