//
//  ClockBackground.swift
//  FloraDummy
//
//  Created by Michael Schloss on 11/22/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class Clock: UIView
{
    //MARK: - Variables
    
    /**The hours hand*/
    var hoursHand : UIView?
    
    /**The minutes hand*/
    var minutesHand : UIView?
    private var minutesTick : UIView?
    
    /**The seconds hand*/
    var secondsHand : UIView?
    
    /**
    Determines whether the hands will move independently of each other
    
    :param: YES Hands will not move in relation to an actual clock.  Moving one hand will move only that hand
    :param: NO Hands will move in relation to an actual clock.  Moving one hand will move the others based on standard time
    */
    var handsMoveIndependently : Bool?
    
    private var showSecondsHand : Bool?
    
    private var startTime : String?
    private var currentTime : String?
    
    //MARK: - init Methods
    
    init(frame: CGRect, andBorderWidth borderWidth : CGFloat, showSecondsHand : Bool)
    {
        super.init(frame: frame)
        layer.borderWidth = borderWidth
        self.showSecondsHand = showSecondsHand
        
        insertHourTicks()
        insertMinuteTicks()
        
        let centerPoint = UIView(frame: CGRectMake(0, 0, 30, 30))
        centerPoint.backgroundColor = .blackColor()
        centerPoint.layer.cornerRadius = centerPoint.frame.size.width/2.0
        centerPoint.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0)
        addSubview(centerPoint)
        
        makeHands()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Build Methods
    
    //Inserts the red hour marks
    private func insertHourTicks()
    {
        let eachHour = (M_PI * 2.0)/12.0
        
        for hour in 1...12
        {
            let hourView = UIView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
            hourView.backgroundColor = .clearColor()
            
            let hourTick = UIView(frame: CGRectMake(0, 0, layer.borderWidth / 1.5, layer.borderWidth * 3.0))
            hourTick.backgroundColor = UIColor(red: 0.9, green: 0.0, blue: 0.0, alpha: 1.0)
            hourTick.center = CGPointMake(hourView.frame.size.width/2.0, hourTick.frame.size.height/2.0 + layer.borderWidth/2.0)
            hourView.addSubview(hourTick)
            
            hourView.transform = CGAffineTransformMakeRotation(CGFloat(eachHour * Double(hour)))
            
            hourView.layer.rasterizationScale = UIScreen.mainScreen().scale
            hourView.layer.shouldRasterize = YES
            
            addSubview(hourView)
        }
    }
    
    //Inserts the black minute marks
    private func insertMinuteTicks()
    {
        let eachMinute = (M_PI * 2.0)/60.0
        
        for minute in 1...60
        {
            if minute % 5 != 0
            {
                let minuteView = UIView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
                minuteView.backgroundColor = .clearColor()
                
                let minuteTick = UIView(frame: CGRectMake(0, 0, layer.borderWidth / 2.0, layer.borderWidth * 2.5))
                minuteTick.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                minuteTick.center = CGPointMake(minuteView.frame.size.width/2.0, minuteTick.frame.size.height/2.0 + layer.borderWidth/2.0)
                minuteView.addSubview(minuteTick)
                
                minuteView.transform = CGAffineTransformMakeRotation(CGFloat(eachMinute * Double(minute)))
                
                minuteView.layer.rasterizationScale = UIScreen.mainScreen().scale
                minuteView.layer.shouldRasterize = YES
                
                addSubview(minuteView)
            }
        }
    }
    
    //Makes the hands
    private func makeHands()
    {
        //Hours Hand
        hoursHand = UIView(frame: CGRectMake(0, 0, 14, frame.size.width))
        hoursHand!.backgroundColor = .clearColor()
        hoursHand!.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0)
        
        let hoursTick = UIView(frame: CGRectMake(0, 0, hoursHand!.frame.size.width, frame.size.width/4.0))
        hoursTick.backgroundColor = .blackColor()
        hoursTick.layer.cornerRadius = 7
        hoursTick.center = CGPointMake(hoursHand!.frame.size.width/2.0, hoursHand!.frame.size.height/2.0 - hoursTick.frame.size.height/2.0)
        hoursHand!.addSubview(hoursTick)
        addSubview(hoursHand!)
        
        let hoursPan = UIPanGestureRecognizer(target: self, action: "handleHoursPan:")
        hoursTick.addGestureRecognizer(hoursPan)
        
        //Minutes Hand
        
        minutesHand = UIView(frame: CGRectMake(0, 0, 10, frame.size.width))
        minutesHand!.backgroundColor = .clearColor()
        minutesHand!.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0)
        
        minutesTick = UIView(frame: CGRectMake(0, 0, minutesHand!.frame.size.width, frame.size.width/2.0 - (layer.borderWidth * 4.0) - 4))
        minutesTick!.backgroundColor = Definitions.lighterColorForColor(Definitions.lighterColorForColor(.blackColor()))
        minutesTick!.layer.cornerRadius = 5
        minutesTick!.center = CGPointMake(minutesHand!.frame.size.width/2.0, minutesHand!.frame.size.height/2.0 - minutesTick!.frame.size.height/2.0)
        minutesHand!.addSubview(minutesTick!)
        
        let minutesBulb = UIView(frame: CGRectMake(0, 0, 20, 20))
        minutesBulb.backgroundColor = minutesTick!.backgroundColor
        minutesBulb.layer.cornerRadius = 10
        minutesBulb.center = CGPointMake(minutesHand!.frame.size.width/2.0, minutesHand!.frame.size.height/2.0)
        minutesHand!.addSubview(minutesBulb)
        addSubview(minutesHand!)
        
        let minutesPan = UIPanGestureRecognizer(target: self, action: "handleMinutesPan:")
        minutesTick!.addGestureRecognizer(minutesPan)
        
        //Seconds Hand
        
        if showSecondsHand == YES
        {
            secondsHand = UIView(frame: CGRectMake(0, 0, 6, frame.size.width))
            secondsHand!.backgroundColor = .clearColor()
            secondsHand!.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0)
            
            let secondsTick = UIView(frame: CGRectMake(0, 0, secondsHand!.frame.size.width, frame.size.width/2.0 - (layer.borderWidth * 4.0) - 8))
            secondsTick.backgroundColor = Definitions.lighterColorForColor(Definitions.lighterColorForColor(.redColor()))
            secondsTick.layer.cornerRadius = 3
            secondsTick.center = CGPointMake(secondsHand!.frame.size.width/2.0, secondsHand!.frame.size.height/2.0 - secondsTick.frame.size.height/2.0)
            secondsHand!.addSubview(secondsTick)
            
            let secondsBulb = UIView(frame: CGRectMake(0, 0, 10, 10))
            secondsBulb.backgroundColor = secondsTick.backgroundColor
            secondsBulb.layer.cornerRadius = 10
            secondsBulb.center = CGPointMake(secondsHand!.frame.size.width/2.0, secondsHand!.frame.size.height/2.0)
            secondsHand!.addSubview(secondsBulb)
            addSubview(secondsHand!)
        }
    }
    
    //MARK: - Rotation Methods
    
    func handleHoursPan(panGesture : UIPanGestureRecognizer)
    {
        switch panGesture.state
        {
        case .Changed:
            let pointOne = CGPointMake(frame.size.width/2.0, frame.size.height/2.0)
            let pointTwo = panGesture.locationInView(self)
            
            let adjacent = Float(pointTwo.x - pointOne.x)
            let opposite = Float(pointTwo.y - pointOne.y)
            
            let angle = atan2f(adjacent, opposite)
            
            UIView.animateWithDuration(0.1, delay: 0.0, options: .AllowAnimatedContent, animations: { () -> Void in
                
                self.hoursHand!.transform = CGAffineTransformMakeRotation(CGFloat((Float(M_PI) + angle) * -1.0))
                
                }, completion: nil)
            
            break
            
        default:
            break
        }
    }
    
    var startMinuteAngle : Float = 0.0
    var isExpectingGreaterValue: Bool?
    
    func handleMinutesPan(panGesture : UIPanGestureRecognizer)
    {
        switch panGesture.state
        {
        case .Began:
            startMinuteAngle = atan2f(Float(self.minutesHand!.transform.b), Float(self.minutesHand!.transform.a))
            break
            
        case .Changed:
            
            let pointOne = CGPointMake(frame.size.width/2.0, frame.size.height/2.0)
            let pointTwo = panGesture.locationInView(self)
            
            var adjacent = Float(pointOne.x - pointTwo.x)
            var opposite = Float(pointOne.y - pointTwo.y)
            
            let deltaAngle = atan2f(opposite, adjacent)
            
            UIView.animateWithDuration(0.1, delay: 0.0, options: .AllowAnimatedContent, animations: { () -> Void in
                
                self.minutesHand!.transform = CGAffineTransformMakeRotation(CGFloat((Float(M_PI_2) - deltaAngle)) * -1.0)
                
                
                if self.handsMoveIndependently == NO
                {
                    let currentAngle = atan2f(Float(self.minutesHand!.transform.b), Float(self.minutesHand!.transform.a))
                    var currentMinute = Double(currentAngle) * 60.0 / (M_PI * 2.0)
                    
                    if currentMinute < 0
                    {
                        currentMinute = 60 - abs(currentMinute)
                    }
                    
                    var formerMinute = Double(self.startMinuteAngle) * 60.0 / (M_PI * 2.0)
                    
                    if formerMinute < 0
                    {
                        formerMinute = 60 - abs(formerMinute)
                    }
                    
                    if self.isExpectingGreaterValue != nil //We've already moved beyond our initial position
                    {
                        print("Current - Former: \(currentMinute - formerMinute)\n")
                        print("IsExpectingGreaterValue: \(self.isExpectingGreaterValue!)\n")
                        if (currentMinute - formerMinute < 0 && self.isExpectingGreaterValue! == YES) || (currentMinute - formerMinute > 0 && self.isExpectingGreaterValue! == NO) //We're switching hours
                        {
                            let timeComponents = self.currentTime!.componentsSeparatedByString(":")
                            
                            var hour = timeComponents[0]
                            print("\(hour)\n")
                            
                            if formerMinute > currentMinute //Going forwards
                            {
                                hour = String((hour as NSString).integerValue + 1)
                                self.isExpectingGreaterValue = YES
                            }
                            else
                            {
                                hour = String((hour as NSString).integerValue - 1)
                                self.isExpectingGreaterValue = NO
                            }
                            
                            print("\((hour as NSString).integerValue % 12)\n")
                            
                            self.currentTime = "\((hour as NSString).integerValue % 12):\(currentMinute):\(timeComponents[2])"
                            
                            let newHourAngle = CGFloat((M_PI * 2.0)/12.0) * CGFloat(CGFloat((hour as NSString).integerValue) + CGFloat(currentMinute/60.0))
                            
                            self.hoursHand!.transform = CGAffineTransformMakeRotation(newHourAngle)
                        }
                        else
                        {
                            let newHourAngle = (currentMinute - formerMinute) * (M_PI * 2.0)/60.0/12.0
                            self.hoursHand!.transform = CGAffineTransformRotate(self.hoursHand!.transform, CGFloat(newHourAngle))
                            
                            print("Current - Former: \(currentMinute - formerMinute)\n")
                            print("Current - Former notFirstTime: \(currentMinute - formerMinute > 0)\n")
                            if currentMinute - formerMinute != 0
                            {
                                self.isExpectingGreaterValue = currentMinute - formerMinute > 0
                            }
                        }
                    }
                    else
                    {
                        let newHourAngle = (currentMinute - formerMinute) * (M_PI * 2.0)/60.0/12.0
                        self.hoursHand!.transform = CGAffineTransformRotate(self.hoursHand!.transform, CGFloat(newHourAngle))
                        
                        print("Current - Former firstTime: \(currentMinute - formerMinute > 0)\n")
                        
                        if currentMinute - formerMinute != 0
                        {
                            self.isExpectingGreaterValue = currentMinute - formerMinute > 0
                        }
                    }
                }
                
                }, completion: nil)
            startMinuteAngle = atan2f(Float(self.minutesHand!.transform.b), Float(self.minutesHand!.transform.a))
            break
            
        default:
            break
        }
    }
    
    //MARK: - Other Methods
    
    /**
    Rotates the hands to a given time using a spring animation
    
    :param: time The time to move to in "HH:MM:SS" format
    */
    func rotateHandsToTime(time : String)
    {
        startTime = time
        currentTime = time
        
        let timeComponents = time.componentsSeparatedByString(":")
        
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: .AllowAnimatedContent, animations: { () -> Void in
            
            let trueHour = CGFloat((timeComponents[0] as NSString).doubleValue + (timeComponents[1] as NSString).doubleValue/60.0 + ((timeComponents[2] as NSString).doubleValue/60.0/60.0))
            self.hoursHand!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 2.0)/CGFloat(12.0) * trueHour)
            
            self.minutesHand!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 2.0)/CGFloat(60.0) * CGFloat((timeComponents[1] as NSString).doubleValue + (timeComponents[2] as NSString).doubleValue/60.0))
            
            self.secondsHand?.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 2.0)/CGFloat(60.0) * CGFloat((timeComponents[2] as NSString).doubleValue))
            
            }, completion: nil)
    }
}
