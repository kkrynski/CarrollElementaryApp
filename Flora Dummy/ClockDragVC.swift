//
//  ClockDragVC.swift
//  FloraDummy
//
//  Created by Michael Schloss on 11/22/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class ClockDragVC: PageVC
{
    /**
    The time to initially show on the clock.
    
    By default, or if no value provided, this is 00:00:00
    
    :param: HH:MM:SS The time format
    */
    var startTime : String?
    
    /**
    The time to be set on the clock by the user.
    
    This cannot be NULL.  If a value is not provided, self will dismiss.
    
    :param: HH:MM:SS The time format
    */
    var endTime : String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        if endTime == nil
        {
            let errorAlert = UIAlertController(title: "We're Sorry", message: "There was no end time specified.\n\nClock will now dismiss.", preferredStyle: .Alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (alertAction) -> Void in
                self.dismissViewControllerAnimated(YES, completion: nil)
            }))
            presentViewController(errorAlert, animated: YES, completion: nil)
        }
    }
    
}
