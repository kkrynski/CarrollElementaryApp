//
//  WeatherView.swift
//  FloraDummy
//
//  Created by Michael Schloss on 11/27/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class WeatherView: UIView, WeatherManagerDelegate
{
    //Weather Stuff
    private var weatherManager : WeatherManager?
    private var currentWeatherItem : WeatherItem?
    private var indexOfCurrentTempString : Int32?
    
    @IBOutlet var weatherHumidity : UILabel?
    @IBOutlet var weatherTemp : UILabel?
    @IBOutlet var weatherWindSpeed : UILabel?
    @IBOutlet var weatherForcastImage : UIImageView?

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateInitialText", userInfo: nil, repeats: NO)
    }
    
    //We have to have this on a delay for initialization
    func updateInitialText()
    {
        weatherHumidity!.text = "0%"
        weatherTemp!.text = "Updating\nWeather"
        weatherTemp!.numberOfLines = 0
        weatherWindSpeed!.text = "0 mph"
        
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
        
        weatherForcastImage!.image = item.weatherCurrentTempImage
        weatherTemp!.text = "\(item.weatherCurrentTemp)°"
        weatherTemp!.numberOfLines = 0
        weatherWindSpeed!.text = "\(item.weatherWindSpeed) mph"
        weatherHumidity!.text = "\(item.weatherHumidity)%"
    }
    
}
