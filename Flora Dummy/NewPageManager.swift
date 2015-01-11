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
    
    private var backButton : UIButton_Typical?
    var backButtonFrame : CGRect?
        {
        get
        {
            return backButton?.frame
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
    
    private var currentViewController : PageVC?
    
    //MARK: - Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

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
}
