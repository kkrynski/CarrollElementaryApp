//
//  MathProblemTextField.swift
//  FloraDummy
//
//  Created by Michael Schloss on 11/14/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class MathProblemTextField: UITextField
{
    //The type of text field
    var type : String?
    
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
        
        placeholder = "Answer"
        textAlignment = .Center
        font = UIFont(name: "Marker Felt", size: 68)
        minimumFontSize = 10.0
        adjustsFontSizeToFitWidth = YES
        
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
    
    
}
