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
            self.nextButton!.userInteractionEnabled == !newValue
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                
                switch newValue
                {
                case YES:
                    self.nextButton!.alpha = 0.0
                    break
                    
                case NO:
                    self.nextButton!.alpha = 1.0
                    
                default:
                    break
                }
                }, completion: nil)
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
    
    private var titleLabel : UILabel?
    private var detailLabel : UILabel?
    
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
    
    //Current Activity (Session) Information
    var currentActivity : Activity?
    
    private var _currentActivitySession : ActivitySession?
    var currentActivitySession : ActivitySession?
        {
        set
        {
            _currentActivitySession = newValue
            presentNextViewController()
        }
        get
        {
            return _currentActivitySession
        }
    }
    var activityID : String?
        {
        get
        {
            return _currentActivitySession?.activityID
        }
    }
    
    private var isPresented : Bool
        {
        get
        {
            return parentViewController != nil
        }
    }
    private var newActivityData = Array<Dictionary<NSNumber, AnyObject>>()
    
    //Transition Direction
    private var direction = "Forward"
    
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
        previousButton!.addTarget(self, action: "goBackOnePage:", forControlEvents: .TouchUpInside)
        previousButton!.userInteractionEnabled = NO
        previousButton!.alpha = 0.0
        view.addSubview(previousButton!)
        
        nextButton = UIButton_Typical(frame: CGRectZero)
        nextButton!.setTranslatesAutoresizingMaskIntoConstraints(NO)
        nextButton!.setTitle("Next", forState: .Normal)
        nextButton!.addTarget(self, action: "goForwardOnePage:", forControlEvents: .TouchUpInside)
        nextButton!.userInteractionEnabled = NO
        nextButton!.alpha = 0.0
        view.addSubview(nextButton!)
        
        saveButton = UIButton_Typical(frame: CGRectZero)
        saveButton!.setTranslatesAutoresizingMaskIntoConstraints(NO)
        saveButton!.setTitle("Save", forState: .Normal)
        saveButton!.addTarget(self, action: "saveActivity:", forControlEvents: .TouchUpInside)
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
        if currentIndex == currentActivitySession!.activityData.count - 1 //Final Page
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
    
    func goBackOnePage(button: UIButton_Typical)
    {
        button.userInteractionEnabled = NO
        _currentIndex--
        direction = "Backward"
        
        presentNextViewController()
    }
    
    func goForwardOnePage(button: UIButton_Typical)
    {
        button.userInteractionEnabled = NO
        _currentIndex++
        direction = "Forward"
        
        presentNextViewController()
    }
    
    func saveActivity(button: UIButton_Typical)
    {
        view.userInteractionEnabled = NO
        
        let savedObject: AnyObject? = (currentViewController as CESDatabaseActivity).saveActivityState?()
        
        let currentActivityPage = currentActivitySession!.activityData[currentIndex]
        let currentActivityType = currentActivityPage.keys.array[0]
        
        if savedObject == nil
        {
            newActivityData[currentIndex].updateValue(NSNull(), forKey: currentActivityType)
        }
        else //If the activity actually returned a saved object, save it
        {
            newActivityData[currentIndex].updateValue(savedObject!, forKey: currentActivityType)
        }
        
        //CHECKS FOR CURRENT ACTIVITY
        
        //Update the currentActivity values with the newActivityData values
        for index in 0...(newActivityData.count - 1)
        {
            currentActivitySession!.activityData[index].updateValue(newActivityData[index].values.array[0], forKey: currentActivitySession!.activityData[index].keys.array[0])
        }
        
        if button.titleLabel!.text == "Finish"  //We are actually finishing
        {
            currentActivitySession!.endDate = NSDate()
            
            if currentActivitySession!.endDate!.compare(currentActivity!.dueDate) == .OrderedDescending
            {
                currentActivitySession!.status = "Past Due"
            }
            else
            {
                currentActivitySession!.status = "Finished"
            }
        }
        else
        {
            currentActivitySession!.status = "Started"
        }
        
        let wheel = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        wheel.center = saveButton!.center
        wheel.startAnimating()
        wheel.alpha = 0.0
        wheel.transform = CGAffineTransformMakeScale(1.3, 1.3)
        view.addSubview(wheel)
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .AllowUserInteraction | .AllowAnimatedContent, animations: { () -> Void in
            
            wheel.alpha = 1.0
            wheel.transform = CGAffineTransformIdentity
            
            self.nextButton!.alpha = 0.0
            self.previousButton!.alpha = 0.0
            self.saveButton!.alpha = 0.0
            self.saveButton!.transform = CGAffineTransformMakeScale(0.7, 0.7)
            
            }, completion: { (finished) -> Void in
                self.databaseManager.uploadActivitySession(self.currentActivitySession!, completion: { (uploadSuccess) -> Void in
                    if uploadSuccess == YES
                    {
                        self.dismissViewControllerAnimated(YES, completion: nil)
                    }
                    else
                    {
                        //TODO: DISPLAY ERROR
                    }
                })
        })
    }
    
    func presentNextViewController()
    {
        //Perform some quick checks to make sure we have a valid activity
        if currentActivitySession != nil && activityID != nil
        {
            if currentActivitySession!.activityData.count == 0
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
        
        //Move the viewController on screen to the oldViewController object
        oldViewController = currentViewController
        
        //If we actually have an oldActivity
        if oldViewController != nil
        {
            //Get the oldActivity's type
            let oldActivityPage = currentActivitySession!.activityData[currentIndex - 1]
            let oldActivityType = oldActivityPage.keys.array[0]
            
            //Get the savedObject for the activity
            let savedObject: AnyObject? = (oldViewController as CESDatabaseActivity).saveActivityState?()
            
            //If the activity didn't return a saved object, save a null value
            if savedObject == nil
            {
                newActivityData[currentIndex - 1].updateValue(NSNull(), forKey: oldActivityType)
            }
            else //If the activity actually returned a saved object, save it
            {
                newActivityData[currentIndex - 1].updateValue(savedObject!, forKey: oldActivityType)
            }
        }
        
        //Get the new activity's type
        let currentActivityPage = currentActivitySession!.activityData[currentIndex]
        let currentActivityType = currentActivityPage.keys.array[0]
        
        //Initialize the new activity
        currentViewController = viewControllerForPageType(ActivityViewControllerType(rawValue: currentActivityType.integerValue)!)
        
        currentViewController?.view.userInteractionEnabled = (currentActivitySession!.status == "Started" || currentActivitySession!.status == "Not Started")
        
        //Check if we have already saved data in the activity (i.e. the user is going backwards)
        if newActivityData[currentIndex].values.array[0].classForCoder !== NSNull.classForCoder()
        {
            (currentViewController! as CESDatabaseActivity).restoreActivityState?(newActivityData[currentIndex].values.array[0])
        }
        else if currentActivityPage.values.array[0].classForCoder !== NSNull.classForCoder()    //There isn't any saved session data for this activity, so load the old session data
        {
            (currentViewController! as CESDatabaseActivity).restoreActivityState?(currentActivityPage.values.array[0])
        }
    }
    
    func continueWithPresentation()
    {
        if isPresented == NO
        {
            if currentViewController != nil
            {
                currentViewController!.willMoveToParentViewController(self)
                view.addSubview(currentViewController!.view)
                
                currentViewControllerConstraints.append(NSLayoutConstraint(item: currentViewController!, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0))
                currentViewControllerConstraints.append(NSLayoutConstraint(item: currentViewController!, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
                currentViewControllerConstraints.append(NSLayoutConstraint(item: currentViewController!, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
                currentViewControllerConstraints.append(NSLayoutConstraint(item: currentViewController!, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 0.0))
                
                currentViewController!.didMoveToParentViewController(self)
            }
            self.modalPresentationStyle = .Custom
            self.transitioningDelegate = subjectParent
            subjectParent!.presentViewController(self, animated: YES, completion: nil)
        }
        else
        {
            setUpButtons()
            if currentViewController != nil
            {
                currentViewController!.view.alpha = 0.0
                currentViewController!.willMoveToParentViewController(self)
                view.addSubview(currentViewController!.view)
                
                currentViewControllerConstraints.append(NSLayoutConstraint(item: currentViewController!, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0))
                currentViewControllerConstraints.append(NSLayoutConstraint(item: currentViewController!, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
                currentViewControllerConstraints.append(NSLayoutConstraint(item: currentViewController!, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
                currentViewControllerConstraints.append(NSLayoutConstraint(item: currentViewController!, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 0.0))
                
                currentViewController!.didMoveToParentViewController(self)
                
                switch direction
                {
                case "Forward":
                    currentViewController!.view.transform = CGAffineTransformMakeTranslation(view.frame.size.width, 0.0)
                    break
                    
                case "Backward":
                    currentViewController!.view.transform = CGAffineTransformMakeTranslation(-view.frame.size.width, 0.0)
                    break
                    
                default:
                    currentViewController!.view.transform = CGAffineTransformMakeTranslation(view.frame.size.width, 0.0)
                    break
                }
                
                UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                    
                    self.currentViewController!.view.transform = CGAffineTransformIdentity
                    
                    if self.oldViewController != nil
                    {
                        switch self.direction
                        {
                        case "Forward":
                            self.oldViewController!.view.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0.0)
                            break
                            
                        case "Backward":
                            self.oldViewController!.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0.0)
                            break
                            
                        default:
                            self.oldViewController!.view.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0.0)
                            break
                        }
                    }
                    
                    }, completion: { (finished) -> Void in
                        
                        if self.nextButton!.alpha == 1.0
                        {
                            self.nextButton!.userInteractionEnabled = YES
                        }
                        if self.previousButton!.alpha == 1.0
                        {
                            self.previousButton!.userInteractionEnabled = YES
                        }
                        if self.saveButton!.alpha == 1.0
                        {
                            self.saveButton!.userInteractionEnabled = YES
                        }
                        
                        if self.oldViewController != nil
                        {
                            self.oldViewController!.willMoveToParentViewController(nil)
                            self.oldViewController!.removeFromParentViewController()
                            self.oldViewController!.view.removeFromSuperview()
                            self.oldViewController!.didMoveToParentViewController(nil)
                        }
                })
            }
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
