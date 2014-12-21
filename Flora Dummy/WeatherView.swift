//
//  WeatherView.swift
//  FloraDummy
//
//  Created by Michael Schloss on 11/27/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class WeatherView: UIView, WeatherManagerDelegate
{
    //Weather Stuff
    private var weatherManager : WeatherManager?
    private var currentWeatherItem : WeatherItem?
    private var indexOfCurrentTempString : Int32?
    
    var player : MPMoviePlayerController?
    var staticWeatherImage : UIImageView?
    
    @IBOutlet var weatherHumidity : UILabel?
    @IBOutlet var weatherTemp : UILabel?
    @IBOutlet var weatherWindSpeed : UILabel?
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateInitialText", userInfo: nil, repeats: NO)
        
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryAmbient, error: nil)
        
        player = MPMoviePlayerController()
        player!.controlStyle = .None
        player!.allowsAirPlay = NO
        player!.shouldAutoplay = NO
        player!.repeatMode = .One
        addSubview(player!.view)
        sendSubviewToBack(player!.view)
        player!.view.layer.shouldRasterize = YES
        player!.view.layer.rasterizationScale = UIScreen.mainScreen().scale
        player!.view.alpha = 0.0
        player!.view.frame = self.bounds
        player!.scalingMode = .AspectFill
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveThumbnailNotification:", name: MPMoviePlayerThumbnailImageRequestDidFinishNotification, object: nil)
        staticWeatherImage = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        staticWeatherImage!.backgroundColor = .clearColor()
        staticWeatherImage!.contentMode = .ScaleAspectFill
        insertSubview(staticWeatherImage!, aboveSubview: player!.view)
        
        if NSUserDefaults.standardUserDefaults().boolForKey("animatedWeather") == NO
        {
            player!.view.alpha = 0.0
            staticWeatherImage!.alpha = 1.0
        }
        else
        {
            staticWeatherImage!.alpha = 0.0
            player!.view.alpha = 1.0
            player!.shouldAutoplay = YES
        }
    }
    
    //We have to have this on a delay for initialization
    func updateInitialText()
    {
        weatherHumidity!.text = "Humidity: Updating..."
        weatherTemp!.text = "0°F"
        weatherWindSpeed!.text = "Wind Speed: Updating..."
        
        weatherManager = WeatherManager.sharedManager() as WeatherManager!
        weatherManager!.delegate = self
        weatherManager!.startUpdatingLocation()
    }
    
    //Update the colors of the labels in the view
    func updateColors(color: UIColor)
    {
        weatherTemp!.textColor = color
        Definitions.outlineTextInLabel(weatherTemp!)
        
        weatherHumidity!.textColor = color
        Definitions.outlineTextInLabel(weatherHumidity!)
        
        weatherWindSpeed!.textColor = color
        Definitions.outlineTextInLabel(weatherWindSpeed!)
    }
    
    func didRecieveAndParseNewWeatherItem(item: WeatherItem!)
    {
        currentWeatherItem = item
        indexOfCurrentTempString = item.indexForWeatherMap
        
        UIView.transitionWithView(self, duration: 0.3, options: .TransitionCrossDissolve, animations: { () -> Void in
            self.videoForForcastImage(item.weatherCode)
            self.player?.view.alpha = 1.0
            self.weatherTemp!.text = "\(item.weatherCurrentTemp)°F"
            self.weatherTemp!.numberOfLines = 0
            self.weatherWindSpeed!.text = "Wind Speed: \(item.weatherWindSpeed) mph"
            self.weatherHumidity!.text = "Humidity: \(item.weatherHumidity)%"
            }, completion: nil)
    }
    
    private func videoForForcastImage(weatherCode: String)
    {
        switch (weatherCode as NSString).integerValue
        {
        case 113:
            player?.contentURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Sunny", ofType: "mp4")!)
            break
            
        case 116:
            player?.contentURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Partly Cloudy", ofType: "mp4")!)
            break
            
        case 119, 122:
            player?.contentURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Cloudy", ofType: "mp4")!)
            break
            
        case 143, 248, 260:
            player?.contentURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Fog", ofType: "mp4")!)
            break
            
        case 176, 185, 263, 266, 281, 284, 293, 296, 299, 302, 305, 308, 311, 314, 353, 356, 359, 362, 365:
            player?.contentURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Rain", ofType: "mp4")!)
            break
            
        case 179, 227, 230, 323, 326, 329, 332, 335, 338, 350, 368, 371, 374, 377:
            player?.contentURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Snow", ofType: "mp4")!)
            break
            
        case 182, 200, 317, 320, 386, 389, 392, 395:
            player?.contentURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Thunder Storm", ofType: "mp4")!)
            break
            
        default:
            player?.contentURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Sunny", ofType: "mp4")!)
            break
        }
        
        if NSUserDefaults.standardUserDefaults().boolForKey("animatedWeather") == YES
        {
            player?.prepareToPlay()
            player?.play()
        }
        else
        {
            player?.prepareToPlay()
            player?.play()
            player?.requestThumbnailImagesAtTimes([NSNumber(double: 2.1)], timeOption: .NearestKeyFrame)
        }
    }
    
    func didReceiveThumbnailNotification(notification: NSNotification)
    {
        player?.stop()
        
        let userInfo = notification.userInfo! as NSDictionary
        
        if (userInfo.allKeys as NSArray).containsObject(MPMoviePlayerThumbnailErrorKey) == NO
        {
            staticWeatherImage!.image = userInfo[MPMoviePlayerThumbnailImageKey] as UIImage!
        }
    }
}
