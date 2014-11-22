//
//  HomeVC.swift
//  Flora Dummy
//
//  Created by Michael Schloss on 10/25/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class HomeVC: FormattedVC, WeatherManagerDelegate
{
    //Elements on screen
    @IBOutlet var titleLabel : UILabel?
    @IBOutlet var subTitleLabel : UILabel?
    @IBOutlet var homeImageView : UIImageView?
    
    //Weather Stuff
    private var weatherManager : WeatherManager?
    private var currentWeatherItem : WeatherItem?
    private var indexOfCurrentTempString : Int32?
    
    @IBOutlet var weatherHumidity : UILabel?
    @IBOutlet var weatherTemp : UILabel?
    @IBOutlet var weatherWindSpeed : UILabel?
    @IBOutlet var weatherForcastImage : UIImageView?
    @IBOutlet var weatherHumidityImage : UIImageView?
    @IBOutlet var weatherWindImage : UIImageView?

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        weatherHumidity!.text = "0%"
        weatherTemp!.text = "Updating\nWeather"
        weatherTemp!.numberOfLines = 0
        weatherWindSpeed!.text = "0 mph"
        
        weatherManager = WeatherManager.sharedManager() as WeatherManager!
        weatherManager!.delegate = self
        weatherManager!.startUpdatingLocation()
    }
    
    //Set the colors here for instant loading
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        titleLabel!.textColor = primaryColor
        Definitions.outlineTextInLabel(titleLabel!)
        
        subTitleLabel!.textColor = primaryColor
        Definitions.outlineTextInLabel(subTitleLabel!)
        
        view.backgroundColor = backgroundColor
        
        weatherTemp!.textColor = primaryColor
        Definitions.outlineTextInLabel(weatherTemp!)
        
        weatherHumidity!.textColor = primaryColor
        Definitions.outlineTextInLabel(weatherHumidity!)
        
        weatherWindSpeed!.textColor = primaryColor
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
