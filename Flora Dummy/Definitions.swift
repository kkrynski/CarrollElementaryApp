//
//  Definitions.swift
//  Flora Dummy
//
//  Created by Michael Schloss on 10/25/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

//  This Swift file will contain all functions that are found everywhere.  This reduces code load and centralizes any changed needed to be made.

import UIKit

class Definitions: NSObject
{
    class func colorWithHexString(hexString : String) -> UIColor
    {
        let colorString = ((hexString as NSString).stringByReplacingOccurrencesOfString("#", withString: "")) as String
        
        let alpha = 1.0
        let red = colorCompenentFrom(colorString, atStartIndex: 0, withLength: 2)
        let greenComponent = colorCompenentFrom(colorString, atStartIndex: 2, withLength: 2)
        let blue = colorCompenentFrom(colorString, atStartIndex: 4, withLength: 2)
        
        return UIColor(red: CGFloat(red), green: CGFloat(greenComponent), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
    class func outlineTextInLabel(label : UILabel)
    {
        label.layer.shadowColor = UIColor.blackColor().CGColor
        label.layer.shadowOffset = CGSizeMake(0.1, 0.1)
        label.layer.shadowOpacity = 1.0
        label.layer.shadowRadius = 1.0
    }
    
    private class func colorCompenentFrom(string : String, atStartIndex start : Int, withLength length : Int) ->Float
    {
        let subString = ((string as NSString).substringWithRange(NSMakeRange(start, length))) as String
        let fullHex = length == 2 ? subString : (subString + subString)
        
        var hexCompenent : UInt32 = 0
        let scanner = NSScanner(string: fullHex)
        scanner.scanHexInt(&hexCompenent)
        
        return Float(hexCompenent) / 255.0
    }
}
