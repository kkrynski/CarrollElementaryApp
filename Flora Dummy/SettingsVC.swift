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
    
    private var selectedGradeButton : UIButton?
    private var selectedColorButton : UIButton?
    
    //IBOutlet setup
    @IBOutlet private var titleLabel : UILabel?
    @IBOutlet private var gradeLabel : UILabel?
    @IBOutlet private var colorLabel : UILabel?
    @IBOutlet private var animatedWeatherLabel : UILabel?
    
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
    
    @IBOutlet private var devModeSwitch : UISwitch?
    @IBOutlet private var animatedWeatherSwitch : UISwitch?
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        devModeSwitch!.on = standardDefaults.boolForKey("showsDevTab")
        
        animatedWeatherSwitch!.on = standardDefaults.boolForKey("animatedWeather")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        let mainDirectory = NSBundle.mainBundle().resourcePath
        let fullPath = mainDirectory?.stringByAppendingPathComponent("Carroll.json")
        let jsonFile = NSData(contentsOfFile: fullPath!)
        let jsonDictionary = NSJSONSerialization.JSONObjectWithData(jsonFile!, options: .AllowFragments, error: nil) as NSDictionary
        colorSchemeDictionary = jsonDictionary["Colors"] as NSDictionary?
        
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        
        //Set up the color buttons
        setUpColorButton(purpleButton!)
        setUpColorButton(redButton!)
        setUpColorButton(pinkButton!)
        setUpColorButton(orangeButton!)
        setUpColorButton(yellowButton!)
        setUpColorButton(greenButton!)
        setUpColorButton(blueButton!)
        
        //Set up the grade buttons
        setUpGradeButton(kindergartenButton!)
        setUpGradeButton(firstButton!)
        setUpGradeButton(secondButton!)
        setUpGradeButton(thirdButton!)
        setUpGradeButton(fourthButton!)
        setUpGradeButton(fifthButton!)
        setUpGradeButton(sixthButton!)
        
        //Update Label colors
        
        titleLabel!.textColor = primaryColor
        Definitions.outlineTextInLabel(titleLabel!)
        
        colorLabel!.textColor = primaryColor
        Definitions.outlineTextInLabel(colorLabel!)
        
        gradeLabel!.textColor = primaryColor
        Definitions.outlineTextInLabel(gradeLabel!)
        
        animatedWeatherLabel!.textColor = primaryColor
        Definitions.outlineTextInLabel(animatedWeatherLabel!)
        
        //Select the buttons that already correspond with the current defaults.
        //This reduces double-loading
        switch standardDefaults.objectForKey("gradeNumber") as String
        {
        case "Kindergarten":
            kindergartenButton!.highlighted = YES
            kindergartenButton!.userInteractionEnabled = NO
            selectedGradeButton = kindergartenButton
            
        case "1":
            firstButton!.highlighted = YES
            firstButton!.userInteractionEnabled = NO
            selectedGradeButton = firstButton
            
        case "2":
            secondButton!.highlighted = YES
            secondButton!.userInteractionEnabled = NO
            selectedGradeButton = secondButton
            
        case "3":
            thirdButton!.highlighted = YES
            thirdButton!.userInteractionEnabled = NO
            selectedGradeButton = thirdButton
            
        case "4":
            fourthButton!.highlighted = YES
            fourthButton!.userInteractionEnabled = NO
            selectedGradeButton = fourthButton
            
        case "5":
            fifthButton!.highlighted = YES
            fifthButton!.userInteractionEnabled = NO
            selectedGradeButton = fifthButton
            
        case "6":
            sixthButton!.highlighted = YES
            sixthButton!.userInteractionEnabled = NO
            selectedGradeButton = sixthButton
            
        default:
            break
        }
        
        switch standardDefaults.integerForKey("selectedBackgroundButton")
        {
        case 1:
            purpleButton!.highlighted = YES
            purpleButton!.userInteractionEnabled = NO;
            selectedColorButton = purpleButton!
            
        case 2:
            redButton!.highlighted = YES
            redButton!.userInteractionEnabled = NO;
            selectedColorButton = redButton!
            
        case 3:
            pinkButton!.highlighted = YES
            pinkButton!.userInteractionEnabled = NO;
            selectedColorButton = pinkButton!
            
        case 4:
            orangeButton!.highlighted = YES
            orangeButton!.userInteractionEnabled = NO;
            selectedColorButton = orangeButton!
            
        case 5:
            yellowButton!.highlighted = YES
            yellowButton!.userInteractionEnabled = NO;
            selectedColorButton = yellowButton!
            
        case 6:
            greenButton!.highlighted = YES
            greenButton!.userInteractionEnabled = NO;
            selectedColorButton = greenButton!
            
        case 7:
            
            blueButton!.highlighted = YES
            blueButton!.userInteractionEnabled = NO;
            selectedColorButton = blueButton!
            
        default:
            break
        }
    }
    
    private func setUpColorButton(button: UIButton)
    {
        button.setTitleColor(primaryColor, forState: .Normal)
        button.backgroundColor = colorForName(button.titleLabel!.text!)
        Definitions.outlineTextInLabel(button.titleLabel!)
        Definitions.outlineButton(button)
    }
    
    func setUpGradeButton(button: UIButton)
    {
        button.setTitleColor(primaryColor, forState: .Normal)
        Definitions.outlineTextInLabel(button.titleLabel!)
        Definitions.outlineButton(button)
        button.backgroundColor = Definitions.lighterColorForColor(view.backgroundColor!)
    }
    
    //Update the background color
    @IBAction private func colorButtonPressed(sender : AnyObject)
    {
        //Get the text of the button.  Should be its color
        let button = sender as UIButton
        let color = button.titleLabel!.text
        
        button.highlighted = YES
        button.userInteractionEnabled = NO
        
        let colorDictionary = colorSchemeDictionary![color!] as NSDictionary
        
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        
        standardDefaults.setObject(colorDictionary["Primary"], forKey: "primaryColor")
        standardDefaults.setObject(colorDictionary["Secondary"], forKey: "secondaryColor")
        standardDefaults.setObject(colorDictionary["Background"], forKey: "backgroundColor")
        
        //Store the tag of the selected button to make it easier to keep track of which was selected
        standardDefaults.setInteger(button.tag, forKey: "selectedBackgroundButton")
        
        standardDefaults.synchronize()
        
        //Fancy Animate the button press and background color change
        
        view.bringSubviewToFront(button)
        
        UIView.animateKeyframesWithDuration(transitionLength, delay: 0.0, options: UIViewKeyframeAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1.0, animations: { () -> Void in
                //self.viewDidLoad()
                self.view.backgroundColor = Definitions.colorWithHexString(standardDefaults.objectForKey("backgroundColor") as String)
                self.kindergartenButton!.backgroundColor = Definitions.lighterColorForColor(self.view.backgroundColor!)
                self.firstButton!.backgroundColor = Definitions.lighterColorForColor(self.view.backgroundColor!)
                self.secondButton!.backgroundColor = Definitions.lighterColorForColor(self.view.backgroundColor!)
                self.thirdButton!.backgroundColor = Definitions.lighterColorForColor(self.view.backgroundColor!)
                self.fourthButton!.backgroundColor = Definitions.lighterColorForColor(self.view.backgroundColor!)
                self.fifthButton!.backgroundColor = Definitions.lighterColorForColor(self.view.backgroundColor!)
                self.sixthButton!.backgroundColor = Definitions.lighterColorForColor(self.view.backgroundColor!)
                
                self.selectedColorButton?.highlighted = NO
                self.selectedColorButton?.userInteractionEnabled = YES
            })
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5, animations: { () -> Void in
                button.transform = CGAffineTransformMakeScale(1.3, 1.3)
            })
            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { () -> Void in
                button.transform = CGAffineTransformMakeScale(1.0, 1.0)
            })
            }, completion: { (finished : Bool) -> Void in
                self.selectedColorButton = button
                UIView.animateWithDuration(transitionLength, delay: 0.0, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                    button.highlighted = YES
                    }, completion: nil)
        })
    }
    
    @IBAction private func gradeButtonPressed(sender : AnyObject)
    {
        //Get the grade number
        let button = sender as UIButton
        var grade = button.titleLabel!.text
        
        button.userInteractionEnabled = NO
        
        //Check for overflow of Kindergarten
        if grade! == "K"
        {
            grade = "Kindergarten"
        }
        
        //Update the grade in the general defaults
        
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        standardDefaults.setObject(grade!, forKey: "gradeNumber")
        standardDefaults.synchronize()
        
        //Fancy Animate the button press
        
        view.bringSubviewToFront(button)
        
        UIView.animateKeyframesWithDuration(transitionLength, delay: 0.0, options: UIViewKeyframeAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1.0, animations: { () -> Void in
                self.selectedGradeButton?.highlighted = NO
                self.selectedGradeButton?.userInteractionEnabled = YES
            })
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5, animations: { () -> Void in
                button.transform = CGAffineTransformMakeScale(1.3, 1.3)
            })
            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { () -> Void in
                button.transform = CGAffineTransformMakeScale(1.0, 1.0)
            })
            }, completion: { (finished : Bool) -> Void in
                self.selectedGradeButton = button
                UIView.animateWithDuration(transitionLength, delay: 0.3, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                    button.highlighted = YES
                    }, completion: nil)
        })
    }
    
    @IBAction private func toggleDevMode(sender : AnyObject)
    {
        var showsDevTab = !NSUserDefaults.standardUserDefaults().boolForKey("showsDevTab")
        NSUserDefaults.standardUserDefaults().setBool((sender as UISwitch).on, forKey: "showsDevTab")
        
        let tabBarController = self.tabBarController!
        
        if (sender as UISwitch).on
        {
            let storyboard = self.storyboard!
            
            let newTabs = NSMutableArray(array: tabBarController.viewControllers!)
            newTabs.addObject(storyboard.instantiateViewControllerWithIdentifier("DevPortal"))
            tabBarController.setViewControllers(newTabs, animated: YES)
        }
        else
        {
            let newTabs = NSMutableArray(array: tabBarController.viewControllers!)
            newTabs.removeLastObject()
            tabBarController.setViewControllers(newTabs, animated: YES)
        }
    }
    
    @IBAction private func toggleAnimatedWeather(sender : UISwitch)
    {
        switch sender.on
        {
        case YES:
            NSUserDefaults.standardUserDefaults().setBool(YES, forKey: "animatedWeather")
            break
            
        case NO:
            NSUserDefaults.standardUserDefaults().setBool(NO, forKey: "animatedWeather")
            break
            
        default:
            break
        }
    }
    
    private func colorForName(name : String) -> UIColor?
    {
        let colorDictionary = colorSchemeDictionary![name] as NSDictionary
        
        let colorHEXString = colorDictionary.objectForKey("Background") as String
        
        return Definitions.colorWithHexString(colorHEXString)
    }
}
