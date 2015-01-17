//
//  PageManager.swift
//  FloraDummy
//
//  Created by Michael Schloss on 1/9/15.
//  Copyright (c) 2015 SGSC. All rights reserved.
//

import UIKit

class NewPageManager: FormattedVC
{
    //MARK: - Variables
    
    //Database Manager
    private var databaseManager = CESDatabase.databaseManagerForPageManagerClass()
    
    //Buttons
    private var previousButton : UIButton_Typical?
    var previousButtonFrame : CGRect?
        {
        get
        {
            return previousButton?.frame
        }
    }
    
    private var nextButton : UIButton_Typical?
    var nextButtonFrame : CGRect?
        {
        get
        {
            return nextButton?.frame
        }
    }
    var nextButtonHidden : Bool
        {
        get
        {
            return nextButton!.userInteractionEnabled == NO
        }
        set
        {
            
        }
    }
    
    private var saveButton : UIButton_Typical?
    var saveButtonFrame : CGRect?
        {
        get
        {
            return saveButton?.frame
        }
    }
    
    //Button Constraints
    private var previousButtonConstraints = Array<NSLayoutConstraint>()
    private var saveButtonConstraints = Array<NSLayoutConstraint>()
    private var nextButtonConstraints = Array<NSLayoutConstraint>()
    
    //Current Index
    private var _currentIndex = 0
    var currentIndex : Int
        {
        get
        {
            return _currentIndex
        }
    }
    
    //Current Activity Information
    private var _currentActivity : ActivitySession?
    var currentActivity : ActivitySession?
        {
        set
        {
            _currentActivity = newValue
            presentNextViewController()
        }
        get
        {
            return _currentActivity
        }
    }
    var activityID : String?
        {
        get
        {
            return _currentActivity?.activityID
        }
    }
    
    private var isPresented : Bool
        {
        get
        {
            return parentViewController != nil
        }
    }
    
    //View Controllers On Screen
    private var oldViewController : FormattedVC?
    private var currentViewController : FormattedVC?
    
    //View Controllers On Screen Constraints
    private var oldViewControllerConstraints = Array<NSLayoutConstraint>()
    private var currentViewControllerConstraints = Array<NSLayoutConstraint>()
    
    var subjectParent : SubjectVC?
    
    //MARK: - Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "continueWithPresentation", name: PageManagerShouldContinuePresentation, object: nil)
        
        previousButton = UIButton_Typical(frame: CGRectZero)
        previousButton!.setTranslatesAutoresizingMaskIntoConstraints(NO)
        previousButton!.setTitle("Back", forState: .Normal)
        previousButton!.addTarget(self, action: "goBackOnePage", forControlEvents: .TouchUpInside)
        previousButton!.userInteractionEnabled = NO
        previousButton!.alpha = 0.0
        view.addSubview(previousButton!)
        
        nextButton = UIButton_Typical(frame: CGRectZero)
        nextButton!.setTranslatesAutoresizingMaskIntoConstraints(NO)
        nextButton!.setTitle("Next", forState: .Normal)
        nextButton!.addTarget(self, action: "goForwardOnePage", forControlEvents: .TouchUpInside)
        nextButton!.userInteractionEnabled = NO
        nextButton!.alpha = 0.0
        view.addSubview(nextButton!)
        
        saveButton = UIButton_Typical(frame: CGRectZero)
        saveButton!.setTranslatesAutoresizingMaskIntoConstraints(NO)
        saveButton!.setTitle("Save", forState: .Normal)
        saveButton!.addTarget(self, action: "saveActivity", forControlEvents: .TouchUpInside)
        saveButton!.userInteractionEnabled = NO
        saveButton!.alpha = 0.0
        view.addSubview(saveButton!)
        
        setUpButtons()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func setUpButtons()
    {
        if currentIndex == currentActivity!.activityData.count - 1 //Final Page
        {
            view.removeConstraints(previousButtonConstraints)
            view.removeConstraints(nextButtonConstraints)
            view.removeConstraints(saveButtonConstraints)
            
            previousButtonConstraints = Array<NSLayoutConstraint>()
            saveButtonConstraints = Array<NSLayoutConstraint>()
            nextButtonConstraints = Array<NSLayoutConstraint>()
            
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton!, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: -4.0))
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton!, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton!, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.2, constant: 0.0))
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton!, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.1, constant: 0.0))
            
            saveButtonConstraints.append(NSLayoutConstraint(item: saveButton!, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 4.0))
            saveButtonConstraints.append(NSLayoutConstraint(item: saveButton!, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
            saveButtonConstraints.append(NSLayoutConstraint(item: saveButton!, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.2, constant: 0.0))
            saveButtonConstraints.append(NSLayoutConstraint(item: saveButton!, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.1, constant: 0.0))
            
            nextButtonConstraints.append(NSLayoutConstraint(item: nextButton!, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: -8.0))
            nextButtonConstraints.append(NSLayoutConstraint(item: nextButton!, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
            nextButtonConstraints.append(NSLayoutConstraint(item: nextButton!, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.2, constant: 0.0))
            nextButtonConstraints.append(NSLayoutConstraint(item: nextButton!, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.1, constant: 0.0))
            
            view.addConstraints(previousButtonConstraints)
            view.addConstraints(saveButtonConstraints)
            view.addConstraints(nextButtonConstraints)
            
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                self.view.layoutIfNeeded()
                
                self.nextButton!.alpha = 0.0
                self.nextButton!.userInteractionEnabled = NO
                }, completion: nil)
            
            UIView.transitionWithView(saveButton!, duration: 0.5, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                self.saveButton!.setTitle("Finish", forState: .Normal)
            }, completion: nil)
        }
        else if currentIndex == 0    //First Page
        {
            view.removeConstraints(previousButtonConstraints)
            view.removeConstraints(nextButtonConstraints)
            view.removeConstraints(saveButtonConstraints)
            
            previousButtonConstraints = Array<NSLayoutConstraint>()
            saveButtonConstraints = Array<NSLayoutConstraint>()
            nextButtonConstraints = Array<NSLayoutConstraint>()
            
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton!, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 8.0))
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton!, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton!, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.2, constant: 0.0))
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton!, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.1, constant: 0.0))
            
            saveButtonConstraints.append(NSLayoutConstraint(item: saveButton!, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: -4.0))
            saveButtonConstraints.append(NSLayoutConstraint(item: saveButton!, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
            saveButtonConstraints.append(NSLayoutConstraint(item: saveButton!, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.2, constant: 0.0))
            saveButtonConstraints.append(NSLayoutConstraint(item: saveButton!, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.1, constant: 0.0))
            
            nextButtonConstraints.append(NSLayoutConstraint(item: nextButton!, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 4.0))
            nextButtonConstraints.append(NSLayoutConstraint(item: nextButton!, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
            nextButtonConstraints.append(NSLayoutConstraint(item: nextButton!, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.2, constant: 0.0))
            nextButtonConstraints.append(NSLayoutConstraint(item: nextButton!, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.1, constant: 0.0))
            
            view.addConstraints(previousButtonConstraints)
            view.addConstraints(saveButtonConstraints)
            view.addConstraints(nextButtonConstraints)
            
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                self.view.layoutIfNeeded()
                
                self.nextButton!.alpha = 1.0
                self.nextButton!.userInteractionEnabled = YES
                self.previousButton!.alpha = 0.0
                self.previousButton!.userInteractionEnabled = NO
                }, completion: nil)
            
            UIView.transitionWithView(saveButton!, duration: 0.5, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                self.saveButton!.setTitle("Save", forState: .Normal)
                }, completion: nil)
        }
        else    //Middle Page
        {
            view.removeConstraints(previousButtonConstraints)
            view.removeConstraints(nextButtonConstraints)
            view.removeConstraints(saveButtonConstraints)
            
            previousButtonConstraints = Array<NSLayoutConstraint>()
            saveButtonConstraints = Array<NSLayoutConstraint>()
            nextButtonConstraints = Array<NSLayoutConstraint>()
            
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton!, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 8.0))
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton!, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton!, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.2, constant: 0.0))
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton!, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.1, constant: 0.0))
            
            saveButtonConstraints.append(NSLayoutConstraint(item: saveButton!, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
            saveButtonConstraints.append(NSLayoutConstraint(item: saveButton!, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
            saveButtonConstraints.append(NSLayoutConstraint(item: saveButton!, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.2, constant: 0.0))
            saveButtonConstraints.append(NSLayoutConstraint(item: saveButton!, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.1, constant: 0.0))
            
            nextButtonConstraints.append(NSLayoutConstraint(item: nextButton!, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: -8.0))
            nextButtonConstraints.append(NSLayoutConstraint(item: nextButton!, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
            nextButtonConstraints.append(NSLayoutConstraint(item: nextButton!, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.2, constant: 0.0))
            nextButtonConstraints.append(NSLayoutConstraint(item: nextButton!, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.1, constant: 0.0))
            
            view.addConstraints(previousButtonConstraints)
            view.addConstraints(saveButtonConstraints)
            view.addConstraints(nextButtonConstraints)
            
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                self.view.layoutIfNeeded()
                
                self.nextButton!.alpha = 1.0
                self.nextButton!.userInteractionEnabled = YES
                self.previousButton!.alpha = 1.0
                self.previousButton!.userInteractionEnabled = YES
            }, completion: nil)
            
            UIView.transitionWithView(saveButton!, duration: 0.5, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                self.saveButton!.setTitle("Save", forState: .Normal)
                }, completion: nil)
        }
    }
    
    private func displayDismissAlert(customMessage: String?)
    {
        var dismissAlert : UIAlertController
        
        if customMessage != nil
        {
            dismissAlert = UIAlertController(title: customMessage?.componentsSeparatedByString("|")[0], message: customMessage?.componentsSeparatedByString("|")[1], preferredStyle: .Alert)
        }
        else
        {
            dismissAlert = UIAlertController(title: "We're Sorry", message: "There's been an issue presenting this activity\n\nPlease contact your teacher for assistance", preferredStyle: .Alert)
        }
        
        dismissAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(YES, completion: nil)
        }))
        
        UIApplication.sharedApplication().keyWindow!.rootViewController!.presentViewController(dismissAlert, animated: YES, completion: nil)
    }
    
    func presentNextViewController()
    {
        //Perform some quick checks to make sure we have a valid activity
        if currentActivity != nil && activityID != nil
        {
            if currentActivity!.activityData.count == 0
            {
                displayDismissAlert("We're sorry|There are no Activity Pages for this activity\n\nPlease contact your teacher for assistance")
                return
            }
        }
        else
        {
            displayDismissAlert("We're sorry|There is no specified Activity Information for this activity\n\nPlease contact your teacher for assistance")
            return
        }
        
        oldViewController = currentViewController
        
        let currentActivityPage = currentActivity!.activityData[currentIndex]
        let currentActivityType = currentActivityPage.keys.array[0]
        currentViewController = viewControllerForPageType(ActivityViewControllerType(rawValue: currentActivityType.integerValue)!)
        (currentViewController! as CESDatabaseActivity).restoreActivityState?(currentActivityPage.values.array[0])
        9
        _currentIndex = min(currentIndex + 1, currentActivity!.activityData.count)
    }
    
    func continueWithPresentation()
    {
        if isPresented == NO
        {
            //TODO: Place currentViewController on screen with NO animation
            self.modalPresentationStyle = .Custom
            self.transitioningDelegate = subjectParent
            subjectParent!.presentViewController(self, animated: YES, completion: nil)
        }
        else
        {
            setUpButtons()
            //TODO: Place currentViewController on screen and run animation
        }
    }
    
    private func viewControllerForPageType(pageType: ActivityViewControllerType) -> FormattedVC?
    {
        switch pageType
        {
        case .Calculator:
            return CalculatorVC()
            
        case .ClockDrag:
            return ClockDragVC()
            
        case .Garden:
            return Page_GardenDataVC()
            
        case .Intro:
            return Page_IntroVC()
            
        case .MathProblem:
            return MathProblemVC()
            
        case .Module:
            return ModuleVC()
            
        case .PictureQuiz:
            return PictureQuizVC()
            
        case .QuickQuiz:
            return QuickQuizVC()
            
        case .Read:
            return Page_ReadVC()
            
            //case .Sandbox:
            //    return SandboxVC()
            
        case .Spelling:
            return SpellingTestVC()
            
        case .SquaresDragAndDrop:
            return SquaresDragAndDrop()
            
        case .Vocab:
            return VocabVC()
            
        default:
            return nil
        }
    }
}

//MARK: - For Future Renaming
//@availability(*, unavailable, renamed="PageManager")
//typealias NewPageManager = PageManager
