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
    private var databaseManager = CESDatabase.databaseManagerForPageManagerClass()
    
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
    
    private var saveButton : UIButton_Typical?
    var saveButtonFrame : CGRect?
        {
        get
        {
            return saveButton?.frame
        }
    }
    
    private var previousButtonConstraints = Array<NSLayoutConstraint>()
    private var saveButtonConstraints = Array<NSLayoutConstraint>()
    private var nextButtonConstraints = Array<NSLayoutConstraint>()
    
    private var _currentIndex = 0
    var currentIndex : Int
        {
        get
        {
            return _currentIndex
        }
    }
    
    var activityID: String?
    var currentActivity : Activity?
    
    private var currentViewController : FormattedVC?
    
    private var isPresented = NO
    
    var subjectParent : SubjectVC?
    
    //MARK: - Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "continueWithPresentation", name: PageManagerShouldContinuePresentation, object: nil)

        //Perform some quick checks to make sure we have a valid activity
        if currentActivity != nil && activityID != nil
        {
            if currentActivity!.pageArray.count == 0
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
        
        let activityInfo = databaseManager.activityInformationForActivityID(activityID!)
        
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
        
        presentNextViewController()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didMoveToParentViewController(parent: UIViewController?)
    {
        super.didMoveToParentViewController(parent)
        
        isPresented = parent != nil
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
    }
    
    func presentNextViewController()
    {
        //currentViewController = viewControllerForPageType("ActivityData", andInformation: nil)
    }
    
    func continueWithPresentation()
    {
        if isPresented == NO
        {
            self.modalPresentationStyle = .Custom
            self.transitioningDelegate = subjectParent
            subjectParent?.presentViewController(self, animated: YES, completion: nil)
        }
        else
        {
            
        }
    }
    
    private func viewControllerForPageType(pageType: String, andInformation pageInformation: NSDictionary)/* -> UIViewController*/
    {
        
    }
}
