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
            
            break
            
        case "#fr#":
            
            break
            
        case "#d#":
            
            break
            
        default:
            
            break
        }
    }
}
