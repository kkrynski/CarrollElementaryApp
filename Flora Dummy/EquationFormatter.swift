//
//  EquationFormatter.swift
//  FloraDummy
//
//  Created by Michael Schloss on 10/26/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class EquationFormatter: NSObject
{
    //Equality Expressions
    private class func operationsArray() -> Array<String>
    {
        return ["+", "-", "*", "/", "^", "(", ")", "="]
    }
    
    class func returnBoxesForEquationString(equation: String) -> NSArray
    {
        let boxes = NSMutableArray()
        
        let stringComponents = equation.componentsSeparatedByString("_")
        
        for component : String in stringComponents
        {
            if component != ""
            {
                let firstChar = (component as NSString).substringWithRange(NSMakeRange(0, 1))
                
                //Test to see if there is a variable
                switch firstChar
                {
                case "#": //We have a variable
                    let varStr = (component as NSString).substringWithRange(NSMakeRange(1, (component as NSString).length - 1))
                    
                    boxes.addObject(createTextBoxForString(varStr))
                    
                    //Answer box requested
                case "?":
                    let answerString = (component as NSString).substringWithRange(NSMakeRange(1, (component as NSString).length - 1))
                    boxes.addObject(createAnswerBoxForAnswer(answerString))
                    
                default:
                    break
                }
                
                //Test to see if the string is a number
                if (component as NSString).rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet()).location != NSNotFound
                {
                    let num = NSNumber(float: (component as NSString).floatValue)
                    
                    boxes.addObject(createNumberTextBoxForNumber(num))
                }
                
                //Test for characters
                for var i = 0; i < operationsArray().count; i++
                {
                    let operatorString = operationsArray()[i]
                    
                    if firstChar == operatorString
                    {
                        //We have an operator
                        boxes.addObject(createOperatorBoxForOperation(component))
                    }
                }
            }
        }
        
        return boxes
    }
    
    //Individual Methods for Creating Box Directories
    
    private class func createOperatorBoxForOperation(operation : String) -> NSDictionary
    {
        let operationBox = NSMutableDictionary()
        
        operationBox.setObject("Operator", forKey: "Type")
        operationBox.setObject(operation, forKey: "Subtype")
        
        return operationBox
    }
    
    private class func createTextBoxForString(string : String) -> NSDictionary
    {
        let textBox = NSMutableDictionary()
        
        textBox.setObject("Text", forKey: "Type")
        textBox.setObject("String", forKey: "Subtype")
        
        return textBox
    }
    
    private class func createNumberTextBoxForNumber(number : NSNumber) -> NSDictionary
    {
        let textBox = NSMutableDictionary()
        
        textBox.setObject("Text", forKey: "Type")
        textBox.setObject("Num_Plain", forKey: "Subtype")
        
        let internalDictionary = NSMutableDictionary()
        internalDictionary.setObject("Num_Plain", forKey: "Type")
        internalDictionary.setObject(number, forKey: "Value")
        
        textBox.setObject([internalDictionary], forKey: "V_Objects")
        
        return textBox
    }
    
    private class func createAnswerBoxForAnswer(answer : String) -> NSDictionary
    {
        let answerBox = NSMutableDictionary()
        
        answerBox.setObject("Answer", forKey: "Type")
        answerBox.setObject("Num_Plain", forKey: "Subtype")
        
        let internalDictionary = NSMutableDictionary()
        internalDictionary.setObject("Num_Plain", forKey: "Type")
        
        answerBox.setObject(internalDictionary, forKey: "V_Objects")
        
        return answerBox
    }
}
