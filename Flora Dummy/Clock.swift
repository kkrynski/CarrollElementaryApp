//
//  Clock.swift
//  FloraDummy
//
//  Created by Michael Schloss on 11/22/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

protocol ClockDelegate
{
    func updateCurrentTimeLabel()
}

class ClockHand : UIView
{
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView?
    {
        let frame = CGRectInset(bounds, -20, -10)
        return CGRectContainsPoint(frame, point) ? self : nil
    }
}

class ClockHandView : UIView
{
    var clockHand : ClockHand?
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView?
    {
        let frame = CGRectInset(bounds, -20, -10)
        if CGRectContainsPoint(frame, point)
        {
            if CGRectContainsPoint(CGRectInset(clockHand!.bounds, -20, -20), point)
            {
                return clockHand!
            }
            return self
        }
        
        return nil
    }
}

class Clock: UIView
{
    //MARK: - Variables
    
    /**The Clock's delegate*/
    var delegate : ClockDelegate?
    
    /**
    Determines whether the hands will move independently of each other
    
    By default, this is set to 'YES'.  Setting to 'No' disables the time-link between each hand.
    */
    var handsMoveDependently = YES
    
    var minuteHandRounding = MinuteHandRounding.None
    
    /**
    The current time displayed by the clock
    
    This property is read-only
    */
    var currentTime : String {
        get
        {
            return _currentTime!
        }
    }
    private var _currentTime : String?
    
    //The hours hand
    private var hoursHand : ClockHandView!
    
    //The minutes hand
    private var minutesHand : ClockHandView!
    
    //The seconds hand
    private var secondsHand : ClockHandView?
    
    //Will show seconds hand
    var showSecondsHand = YES
    
    //Used for moving hands around
    private var startMinuteAngle : Float = 0.0
    private var oldMinute : Int = 0
    private var startSecondAngle : Float = 0.0
    private var oldSecond : Int = 0
    
    //MARK: - init Methods
    
    init(frame: CGRect, andBorderWidth borderWidth : CGFloat)
    {
        super.init(frame: frame)
        layer.borderWidth = borderWidth
        layer.cornerRadius = frame.size.width/2.0
        self.backgroundColor = .whiteColor()
        self.layer.borderColor = UIColor.blackColor().CGColor
        
        insertHourTicks()
        insertMinuteTicks()
        
        let centerPoint = UIView(frame: CGRectMake(0, 0, 30, 30))
        centerPoint.backgroundColor = .blackColor()
        centerPoint.layer.cornerRadius = centerPoint.frame.size.width/2.0
        centerPoint.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0)
        addSubview(centerPoint)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func willMoveToSuperview(newSuperview: UIView?)
    {
        super.willMoveToSuperview(newSuperview)
        
        makeHands()
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
        hoursHand = ClockHandView(frame: CGRectMake(0, 0, 14, frame.size.width))
        hoursHand.backgroundColor = .clearColor()
        hoursHand.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0)
        hoursHand.layer.rasterizationScale = UIScreen.mainScreen().scale
        hoursHand.layer.shouldRasterize = YES
        
        let hoursTick = ClockHand(frame: CGRectMake(0, 0, hoursHand!.frame.size.width, frame.size.width/4.0))
        hoursTick.backgroundColor = .blackColor()
        hoursTick.layer.cornerRadius = 7
        hoursTick.center = CGPointMake(hoursHand.frame.size.width/2.0, hoursHand.frame.size.height/2.0 - hoursTick.frame.size.height/2.0)
        hoursHand.addSubview(hoursTick)
        addSubview(hoursHand)
        hoursHand.clockHand = hoursTick
        
        let hoursPan = UIPanGestureRecognizer(target: self, action: "handleHoursPan:")
        hoursTick.addGestureRecognizer(hoursPan)
        
        //Minutes Hand
        
        minutesHand = ClockHandView(frame: CGRectMake(0, 0, 10, frame.size.width))
        minutesHand.backgroundColor = .clearColor()
        minutesHand.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0)
        minutesHand.layer.rasterizationScale = UIScreen.mainScreen().scale
        minutesHand.layer.shouldRasterize = YES
        
        let minutesTick = ClockHand(frame: CGRectMake(0, 0, minutesHand!.frame.size.width, frame.size.width/2.0 - (layer.borderWidth * 4.0) - 4))
        minutesTick.backgroundColor = Definitions.lighterColorForColor(Definitions.lighterColorForColor(.blackColor()))
        minutesTick.layer.cornerRadius = 5
        minutesTick.center = CGPointMake(minutesHand.frame.size.width/2.0, minutesHand.frame.size.height/2.0 - minutesTick.frame.size.height/2.0)
        minutesHand.addSubview(minutesTick)
        minutesHand.clockHand = minutesTick
        
        let minutesBulb = UIView(frame: CGRectMake(0, 0, 24, 24))
        minutesBulb.backgroundColor = minutesTick.backgroundColor
        minutesBulb.layer.cornerRadius = 10
        minutesBulb.center = CGPointMake(minutesHand!.frame.size.width/2.0, minutesHand!.frame.size.height/2.0)
        minutesHand!.addSubview(minutesBulb)
        addSubview(minutesHand!)
        
        let minutesPan = UIPanGestureRecognizer(target: self, action: "handleMinutesPan:")
        minutesTick.addGestureRecognizer(minutesPan)
        
        //Seconds Hand
        
        if showSecondsHand == YES
        {
            secondsHand = ClockHandView(frame: CGRectMake(0, 0, 6, frame.size.width))
            secondsHand!.backgroundColor = .clearColor()
            secondsHand!.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0)
            secondsHand!.layer.rasterizationScale = UIScreen.mainScreen().scale
            secondsHand!.layer.shouldRasterize = YES
            
            let secondsTick = ClockHand(frame: CGRectMake(0, 0, secondsHand!.frame.size.width, frame.size.width/2.0 - (layer.borderWidth * 4.0) - 8))
            secondsTick.backgroundColor = Definitions.lighterColorForColor(Definitions.lighterColorForColor(.redColor()))
            secondsTick.layer.cornerRadius = 3
            secondsTick.center = CGPointMake(secondsHand!.frame.size.width/2.0, secondsHand!.frame.size.height/2.0 - secondsTick.frame.size.height/2.0)
            secondsHand!.addSubview(secondsTick)
            secondsHand!.clockHand = secondsTick
            
            let secondsBulb = UIView(frame: CGRectMake(0, 0, 15, 15))
            secondsBulb.backgroundColor = secondsTick.backgroundColor
            secondsBulb.layer.cornerRadius = 10
            secondsBulb.center = CGPointMake(secondsHand!.frame.size.width/2.0, secondsHand!.frame.size.height/2.0)
            secondsHand!.addSubview(secondsBulb)
            addSubview(secondsHand!)
            
            let secondsPan = UIPanGestureRecognizer(target: self, action: "handleSecondsPan:")
            secondsTick.addGestureRecognizer(secondsPan)
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
            updateCurrentTime()
            break
            
        default:
            break
        }
    }
    
    func handleMinutesPan(panGesture : UIPanGestureRecognizer)
    {
        switch panGesture.state
        {
        case .Began:
            startMinuteAngle = atan2f(Float(self.minutesHand!.transform.b), Float(self.minutesHand!.transform.a))
            
            oldMinute = Int(floor((atan2f(Float(self.minutesHand!.transform.b), Float(self.minutesHand!.transform.a)) * 60.0)/Float(M_PI * 2.0)))
            oldMinute = oldMinute < 0 ? 60 - abs(oldMinute):oldMinute
            break
            
        case .Changed:
            
            let pointOne = CGPointMake(frame.size.width/2.0, frame.size.height/2.0)
            let pointTwo = panGesture.locationInView(self)
            
            var adjacent = Float(pointOne.x - pointTwo.x)
            var opposite = Float(pointOne.y - pointTwo.y)
            
            let deltaAngle = atan2f(opposite, adjacent)
            
            UIView.animateWithDuration(0.1, delay: 0.0, options: .AllowAnimatedContent, animations: { () -> Void in
                
                self.minutesHand!.transform = CGAffineTransformMakeRotation(CGFloat((Float(M_PI_2) - deltaAngle)) * -1.0)
                
                if self.handsMoveDependently == YES
                {
                    let timeComponents = self.currentTime.componentsSeparatedByString(":")
                    
                    var minute = Int(floor((atan2f(Float(self.minutesHand!.transform.b), Float(self.minutesHand!.transform.a)) * 60.0)/Float(M_PI * 2.0)))
                    minute = minute < 0 ? 60 - abs(minute):minute
                    
                    let hours = self.oldMinute - minute > 30 ? (timeComponents[0] as NSString).doubleValue + 1 : (self.oldMinute - minute < -30 ? (timeComponents[0] as NSString).doubleValue - 1 : (timeComponents[0] as NSString).doubleValue)
                    
                    var trueHour = CGFloat(hours)
                    trueHour += CGFloat(Float(minute)/60.0)
                    if self.showSecondsHand == YES
                    {
                        trueHour += CGFloat((timeComponents[2] as NSString).doubleValue/3600.0)
                    }
                    
                    self.hoursHand!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 2.0)/CGFloat(12.0) * trueHour)
                }
                
                }, completion: nil)
            startMinuteAngle = atan2f(Float(self.minutesHand!.transform.b), Float(self.minutesHand!.transform.a))
            
            oldMinute = Int(floor((atan2f(Float(self.minutesHand!.transform.b), Float(self.minutesHand!.transform.a)) * 60.0)/Float(M_PI * 2.0)))
            oldMinute = oldMinute < 0 ? 60 - abs(oldMinute):oldMinute
            updateCurrentTime()
            break
            
        case .Ended:
            if minuteHandRounding == .None
            {
                break
            }
            //Check for minute hand rounding
            
            
            
            break
            
        default:
            break
        }
    }
    
    func handleSecondsPan(panGesture : UIPanGestureRecognizer)
    {
        switch panGesture.state
        {
        case .Began:
            startSecondAngle = atan2f(Float(self.secondsHand!.transform.b), Float(self.secondsHand!.transform.a))
            
            oldSecond = Int(floor((atan2f(Float(self.secondsHand!.transform.b), Float(self.secondsHand!.transform.a)) * 60.0)/Float(M_PI * 2.0)))
            oldSecond = oldSecond < 0 ? 60 - abs(oldSecond):oldSecond
            
            oldMinute = Int(floor((atan2f(Float(self.minutesHand!.transform.b), Float(self.minutesHand!.transform.a)) * 60.0)/Float(M_PI * 2.0)))
            oldMinute = oldMinute < 0 ? 60 - abs(oldMinute):oldMinute
            break
            
        case .Changed:
            
            let pointOne = CGPointMake(frame.size.width/2.0, frame.size.height/2.0)
            let pointTwo = panGesture.locationInView(self)
            
            var adjacent = Float(pointOne.x - pointTwo.x)
            var opposite = Float(pointOne.y - pointTwo.y)
            
            let deltaAngle = atan2f(opposite, adjacent)
            
            UIView.animateWithDuration(0.1, delay: 0.0, options: .AllowAnimatedContent, animations: { () -> Void in
                
                self.secondsHand!.transform = CGAffineTransformMakeRotation(CGFloat((Float(M_PI_2) - deltaAngle)) * -1.0)
                
                if self.handsMoveDependently == YES
                {
                    let timeComponents = self.currentTime.componentsSeparatedByString(":")
                    
                    //Minutes
                    
                    var second = Int(floor((atan2f(Float(self.secondsHand!.transform.b), Float(self.secondsHand!.transform.a)) * 60.0)/Float(M_PI * 2.0)))
                    second = second < 0 ? 60 - abs(second):second
                    
                    let minutes = self.oldSecond - second > 30 ? (timeComponents[1] as NSString).doubleValue + 1 : (self.oldSecond - second < -30 ? (timeComponents[1] as NSString).doubleValue - 1 : (timeComponents[1] as NSString).doubleValue)
                    
                    var trueMinute = CGFloat(minutes)
                    trueMinute += CGFloat(Float(second)/60.0)
                    
                    self.minutesHand!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 2.0)/CGFloat(60.0) * (trueMinute + 0.00000000001))
                    
                    //Hours
                    
                    var minute = Int(floor(trueMinute))
                    minute = minute < 0 ? 60 - abs(minute):minute
                    
                    let hours = self.oldMinute - minute > 30 ? (timeComponents[0] as NSString).doubleValue + 1 : (self.oldMinute - minute < -30 ? (timeComponents[0] as NSString).doubleValue - 1 : (timeComponents[0] as NSString).doubleValue)
                    
                    var trueHour = CGFloat(hours)
                    trueHour += CGFloat(Float(minute)/60.0)
                    trueHour += CGFloat(Float(second)/3600.0)
                    
                    self.hoursHand!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 2.0)/CGFloat(12.0) * trueHour)
                    
                }
                
                }, completion: nil)
            startSecondAngle = atan2f(Float(self.secondsHand!.transform.b), Float(self.secondsHand!.transform.a))
            
            oldSecond = Int(floor((atan2f(Float(self.secondsHand!.transform.b), Float(self.secondsHand!.transform.a)) * 60.0)/Float(M_PI * 2.0)))
            oldSecond = oldSecond < 0 ? 60 - abs(oldSecond):oldSecond
            
            oldMinute = Int(floor((atan2f(Float(self.minutesHand!.transform.b), Float(self.minutesHand!.transform.a)) * 60.0)/Float(M_PI * 2.0)))
            oldMinute = oldMinute < 0 ? 60 - abs(oldMinute):oldMinute
            
            updateCurrentTime()
            break
            
        default:
            break
        }
    }
    
    //MARK: - Other Methods
    
    //Updates the current time for display
    private func updateCurrentTime()
    {
        let hours = Int(floor((atan2f(Float(self.hoursHand!.transform.b), Float(self.hoursHand!.transform.a)) * 12.0)/Float(M_PI * 2.0)))
        let minutes = Int(floor((atan2f(Float(self.minutesHand!.transform.b), Float(self.minutesHand!.transform.a)) * 60.0)/Float(M_PI * 2.0)))
        
        if showSecondsHand == YES
        {
            let seconds = Int(floor((atan2f(Float(self.secondsHand!.transform.b), Float(self.secondsHand!.transform.a)) * 60.0)/Float(M_PI * 2.0)))
            _currentTime = String(format: "%02d:%02d:%02d", (hours < 0 ? 12 - abs(hours):hours), (minutes < 0 ? 60 - abs(minutes):minutes), (seconds < 0 ? 60 - abs(seconds):seconds))
        }
        else
        {
            _currentTime = String(format: "%02d:%02d", (hours < 0 ? 12 - abs(hours):hours), (minutes < 0 ? 60 - abs(minutes):minutes))
        }
        
        delegate?.updateCurrentTimeLabel()
    }
    
    /**
    Rotates the hands to a given time using a spring animation
    
    :param: time The time to move to in "HH:MM:SS" format
    */
    func rotateHandsToTime(time : String, animated: Bool)
    {
        _currentTime = time
        
        let timeComponents = time.componentsSeparatedByString(":")
        
        UIView.animateWithDuration(animated == YES ? 1.0: 0.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: .AllowAnimatedContent, animations: { () -> Void in
            
            let secondsValue = self.showSecondsHand == YES ? (timeComponents[2] as NSString).doubleValue/60.0/60.0 : Double(0.0)
            
            let trueHour = CGFloat((timeComponents[0] as NSString).doubleValue + (timeComponents[1] as NSString).doubleValue/60.0 + secondsValue)
            self.hoursHand!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 2.0)/CGFloat(12.0) * trueHour)
            
            self.minutesHand!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 2.0)/CGFloat(60.0) * CGFloat((timeComponents[1] as NSString).doubleValue + (self.showSecondsHand == YES ? (timeComponents[2] as NSString).doubleValue/60.0 : 0.0)))
            
            if self.showSecondsHand == YES
            {
                self.secondsHand?.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 2.0)/CGFloat(60.0) * CGFloat((timeComponents[2] as NSString).doubleValue))
            }
            
            }, completion: nil)
    }
}
