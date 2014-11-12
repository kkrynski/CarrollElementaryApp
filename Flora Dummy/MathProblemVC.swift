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
        
        print(backgroundColor)
        
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
        equalsLabel.textColor = primaryColor!
        equalsLabel.center = CGPointMake(equationView.frame.size.width * 0.7, equationView.frame.size.height/2.0)
        equationView.addSubview(equalsLabel)
        
        createEquationLabel(equation[0], inView: equationView)
        createAnswerSpace(equation[1], inView: equationView)
    }
    
    func createEquationLabel(equation : String, inView equationView : UIView)
    {
        
    }
    
    func createAnswerSpace(answer : String, inView equationView : UIView)
    {
        
    }
}
