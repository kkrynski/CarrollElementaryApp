//
//  Definitions.swift
//  Flora Dummy
//
//  Created by Michael Schloss on 10/25/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

//  This Swift file will contain all functions that are found everywhere.  This reduces code load and centralizes any changed needed to be made.

import UIKit
import QuartzCore

class Definitions: NSObject
{
    //MARK: - Color methods
    
    //Convert a hex string to UIColor
    class func colorWithHexString(hexString : String) -> UIColor
    {
        let colorString = ((hexString as NSString).stringByReplacingOccurrencesOfString("#", withString: "")) as String
        
        let alpha = 1.0
        let red = colorCompenentFrom(colorString, atStartIndex: 0, withLength: 2)
        let greenComponent = colorCompenentFrom(colorString, atStartIndex: 2, withLength: 2)
        let blue = colorCompenentFrom(colorString, atStartIndex: 4, withLength: 2)
        
        return UIColor(red: CGFloat(red), green: CGFloat(greenComponent), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
    //Lighten a UIColor
    class func lighterColorForColor(color : UIColor) -> UIColor
    {
        var alpha : CGFloat = 0.0
        var red : CGFloat = 0.0
        var green : CGFloat = 0.0
        var blue : CGFloat = 0.0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return UIColor(red: red + 0.1, green: green + 0.1, blue: blue + 0.1, alpha: alpha)
    }
    
    //Darken a UIColor
    class func darkerColorForColor(color : UIColor) -> UIColor
    {
        var alpha : CGFloat = 0.0
        var red : CGFloat = 0.0
        var green : CGFloat = 0.0
        var blue : CGFloat = 0.0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return UIColor(red: red - 0.1, green: green - 0.1, blue: blue - 0.1, alpha: alpha)
    }
    
    //MARK: - Outline functions
    
    //Outline a UILabel
    class func outlineTextInLabel(label : UILabel)
    {
        label.layer.shadowColor = UIColor.blackColor().CGColor
        label.layer.shadowOffset = CGSizeMake(0.1, 0.1)
        label.layer.shadowOpacity = 1.0
        label.layer.shadowRadius = 1.0
    }
    
    //Outline a UITextView
    class func outlineTextInTextView(textView : UITextView, forFont font : UIFont!)
    {
        //Store the text since we're working with it
        let text = textView.text
        
        //Format the paragraphs -- APPLE CODE
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 10.0
        paragraphStyle.firstLineHeadIndent = 10.0
        paragraphStyle.tailIndent = -10.0
        
        let attributes = [NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle]
        textView.attributedText = NSAttributedString(string: text, attributes: attributes)
        
        //Create the shadow
        textView.textInputView.layer.shadowColor = UIColor.blackColor().CGColor
        textView.textInputView.layer.shadowOffset = CGSizeMake(0.1, 0.1)
        textView.textInputView.layer.shadowOpacity = 1.0
        textView.textInputView.layer.shadowRadius = 1.0
        
        //Add cushion so that we don't have text touching the border
        textView.contentInset = UIEdgeInsetsMake(10.0, 0.0, 10.0, 0.0)
    }
    
    //Outline a UIView
    class func outlineView(view : UIView)
    {
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    //Outline a UIButton
    class func outlineButton(button : UIButton)
    {
        Definitions.outlineTextInLabel(button.titleLabel!)
        
        button.layer.borderWidth = 4.0
        button.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    // MARK: - Private class functions for Definitions.  These will NOT be able to be referenced outside the app. (They don't need to be).
    
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
