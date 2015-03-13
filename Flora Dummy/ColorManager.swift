//
//  ColorManager.swift
//  FloraDummy
//
//  Created by Michael Schloss on 2/8/15.
//  Copyright (c) 2015 SGSC. All rights reserved.
//

import UIKit

class Color : NSObject
{
    var name : String!
    
    var primaryColor : UIColor!
    var secondaryColor : UIColor!
    var backgroundColor : UIColor!
    
    override func isEqual(object: AnyObject?) -> Bool
    {
        if object!.classForCoder !== self.classForCoder
        {
            return NO
        }
        
        let colorToCompare = object as Color
        
        return name == colorToCompare.name && primaryColor == colorToCompare.primaryColor && secondaryColor == colorToCompare.secondaryColor && backgroundColor == colorToCompare.backgroundColor
    }
}

private var colorManagerInstance: ColorManager!

private let databaseWebsite     = "http://cescomet.michaelschlosstech.com/appdatabase.php"
private let databasePassword    = "7AZ-hSz-X7p-HGB"

@objc class ColorManager
{
    private var activeColorScheme : Color!
    
    private var colors = Array<Color>()
    var storedColors : Array<Color>
        {
        get
        {
            return colors
        }
    }
    
    init()
    {
        colorManagerInstance = self
        
        let colorsPath = NSBundle.mainBundle().pathForResource("Colors", ofType: "plist")!
        let loadedColors = NSArray(contentsOfFile: colorsPath) as Array<Dictionary<String, String>>
        
        for color in loadedColors
        {
            let newColor = Color()
            
            newColor.name = color["Name"]
            newColor.backgroundColor = Definitions.colorWithHexString(color["Background Color"]!)
            newColor.primaryColor = Definitions.colorWithHexString(color["Primary Color"]!)
            newColor.secondaryColor = Definitions.colorWithHexString(color["Secondary Color"]!)
            
            colors.append(newColor)
        }
    }
    
    class func sharedManager() -> ColorManager
    {
        if colorManagerInstance == nil
        {
            colorManagerInstance = ColorManager()
        }
        
        return colorManagerInstance
    }
    
    ///Reloads the current color scheme and updating with changes on server-side
    func loadColorScheme()
    {
        let defaultColor = NSUserDefaults.standardUserDefaults().objectForKey("selectedColor") as String
        
        for color in colors
        {
            if color.name == defaultColor
            {
                activeColorScheme = color
                updateColors()
                return
            }
        }
        
        if activeColorScheme == nil
        {
            activeColorScheme = colors[0]
            NSUserDefaults.standardUserDefaults().setObject(colors[0].name, forKey: "selectedColor")
        }
    }
    
    func currentColor() -> Color!
    {
        return activeColorScheme
    }
    
    ///Reloads the current color scheme without updating with changes on server-side
    func loadColorSchemeWithoutRefresh()
    {
        let defaultColor = NSUserDefaults.standardUserDefaults().objectForKey("selectedColor") as String
        
        for color in colors
        {
            if color.name == defaultColor
            {
                activeColorScheme = color
                return
            }
        }
        
        if activeColorScheme == nil
        {
            activeColorScheme = colors[0]
            NSUserDefaults.standardUserDefaults().setObject(colors[0].name, forKey: "selectedColor")
        }
    }
    
    //MARK: - Private Methods
    
    private func updateColors()
    {
        println("Loading Colors")
        
        let post = "Password=\(databasePassword)&SQLQuery=SELECT * FROM color"
        let url = NSURL(string: databaseWebsite)!
        
        let postData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: YES)
        let postLength = String(postData!.length)
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.HTTPBody = postData
        
        let urlSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlSessionConfiguration.allowsCellularAccess = NO
        urlSessionConfiguration.HTTPAdditionalHeaders = ["Accept":"application/json"]
        urlSessionConfiguration.timeoutIntervalForRequest = 15.0
        let urlSession = NSURLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: nil)
        
        let activeSessionColors = urlSession.dataTaskWithRequest(request, completionHandler: { (databaseData, urlRespone, error) -> Void in
            
            if error != nil || databaseData == nil
            {
                println("There's been an error")
                return
            }
            
            let stringData = NSString(data: databaseData, encoding: NSASCIIStringEncoding)
            
            if stringData!.containsString("No Data")
            {
                println("There are no colors")
                return
            }
            
            let JSONData = NSJSONSerialization.JSONObjectWithData(databaseData, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
            let newColors = JSONData["Data"] as Array<Dictionary<String, String>>
            
            var madeColors = Array<Color>()
            for color in newColors
            {
                let newColor = Color()
                
                newColor.name = color["Name"]
                newColor.backgroundColor = Definitions.colorWithHexString(color["Background Color"]!)
                newColor.primaryColor = Definitions.colorWithHexString(color["Primary Color"]!)
                newColor.secondaryColor = Definitions.colorWithHexString(color["Secondary Color"]!)
                
                madeColors.append(newColor)
            }
            
            for madeColor in madeColors
            {
                var foundColor = NO
                for color in self.colors
                {
                    if color.isEqual(madeColor) == YES
                    {
                        foundColor = YES
                        break
                    }
                }
                
                if foundColor == NO
                {
                    self.colors = madeColors
                    self.loadColorSchemeWithoutRefresh()
                }
            }
            NSNotificationCenter.defaultCenter().postNotificationName(ColorSchemeDidChangeNotification, object: nil)
        })
        
        activeSessionColors.resume()
    }
}
