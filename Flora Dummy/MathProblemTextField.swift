//
//  MathProblemTextField.swift
//  FloraDummy
//
//  Created by Michael Schloss on 11/14/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

let MathProblemTextFieldWillReturnNotification = "MathProblemTextFieldWillReturnNotification"

class MathProblemTextField: UITextField, UITextFieldDelegate
{
    private var type : String?
    
    init(frame: CGRect, andTextFieldType textFieldType : String)
    {
        super.init(frame: frame)
        
        type = textFieldType
        setUpTextBox()
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        type = "Whole Number"
        setUpTextBox()
    }
    
    func setUpTextBox()
    {
        switch type!
        {
        case "Variable":
            keyboardType = .Default
            break
            
        case "Whole Number":
            keyboardType = .NumberPad
            break
            
        default:
            keyboardType = .DecimalPad
            break
        }
        
        delegate = self
        
        
        placeholder = "Answer"
        textAlignment = .Center
        font = UIFont(name: "Marker Felt", size: 72)
        minimumFontSize = 10.0
        adjustsFontSizeToFitWidth = true
        
        Definitions.outlineView(self)
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect
    {
        return CGRectInset(bounds, 8, 0);
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect
    {
        return CGRectInset(bounds, 8, 0);
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        let alphabetSet = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let numberSet = NSCharacterSet(charactersInString: "0123456789")
        
        switch type!
        {
        case "Whole Number":
            return (string as NSString).containsString(".") == false && (string as NSString).rangeOfCharacterFromSet(numberSet).location != NSNotFound || string == ""
            
        case "Decimal", "Fraction":
            return (string as NSString).rangeOfCharacterFromSet(alphabetSet).location == NSNotFound && (string as NSString).rangeOfCharacterFromSet(numberSet).location != NSNotFound || string == ""
            
        default:
            return true
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        finalizeEditing()
        return false
    }
    
    func finalizeEditing()
    {
        NSNotificationCenter.defaultCenter().postNotificationName(MathProblemTextFieldWillReturnNotification, object: nil)
        resignFirstResponder()
        endEditing(true)
    }
}
