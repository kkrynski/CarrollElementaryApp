//
//  ClockDragVC.swift
//  FloraDummy
//
//  Created by Michael Schloss on 11/22/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit
import QuartzCore

class ClockDragVC: PageVC
{
    /**
    The time to initially show on the clock.
    
    By default, or if no value provided, this is 00:00:00
    
    :param: HH:MM:SS The time format
    */
    var startTime = "00:00:00"
    
    /**
    The time to be set on the clock by the user.
    
    This cannot be NULL.  If a value is not provided, self will dismiss.
    
    :param: HH:MM:SS The time format
    */
    var endTime : String?
    
    /**
    The buffer zone for how incorrect each hand can be.

    By default, or if no value provided, this is 00:02:02
    
    :param: HH:MM:SS The time format
    */
    var bufferZone = "00:02:02"
    
    //The clock itself
    private var clock : Clock?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        createAndDisplayClockForStartTime()
    }
    
    //If we have no end time, we need to dismiss because there's nothing to do.
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
        else
        {
            clock!.rotateHandsToTime(startTime)
        }
    }
    
    //MARK: - Create Clock Methods
    
    private func createAndDisplayClockForStartTime()
    {
        clock = Clock(frame: CGRectMake(0, 0, 400, 400), andBorderWidth: 8.0, showSecondsHand: YES)
        clock!.handsMoveIndependently = NO
        clock!.backgroundColor = .whiteColor()
        clock!.layer.cornerRadius = clock!.frame.size.width/2.0
        clock!.layer.borderColor = UIColor.blackColor().CGColor
        clock!.center = CGPointMake(view.frame.size.width/2.0, view.frame.size.height/2.0)
        view.addSubview(clock!)
    }
    
}
