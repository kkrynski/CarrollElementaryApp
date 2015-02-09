//
//  UIButton_Typical.swift
//  FloraDummy
//
//  Created by Michael Schloss on 11/27/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class UIButton_Typical: UIButton
{
    override func setTitle(title: String?, forState state: UIControlState)
    {
        super.setTitle(title, forState: state)
        
        Definitions.outlineTextInLabel(titleLabel!)
    }
    
    func setHighlighted(highlighted: Bool, animated: Bool)
    {
        self.highlighted = highlighted
        
        highlighted == YES ? animated == YES ? highlightButton() : nonAnimatedHighlight() : animated == YES ? unhighlightButton() : nonAnimatedUnHighlight()
    }
    
    private func nonAnimatedHighlight()
    {
        alpha = 0.6
    }
    
    private func nonAnimatedUnHighlight()
    {
        alpha = 1.0
    }
    
    private func highlightButton()
    {
        UIView.animateWithDuration(0.3, delay: 0.0, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
            self.alpha = 0.6
        }, completion: nil)
    }
    
    private func unhighlightButton()
    {
        UIView.animateWithDuration(0.3, delay: 0.0, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
            self.alpha = 1.0
            }, completion: nil)
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool
    {
        let boundsExtension = 5
        let outerBounds = CGRectInset(bounds, CGFloat(0 - boundsExtension), CGFloat(0 - boundsExtension))
        let touchedInside = CGRectContainsPoint(outerBounds, touch.locationInView(self))
        
        touchedInside ? nonAnimatedHighlight() : unhighlightButton()
        
        sendActionsForControlEvents(.TouchDown)
        
        return YES
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool
    {
        let boundsExtension = 5
        let outerBounds = CGRectInset(bounds, CGFloat(0 - boundsExtension), CGFloat(0 - boundsExtension))
        let touchedInside = CGRectContainsPoint(outerBounds, touch.locationInView(self))
        let previouslyTouchedInside = CGRectContainsPoint(outerBounds, touch.previousLocationInView(self))
        
        if touchedInside
        {
            if previouslyTouchedInside
            {
                sendActionsForControlEvents(.TouchDragInside)
            }
            else
            {
                highlightButton()
                sendActionsForControlEvents(.TouchDragEnter)
            }
        }
        else
        {
            if previouslyTouchedInside
            {
                unhighlightButton()
                sendActionsForControlEvents(.TouchDragExit)
            }
            else
            {
                sendActionsForControlEvents(.TouchDragOutside)
            }
        }
        return YES
    }
    
    override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent)
    {
        unhighlightButton()
    }
}
