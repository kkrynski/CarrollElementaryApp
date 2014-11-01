//
//  MathProblemVC_Normal.swift
//  FloraDummy
//
//  Created by Michael Schloss on 10/26/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class MathProblemVC_Normal: PageVC
{
    //Data that is set by incoming ViewControllers
    var mathEquation : String?
    
    var buttonsArray : NSArray?
    var buttonsInfoArray : NSArray?
    var boxesArray : NSArray?
    var boxesInfoArray : NSArray?
    
    //Private data and views
    private var problemBoxView : UIView?
    private var mathBoxView : UIView?
    
    //Contants
    //Problem Box
    private var MARGIN_PB_TOP : Float?
    private var MARGIN_PB_SIDE : Float?
    private var MARGIN_PB_BOTTOM : Float?
    private var PB_X : Float?
    private var PB_Y : Float?
    private var PB_WIDTH : Float?
    private var PB_HEIGHT : Float?
    
    //Math Box
    private var MARGIN_MB_TOP : Float?
    private var MARGIN_MB_SIDE : Float?
    private var MARGIN_MB_BOTTOM : Float?
    private var MB_WIDTH : Float?
    private var MB_HEIGHT : Float?
    
    //Buttons
    private var BUTTON_MARGIN_TOP : Float?
    private var BUTTON_MARGIN_SIDE : Float?
    private var BUTTON_MARGIN_BOTTOM : Float?
    private var BUTTON_MARGIN_BETWEEN : Float?
    private var BUTTON_HEIGHT : Float?
    private var BUTTON_WIDTH : Float?
    
    //Text Boxes
    private var TB_HEIGHT : Float?
    private var TB_WIDTH : Float?
    
    //Answer Boxes
    private var AB_HEIGHT : Float?
    private var AB_WIDTH : Float?
    
    //Operations Boxes
    private var OB_HEIGHT : Float?
    private var OB_WIDTH : Float?
    
    //Spacing
    private var MATHEMATICS_TOP : Float?
    private var MATHEMATICS_BOTTOM : Float?
    private var MATHEMATICS_BETWEEN : Float?
    private var MATHEMATICS_MARGIN_SIDE : Float?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if mathEquation == nil || mathEquation == ""
        {
            mathEquation = "_2_+_4_=_?_"
        }
        
        boxesInfoArray = EquationFormatter.returnBoxesForEquationString(mathEquation!)
        
        let submitButtonInfo = ["Type":"Submit", "Name":"Submit"]
        let helpButtonInfo = ["Type":"Help", "Name":"Help"]
        
        buttonsInfoArray = NSArray(objects: submitButtonInfo, helpButtonInfo)
        
        //Define the constants (refer to above for what they are)
        MARGIN_PB_TOP = 20.0
        MARGIN_PB_SIDE = 37.0
        MARGIN_PB_BOTTOM = 20.0
        PB_X = MARGIN_PB_SIDE!
        PB_Y = Float(dateLabel!.frame.origin.y) + Float(dateLabel!.frame.size.height) + MARGIN_PB_TOP!
        PB_WIDTH = Float(view.bounds.size.width) - (2.0 * MARGIN_PB_SIDE!)
        PB_HEIGHT = Float(previousButton!.frame.origin.y) - PB_Y! - MARGIN_PB_TOP! - MARGIN_PB_BOTTOM!
        
        MARGIN_MB_TOP = 30
        MARGIN_MB_SIDE = 30
        MARGIN_MB_BOTTOM = 180
        MB_WIDTH = PB_WIDTH! - (2 * MARGIN_MB_SIDE!)
        MB_HEIGHT = PB_HEIGHT! - MARGIN_MB_TOP! - MARGIN_MB_BOTTOM!
        
        BUTTON_MARGIN_TOP = 10
        BUTTON_MARGIN_BOTTOM = 10
        BUTTON_MARGIN_BETWEEN = 10
        BUTTON_HEIGHT = 60
        BUTTON_WIDTH = 160
        BUTTON_MARGIN_SIDE = (PB_WIDTH! - (Float(buttonsInfoArray!.count) * BUTTON_WIDTH!) + ((Float(buttonsInfoArray!.count) - 1) * BUTTON_MARGIN_BETWEEN!)) / 2.0
        
        TB_HEIGHT = 100
        TB_WIDTH = 200
        
        AB_HEIGHT = 100
        AB_WIDTH = 200
        
        OB_HEIGHT = 100
        OB_WIDTH = 100
        
        MATHEMATICS_TOP = (MB_HEIGHT! - AB_HEIGHT!)/2.0
        MATHEMATICS_BOTTOM = (MB_HEIGHT! - AB_HEIGHT!)/2.0
        MATHEMATICS_BETWEEN = 10
        
        var boxesWidth : Float = 0.0
        for boxInfo : NSDictionary? in (boxesInfoArray as Array<NSDictionary>)
        {
            switch boxInfo!.objectForKey("Type") as String
            {
            case "Text":
                boxesWidth += TB_WIDTH!
                
            case "Operator":
                boxesWidth += OB_WIDTH!
                
            case "Answer":
                boxesWidth += AB_WIDTH!
                
            default:
                let type = boxInfo!.objectForKey("Type") as String
                fatalError("Unsupported Math Type: \(type)")
            }
        }
        
        MATHEMATICS_MARGIN_SIDE = (MB_WIDTH! - boxesWidth - ((Float(boxesInfoArray!.count) - 1) * MATHEMATICS_BETWEEN!))/2.0
        
        problemBoxView = UIView(frame: CGRectMake(CGFloat(PB_X!), CGFloat(PB_Y!), CGFloat(PB_WIDTH!), CGFloat(PB_HEIGHT!)))
        problemBoxView!.backgroundColor = Definitions.lighterColorForColor(backgroundColor!)
        Definitions.outlineView(problemBoxView!)
        view.addSubview(problemBoxView!)
        
        mathBoxView = UIView(frame: CGRectMake(CGFloat(MARGIN_MB_SIDE!), CGFloat(MARGIN_MB_TOP!), CGFloat(MB_WIDTH!), CGFloat(MB_HEIGHT!)))
        mathBoxView!.backgroundColor = backgroundColor!
        Definitions.outlineView(mathBoxView!)
        problemBoxView!.addSubview(mathBoxView!)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewDidLoad()
        
        problemBoxView!.backgroundColor = Definitions.lighterColorForColor(backgroundColor!)
        mathBoxView!.backgroundColor = backgroundColor
        
        Definitions.outlineView(problemBoxView!)
        Definitions.outlineView(mathBoxView!)
        
        populateMathBox()
        populateButtons()
    }
    
    func populateMathBox()
    {
        let numberFont = UIFont(name: "MarkerFelt-Wide", size: 72.0)
        
        var xCoordinate : Float = MATHEMATICS_MARGIN_SIDE!
        for boxInfo : NSDictionary in (boxesInfoArray! as Array<NSDictionary>)
        {
            switch boxInfo.objectForKey("Type") as String
            {
            case "Text":
                let textLabel = UILabel(frame: CGRectMake(CGFloat(xCoordinate), CGFloat(MATHEMATICS_TOP!), CGFloat(TB_WIDTH!), CGFloat(TB_HEIGHT!)))
                
                //Vertical objects is an array, so for now just take the first one
                let internalDict = (boxInfo.objectForKey("V_Objects") as NSArray).objectAtIndex(0) as NSDictionary
                textLabel.text = String(format: "%.0f", (internalDict.objectForKey("Value") as NSNumber).floatValue)
                
                textLabel.backgroundColor = .clearColor()
                textLabel.textColor = primaryColor!
                textLabel.font = numberFont
                textLabel.textAlignment = .Center
                
                mathBoxView!.addSubview(textLabel)
                
                xCoordinate += TB_WIDTH!
                
            case "Operator":
                let operatorLabel = UILabel(frame: CGRectMake(CGFloat(xCoordinate), CGFloat(MATHEMATICS_TOP!), CGFloat(OB_WIDTH!), CGFloat(OB_HEIGHT!)))
                
                let subType = boxInfo.objectForKey("Subtype") as String
                
                operatorLabel.text = subType
                operatorLabel.backgroundColor = .clearColor()
                operatorLabel.textColor = primaryColor!
                operatorLabel.font = numberFont
                operatorLabel.textAlignment = .Center
                
                mathBoxView!.addSubview(operatorLabel)
                
                xCoordinate += OB_WIDTH!
                
            case "Answer":
                let answerView = UITextView(frame: CGRectMake(CGFloat(xCoordinate), CGFloat(MATHEMATICS_TOP!), CGFloat(AB_WIDTH!), CGFloat(AB_HEIGHT!)))
                
                Definitions.outlineView(answerView)
                
                answerView.backgroundColor = Definitions.lighterColorForColor(backgroundColor!)
                answerView.textColor = primaryColor!
                answerView.font = numberFont
                answerView.textAlignment = .Center
                
                mathBoxView!.addSubview(answerView)
                
                xCoordinate += AB_WIDTH!
                
            default:
                let type = boxInfo.objectForKey("Type") as String
                fatalError("Unsupported Math Type: \(type)")
            }
            
            xCoordinate += MATHEMATICS_BETWEEN!
        }
    }
    
    func populateButtons()
    {
        let buttonFont = UIFont(name: "MarkerFelt-Wide", size: 36.0)
        
        var xCoordinate : Float = BUTTON_MARGIN_SIDE!
        for buttonInfo : NSDictionary in buttonsInfoArray as Array<NSDictionary>
        {
            let type = buttonInfo.objectForKey("Type") as String?
            let name = buttonInfo.objectForKey("Name") as String?
            
            let button = UIButton(frame: CGRectMake(CGFloat(xCoordinate), CGFloat(BUTTON_MARGIN_TOP! + MB_HEIGHT! + Float(mathBoxView!.frame.origin.y)), CGFloat(BUTTON_WIDTH!), CGFloat(BUTTON_HEIGHT!)))
            
            Definitions.outlineButton(button)
            
            button.setTitle(name, forState: .Normal)
            button.titleLabel!.textColor = primaryColor
            button.titleLabel!.font = buttonFont
            button.titleLabel!.textAlignment = .Center
            
            problemBoxView!.addSubview(button)
            
            xCoordinate += BUTTON_WIDTH!
            xCoordinate += MATHEMATICS_BETWEEN!
        }
    }
}
