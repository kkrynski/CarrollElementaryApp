//
//  Definitions.swift
//  Flora Dummy
//
//  Created by Michael Schloss on 10/25/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

//  This Swift file will contain all functions that are found everywhere.  This reduces code load and centralizes any changes needed to be made.

import UIKit
import QuartzCore

//MARK: - Global Variables

let YES = 1 as Bool
let NO = 0 as Bool

//MARK: - String Extension
extension String {
    
    subscript (i: Int) -> Character
        {
            return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String
        {
            return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String
        {
            return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
}

//MARK: - Definitions Class

class Definitions: NSObject
{
    //MARK: - Color Methods
    
    //Random Color
    class func randomColor() -> UIColor
    {
        let red = Double(arc4random_uniform(255))/255.0
        let blue = Double(arc4random_uniform(255))/255.0
        let green = Double(arc4random_uniform(255))/255.0
        
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0)
    }
    
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
    
    //MARK: - Outline Methods
    
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
        view.layer.borderColor = ColorManager.sharedManager().currentColor().secondaryColor.CGColor
    }
    
    //Outline a UIButton
    class func outlineButton(button : UIButton)
    {
        Definitions.outlineTextInLabel(button.titleLabel!)
        
        button.layer.borderWidth = 4.0
        button.layer.borderColor = ColorManager.sharedManager().currentColor().secondaryColor.CGColor
    }
    
    //Calculate the answer to a math problem
    class func calculate(equation: String) -> Double
    {
        var finalAnswer = 0.0
        
        //Trims the string to remove white space and other accidental charcters
        var trimmedEquation = equation.stringByReplacingOccurrencesOfString(" ", withString: "", options: .CaseInsensitiveSearch, range: nil).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " ,;."))
        
        //Parentheses -- (P)emdas
        var positionOfFirstOpenParentheses = -1
        var positionOfMatchingCloseParentheses = -1
        var parenCounter = 0
        
        for index in 0...countElements(trimmedEquation) - 1
        {
            if index > countElements(trimmedEquation) - 1
            {
                break
            }
            
            let character : Character = trimmedEquation[index]
            
            if character == "(" && positionOfFirstOpenParentheses == -1
            {
                positionOfFirstOpenParentheses = index
                parenCounter++
            }
            else if character == "("
            {
                parenCounter++
            }
            else if character == ")"
            {
                parenCounter--
                if parenCounter == 0
                {
                    positionOfMatchingCloseParentheses = index
                    let newEquation = trimmedEquation[(positionOfFirstOpenParentheses + 1)...(positionOfMatchingCloseParentheses - 1)]
                    let substitution = String(format: "%f", calculate(newEquation)).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "0")).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "."))
                    trimmedEquation.replaceRange(Range<String.Index>(start: advance(trimmedEquation.startIndex, positionOfFirstOpenParentheses), end: advance(trimmedEquation.startIndex, positionOfMatchingCloseParentheses + 1)), with: substitution)
                }
            }
        }
        
        //Get just the numbers
        var numbers = trimmedEquation.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "+-^*/"))
        //Get just the operators
        var operators = trimmedEquation.componentsSeparatedByCharactersInSet(NSCharacterSet.alphanumericCharacterSet())
        //Sort out accidental blank space that comes with separating by numbers
        let tempArray = NSMutableArray(array: operators)
        if tempArray.containsObject("")
        {
            tempArray.removeObject("")
        }
        operators = tempArray.subarrayWithRange(NSRange(location:0, length: tempArray.count)) as [String]
        
        //Exponents -- p(E)mdas
        for oper in operators
        {
            let index = (operators as NSArray).indexOfObject(oper)
            
            if oper == "^"
            {
                let leftSide = (numbers[index] as NSString).doubleValue
                let rightSide = (numbers[index + 1] as NSString).doubleValue
                
                let answer = pow(leftSide, rightSide)
                numbers[index] = String(format: "%f", answer).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "0")).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "."))
                numbers.removeAtIndex(index + 1)
                operators.removeAtIndex(index)
            }
        }
        
        //Multiplication and Division -- pe(MD)as
        for oper in operators
        {
            let index = (operators as NSArray).indexOfObject(oper)
            
            if oper == "*"
            {
                let leftSide = (numbers[index] as NSString).doubleValue
                let rightSide = (numbers[index + 1] as NSString).doubleValue
                
                let answer = leftSide * rightSide
                numbers[index] = String(format: "%f", answer).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "0")).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "."))
                numbers.removeAtIndex(index + 1)
                operators.removeAtIndex(index)
            }
            else if oper == "/"
            {
                let leftSide = (numbers[index] as NSString).doubleValue
                let rightSide = (numbers[index + 1] as NSString).doubleValue
                
                let answer = leftSide / rightSide
                numbers[index] = String(format: "%f", answer).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "0")).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "."))
                numbers.removeAtIndex(index + 1)
                operators.removeAtIndex(index)
            }
        }
        
        //Addition and Subtraction -- pemd(AS)
        for oper in operators
        {
            let index = (operators as NSArray).indexOfObject(oper)
            
            if oper == "+"
            {
                let leftSide = (numbers[index] as NSString).doubleValue
                let rightSide = (numbers[index + 1] as NSString).doubleValue
                
                let answer = leftSide + rightSide
                numbers[index] = String(format: "%f", answer).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "0")).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "."))
                numbers.removeAtIndex(index + 1)
                operators.removeAtIndex(index)
            }
            else if oper == "-"
            {
                let leftSide = (numbers[index] as NSString).doubleValue
                let rightSide = (numbers[index + 1] as NSString).doubleValue
                
                let answer = leftSide - rightSide
                numbers[index] = String(format: "%f", answer).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "0")).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "."))
                numbers.removeAtIndex(index + 1)
                operators.removeAtIndex(index)
            }
        }
        
        finalAnswer = (numbers[0] as NSString).doubleValue
        
        return finalAnswer
    }
    
    // MARK: - Private Methods for Definitions
    //These will NOT be able to be referenced outside this Swift file (They don't need to be).
    
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
