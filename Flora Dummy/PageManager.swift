//
//  PageManager.swift
//  FloraDummy
//
//  Created by Michael Schloss on 1/9/15.
//  Copyright (c) 2015 SGSC. All rights reserved.
//

import UIKit

class PageManager: FormattedVC
{
    //MARK: - Variables
    
    //Database Manager
    private var databaseManager = CESDatabase.databaseManagerForPageManagerClass()
    
    //Buttons
    private var previousButton : UIButton_Typical!
    var previousButtonFrame : CGRect
        {
        get
        {
            return previousButton.frame
        }
    }
    
    private var nextButton : UIButton_Typical!
    var nextButtonFrame : CGRect
        {
        get
        {
            return nextButton.frame
        }
    }
    var nextButtonHidden : Bool
        {
        get
        {
            return nextButton.userInteractionEnabled == NO
        }
        set
        {
            self.nextButton.userInteractionEnabled == newValue
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                
                switch newValue
                {
                case YES:
                    self.nextButton.alpha = 0.0
                    break
                    
                case NO:
                    self.nextButton.alpha = 1.0
                    
                default:
                    break
                }
                }, completion: nil)
        }
    }
    
    private var saveButton : UIButton_Typical!
    var saveButtonFrame : CGRect
        {
        get
        {
            return saveButton.frame
        }
    }
    
    private var pageNumberLabel : UILabel!
    
    //Button Constraints
    private var previousButtonConstraints = Array<NSLayoutConstraint>()
    private var saveButtonConstraints = Array<NSLayoutConstraint>()
    private var nextButtonConstraints = Array<NSLayoutConstraint>()
    
    //Current Index
    private var currentIndex : NSInteger = -1
    
    //Current Activity (Session) Information
    var currentActivity : Activity!
    
    private var currentActivitySession : ActivitySession!
    private var activityID : String
        {
        get
        {
            return currentActivitySession.activityID
        }
    }
    
    private var isPresented : Bool
        {
        get
        {
            return presentingViewController != nil
        }
    }
    private var newActivityData = Array<Dictionary<NSNumber, AnyObject?>>()
    
    //Transition Direction
    private var direction = "Forward"
    
    //View Controllers On Screen
    private var oldViewController : FormattedVC?
    private var currentViewController : FormattedVC!
    
    //View Controllers On Screen Constraints
    private var oldViewControllerConstraints = Array<NSLayoutConstraint>()
    private var currentViewControllerConstraints = Array<NSLayoutConstraint>()
    
    //The Subject that presented this Page Manager instance
    var subjectParent : UIViewController!
    
    //Exit and Table of Contents Buttons
    private var exitButton : UIButton_Typical!
    private var TOCButton : UIButton_Typical!
    
    //Table Of Contents
    private var tableOfContentsImages = Array<UIImage>()
    private var tableOfContentsView : UIScrollView!
    private var tableOfContentsImageViews = Array<CESCometUIImageView>()
    
    private var lastVisibleIndex : NSInteger = -1
    private var selectedImageView : CESCometUIImageView!
    
    
    private var isInTOC = NO
    
    //MARK: - View Setup
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        subjectParent = FormattedVC(nibName: nil, bundle: nil)
        currentActivitySession = ActivitySession()
        currentActivity = Activity()
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, activitySession: ActivitySession, forActivity activity: Activity, withParent parent: UIViewController)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        subjectParent = parent
        currentActivitySession = activitySession
        currentActivity = activity
        
        let introVC = Page_IntroVC(nibName: "Page_IntroVC", bundle: nil)
        introVC.activityTitle = activity.name
        introVC.summary = activity.activityDescription
        
        currentViewController = introVC
        continueWithPresentation()
        
        setUpTOC()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()
        
        previousButton = UIButton_Typical(frame: CGRectZero)
        previousButton.setTranslatesAutoresizingMaskIntoConstraints(NO)
        previousButton.setTitle("Back", forState: .Normal)
        previousButton.titleLabel!.font = UIFont(name: "MarkerFelt-Thin", size: 36)
        previousButton.addTarget(self, action: "goBackOnePage:", forControlEvents: .TouchUpInside)
        previousButton.userInteractionEnabled = NO
        view.addSubview(previousButton)
        
        nextButton = UIButton_Typical(frame: CGRectZero)
        nextButton.setTranslatesAutoresizingMaskIntoConstraints(NO)
        nextButton.setTitle("Next", forState: .Normal)
        nextButton.titleLabel!.font = UIFont(name: "MarkerFelt-Thin", size: 36)
        nextButton.addTarget(self, action: "goForwardOnePage:", forControlEvents: .TouchUpInside)
        nextButton.userInteractionEnabled = NO
        view.addSubview(nextButton)
        
        saveButton = UIButton_Typical(frame: CGRectZero)
        saveButton.setTranslatesAutoresizingMaskIntoConstraints(NO)
        saveButton.setTitle("Save", forState: .Normal)
        saveButton.titleLabel!.font = UIFont(name: "MarkerFelt-Thin", size: 36)
        saveButton.addTarget(self, action: "saveActivity:", forControlEvents: .TouchUpInside)
        view.addSubview(saveButton)
        
        exitButton = UIButton_Typical(frame: CGRectMake(20, 40, 75, 50))
        exitButton.setTitle("Exit", forState: .Normal)
        exitButton.titleLabel!.font = UIFont(name: "MarkerFelt-Thin", size: 32)
        exitButton.addTarget(self, action: "exitActivity:", forControlEvents: .TouchUpInside)
        view.addSubview(exitButton)
        
        TOCButton = UIButton_Typical(frame: CGRectMake(20, 40, 75, 50))
        TOCButton.setTitle("⊞", forState: .Normal)
        TOCButton.titleLabel!.font = UIFont(name: "MarkerFelt-Thin", size: 38)
        TOCButton.addTarget(self, action: "tableOfContents:", forControlEvents: .TouchUpInside)
        TOCButton.center = CGPointMake(view.frame.size.width - 20 - TOCButton.frame.size.width/2.0, 40 + TOCButton.frame.size.height/2.0)
        view.addSubview(TOCButton)
        
        setUpButtons()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func setUpButtons()
    {
        if currentIndex == currentActivitySession.activityData.count - 1 //Final Page
        {
            view.removeConstraints(previousButtonConstraints)
            view.removeConstraints(nextButtonConstraints)
            view.removeConstraints(saveButtonConstraints)
            
            previousButtonConstraints = Array<NSLayoutConstraint>()
            saveButtonConstraints = Array<NSLayoutConstraint>()
            nextButtonConstraints = Array<NSLayoutConstraint>()
            
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: -4.0))
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.2, constant: 0.0))
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.1, constant: 0.0))
            
            saveButtonConstraints.append(NSLayoutConstraint(item: saveButton, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 4.0))
            saveButtonConstraints.append(NSLayoutConstraint(item: saveButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
            saveButtonConstraints.append(NSLayoutConstraint(item: saveButton, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.2, constant: 0.0))
            saveButtonConstraints.append(NSLayoutConstraint(item: saveButton, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.1, constant: 0.0))
            
            nextButtonConstraints.append(NSLayoutConstraint(item: nextButton, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: -8.0))
            nextButtonConstraints.append(NSLayoutConstraint(item: nextButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
            nextButtonConstraints.append(NSLayoutConstraint(item: nextButton, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.2, constant: 0.0))
            nextButtonConstraints.append(NSLayoutConstraint(item: nextButton, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.1, constant: 0.0))
            
            view.addConstraints(previousButtonConstraints)
            view.addConstraints(saveButtonConstraints)
            view.addConstraints(nextButtonConstraints)
            
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                self.view.layoutIfNeeded()
                
                self.saveButton.alpha = 1.0
                self.saveButton.userInteractionEnabled = YES
                self.previousButton.alpha = 1.0
                self.previousButton.userInteractionEnabled = YES
                self.nextButton.alpha = 0.0
                self.nextButton.userInteractionEnabled = NO
                }, completion: nil)
            
            UIView.transitionWithView(saveButton, duration: 0.5, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                self.saveButton.setTitle("Finish", forState: .Normal)
                }, completion: nil)
        }
        else if currentIndex == -1    //First Page
        {
            view.removeConstraints(previousButtonConstraints)
            view.removeConstraints(nextButtonConstraints)
            view.removeConstraints(saveButtonConstraints)
            
            previousButtonConstraints = Array<NSLayoutConstraint>()
            saveButtonConstraints = Array<NSLayoutConstraint>()
            nextButtonConstraints = Array<NSLayoutConstraint>()
            
            var shouldShowSaveButton = NO
            
            for activityData in newActivityData
            {
                if let object: AnyObject = activityData.values.array[0]
                {
                    if object as String != "<null>"
                    {
                        shouldShowSaveButton = YES
                        break
                    }
                }
            }
            
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 8.0))
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.2, constant: 0.0))
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.1, constant: 0.0))
            
            if (shouldShowSaveButton)
            {
                saveButtonConstraints.append(NSLayoutConstraint(item: saveButton, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: -4.0))
                saveButtonConstraints.append(NSLayoutConstraint(item: saveButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
                saveButtonConstraints.append(NSLayoutConstraint(item: saveButton, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.2, constant: 0.0))
                saveButtonConstraints.append(NSLayoutConstraint(item: saveButton, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.1, constant: 0.0))
                
                nextButtonConstraints.append(NSLayoutConstraint(item: nextButton, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 4.0))
            }
            else
            {
                saveButtonConstraints.append(NSLayoutConstraint(item: saveButton, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
                saveButtonConstraints.append(NSLayoutConstraint(item: saveButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
                saveButtonConstraints.append(NSLayoutConstraint(item: saveButton, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.2, constant: 0.0))
                saveButtonConstraints.append(NSLayoutConstraint(item: saveButton, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.1, constant: 0.0))
                
                nextButtonConstraints.append(NSLayoutConstraint(item: nextButton, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
            }
            nextButtonConstraints.append(NSLayoutConstraint(item: nextButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
            nextButtonConstraints.append(NSLayoutConstraint(item: nextButton, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.2, constant: 0.0))
            nextButtonConstraints.append(NSLayoutConstraint(item: nextButton, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.1, constant: 0.0))
            
            view.addConstraints(previousButtonConstraints)
            view.addConstraints(saveButtonConstraints)
            view.addConstraints(nextButtonConstraints)
            
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                self.view.layoutIfNeeded()
                
                if shouldShowSaveButton == NO
                {
                    self.saveButton.alpha = 0.0
                    self.saveButton.userInteractionEnabled = NO
                }
                else
                {
                    self.saveButton.alpha = 1.0
                    self.saveButton.userInteractionEnabled = YES
                }
                self.nextButton.alpha = 1.0
                self.nextButton.userInteractionEnabled = YES
                self.previousButton.alpha = 0.0
                self.previousButton.userInteractionEnabled = NO
                }, completion: nil)
            
            UIView.transitionWithView(saveButton, duration: 0.5, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                self.saveButton.setTitle("Save", forState: .Normal)
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
            
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 8.0))
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.2, constant: 0.0))
            previousButtonConstraints.append(NSLayoutConstraint(item: previousButton, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.1, constant: 0.0))
            
            saveButtonConstraints.append(NSLayoutConstraint(item: saveButton, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
            saveButtonConstraints.append(NSLayoutConstraint(item: saveButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
            saveButtonConstraints.append(NSLayoutConstraint(item: saveButton, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.2, constant: 0.0))
            saveButtonConstraints.append(NSLayoutConstraint(item: saveButton, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.1, constant: 0.0))
            
            nextButtonConstraints.append(NSLayoutConstraint(item: nextButton, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: -8.0))
            nextButtonConstraints.append(NSLayoutConstraint(item: nextButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
            nextButtonConstraints.append(NSLayoutConstraint(item: nextButton, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.2, constant: 0.0))
            nextButtonConstraints.append(NSLayoutConstraint(item: nextButton, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.1, constant: 0.0))
            
            view.addConstraints(previousButtonConstraints)
            view.addConstraints(saveButtonConstraints)
            view.addConstraints(nextButtonConstraints)
            
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                self.view.layoutIfNeeded()
                
                self.saveButton.alpha = 1.0
                self.saveButton.userInteractionEnabled = YES
                self.nextButton.alpha = 1.0
                self.nextButton.userInteractionEnabled = YES
                self.previousButton.alpha = 1.0
                self.previousButton.userInteractionEnabled = YES
                }, completion: nil)
            
            UIView.transitionWithView(saveButton, duration: 0.5, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                self.saveButton.setTitle("Save", forState: .Normal)
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
    
    func exitActivity(button: UIButton_Typical)
    {
        var dismissAlert = UIAlertController(title: "Are you sure?", message: "Do you want to leave the activity?\n\nAny work you have done will NOT be saved!", preferredStyle: .Alert)
        
        dismissAlert.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(YES, completion: nil)
        }))
        
        dismissAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        
        presentViewController(dismissAlert, animated: YES, completion: nil)
    }
    
    //MARK: - Table Of Contents
    
    private func setUpTOC()
    {
        let introVC = Page_IntroVC(nibName: "Page_IntroVC", bundle: nil)
        introVC.activityTitle = currentActivity.name
        introVC.summary = currentActivity.activityDescription
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0)
        introVC.view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: YES)
        let copied = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tableOfContentsImages.append(copied)
        
        for index in 0...(currentActivitySession.activityData.count - 1)
        {
            //Get the new activity's type
            let currentActivityPage = currentActivitySession.activityData[index]
            let currentActivityType = currentActivityPage.keys.array[0]
            
            //Initialize the new activity
            let viewControllerToRender = viewControllerForPageType(ActivityViewControllerType(rawValue: currentActivityType.integerValue)!)!
            
            if newActivityData.count > index
            {
                let object : AnyObject = newActivityData[index].values.array[0]!
                
                if object as String != "<null>"
                {
                    viewControllerToRender.restoreActivityState(newActivityData[index].values.array[0])
                }
                else
                {
                    viewControllerToRender.restoreActivityState(currentActivityPage.values.array[0])
                }
            }
            else    //There isn't any saved session data for this activity, so load the old session data
            {
                viewControllerToRender.restoreActivityState(currentActivityPage.values.array[0])
            }
            
            viewControllerToRender.view.layoutIfNeeded()
            
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0)
            viewControllerToRender.view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: YES)
            let copied = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            tableOfContentsImages.append(copied)
        }
    }
    
    func tableOfContents(button: UIButton_Typical)
    {
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: NO)
        setNeedsStatusBarAppearanceUpdate()
        
        //Update live image
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0)
        currentViewController.view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: YES)
        let copied = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        tableOfContentsImages[currentIndex + 1] = copied
        
        let numberOfScreensPerRow = 4.0
        let aspectRatio = 1024.0/768.0
        let bufferY = 47.0
        let bufferX = 47.0
        
        var posX = CGFloat(bufferY)
        var posY = CGFloat(bufferX)
        
        tableOfContentsView = UIScrollView(frame: view.bounds)
        tableOfContentsView.alpha = 0.0
        tableOfContentsView.backgroundColor = .clearColor()
        tableOfContentsView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        tableOfContentsView.alwaysBounceHorizontal = NO
        tableOfContentsView.userInteractionEnabled = NO
        
        let twoFingerDismiss = UIPanGestureRecognizer(target: self, action: "handlePan:")
        twoFingerDismiss.minimumNumberOfTouches = 2
        twoFingerDismiss.maximumNumberOfTouches = 2
        tableOfContentsView.addGestureRecognizer(twoFingerDismiss)
        
        view.addSubview(tableOfContentsView)
        
        let width = CGFloat((Double(view.bounds.width) - Double(Double(bufferX * numberOfScreensPerRow) + 2.0))/numberOfScreensPerRow)
        
        for index in 0...tableOfContentsImages.count - 1
        {
            let imageView = CESCometUIImageView(frame: CGRectMake(posX, posY, width, CGFloat(Double(width)/aspectRatio)))
            imageView.setImage(tableOfContentsImages[index])
            imageView.layer.cornerRadius = 10.0
            
            if index > 0 && index != currentIndex + 1 && index != lastVisibleIndex + 1 && currentActivity.quizMode == YES
            {
                imageView.enableQuizMode()
            }
            
            imageView.setTarget(self, forAction: "tableOfContentsOptionWasSelected:")
            
            tableOfContentsView.addSubview(imageView)
            
            if (index + 1) % 5 == 0
            {
                posY += CGFloat(bufferY)
                posY += imageView.frame.size.height
                
                posX = CGFloat(bufferX)
            }
            else
            {
                posX += CGFloat(bufferX)
                posX += width
            }
            tableOfContentsView.contentSize = CGSizeMake(0, posY)
            
            tableOfContentsImageViews.append(imageView)
            
            let titleLabel = UILabel()
            titleLabel.textColor = primaryColor
            titleLabel.font = UIFont(name: "MarkerFelt-Thin", size: 22)
            if index == 0
            {
                 titleLabel.text = "Introduction"
            }
            else
            {
                titleLabel.text = "Problem \(index)"
            }
            titleLabel.sizeToFit()
            titleLabel.center = CGPointMake(imageView.center.x, imageView.frame.origin.y - (CGFloat(bufferY) - titleLabel.frame.size.height)/3.0 - titleLabel.frame.size.height/2.0)
            Definitions.outlineTextInLabel(titleLabel)
            tableOfContentsView.addSubview(titleLabel)
        }
        
        tableOfContentsView.scrollRectToVisible(self.tableOfContentsImageViews[self.currentIndex + 1].frame, animated: NO)
        
        tableOfContentsView.bringSubviewToFront(self.tableOfContentsImageViews[self.currentIndex + 1])
        
        selectedImageView = tableOfContentsImageViews[currentIndex + 1]
        
        let oldFrame = tableOfContentsImageViews[currentIndex + 1].frame
        
        tableOfContentsImageViews[currentIndex + 1].layer.cornerRadius = 0.001
        tableOfContentsImageViews[currentIndex + 1].frame = CGRectMake(view.bounds.origin.x, view.bounds.origin.y - tableOfContentsView.contentInset.top, view.bounds.size.width, view.bounds.size.height)
        
        NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "reEnableTOCSelection", userInfo: nil, repeats: NO)
        
        UIView.animateWithDuration(0.0, animations: { () -> Void in
            self.tableOfContentsImageViews[self.currentIndex + 1].layoutIfNeeded()
            }, completion: { (finished) -> Void in
                
                UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.2, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                    
                    self.tableOfContentsView.alpha = 1.0
                    
                    }, completion: { (finished) -> Void in
                        
                        let animation = CABasicAnimation(keyPath: "cornerRadius")
                        animation.fromValue = NSNumber(double: 0.001)
                        animation.toValue = NSNumber(double: 10.0)
                        animation.duration = 0.5
                        self.tableOfContentsImageViews[self.currentIndex + 1].layer.addAnimation(animation, forKey: "cornerRadius")
                        self.tableOfContentsImageViews[self.currentIndex + 1].layer.cornerRadius = 10.0
                        
                        self.currentViewController.view.alpha = 0.0
                        self.tableOfContentsView.backgroundColor = .blackColor()
                        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.2, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                            
                            self.tableOfContentsImageViews[self.currentIndex + 1].frame = oldFrame
                            self.tableOfContentsImageViews[self.currentIndex + 1].layoutIfNeeded()
                            
                            }, completion: nil)
                })
        })
    }
    
    func reEnableTOCSelection()
    {
        tableOfContentsView.userInteractionEnabled = YES
    }
    
    func tableOfContentsOptionWasSelected(timer: NSTimer)
    {
        selectedImageView = timer.userInfo!["ImageView"] as CESCometUIImageView
        
        let oldIndex = currentIndex
        
        currentIndex = (tableOfContentsImageViews as NSArray).indexOfObject(selectedImageView) - 1
        
        if oldIndex == -1
        {
            direction = "Forward"
        }
        else if oldIndex == currentIndex
        {
            direction = "Same"
        }
        else
        {
            direction = "Jump"
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideTableOfContents", name: PageManagerShouldContinuePresentation, object: nil)
        
        presentNextViewController(NO)
    }
    
    func hideTableOfContents()
    {
        tableOfContentsView.userInteractionEnabled = NO
        
        tableOfContentsView.bringSubviewToFront(selectedImageView)
        tableOfContentsView.removeGestureRecognizer(tableOfContentsView.gestureRecognizers![0] as UIGestureRecognizer)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        //Setup the new View behind the table of contents
        oldViewController?.removeFromParentViewController()
        oldViewController?.view.removeFromSuperview()
        view.removeConstraints(oldViewControllerConstraints)
        
        currentViewControllerConstraints = Array<NSLayoutConstraint>()
        
        currentViewController.willMoveToParentViewController(self)
        currentViewController.view.setTranslatesAutoresizingMaskIntoConstraints(NO)
        view.addSubview(currentViewController.view)
        view.sendSubviewToBack(currentViewController.view)
        
        currentViewControllerConstraints.append(NSLayoutConstraint(item: currentViewController.view, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0))
        currentViewControllerConstraints.append(NSLayoutConstraint(item: currentViewController.view, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        currentViewControllerConstraints.append(NSLayoutConstraint(item: currentViewController.view, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        currentViewControllerConstraints.append(NSLayoutConstraint(item: currentViewController.view, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        
        view.addConstraints(currentViewControllerConstraints)
        
        currentViewController.didMoveToParentViewController(self)
        
        //Animate out the table of contents
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.fromValue = NSNumber(double: 10.0)
        animation.toValue = NSNumber(double: 0.001)
        animation.duration = 0.5
        self.tableOfContentsImageViews[self.currentIndex + 1].layer.addAnimation(animation, forKey: "cornerRadius")
        self.tableOfContentsImageViews[self.currentIndex + 1].layer.cornerRadius = 0.001
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.2, options: .AllowAnimatedContent | .AllowUserInteraction | .BeginFromCurrentState, animations: { () -> Void in
            
            self.selectedImageView.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y - self.tableOfContentsView.contentInset.top, self.view.bounds.size.width, self.view.bounds.size.height)
            self.selectedImageView.layoutIfNeeded()
            
            self.setUpButtons()
            
            }, completion: { (finished) -> Void in
                
                UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.2, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                    
                    self.tableOfContentsView.alpha = 0.0
                    
                    }, completion: { (finished) -> Void in
                        
                        self.tableOfContentsView.removeFromSuperview()
                        self.tableOfContentsImageViews = Array<CESCometUIImageView>()
                })
        })
    }
    
    func handlePan(panGesture: UIPanGestureRecognizer)
    {
        switch panGesture.state
        {
        case .Changed:
            if panGesture.translationInView(tableOfContentsView).y > 100
            {
                panGesture.enabled = NO
                NSTimer.scheduledTimerWithTimeInterval(0.0, target: self, selector: "tableOfContentsOptionWasSelected:", userInfo: ["ImageView":selectedImageView], repeats: NO)
            }
            break
            
        default:
            break
        }
    }
    
    //MARK: - Page Movement
    
    func goBackOnePage(button: UIButton_Typical)
    {
        button.userInteractionEnabled = NO
        currentIndex--
        direction = "Backward"
        
        self.presentNextViewController(YES)
    }
    
    func goForwardOnePage(button: UIButton_Typical)
    {
        button.userInteractionEnabled = NO
        currentIndex = currentIndex + 1
        direction = "Forward"
        
        self.presentNextViewController(YES)
    }
    
    func saveActivity(button: UIButton_Typical)
    {
        view.userInteractionEnabled = NO
        
        let savedObject: AnyObject? = currentViewController.saveActivityState()
        
        let currentActivityPage = currentActivitySession.activityData[currentIndex]
        let currentActivityType = currentActivityPage.keys.array[0]
        
        if newActivityData.count <= currentIndex
        {
            newActivityData.append(Dictionary<NSNumber, AnyObject?>())
        }
        
        if savedObject == nil
        {
            newActivityData[currentIndex].updateValue("<null>", forKey: currentActivityType)
        }
        else //If the activity actually returned a saved object, save it
        {
            newActivityData[currentIndex].updateValue(savedObject!, forKey: currentActivityType)
        }
        
        //CHECKS FOR CURRENT ACTIVITY
        
        let currentActivitySessionCopy = currentActivitySession.copy() as ActivitySession
        
        //Update the currentActivity values with the newActivityData values
        for index in 0...(newActivityData.count - 1)
        {
            currentActivitySessionCopy.activityData[index].updateValue(newActivityData[index].values.array[0]!, forKey: currentActivitySessionCopy.activityData[index].keys.array[0])
        }
        
        if button.titleLabel!.text == "Finish"  //We are actually finishing
        {
            currentActivitySessionCopy.endDate = NSDate()
            
            if currentActivitySessionCopy.endDate!.compare(currentActivity.dueDate) == .OrderedDescending
            {
                currentActivitySessionCopy.status = "Past Due"
            }
            else
            {
                currentActivitySessionCopy.status = "Finished"
            }
        }
        else
        {
            currentActivitySessionCopy.status = "Started"
        }
        
        let wheel = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        wheel.center = saveButton.center
        wheel.startAnimating()
        wheel.alpha = 0.0
        wheel.transform = CGAffineTransformMakeScale(1.3, 1.3)
        view.addSubview(wheel)
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .AllowUserInteraction | .AllowAnimatedContent, animations: { () -> Void in
            
            wheel.alpha = 1.0
            wheel.transform = CGAffineTransformIdentity
            
            self.nextButton.alpha = 0.0
            self.previousButton.alpha = 0.0
            self.saveButton.alpha = 0.0
            self.saveButton.transform = CGAffineTransformMakeScale(0.7, 0.7)
            
            }, completion: { (finished) -> Void in
                self.databaseManager.uploadActivitySession(currentActivitySessionCopy, completion: { (uploadSuccess) -> Void in
                    if uploadSuccess == YES
                    {
                        self.dismissViewControllerAnimated(YES, completion: nil)
                    }
                    else
                    {
                        self.setUpButtons()
                        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .AllowUserInteraction | .AllowAnimatedContent, animations: { () -> Void in
                            
                            wheel.alpha = 0.0
                            wheel.transform = CGAffineTransformMakeScale(1.3, 1.3)
                            
                            self.saveButton.transform = CGAffineTransformIdentity
                            
                            }, completion: { (finished) -> Void in
                                
                                self.view.userInteractionEnabled = YES
                                
                                let errorAlert = UIAlertController(title: "We're Sorry", message: "There's been an issue saving this activity\n\nPlease contact your teacher for assistance and try again.", preferredStyle: .Alert)
                                errorAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                                self.presentViewController(errorAlert, animated: YES, completion: nil)
                        })
                    }
                })
        })
    }
    
    private func presentNextViewController(shouldAddListener: Bool)
    {
        if shouldAddListener == YES
        {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "continueWithPresentation", name: PageManagerShouldContinuePresentation, object: nil)
        }
        
        if (direction as NSString).isEqualToString("Same")
        {
            currentViewController.view.alpha = 1.0
            NSNotificationCenter.defaultCenter().postNotificationName(PageManagerShouldContinuePresentation, object: nil)
            return
        }
        
        //Move the viewController on screen to the oldViewController object
        oldViewController = currentViewController
        oldViewControllerConstraints = currentViewControllerConstraints
        
        let index = currentIndex
        let direc = direction
        
        if index != -1
        {
            let comingFromIntro = index == NSInteger(0) && ((direc as NSString).isEqualToString("Forward") || (direc as NSString).isEqualToString("Same"))
            
            if comingFromIntro == NO
            {
                //If we actually have an oldActivity
                if let oldVC = oldViewController
                {
                    //Get the oldActivity's type
                    let oldActivityPage = currentActivitySession.activityData[currentIndex - 1]
                    let oldActivityType = oldActivityPage.keys.array[0]
                    
                    //Get the savedObject for the activity
                    let savedObject: AnyObject? = oldVC.saveActivityState()
                    
                    //If the activity didn't return a saved object, save a null value
                    if savedObject == nil
                    {
                        newActivityData[currentIndex - 1].updateValue("<null>", forKey: oldActivityType)
                    }
                    else //If the activity actually returned a saved object, save it
                    {
                        newActivityData[currentIndex - 1].updateValue(savedObject!, forKey: oldActivityType)
                    }
                }
            }
            
            //Get the new activity's type
            let currentActivityPage = currentActivitySession.activityData[currentIndex]
            let currentActivityType = currentActivityPage.keys.array[0]
            
            //Initialize the new activity
            currentViewController = viewControllerForPageType(ActivityViewControllerType(rawValue: currentActivityType.integerValue)!)
            
            let status = currentActivitySession.status
            if currentViewController.isViewLoaded() == YES
            {
                currentViewController.view.userInteractionEnabled = (status == "Started" || status == "Not Started")
            }
            
            //Check if we have already saved data in the activity (i.e. the user is going backwards)
            if newActivityData.count > currentIndex
            {
                let object : AnyObject = newActivityData[currentIndex].values.array[0]!
                
                if object as String != "<null>"
                {
                    currentViewController.restoreActivityState(newActivityData[currentIndex].values.array[0])
                }
                else
                {
                    currentViewController.restoreActivityState(currentActivityPage.values.array[0])
                }
            }
            else    //There isn't any saved session data for this activity, so load the old session data
            {
                currentViewController.restoreActivityState(currentActivityPage.values.array[0])
            }
        }
        else
        {
            let introVC = Page_IntroVC(nibName: "Page_IntroVC", bundle: nil)
            introVC.activityTitle = currentActivity.name
            introVC.summary = currentActivity.activityDescription
            
            currentViewController = introVC
            
            if shouldAddListener == YES
            {
                continueWithPresentation()
            }
            else
            {
                hideTableOfContents()
            }
        }
    }
    
    func continueWithPresentation()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        if isPresented == NO
        {
            if currentViewController != nil
            {
                currentViewController.willMoveToParentViewController(self)
                currentViewController.view.setTranslatesAutoresizingMaskIntoConstraints(NO)
                view.addSubview(currentViewController.view)
                view.sendSubviewToBack(currentViewController.view)
                
                currentViewControllerConstraints.append(NSLayoutConstraint(item: currentViewController.view, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0))
                currentViewControllerConstraints.append(NSLayoutConstraint(item: currentViewController.view, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
                currentViewControllerConstraints.append(NSLayoutConstraint(item: currentViewController.view, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
                currentViewControllerConstraints.append(NSLayoutConstraint(item: currentViewController.view, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 0.0))
                
                view.addConstraints(currentViewControllerConstraints)
                
                currentViewController.didMoveToParentViewController(self)
            }
            self.modalPresentationStyle = .Custom
            if subjectParent.classForCoder !== TestingTVC.classForCoder()
            {
                self.transitioningDelegate = (subjectParent as SubjectVC)
            }
            subjectParent.presentViewController(self, animated: YES, completion: nil)
        }
        else
        {
            setUpButtons()
            if currentViewController != nil
            {
                currentViewController.willMoveToParentViewController(self)
                currentViewController.view.setTranslatesAutoresizingMaskIntoConstraints(NO)
                view.insertSubview(currentViewController.view, aboveSubview: oldViewController!.view)
                view.sendSubviewToBack(currentViewController.view)
                
                currentViewControllerConstraints = Array<NSLayoutConstraint>()
                
                currentViewControllerConstraints.append(NSLayoutConstraint(item: currentViewController.view, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0))
                currentViewControllerConstraints.append(NSLayoutConstraint(item: currentViewController.view, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
                currentViewControllerConstraints.append(NSLayoutConstraint(item: currentViewController.view, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
                currentViewControllerConstraints.append(NSLayoutConstraint(item: currentViewController.view, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 0.0))
                
                view.addConstraints(currentViewControllerConstraints)
                
                currentViewController.didMoveToParentViewController(self)
                
                switch direction
                {
                case "Forward":
                    currentViewController.view.transform = CGAffineTransformMakeTranslation(view.frame.size.width, 0.0)
                    break
                    
                case "Backward":
                    currentViewController.view.transform = CGAffineTransformMakeTranslation(-view.frame.size.width, 0.0)
                    break
                    
                default:
                    currentViewController.view.transform = CGAffineTransformMakeTranslation(view.frame.size.width, 0.0)
                    break
                }
                
                lastVisibleIndex = currentIndex
                
                UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                    
                    self.currentViewController.view.transform = CGAffineTransformIdentity
                    
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
                        
                        if self.nextButton.alpha == 1.0
                        {
                            self.nextButton.userInteractionEnabled = YES
                        }
                        if self.previousButton.alpha == 1.0
                        {
                            self.previousButton.userInteractionEnabled = YES
                        }
                        if self.saveButton.alpha == 1.0
                        {
                            self.saveButton.userInteractionEnabled = YES
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
@availability(*, unavailable, renamed="PageManager")
typealias NewPageManager = PageManager
