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

private let website = "http://cescomet.michaelschlosstech.com/weather/videos"

class WeatherView: UIView, WeatherManagerDelegate
{
    //Weather Stuff
    private var weatherManager : WeatherManager!
    private var currentWeatherItem : WeatherItem!
    private var indexOfCurrentTempString : Int32?
    
    var staticWeatherImage : UIImageView!
    
    @IBOutlet var weatherHumidity : UILabel!
    @IBOutlet var weatherTemp : UILabel!
    @IBOutlet var weatherWindSpeed : UILabel!
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateInitialText", userInfo: nil, repeats: NO)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateColors", name: ColorSchemeDidChangeNotification, object: nil)
        
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryAmbient, error: nil)
        
        staticWeatherImage = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        staticWeatherImage.backgroundColor = .clearColor()
        staticWeatherImage.contentMode = .ScaleAspectFill
        addSubview(staticWeatherImage)
        sendSubviewToBack(staticWeatherImage)
    }
    
    override func removeFromSuperview()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        super.removeFromSuperview()
    }
    
    func updateColors()
    {
        UIView.transitionWithView(self, duration: transitionLength, options: .TransitionCrossDissolve, animations: { () -> Void in
            self.weatherHumidity.textColor = ColorManager.sharedManager().currentColor().primaryColor
            self.weatherTemp.textColor = ColorManager.sharedManager().currentColor().primaryColor
            self.weatherWindSpeed.textColor = ColorManager.sharedManager().currentColor().primaryColor
        }, completion: nil)
    }
    
    //We have to have this on a delay for initialization
    func updateInitialText()
    {
        weatherHumidity.text = "Humidity: Updating..."
        weatherTemp.text = "0°F"
        weatherWindSpeed.text = "Wind Speed: Updating..."
        
        weatherManager = WeatherManager.sharedManager() as WeatherManager!
        weatherManager.delegate = self
        weatherManager.startUpdatingLocation()
    }
    
    //Update the colors of the labels in the view
    func updateColors(color: UIColor)
    {
        weatherTemp.textColor = color
        Definitions.outlineTextInLabel(weatherTemp!)
        
        weatherHumidity.textColor = color
        Definitions.outlineTextInLabel(weatherHumidity!)
        
        weatherWindSpeed.textColor = color
        Definitions.outlineTextInLabel(weatherWindSpeed!)
    }
    
    func didRecieveAndParseNewWeatherItem(item: WeatherItem!)
    {
        currentWeatherItem = item
        indexOfCurrentTempString = item.indexForWeatherMap
        
        let unknown = "ERR"
        
        UIView.transitionWithView(self, duration: 0.3, options: .TransitionCrossDissolve, animations: { () -> Void in
            if let code = item.weatherCode
            {
                self.videoForForcastImage(code)
            }
            self.weatherTemp.text = "\(item.weatherCurrentTemp == nil ? unknown:item.weatherCurrentTemp)°F"
            self.weatherTemp.numberOfLines = 0
            self.weatherWindSpeed.text = "Wind Speed: \(item.weatherWindSpeed == nil ? unknown:item.weatherWindSpeed) mph"
            self.weatherHumidity.text = "Humidity: \(item.weatherHumidity == nil ? unknown:item.weatherHumidity)%"
            }, completion: nil)
    }
    
    private func videoForForcastImage(weatherCode: String)
    {
        switch weatherCode.toInt()!
        {
            
        case 116:
            //player.contentURL = NSURL(string: website.stringByAppendingPathComponent("PartlyCloudy.mp4"))!
            break
            
        case 119, 122:
            //player.contentURL = NSURL(string: website.stringByAppendingPathComponent("Cloudy.mp4"))!
            break
            
        case 143, 248, 260:
            //player.contentURL = NSURL(string: website.stringByAppendingPathComponent("Foggy.mp4"))!
            break
            
        case 176, 185, 263, 266, 281, 284, 293, 296, 299, 302, 305, 308, 311, 314, 353, 356, 359, 362, 365:
            //player.contentURL = NSURL(string: website.stringByAppendingPathComponent("Rain.mp4"))!
            break
            
        case 179, 227, 230, 323, 326, 329, 332, 335, 338, 350, 368, 371, 374, 377:
            //player.contentURL = NSURL(string: website.stringByAppendingPathComponent("Snow.mp4"))!
            break
            
        case 182, 200, 317, 320, 386, 389, 392, 395:
            //player.contentURL = NSURL(string: website.stringByAppendingPathComponent("ThunderStorm.mp4"))!
            break
            
        default:
            //player.contentURL = NSURL(string: website.stringByAppendingPathComponent("Sunny.mp4"))!
            break
        }
    }
}
