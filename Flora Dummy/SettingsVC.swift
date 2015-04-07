//
//  SettingsVC.swift
//  Flora Dummy
//
//  Created by Michael Schloss on 10/25/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class SettingsVC: FormattedVC
{
    //Standard Setup
    private let borderWidth = 4.0
    
    private var selectedColorButton : NSInteger!
    
    @IBOutlet private var titleLabel : UILabel!
    private var gradeLabel : UILabel!
    private var colorLabel : UILabel!
    
    private var colorButtons = Array<UIButton_Typical>()
    
    private var devModeSwitch : UISwitch!
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        devModeSwitch!.on = NSUserDefaults.standardUserDefaults().boolForKey("showsDevTab")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let colors = ColorManager.sharedManager().storedColors
        
        var width = view.frame.size.width - CGFloat(20 * (colors.count + 1))
        width = width / CGFloat(colors.count)
        
        for color in colors
        {
            let index = (colors as NSArray).indexOfObject(color)
            
            let button = UIButton_Typical()
            button.addTarget(self, action: "colorButtonPressed:", forControlEvents: .TouchUpInside)
            button.setTranslatesAutoresizingMaskIntoConstraints(NO)
            button.setTitle(color.name, forState: .Normal)
            button.setTitleColor(color.primaryColor, forState: .Normal)
            button.backgroundColor = color.backgroundColor
            button.layer.borderWidth = 4.0
            button.layer.borderColor = color.secondaryColor.CGColor
            button.titleLabel!.font = font
            button.titleLabel!.numberOfLines = 0
            
            if color.name == NSUserDefaults.standardUserDefaults().objectForKey("selectedColor") as String
            {
                selectedColorButton = index
                button.setHighlighted(YES, animated: NO)
                button.userInteractionEnabled = NO
            }
            
            view.addSubview(button)
            colorButtons.append(button)
            
            if index == 0
            {
            view.addConstraint(NSLayoutConstraint(item: button, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 20))
            }
            else
            {
                view.addConstraint(NSLayoutConstraint(item: button, attribute: .Leading, relatedBy: .Equal, toItem: colorButtons[index - 1], attribute: .Trailing, multiplier: 1.0, constant: 20))
            }
            view.addConstraint(NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: width/view.frame.size.width, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: width/view.frame.size.width, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: -8.0))
        }
        
        devModeSwitch = UISwitch()
        devModeSwitch.addTarget(self, action: "toggleDevMode:", forControlEvents: .ValueChanged)
        devModeSwitch.center = CGPointMake(20 + devModeSwitch.frame.size.width/2.0, view.frame.size.height - 20 - tabBarController!.tabBar.frame.size.height - devModeSwitch.frame.size.height/2.0)
        view.addSubview(devModeSwitch)
        
        let devModeLabel = UILabel()
        devModeLabel.text = "Developer Mode"
        devModeLabel.textColor = primaryColor
        devModeLabel.font = UIFont(name: "MarkerFelt-Thin", size: 26)
        Definitions.outlineTextInLabel(devModeLabel)
        devModeLabel.sizeToFit()
        devModeLabel.center = CGPointMake(20 + devModeLabel.frame.size.width/2.0, devModeSwitch.frame.origin.y - 8 - devModeLabel.frame.size.height/2.0)
        view.addSubview(devModeLabel)
        
        devModeSwitch.center = CGPointMake(devModeLabel.center.x, devModeSwitch.center.y)
        
        //Update Label colors
        
        titleLabel.textColor = primaryColor
        Definitions.outlineTextInLabel(titleLabel)
    }
    
    //Update the background color
    func colorButtonPressed(button : UIButton_Typical)
    {
        NSUserDefaults.standardUserDefaults().setObject(button.titleLabel!.text, forKey: "selectedColor")
        ColorManager.sharedManager().loadColorSchemeWithoutRefresh()
        NSNotificationCenter.defaultCenter().postNotificationName(ColorSchemeDidChangeNotification, object: nil)
        
        button.setHighlighted(YES, animated: YES)
        button.userInteractionEnabled = NO
        
        //Fancy Animate the button press
        view.bringSubviewToFront(button)
        
        self.colorButtons[self.selectedColorButton].setHighlighted(NO, animated: YES)
        self.colorButtons[self.selectedColorButton].userInteractionEnabled = YES
        
        UIView.transitionWithView(titleLabel, duration: transitionLength, options: .TransitionCrossDissolve, animations: { () -> Void in
            self.titleLabel.textColor = self.primaryColor
        }, completion: nil)
        
        UIView.animateKeyframesWithDuration(transitionLength, delay: 0.0, options: UIViewKeyframeAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5, animations: { () -> Void in
                button.transform = CGAffineTransformMakeScale(1.3, 1.3)
            })
            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { () -> Void in
                button.transform = CGAffineTransformMakeScale(1.0, 1.0)
            })
            }, completion: { (finished : Bool) -> Void in
                self.selectedColorButton = (self.colorButtons as NSArray).indexOfObject(button)
                UIView.animateWithDuration(transitionLength, delay: 0.0, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                    button.highlighted = YES
                    }, completion: nil)
        })
    }
    
    func toggleDevMode(devToggle : UISwitch)
    {
        var showsDevTab = !NSUserDefaults.standardUserDefaults().boolForKey("showsDevTab")
        NSUserDefaults.standardUserDefaults().setBool(devToggle.on, forKey: "showsDevTab")
        
        let tabBarController = self.tabBarController!
        
        if devToggle.on
        {
            let visibleTabs = NSMutableArray(array: tabBarController.viewControllers!)
            visibleTabs.addObject(self.storyboard!.instantiateViewControllerWithIdentifier("DevPortal"))
            tabBarController.setViewControllers(visibleTabs, animated: YES)
        }
        else
        {
            let visibleTabs = NSMutableArray(array: tabBarController.viewControllers!)
            visibleTabs.removeLastObject()
            tabBarController.setViewControllers(visibleTabs, animated: YES)
        }
    }
}
