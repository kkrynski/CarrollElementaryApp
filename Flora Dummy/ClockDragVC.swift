//
//  ClockDragVC.swift
//  FloraDummy
//
//  Created by Michael Schloss on 11/22/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit
import QuartzCore

class ClockDragVC: PageVC, ClockDelegate
{
    /**
    The time to initially show on the clock.
    
    By default, this is 00:00:00
    
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

    By default, this is 00:02:02
    
    :param: HH:MM:SS The time format
    */
    var bufferZone = "00:02:02"
    
    /**
    Determines whether the hands will move independently of each other
    
    By default, this is set to 'YES'
    
    :param: YES(true) Hands will move in relation to an actual clock.  Moving one hand will move the others based on standard time
    :param: NO(false) Hands will not move in relation to an actual clock.  Moving one hand will move only that hand
    */
    var handsMoveDependently = YES
    
    /**
    Determines whether the Seconds Hand will be displayed on screen
    
    By default, this is set to 'YES'
    
    :param: YES(true) The Seconds Hand will be shown
    :param: NO(false) The Seconds Hand will not be shown
    */
    var showSecondsHand = YES
    
    //The clock itself
    private var clock : Clock?
    
    //The current time label
    private var currentTimeLabel : UILabel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        createAndDisplayClockForStartTime()
        
        let instructions = UILabel()
        instructions.font = UIFont(name: "Marker Felt", size: 32)
        instructions.text = "Please set the time on the clock to:\n\(endTime!)"
        instructions.textColor = primaryColor
        instructions.textAlignment = .Center
        instructions.numberOfLines = 0
        instructions.sizeToFit()
        instructions.center = CGPointMake(clock!.center.x, clock!.frame.origin.y - 8 - instructions.frame.size.height/2.0)
        Definitions.outlineTextInLabel(instructions)
        view.addSubview(instructions)
        
        currentTimeLabel = UILabel()
        currentTimeLabel!.font = UIFont(name: "Marker Felt", size: 32)
        currentTimeLabel!.text = "Current time set:\n\(startTime)"
        currentTimeLabel!.textColor = primaryColor
        currentTimeLabel!.textAlignment = .Center
        currentTimeLabel!.numberOfLines = 0
        currentTimeLabel!.sizeToFit()
        currentTimeLabel!.center = CGPointMake(clock!.center.x, clock!.frame.origin.y + clock!.frame.size.height + 8 + currentTimeLabel!.frame.size.height/2.0)
        Definitions.outlineTextInLabel(currentTimeLabel!)
        view.addSubview(currentTimeLabel!)
        
        let checkAnswerTap = UITapGestureRecognizer(target: self, action: "checkAnswer")
        clock!.addGestureRecognizer(checkAnswerTap)
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
        clock = Clock(frame: CGRectMake(0, 0, 400, 400), andBorderWidth: 8.0, showSecondsHand: showSecondsHand)
        clock!.handsMoveDependently = handsMoveDependently
        clock!.delegate = self
        clock!.center = CGPointMake(view.frame.size.width/2.0, view.frame.size.height/2.0)
        view.addSubview(clock!)
    }
    
    //MARK: - UI Update Methods
    
    //Checks the answer and displays the response
    func checkAnswer()
    {
        clock!.userInteractionEnabled = NO
        
        let currentTimeComponents = clock!.currentTime.componentsSeparatedByString(":")
        
        let currentHours = (currentTimeComponents[0] as NSString).integerValue
        let currentMinutes = (currentTimeComponents[1] as NSString).integerValue
        let currentSeconds = (currentTimeComponents[2] as NSString).integerValue
        
        
        let endTimeComponents = endTime!.componentsSeparatedByString(":")
        
        let endHours = (endTimeComponents[0] as NSString).integerValue
        let endMinutes = (endTimeComponents[1] as NSString).integerValue
        let endSeconds = (endTimeComponents[2] as NSString).integerValue
        
        
        let bufferTimeComponents = bufferZone.componentsSeparatedByString(":")
        
        let bufferHours = (bufferTimeComponents[0] as NSString).integerValue
        let bufferMinutes = (bufferTimeComponents[1] as NSString).integerValue
        let bufferSeconds = (bufferTimeComponents[2] as NSString).integerValue
        
        let dimView = UIView(frame: clock!.frame)
        dimView.clipsToBounds = YES
        dimView.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        dimView.layer.cornerRadius = dimView.frame.size.width/2.0
        dimView.alpha = 0.0
        view.addSubview(dimView)
        
        switch  (endHours >= currentHours - bufferHours && endHours <= currentHours + bufferHours) &&
                (endMinutes >= currentMinutes - bufferMinutes && endMinutes <= currentMinutes + bufferMinutes) &&
                (endSeconds >= currentSeconds - bufferSeconds && endSeconds <= currentSeconds + bufferSeconds)
        {
        case YES:
            let correctLabel = UILabel()
            correctLabel.alpha = 0.0
            correctLabel.text = "Correct!"
            correctLabel.textColor = primaryColor
            correctLabel.font = UIFont(name: "Marker Felt", size: 72)
            correctLabel.sizeToFit()
            Definitions.outlineTextInLabel(correctLabel)
            correctLabel.center = CGPointMake(dimView.frame.size.width/2.0, dimView.frame.size.height/2.0)
            dimView.addSubview(correctLabel)
            correctLabel.transform = CGAffineTransformMakeScale(0.3, 0.3)
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                
                dimView.alpha = 1.0
                
            }, completion: { (finished) -> Void in
                
                UIView.animateWithDuration(0.3, delay: 0.0, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                    
                    correctLabel.alpha = 1.0
                    
                    }, completion: nil)
                UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                    
                    correctLabel.transform = CGAffineTransformIdentity
                    
                }, completion: nil)
                
            })
            break
            
        case NO:
            let incorrectLabel = UILabel()
            incorrectLabel.alpha = 0.0
            incorrectLabel.text = "Incorrect!\nPlease try again!"
            incorrectLabel.numberOfLines = 0
            incorrectLabel.textAlignment = .Center
            incorrectLabel.textColor = primaryColor
            incorrectLabel.font = UIFont(name: "Marker Felt", size: 42)
            incorrectLabel.sizeToFit()
            Definitions.outlineTextInLabel(incorrectLabel)
            incorrectLabel.center = CGPointMake(dimView.frame.size.width/2.0, dimView.frame.size.height/2.0)
            dimView.addSubview(incorrectLabel)
            incorrectLabel.transform = CGAffineTransformMakeScale(0.3, 0.3)
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                
                dimView.alpha = 1.0
                
                }, completion: { (finished) -> Void in
                    
                    UIView.animateWithDuration(0.3, delay: 0.0, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                        
                        incorrectLabel.alpha = 1.0
                        
                        }, completion: nil)
                    UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                        
                        incorrectLabel.transform = CGAffineTransformIdentity
                        
                        }, completion: { (finished) -> Void in
                            
                            UIView.animateWithDuration(0.3, delay: 1.0, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                                
                                dimView.alpha = 0.0
                                incorrectLabel.transform = CGAffineTransformMakeScale(2.0, 2.0)
                                
                                }, completion: { (finished) -> Void in
                                    
                                    dimView.removeFromSuperview()
                                    self.clock!.userInteractionEnabled = YES
                            })
                    })
            })
            break
            
        default:
            break
        }
    }
    
    //Updates the current time label on screen
    func updateCurrentTimeLabel()
    {
        currentTimeLabel!.text = "Current time set:\n\(clock!.currentTime)"
    }
    
}
