//
//  SettingsVC.swift
//  Flora Dummy
//
//  Created by Michael Schloss on 10/25/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController
{
    //Standard Setup
    private let borderWidth = 4.0
    
    private var primaryColor : UIColor?
    private var secondaryColor : UIColor?
    
    private var colorSchemeDictionary : NSDictionary?
    
    //IBOutlet setup
    @IBOutlet private var titleLabel : UILabel?
    @IBOutlet private var gradeLabel : UILabel?
    @IBOutlet private var colorLabel : UILabel?
    
    @IBOutlet private var kindergartenButton : UIButton?
    @IBOutlet private var firstButton : UIButton?
    @IBOutlet private var secondButton : UIButton?
    @IBOutlet private var thirdButton : UIButton?
    @IBOutlet private var fourthButton : UIButton?
    @IBOutlet private var fifthButton : UIButton?
    @IBOutlet private var sixthButton : UIButton?
    
    @IBOutlet private var purpleButton : UIButton?
    @IBOutlet private var redButton : UIButton?
    @IBOutlet private var pinkButton : UIButton?
    @IBOutlet private var orangeButton : UIButton?
    @IBOutlet private var yellowButton : UIButton?
    @IBOutlet private var greenButton : UIButton?
    @IBOutlet private var blueButton : UIButton?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        //Do JSON Work
        let mainDirectory = NSBundle.mainBundle().resourcePath
        let fullPath = mainDirectory?.stringByAppendingPathComponent("Carroll.json")
        let jsonFile = NSData(contentsOfFile: fullPath!)
        let jsonDictionary = NSJSONSerialization.JSONObjectWithData(jsonFile!, options: .AllowFragments, error: nil) as NSDictionary
        
        colorSchemeDictionary = jsonDictionary["Colors"] as NSDictionary?
        
        //Override Code until a better solution can be crafted
        primaryColor = .whiteColor()
        
        purpleButton!.setTitleColor(primaryColor, forState: .Normal)
        purpleButton!.backgroundColor = colorForName(purpleButton!.titleLabel!.text!)
        Definitions.outlineTextInLabel(purpleButton!.titleLabel!)
        purpleButton!.layer.borderWidth = CGFloat(borderWidth)
        purpleButton!.layer.borderColor = UIColor.whiteColor().CGColor
        
        redButton!.setTitleColor(primaryColor, forState: .Normal)
        redButton!.backgroundColor = colorForName(redButton!.titleLabel!.text!)
        Definitions.outlineTextInLabel(redButton!.titleLabel!)
        redButton!.layer.borderWidth = CGFloat(borderWidth)
        redButton!.layer.borderColor = UIColor.whiteColor().CGColor
        
        pinkButton!.setTitleColor(primaryColor, forState: .Normal)
        pinkButton!.backgroundColor = colorForName(pinkButton!.titleLabel!.text!)
        Definitions.outlineTextInLabel(pinkButton!.titleLabel!)
        pinkButton!.layer.borderWidth = CGFloat(borderWidth)
        pinkButton!.layer.borderColor = UIColor.whiteColor().CGColor
        
        orangeButton!.setTitleColor(primaryColor, forState: .Normal)
        orangeButton!.backgroundColor = colorForName(orangeButton!.titleLabel!.text!)
        Definitions.outlineTextInLabel(orangeButton!.titleLabel!)
        orangeButton!.layer.borderWidth = CGFloat(borderWidth)
        orangeButton!.layer.borderColor = UIColor.whiteColor().CGColor
        
        yellowButton!.setTitleColor(primaryColor, forState: .Normal)
        yellowButton!.backgroundColor = colorForName(yellowButton!.titleLabel!.text!)
        Definitions.outlineTextInLabel(yellowButton!.titleLabel!)
        yellowButton!.layer.borderWidth = CGFloat(borderWidth)
        yellowButton!.layer.borderColor = UIColor.whiteColor().CGColor
        
        greenButton!.setTitleColor(primaryColor, forState: .Normal)
        greenButton!.backgroundColor = colorForName(greenButton!.titleLabel!.text!)
        Definitions.outlineTextInLabel(greenButton!.titleLabel!)
        greenButton!.layer.borderWidth = CGFloat(borderWidth)
        greenButton!.layer.borderColor = UIColor.whiteColor().CGColor
        
        blueButton!.setTitleColor(primaryColor, forState: .Normal)
        blueButton!.backgroundColor = colorForName(blueButton!.titleLabel!.text!)
        Definitions.outlineTextInLabel(blueButton!.titleLabel!)
        blueButton!.layer.borderWidth = CGFloat(borderWidth)
        blueButton!.layer.borderColor = UIColor.whiteColor().CGColor
        
        //Update Label colors
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        
        primaryColor = Definitions.colorWithHexString(standardDefaults.objectForKey("primaryColor") as String)
        secondaryColor = Definitions.colorWithHexString(standardDefaults.objectForKey("secondaryColor") as String)
        view.backgroundColor = Definitions.colorWithHexString(standardDefaults.objectForKey("backgroundColor") as String)
        
        titleLabel!.textColor = primaryColor
        Definitions.outlineTextInLabel(titleLabel!)
        
        colorLabel!.textColor = primaryColor
        Definitions.outlineTextInLabel(colorLabel!)
        
        gradeLabel!.textColor = primaryColor
        Definitions.outlineTextInLabel(gradeLabel!)
        
        kindergartenButton!.setTitleColor(primaryColor, forState: .Normal)
        Definitions.outlineTextInLabel(kindergartenButton!.titleLabel!)
        kindergartenButton!.layer.borderWidth = CGFloat(borderWidth)
        kindergartenButton!.layer.borderColor = UIColor.whiteColor().CGColor
        kindergartenButton!.backgroundColor = secondaryColor
        
        firstButton!.setTitleColor(primaryColor, forState: .Normal)
        Definitions.outlineTextInLabel(firstButton!.titleLabel!)
        firstButton!.layer.borderWidth = CGFloat(borderWidth)
        firstButton!.layer.borderColor = UIColor.whiteColor().CGColor
        firstButton!.backgroundColor = secondaryColor
        
        secondButton!.setTitleColor(primaryColor, forState: .Normal)
        Definitions.outlineTextInLabel(secondButton!.titleLabel!)
        secondButton!.layer.borderWidth = CGFloat(borderWidth)
        secondButton!.layer.borderColor = UIColor.whiteColor().CGColor
        secondButton!.backgroundColor = secondaryColor
        
        thirdButton!.setTitleColor(primaryColor, forState: .Normal)
        Definitions.outlineTextInLabel(thirdButton!.titleLabel!)
        thirdButton!.layer.borderWidth = CGFloat(borderWidth)
        thirdButton!.layer.borderColor = UIColor.whiteColor().CGColor
        thirdButton!.backgroundColor = secondaryColor
        
        fourthButton!.setTitleColor(primaryColor, forState: .Normal)
        Definitions.outlineTextInLabel(fourthButton!.titleLabel!)
        fourthButton!.layer.borderWidth = CGFloat(borderWidth)
        fourthButton!.layer.borderColor = UIColor.whiteColor().CGColor
        fourthButton!.backgroundColor = secondaryColor
        
        fifthButton!.setTitleColor(primaryColor, forState: .Normal)
        Definitions.outlineTextInLabel(fifthButton!.titleLabel!)
        fifthButton!.layer.borderWidth = CGFloat(borderWidth)
        fifthButton!.layer.borderColor = UIColor.whiteColor().CGColor
        fifthButton!.backgroundColor = secondaryColor
        
        sixthButton!.setTitleColor(primaryColor, forState: .Normal)
        Definitions.outlineTextInLabel(sixthButton!.titleLabel!)
        sixthButton!.layer.borderWidth = CGFloat(borderWidth)
        sixthButton!.layer.borderColor = UIColor.whiteColor().CGColor
        sixthButton!.backgroundColor = secondaryColor
    }
    
    //Update the background color
    @IBAction func colorButtonPressed(sender : AnyObject)
    {
        //Get the text of the button.  Should be its color
        let button = sender as UIButton
        let color = button.titleLabel!.text
        
        let colorDictionary = colorSchemeDictionary!.objectForKey(color!) as NSDictionary
        
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        
        standardDefaults.setObject(colorDictionary["Primary"], forKey: "primaryColor")
        standardDefaults.setObject(colorDictionary["Secondary"], forKey: "secondaryColor")
        standardDefaults.setObject(colorDictionary["Background"], forKey: "backgroundColor")
        
        standardDefaults.synchronize()
        
        UIView.animateKeyframesWithDuration(0.3, delay: 0.0, options: UIViewKeyframeAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1.0, animations: { () -> Void in
                self.viewDidLoad()
            })
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5, animations: { () -> Void in
                button.transform = CGAffineTransformMakeScale(1.5, 1.5)
            })
            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { () -> Void in
                button.transform = CGAffineTransformMakeScale(1.0, 1.0)
            })
        }, completion: nil)
    }

    @IBAction func gradeButtonPressed(sender : AnyObject)
    {
        //Get the grade number
        let button = sender as UIButton
        var grade = button.titleLabel!.text
        
        //Check for overflow of Kindergarten
        if grade! == "K"
        {
            grade = "Kindergarten"
        }
        
        //Update the grade in the general defaults
        
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        
        standardDefaults.setObject(grade!, forKey: "gradeNumber")
        
        standardDefaults.synchronize()
        
        UIView.animateKeyframesWithDuration(0.3, delay: 0.0, options: UIViewKeyframeAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5, animations: { () -> Void in
                button.transform = CGAffineTransformMakeScale(1.5, 1.5)
            })
            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { () -> Void in
                button.transform = CGAffineTransformMakeScale(1.0, 1.0)
            })
            }, completion: nil)
    }
    
    private func colorForName(name : String) -> UIColor?
    {
        let colorDictionary = colorSchemeDictionary!.objectForKey(name) as NSDictionary
        
        let colorHEXString = colorDictionary.objectForKey("Background") as String
        
        return Definitions.colorWithHexString(colorHEXString)
    }
}
