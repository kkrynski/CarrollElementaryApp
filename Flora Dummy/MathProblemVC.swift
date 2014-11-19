//
//  MathProblemVC.swift
//  FloraDummy
//
//  Created by Michael Schloss on 11/9/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class MathProblemVC: PageVC
{
    //The mathEquation to make
    var mathEquation : String?
    
    class func convertStringIntoEquation(equationString : String) -> Array<String>
    {
        let tempArray = equationString.componentsSeparatedByString("=")
        if tempArray.count != 2
        {
            fatalError("Invalid Math Equation Specified!\n\tGiven Equation: \(equationString)")
        }
        
        return tempArray
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if mathEquation == nil || mathEquation == ""
        {
            fatalError("There is no Math Equation Specified.  Cannot continue.")
        }
        
        let equation = MathProblemVC.convertStringIntoEquation(mathEquation!)
        
        let equationView = UIView(frame: CGRectMake(0, 0, view.frame.size.width * 0.9, view.frame.size.height * 0.4))
        equationView.backgroundColor = Definitions.lighterColorForColor(backgroundColor!)
        Definitions.outlineView(equationView)
        equationView.center = CGPointMake(view.frame.size.width/2.0, view.frame.size.height/2.0)
        view.addSubview(equationView)
        
        let equalsLabel = UILabel()
        equalsLabel.text = "="
        equalsLabel.font = UIFont(name: "Marker Felt", size: 104)
        equalsLabel.sizeToFit()
        Definitions.outlineTextInLabel(equalsLabel)
        equalsLabel.textColor = primaryColor
        equalsLabel.center = CGPointMake(equationView.frame.size.width * 0.7, equationView.frame.size.height/2.0)
        equationView.addSubview(equalsLabel)
        
        let equationViewView = UIView(frame: CGRectMake(8, 8, equalsLabel.frame.origin.x - 8, equationView.frame.size.height - 16))
        equationView.addSubview(equationViewView)
        
        let answerView = UIView(frame: CGRectMake(equalsLabel.frame.origin.x + equalsLabel.frame.size.width + 8, 8, equationView.frame.size.width - 8 - (equalsLabel.frame.origin.x + equalsLabel.frame.size.width + 8), equationView.frame.size.height - 16))
        equationView.addSubview(answerView)
        
        createEquationLabel(equation[0], inView: equationViewView)
        createAnswerSpace(equation[1], inView: answerView)
    }
    
    func createEquationLabel(equation : String, inView equationView : UIView)
    {
        let equationParts = equation.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: " "))
        
        let numberOfLines = Int(ceil(Double(equationParts.count) / 5.0))
        let height = numberOfLines > 1 ? equationView.frame.size.height/CGFloat(numberOfLines) : equationView.frame.size.height/2.0
        
        let insertedEquationParts = NSMutableArray()
        
        var currentLine = -1.0
        
        for var i = 0; i < equationParts.count; i++
        {
            let equationPart = equationParts[i]
            
            if i % 5 == 0
            {
                currentLine += 1.0
            }
            
            if (equationPart as NSString).containsString("[")   //Improper/Proper Fraction
            {
                let equationPartLabel = UILabel()
                equationPartLabel.frame = CGRectMake(0, numberOfLines > 1 ? CGFloat(0.0 + (Double(height) * currentLine)) : CGFloat(equationView.frame.size.height/2.0) - CGFloat(height/2.0), equationView.frame.size.width/5.0, height)
                
                let numbersInFraction = equationPart.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "[]")).componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: ","))
                
                print(numbersInFraction)
                
                equationView.addSubview(equationPartLabel)
                insertedEquationParts.addObject(equationPartLabel)
            }
            else
            {
                let equationPartLabel = UILabel()
                equationPartLabel.font = UIFont(name: "Marker Felt", size: 85)
                equationPartLabel.text = equationPart
                equationPartLabel.textColor = primaryColor
                equationPartLabel.textAlignment = .Center
                Definitions.outlineTextInLabel(equationPartLabel)
                equationPartLabel.adjustsFontSizeToFitWidth = true
                equationPartLabel.minimumScaleFactor = 0.1
                equationPartLabel.frame = CGRectMake(0, numberOfLines > 1 ? CGFloat(0.0 + (Double(height) * currentLine)) : CGFloat(equationView.frame.size.height/2.0) - CGFloat(height/2.0), equationView.frame.size.width/5.0, height)
                equationView.addSubview(equationPartLabel)
                insertedEquationParts.addObject(equationPartLabel)
            }
            
            centerItems(insertedEquationParts, inView: equationView)
        }
    }
    
    private func centerItems(equationItems : NSMutableArray, inView equationView : UIView)
    {
        let numberOfLines = Int(floor(Double(equationItems.count) / 5.0)) + 1
        
        for var i = 0; i < numberOfLines; i++
        {
            let equationPartsInRow = equationItems.subarrayWithRange(NSMakeRange(5 * i, i == equationItems.count / 5 ? min(5, equationItems.count % 5) : 5))
            
            let startingX = equationView.frame.size.width/2.0 - (equationView.frame.size.width/5.0 * CGFloat(equationPartsInRow.count/2)) + (equationItems.count % 2 == 0 ? equationView.frame.size.width/10.0 : 0)
            
            for var j = 0; j < equationPartsInRow.count; j++
            {
                let equationPartItem = equationPartsInRow[j] as UILabel
                equationPartItem.center = CGPointMake(startingX + (equationView.frame.size.width/5.0 * CGFloat(j)), equationPartItem.center.y)
            }
        }
    }
    
    func createAnswerSpace(answer : String, inView answerView : UIView)
    {
        switch answer
        {
        case "#w#":
            let answerSpace = MathProblemTextField(frame: CGRectMake(0, 0, answerView.frame.size.width, answerView.frame.size.height * 0.5), andTextFieldType: "Whole Number")
            answerSpace.center = CGPointMake(answerView.frame.size.width/2.0, answerView.frame.size.height/2.0)
            answerSpace.backgroundColor = Definitions.lighterColorForColor(Definitions.lighterColorForColor(backgroundColor))
            answerSpace.textColor = primaryColor
            answerView.addSubview(answerSpace)
            break
            
        case "#v#":
            let answerSpace = MathProblemTextField(frame: CGRectMake(0, 0, answerView.frame.size.width, answerView.frame.size.height * 0.5), andTextFieldType: "Variable")
            answerSpace.center = CGPointMake(answerView.frame.size.width/2.0, answerView.frame.size.height/2.0)
            answerSpace.backgroundColor = Definitions.lighterColorForColor(Definitions.lighterColorForColor(backgroundColor))
            answerSpace.textColor = primaryColor
            answerView.addSubview(answerSpace)
            break
            
        case "#fr#":
            let topAnswerSpace = MathProblemTextField(frame: CGRectMake(0, 0, answerView.frame.size.width, answerView.frame.size.height * 0.4), andTextFieldType: "Any")
            topAnswerSpace.center = CGPointMake(answerView.frame.size.width/2.0, answerView.frame.size.height/2.0 - 3 - 8 - topAnswerSpace.frame.size.height/2.0)
            topAnswerSpace.backgroundColor = Definitions.lighterColorForColor(Definitions.lighterColorForColor(backgroundColor))
            topAnswerSpace.textColor = primaryColor
            answerView.addSubview(topAnswerSpace)
            
            let line = UIView(frame: CGRectMake(0, 0, answerView.frame.size.width, 6))
            line.center = CGPointMake(answerView.frame.size.width/2.0, answerView.frame.size.height/2.0)
            line.backgroundColor = primaryColor
            answerView.addSubview(line)
            
            let bottomAnswerSpace = MathProblemTextField(frame: CGRectMake(0, 0, answerView.frame.size.width, answerView.frame.size.height * 0.4), andTextFieldType: "Any")
            bottomAnswerSpace.center = CGPointMake(answerView.frame.size.width/2.0, answerView.frame.size.height/2.0 + 3 + 8 + topAnswerSpace.frame.size.height/2.0)
            bottomAnswerSpace.backgroundColor = Definitions.lighterColorForColor(Definitions.lighterColorForColor(backgroundColor))
            bottomAnswerSpace.textColor = primaryColor
            answerView.addSubview(bottomAnswerSpace)
            break
            
        case "#d#":
            let answerSpace = MathProblemTextField(frame: CGRectMake(0, 0, answerView.frame.size.width, answerView.frame.size.height * 0.5), andTextFieldType: "Decimal")
            answerSpace.center = CGPointMake(answerView.frame.size.width/2.0, answerView.frame.size.height/2.0)
            answerSpace.backgroundColor = Definitions.lighterColorForColor(Definitions.lighterColorForColor(backgroundColor))
            answerSpace.textColor = primaryColor
            answerView.addSubview(answerSpace)
            break
            
        default:
            
            break
        }
    }
}
