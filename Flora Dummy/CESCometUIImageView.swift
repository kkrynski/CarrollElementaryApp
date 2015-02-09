//
//  CESCometUIImageView.swift
//  FloraDummy
//
//  Created by Michael Schloss on 2/7/15.
//  Copyright (c) 2015 SGSC. All rights reserved.
//

import UIKit

class CESCometUIImageView: UIView
{
    let imageView : UIImageView!
    let dimView : UIView!
    let wheel : UIActivityIndicatorView!
    var quizLabel : UILabel?
    
    private var target : AnyObject?
    private var action : Selector?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        backgroundColor = .whiteColor()
        
        layer.shadowColor = UIColor.whiteColor().CGColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSizeMake(0, 1)
        
        layer.shouldRasterize = YES
        layer.rasterizationScale = UIScreen.mainScreen().scale
        
        imageView = UIImageView()
        imageView.clipsToBounds = YES
        imageView.setTranslatesAutoresizingMaskIntoConstraints(NO)
        imageView.layer.cornerRadius = 0.001
        imageView.contentMode = .ScaleAspectFit
        addSubview(imageView)
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        
        wheel = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        wheel.color = .blackColor()
        wheel.startAnimating()
        wheel.setTranslatesAutoresizingMaskIntoConstraints(NO)
        addSubview(wheel)
        
        addConstraint(NSLayoutConstraint(item: wheel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: wheel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[wheel(37)]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["wheel":wheel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[wheel(37)]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["wheel":wheel]))
        
        dimView = UIView()
        dimView.setTranslatesAutoresizingMaskIntoConstraints(NO)
        dimView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        dimView.alpha = 0.0
        addSubview(dimView)
        
        addConstraint(NSLayoutConstraint(item: dimView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: dimView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: dimView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: dimView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    func setImage(image: UIImage)
    {
        UIView.transitionWithView(self, duration: imageView.image != nil ? 0.3:0.0, options: .TransitionCrossDissolve, animations: { () -> Void in
            self.wheel.alpha = 0.0
            self.imageView.image = image
            }, completion: { (finished) -> Void in
                self.wheel.removeFromSuperview()
                self.backgroundColor = .clearColor()
        })
    }
    
    func setTarget(target: AnyObject, forAction action: Selector)
    {
        if target.canPerformAction(action, withSender: self) == NO
        {
            return
        }
        
        self.target = target
        self.action = action
    }
    
    func enableQuizMode()
    {
        imageView.alpha = 0.0
        userInteractionEnabled = NO
        
        self.backgroundColor = .whiteColor()
        
        quizLabel = UILabel()
        quizLabel!.setTranslatesAutoresizingMaskIntoConstraints(NO)
        quizLabel!.textAlignment = .Center
        quizLabel!.textColor = .blackColor()
        quizLabel!.numberOfLines = 0
        quizLabel!.font = UIFont(name: "MarkerFelt-Thin", size: 22)
        quizLabel!.text = "You are in Quiz Mode!"
        Definitions.outlineTextInLabel(quizLabel!)
        addSubview(quizLabel!)
        
        addConstraint(NSLayoutConstraint(item: quizLabel!, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: quizLabel!, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: quizLabel!, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: quizLabel!, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
    }
    
    override func updateConstraints()
    {
        super.updateConstraints()
        
        removeConstraints(constraints())
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        
        addConstraint(NSLayoutConstraint(item: dimView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: dimView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: dimView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: dimView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        
        if quizLabel != nil
        {
            addConstraint(NSLayoutConstraint(item: quizLabel!, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
            addConstraint(NSLayoutConstraint(item: quizLabel!, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
            addConstraint(NSLayoutConstraint(item: quizLabel!, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
            addConstraint(NSLayoutConstraint(item: quizLabel!, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        }
        
        if wheel != nil
        {
            addConstraint(NSLayoutConstraint(item: wheel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
            addConstraint(NSLayoutConstraint(item: wheel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[wheel(37)]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["wheel":wheel]))
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[wheel(37)]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["wheel":wheel]))
        }
    }
    
    private func highlightSelf()
    {
        dimView.alpha = 1.0
        layer.shadowColor = UIColor.blackColor().CGColor!
    }
    
    private func unHighlightSelf()
    {
        dimView.alpha = 0.0
        layer.shadowColor = UIColor.whiteColor().CGColor!
    }
    
    private func animateHighlightSelf()
    {
        let animation = CABasicAnimation(keyPath: "shadowColor")
        animation.fromValue = UIColor.whiteColor().CGColor!
        animation.toValue = UIColor.blackColor().CGColor!
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        animation.duration = 0.3
        self.layer.addAnimation(animation, forKey: "shadowColor")
        self.layer.shadowColor = UIColor.blackColor().CGColor!
        
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
            self.dimView.alpha = 1.0
            }, completion: nil)
    }
    
    private func animateUnHighlightSelf()
    {
        let animation = CABasicAnimation(keyPath: "shadowColor")
        animation.fromValue = UIColor.blackColor().CGColor!
        animation.toValue = UIColor.whiteColor().CGColor!
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        animation.duration = 0.3
        self.layer.addAnimation(animation, forKey: "shadowColor")
        self.layer.shadowColor = UIColor.whiteColor().CGColor!
        
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
            self.dimView.alpha = 0.0
            }, completion: nil)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        highlightSelf()
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!)
    {
        unHighlightSelf()
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent)
    {
        unHighlightSelf()
        
        let point = (touches.allObjects.first as UITouch).locationInView(self)
        
        if CGRectContainsPoint(self.bounds, point) && target != nil && action != nil
        {
            
            NSTimer.scheduledTimerWithTimeInterval(0.0, target: target!, selector: action!, userInfo: ["ImageView" : self], repeats: NO)
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent)
    {
        let previousPoint = (touches.allObjects.first as UITouch).previousLocationInView(self)
        let point = (touches.allObjects.first as UITouch).locationInView(self)
        
        if CGRectContainsPoint(self.bounds, point)
        {
            if CGRectContainsPoint(self.bounds, previousPoint) == NO
            {
                animateHighlightSelf()
            }
        }
        else
        {
            if CGRectContainsPoint(self.bounds, previousPoint)
            {
                animateUnHighlightSelf()
            }
        }
    }
}
