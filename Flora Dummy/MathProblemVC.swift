//
//  MathProblemVC.swift
//  FloraDummy
//
//  Created by Michael Schloss on 11/9/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class MathProblemAnswerGradiant : UIView
{
    private var isCorrect = NO
    
    init(frame: CGRect, isCorrect: Bool)
    {
        super.init(frame: frame)
        
        self.isCorrect = isCorrect
        
        self.backgroundColor = UIColor.whiteColor()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext()
        
        var gradient : CGGradientRef
        var colorSpace : CGColorSpaceRef
        
        let locations = [CGFloat(0.0), CGFloat(1.0)]
        
        var colors : Array<CGColorRef>
        
        if isCorrect == YES
        {
            colors = [UIColor.greenColor().CGColor, UIColor.whiteColor().CGColor]
        }
        else
        {
            colors = [UIColor.redColor().CGColor, UIColor.whiteColor().CGColor]
        }
        
        colorSpace = CGColorSpaceCreateDeviceRGB()
        
        gradient = CGGradientCreateWithColors(colorSpace, colors, locations)
        
        var startPoint = CGPointMake(0.0, rect.size.height/2.0)
        var endPoint = CGPointMake(rect.size.width/4.0, rect.size.height/2.0)
        CGContextDrawRadialGradient(context, gradient, CGPointMake(rect.size.width/2.0, rect.size.height/2.0), rect.size.width, CGPointMake(rect.size.width/2.0, rect.size.height/2.0), 0, CGGradientDrawingOptions(0))
    }
}

class MathProblemVC: FormattedVC, UITextFieldDelegate, UIViewControllerTransitioningDelegate
{
    /**
    The Math Equation to be displayed.
    
    Please format your math equation based the following rules:
    
    - Fractions: Use "[X,Y,Z]" to form fractions, where
    - "X" is the whole number (This can be '0')
    - "Y" is the numerator of the fraction
    - "Z" is the denominator of the fraction
    - Exponents: Use "X^Y" to denote an exponent, where
    - "X" is the base
    - "Y" is the power, or exponent
    - Random Numbers: Use "#rw(X,Y)#" to create a random number, where
    - "X" is the starting number
    - "Y" is the ending range of numbers
    - Parentheses: Use "( XX )" to create paretheses, where 'XX' is an equation satisfying the before-mentioned rules
    - NOTE: Parentheses are not supported yet
    
    - Answer Spaces: Use "#X#" to denote answer spaces, where 'X' takes the following substitutions:
    - "w" creates an answer box accepting only Whole Numbers
    - "fr" creates an answer box for fractions accepting any acceptable character
    - "v" creates an answer box accepting only Variables
    - NOTE: Not supported yet
    - "d" creates an answer box accepting decimals
    
    Each item must be have a space on both sides, except if it is the first or last item or it is next to the '=' sign, then only spaces on the inner sides.
    
    - Example: "[1,3,4] + 10 * 20 - 2^3 / #rw(-5,10)#=#w#"
    
    All equations MUST have the Answer Space on the right side of the '=' sign, and all equation data on the left.
    
    */
    var mathEquation : String?
    
    //Private variables for answering
    private var randomNumber : UInt32?
    private var textBoxes : NSMutableArray?
    
    private var equationView : UIView?
    
    private var answers : NSArray!
    private var didCheckAnswers = NO
    
    //Checks to make sure it's a valid equation
    func convertStringIntoEquation(equationString : String) -> Array<String>
    {
        let tempArray = equationString.componentsSeparatedByString("=")
        if tempArray.count != 2
        {
            fatalError("Invalid Math Equation Specified!\n\tGiven Equation: \(equationString)")
        }
        
        return tempArray
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if mathEquation == nil || mathEquation == ""
        {
            fatalError("There is no Math Equation Specified.  Cannot continue.")
        }
        
        //Get the equation, if correct
        let equation = convertStringIntoEquation(mathEquation!)
        
        //Build the equation view
        //This will be where the equation is displayed
        equationView = UIView(frame: CGRectMake(0, 0, view.frame.size.width * 0.9, view.frame.size.height * 0.4))
        equationView!.backgroundColor = Definitions.lighterColorForColor(view.backgroundColor!)
        Definitions.outlineView(equationView!)
        equationView!.center = CGPointMake(view.frame.size.width/2.0, view.frame.size.height/2.0)
        view.addSubview(equationView!)
        
        //Creates and puts the "=" on screen
        let equalsLabel = UILabel()
        equalsLabel.text = "="
        equalsLabel.font = UIFont(name: "Marker Felt", size: 104)
        equalsLabel.sizeToFit()
        Definitions.outlineTextInLabel(equalsLabel)
        equalsLabel.textColor = primaryColor
        equalsLabel.center = CGPointMake(equationView!.frame.size.width * 0.7, equationView!.frame.size.height/2.0)
        equationView!.addSubview(equalsLabel)
        
        //The left side of the "=" sign
        let equationViewView = UIView(frame: CGRectMake(8, 8, equalsLabel.frame.origin.x - 8, equationView!.frame.size.height - 16))
        equationView!.addSubview(equationViewView)
        
        //The right side of the "=" sign
        let answerView = UIView(frame: CGRectMake(equalsLabel.frame.origin.x + equalsLabel.frame.size.width + 28, 8, equationView!.frame.size.width - 28 - (equalsLabel.frame.origin.x + equalsLabel.frame.size.width + 28), equationView!.frame.size.height - 16))
        equationView!.addSubview(answerView)
        
        createEquationLabel(equation[0], inView: equationViewView)
        createAnswerSpace(equation[1], inView: answerView)
        
        let calculatorButton = UIButton(frame: CGRectMake(0, 0, 100, 100))
        calculatorButton.setImage(UIImage(named: "Math"), forState: .Normal)
        calculatorButton.setImage(UIImage(named: "Math2"), forState: .Selected)
        calculatorButton.addTarget(self, action: "presentCalculator", forControlEvents: .TouchUpInside)
        view.addSubview(calculatorButton)
        calculatorButton.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        calculatorButton.center = CGPointMake(view.frame.size.width/2.0, equationView!.frame.size.height/2.0 + equationView!.center.y + 10 + calculatorButton.frame.size.height/2.0)
        
        if answers != nil
        {
            for object in textBoxes!
            {
                let textField = object as UITextField
                if answers[textBoxes!.indexOfObject(object)] as String != "<null>"
                {
                    textField.text = answers[textBoxes!.indexOfObject(object)] as String
                }
            }
            
            if didCheckAnswers == YES
            {
                var answerResult = 0.0
                
                for textBox in (textBoxes! as [AnyObject])
                {
                    let answerBox = textBox as UITextField
                    
                    answerResult += (answerBox.text as NSString).doubleValue
                }
                UIView.performWithoutAnimation({ () -> Void in
                    self.checkAnswer(answerResult, animated: NO)
                })
            }
        }
    }
    
    //MARK: - Save and Restore and Settings
    
    override func restoreActivityState(object: AnyObject!)
    {
        let settings = (object as [AnyObject])[0] as [String : AnyObject]
        mathEquation = settings["Equation"]! as? String
        if let checkedAnswers = (settings["DidCheckAnswers"] as? NSNumber)?.boolValue
        {
            didCheckAnswers = checkedAnswers
        }
        
        if object.count > 1
        {
            answers = ((object as [AnyObject])[1] as [String : NSArray]).values.array[0]
            
        }
        
        view.layoutIfNeeded()
        NSNotificationCenter.defaultCenter().postNotificationName(PageManagerShouldContinuePresentation, object: nil)
    }
    
    override func saveActivityState() -> AnyObject!
    {
        var returnArray = Array<Dictionary<String, AnyObject>>()
        
        var settings = Dictionary<String, AnyObject>()
        settings.updateValue(mathEquation!, forKey: "Equation")
        
        let array = answer()
        var shouldInsertAnswers = NO
        for answer in array
        {
            if answer as String != "<null>"
            {
                shouldInsertAnswers = YES
                break
            }
        }
        
        if shouldInsertAnswers == YES
        {
            settings.updateValue(NSNumber(bool: didCheckAnswers), forKey: "DidCheckAnswers")
            returnArray.append(settings)
            
            var answers = Dictionary<String, NSArray>()
            answers.updateValue(array, forKey: "Answer")
            returnArray.append(answers)
        }
        else
        {
            returnArray.append(settings)
        }
        
        return returnArray
    }
    
    override func settings() -> [NSObject : AnyObject]!
    {
        return ["Math Equation" : "String"]
    }
    
    //Creates the left equation side
    func createEquationLabel(equation : String, inView equationView : UIView)
    {
        //Get each part of the equation
        let equationParts = equation.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: " "))
        
        //Calculate the number of lines
        //Every 5 parts adds a new line
        //Starts at 1
        let numberOfLines = Int(ceil(Double(equationParts.count) / 5.0))
        
        //Calculate the height of each line
        //Simple calculation based on the number of lines
        var height = CGFloat(0.0)
        if numberOfLines > 1
        {
            height = equationView.frame.size.height/CGFloat(numberOfLines)
        }
        else
        {
            height = equationView.frame.size.height/2.0
        }
        
        let insertedEquationParts = NSMutableArray()
        
        var currentLine = -1.0
        
        //Makes the part a UILabel and places it on the correct line
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
                
                assert(numbersInFraction.count == 3, "There needs to be three parts to the fraction.  Output of given fraction: \(numbersInFraction)")
                
                let numerator = UILabel()
                numerator.setTranslatesAutoresizingMaskIntoConstraints(NO)
                numerator.font = UIFont(name: "Marker Felt", size: 64)
                numerator.text = numbersInFraction[1]
                numerator.textColor = primaryColor
                numerator.textAlignment = .Center
                numerator.adjustsFontSizeToFitWidth = YES
                numerator.minimumScaleFactor = 0.1
                Definitions.outlineTextInLabel(numerator)
                equationPartLabel.addSubview(numerator)
                
                let line = UIView()
                line.setTranslatesAutoresizingMaskIntoConstraints(NO)
                line.backgroundColor = primaryColor
                equationPartLabel.addSubview(line)
                
                let denominator = UILabel()
                denominator.setTranslatesAutoresizingMaskIntoConstraints(NO)
                denominator.font = UIFont(name: "Marker Felt", size: 64)
                denominator.text = numbersInFraction[2]
                denominator.textColor = primaryColor
                denominator.textAlignment = .Center
                denominator.adjustsFontSizeToFitWidth = YES
                denominator.minimumScaleFactor = 0.1
                Definitions.outlineTextInLabel(denominator)
                equationPartLabel.addSubview(denominator)
                
                let layoutConstraints = NSMutableArray()
                let views = NSDictionary(objectsAndKeys: numerator, "numerator", denominator, "denominator", line, "line")
                let metrics = NSDictionary(objectsAndKeys: NSNumber(double: 3.0), "lineHeight")
                
                
                if (numbersInFraction[0] != String(0))
                {
                    let improperNumber = UILabel()
                    improperNumber.setTranslatesAutoresizingMaskIntoConstraints(NO)
                    improperNumber.font = UIFont(name: "Marker Felt", size: 72)
                    improperNumber.text = numbersInFraction[0]
                    improperNumber.textColor = primaryColor
                    improperNumber.textAlignment = .Center
                    improperNumber.adjustsFontSizeToFitWidth = YES
                    improperNumber.minimumScaleFactor = 0.1
                    Definitions.outlineTextInLabel(improperNumber)
                    equationPartLabel.addSubview(improperNumber)
                    
                    //Autolayout Code
                    let view = NSDictionary(objectsAndKeys: improperNumber, "improperNumber")
                    
                    layoutConstraints.addObject(NSLayoutConstraint(item: improperNumber, attribute: .Leading, relatedBy: .Equal, toItem: equationPartLabel, attribute: .Leading, multiplier: 1.0, constant: 0.0))
                    layoutConstraints.addObject(NSLayoutConstraint(item: improperNumber, attribute: .Trailing, relatedBy: .Equal, toItem: equationPartLabel, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
                    layoutConstraints.addObject(NSLayoutConstraint(item: improperNumber, attribute: .Top, relatedBy: .Equal, toItem: equationPartLabel, attribute: .Top, multiplier: 1.0, constant: 0.0))
                    layoutConstraints.addObject(NSLayoutConstraint(item: improperNumber, attribute: .Bottom, relatedBy: .Equal, toItem: equationPartLabel, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
                    
                    layoutConstraints.addObject(NSLayoutConstraint(item: numerator, attribute: .Leading, relatedBy: .Equal, toItem: equationPartLabel, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
                }
                else
                {
                    //Autolayout Code
                    layoutConstraints.addObject(NSLayoutConstraint(item: numerator, attribute: .CenterX, relatedBy: .Equal, toItem: equationPartLabel, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
                }
                //Autolayout Code
                layoutConstraints.addObject(NSLayoutConstraint(item: numerator, attribute: .Leading, relatedBy: .Equal, toItem: denominator, attribute: .Leading, multiplier: 1.0, constant: 0.0))
                layoutConstraints.addObject(NSLayoutConstraint(item: numerator, attribute: .Trailing, relatedBy: .Equal, toItem: denominator, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
                layoutConstraints.addObject(NSLayoutConstraint(item: numerator, attribute: .Trailing, relatedBy: .Equal, toItem: equationPartLabel, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
                layoutConstraints.addObject(NSLayoutConstraint(item: line, attribute: .Leading, relatedBy: .Equal, toItem: numerator, attribute: .Leading, multiplier: 1.0, constant: 0.0))
                layoutConstraints.addObject(NSLayoutConstraint(item: line, attribute: .Trailing, relatedBy: .Equal, toItem: numerator, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
                
                layoutConstraints.addObject(NSLayoutConstraint(item: numerator, attribute: .Top, relatedBy: .Equal, toItem: equationPartLabel, attribute: .Top, multiplier: 1.0, constant: 0.0))
                layoutConstraints.addObject(NSLayoutConstraint(item: numerator, attribute: .Bottom, relatedBy: .Equal, toItem: equationPartLabel, attribute: .CenterY, multiplier: 1.0, constant: -4.0))
                layoutConstraints.addObject(NSLayoutConstraint(item: denominator, attribute: .Top, relatedBy: .Equal, toItem: equationPartLabel, attribute: .CenterY, multiplier: 1.0, constant: 4.0))
                layoutConstraints.addObject(NSLayoutConstraint(item: denominator, attribute: .Bottom, relatedBy: .Equal, toItem: equationPartLabel, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
                layoutConstraints.addObject(NSLayoutConstraint(item: line, attribute: .CenterY, relatedBy: .Equal, toItem: equationPartLabel, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
                layoutConstraints.addObject(NSLayoutConstraint(item: line, attribute: .Top, relatedBy: .Equal, toItem: numerator, attribute: .Bottom, multiplier: 1.0, constant: 2.0))
                layoutConstraints.addObject(NSLayoutConstraint(item: line, attribute: .Bottom, relatedBy: .Equal, toItem: denominator, attribute: .Top, multiplier: 1.0, constant: -2.0))
                
                equationPartLabel.addConstraints(layoutConstraints)
                
                equationView.addSubview(equationPartLabel)
                insertedEquationParts.addObject(equationPartLabel)
            }
            else if (equationPart as NSString).containsString("#rw")    //Random Number
            {
                let numbers = equationPart.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "#rw()")).componentsSeparatedByString(",")
                
                randomNumber = arc4random_uniform(UInt32((numbers[1] as NSString).integerValue - (numbers[1] as NSString).integerValue)) + (numbers[0] as NSString).integerValue
                
                let equationPartLabel = UILabel()
                equationPartLabel.font = UIFont(name: "Marker Felt", size: 85)
                equationPartLabel.text = String(randomNumber!)
                equationPartLabel.textColor = primaryColor
                equationPartLabel.textAlignment = .Center
                Definitions.outlineTextInLabel(equationPartLabel)
                equationPartLabel.adjustsFontSizeToFitWidth = YES
                equationPartLabel.minimumScaleFactor = 0.1
                equationPartLabel.frame = CGRectMake(0, numberOfLines > 1 ? CGFloat(0.0 + (Double(height) * currentLine)) : CGFloat(equationView.frame.size.height/2.0) - CGFloat(height/2.0), equationView.frame.size.width/5.0, height)
                equationView.addSubview(equationPartLabel)
                insertedEquationParts.addObject(equationPartLabel)
            }
            else if (equationPart as NSString).containsString("^")      //Exponentiation
            {
                let equationPartLabel = UILabel()
                equationPartLabel.frame = CGRectMake(0, numberOfLines > 1 ? CGFloat(0.0 + (Double(height) * currentLine)) : CGFloat(equationView.frame.size.height/2.0) - CGFloat(height/2.0), equationView.frame.size.width/5.0, height)
                equationPartLabel.font = UIFont(name: "Marker Felt", size: 85)
                
                let location = (equationPart as NSString).rangeOfString("^").location
                let range = (equationPart as NSString).length - location - 1
                let equationString = (equationPart as NSString).stringByReplacingOccurrencesOfString("^", withString: "")
                
                let attributedString = NSMutableAttributedString(string: equationString, attributes: [NSFontAttributeName : equationPartLabel.font])
                if numberOfLines < 3
                {
                    attributedString.addAttribute(NSBaselineOffsetAttributeName, value: NSNumber(float: Float(equationPartLabel.frame.size.height/4.0)), range: NSMakeRange(location, range))
                }
                else
                {
                    attributedString.addAttribute(NSBaselineOffsetAttributeName, value: NSNumber(float: Float(equationPartLabel.frame.size.height - 42)), range: NSMakeRange(location, range))
                }
                attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Marker Felt", size: 42)!, range: NSMakeRange(location, range))
                
                equationPartLabel.attributedText = attributedString
                equationPartLabel.textColor = primaryColor
                equationPartLabel.textAlignment = .Center
                Definitions.outlineTextInLabel(equationPartLabel)
                equationPartLabel.adjustsFontSizeToFitWidth = YES
                equationPartLabel.minimumScaleFactor = 0.1
                equationView.addSubview(equationPartLabel)
                insertedEquationParts.addObject(equationPartLabel)
            }
            else    //Normal text
            {
                let equationPartLabel = UILabel()
                equationPartLabel.font = UIFont(name: "Marker Felt", size: 85)
                equationPartLabel.text = equationPart
                equationPartLabel.textColor = primaryColor
                equationPartLabel.textAlignment = .Center
                Definitions.outlineTextInLabel(equationPartLabel)
                equationPartLabel.adjustsFontSizeToFitWidth = YES
                equationPartLabel.minimumScaleFactor = 0.1
                equationPartLabel.frame = CGRectMake(0, numberOfLines > 1 ? CGFloat(0.0 + (Double(height) * currentLine)) : CGFloat(equationView.frame.size.height/2.0) - CGFloat(height/2.0), equationView.frame.size.width/5.0, height)
                equationView.addSubview(equationPartLabel)
                insertedEquationParts.addObject(equationPartLabel)
            }
            
            //Center all the items every time we add a new one
            centerItems(insertedEquationParts, inView: equationView)
        }
    }
    
    //Centers the items on the equation side
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
    
    //Creates the answer space (right side)
    func createAnswerSpace(answer : String, inView answerView : UIView)
    {
        textBoxes = NSMutableArray()
        
        switch answer
        {
        case "#w#":
            let answerSpace = MathProblemTextField(frame: CGRectMake(0, 0, answerView.frame.size.width, answerView.frame.size.height * 0.5), andTextFieldType: "Whole Number")
            answerSpace.center = CGPointMake(answerView.frame.size.width/2.0, answerView.frame.size.height/2.0)
            answerSpace.backgroundColor = Definitions.lighterColorForColor(Definitions.lighterColorForColor(view.backgroundColor!))
            answerSpace.textColor = primaryColor
            answerSpace.delegate = self
            answerView.addSubview(answerSpace)
            textBoxes!.addObject(answerSpace)
            break
            
        case "#v#":
            let answerSpace = MathProblemTextField(frame: CGRectMake(0, 0, answerView.frame.size.width, answerView.frame.size.height * 0.5), andTextFieldType: "Variable")
            answerSpace.center = CGPointMake(answerView.frame.size.width/2.0, answerView.frame.size.height/2.0)
            answerSpace.backgroundColor = Definitions.lighterColorForColor(Definitions.lighterColorForColor(view.backgroundColor!))
            answerSpace.textColor = primaryColor
            answerSpace.delegate = self
            answerView.addSubview(answerSpace)
            textBoxes!.addObject(answerSpace)
            break
            
        case "#fr#":
            let topAnswerSpace = MathProblemTextField(frame: CGRectMake(0, 0, answerView.frame.size.width, answerView.frame.size.height * 0.4), andTextFieldType: "Any")
            topAnswerSpace.center = CGPointMake(answerView.frame.size.width/2.0, answerView.frame.size.height/2.0 - 3 - 8 - topAnswerSpace.frame.size.height/2.0)
            topAnswerSpace.backgroundColor = Definitions.lighterColorForColor(Definitions.lighterColorForColor(view.backgroundColor!))
            topAnswerSpace.textColor = primaryColor
            topAnswerSpace.delegate = self
            answerView.addSubview(topAnswerSpace)
            textBoxes!.addObject(topAnswerSpace)
            
            let line = UIView(frame: CGRectMake(0, 0, answerView.frame.size.width, 6))
            line.center = CGPointMake(answerView.frame.size.width/2.0, answerView.frame.size.height/2.0)
            line.backgroundColor = primaryColor
            answerView.addSubview(line)
            
            let bottomAnswerSpace = MathProblemTextField(frame: CGRectMake(0, 0, answerView.frame.size.width, answerView.frame.size.height * 0.4), andTextFieldType: "Any")
            bottomAnswerSpace.center = CGPointMake(answerView.frame.size.width/2.0, answerView.frame.size.height/2.0 + 3 + 8 + topAnswerSpace.frame.size.height/2.0)
            bottomAnswerSpace.backgroundColor = Definitions.lighterColorForColor(Definitions.lighterColorForColor(view.backgroundColor!))
            bottomAnswerSpace.textColor = primaryColor
            bottomAnswerSpace.delegate = self
            answerView.addSubview(bottomAnswerSpace)
            textBoxes!.addObject(bottomAnswerSpace)
            break
            
        case "#d#":
            let answerSpace = MathProblemTextField(frame: CGRectMake(0, 0, answerView.frame.size.width, answerView.frame.size.height * 0.5), andTextFieldType: "Decimal")
            answerSpace.center = CGPointMake(answerView.frame.size.width/2.0, answerView.frame.size.height/2.0)
            answerSpace.backgroundColor = Definitions.lighterColorForColor(Definitions.lighterColorForColor(view.backgroundColor!))
            answerSpace.textColor = primaryColor
            answerSpace.delegate = self
            answerView.addSubview(answerSpace)
            textBoxes!.addObject(answerSpace)
            break
            
        default:
            
            break
        }
    }
    
    //MARK: - Answer box methods
    
    //Checks the answer.  Answer box(es) must be in right side
    func checkAnswer(textBoxAnswer : Double, animated: Bool)
    {
        //Build final result
        
        let equation = mathEquation!.componentsSeparatedByString("=")
        let parts = equation[0].componentsSeparatedByString(" ")
        
        var finalResult = 0.0
        var operation = 0
        var currentNumber = 0.0
        
        for part in parts
        {
            if part != "+" && part != "-" && part != "/" && part != "*" //It's a number
            {
                if (part as NSString).containsString("[")   //Fraction
                {
                    let numbersInFraction = part.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "[]")).componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: ","))
                    if (numbersInFraction[0] as NSString).doubleValue != 0.0
                    {
                        currentNumber += (numbersInFraction[1] as NSString).doubleValue
                        currentNumber += (numbersInFraction[0] as NSString).doubleValue * (numbersInFraction[2] as NSString).doubleValue
                    }
                    else
                    {
                        currentNumber += (numbersInFraction[1] as NSString).doubleValue
                    }
                    currentNumber /= (numbersInFraction[2] as NSString).doubleValue
                }
                else if (part as NSString).containsString("^")  //Power
                {
                    let powerNumbers = part.componentsSeparatedByString("^")
                    currentNumber += pow((powerNumbers[0] as NSString).doubleValue, (powerNumbers[1] as NSString).doubleValue)
                }
                else if (part as NSString).containsString("#rw")    //Random number
                {
                    currentNumber += Double(randomNumber!)
                }
                else    //Just a normal number
                {
                    currentNumber += (part as NSString).doubleValue
                }
                
                switch operation
                {
                case 1:
                    finalResult += currentNumber
                    currentNumber = 0.0
                    break
                    
                case 2:
                    finalResult -= currentNumber
                    currentNumber = 0.0
                    break
                    
                case 3:
                    finalResult /= currentNumber
                    currentNumber = 0.0
                    break
                    
                case 4:
                    finalResult *= currentNumber
                    currentNumber = 0.0
                    break
                    
                default:
                    finalResult = currentNumber
                    currentNumber = 0.0
                    break
                }
            }
            else    //It's an operation
            {
                switch part
                {
                case "+":
                    operation = 1
                    break
                    
                case "-":
                    operation = 2
                    break
                    
                case "/":
                    operation = 3
                    break
                    
                case "*":
                    operation = 4
                    break
                    
                default:
                    operation = 0
                    break
                }
            }
        }
        
        //Do checking
        if textBoxAnswer == finalResult
        {
            showCorrect(animated)
        }
        else
        {
            showIncorrect(animated)
        }
    }
    
    private func showCorrect(animated: Bool)
    {
        didCheckAnswers = YES
        
        let correctView = UIView(frame: CGRectMake(0, 0, equationView!.frame.size.width, equationView!.frame.size.height))
        correctView.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.8)
        correctView.alpha = 0.0
        correctView.clipsToBounds = YES
        equationView!.addSubview(correctView)
        
        let correctLabel = UILabel()
        correctLabel.alpha = 0.0
        correctLabel.text = "Correct!"
        correctLabel.textColor = primaryColor
        correctLabel.font = UIFont(name: "MarkerFelt-Thin", size: 72)
        correctLabel.sizeToFit()
        Definitions.outlineTextInLabel(correctLabel)
        correctLabel.center = CGPointMake(correctView.frame.size.width/2.0, correctView.frame.size.height/2.0)
        correctView.addSubview(correctLabel)
        correctLabel.transform = CGAffineTransformMakeScale(0.3, 0.3)
        
        UIView.animateWithDuration(animated == YES ? 0.3 : 0.0, delay: 0.0, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
            
            correctView.alpha = 1.0
            
            }, completion: { (finished) -> Void in
                
                UIView.animateWithDuration(animated == YES ? 0.3 : 0.0, delay: 0.0, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                    
                    correctLabel.alpha = 1.0
                    
                    }, completion: nil)
                UIView.animateWithDuration(animated == YES ? 0.5 : 0.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                    
                    correctLabel.transform = CGAffineTransformIdentity
                    
                    }, completion: nil)
                
        })
    }
    
    private func showIncorrect(animated: Bool)
    {
        let incorrectView = UIView(frame: CGRectMake(0, 0, equationView!.frame.size.width, equationView!.frame.size.height))
        incorrectView.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.8)
        incorrectView.alpha = 0.0
        incorrectView.clipsToBounds = YES
        equationView!.addSubview(incorrectView)
        
        let incorrectLabel = UILabel()
        incorrectLabel.alpha = 0.0
        incorrectLabel.text = "Incorrect!\nPlease try again!"
        incorrectLabel.numberOfLines = 0
        incorrectLabel.textAlignment = .Center
        incorrectLabel.textColor = primaryColor
        incorrectLabel.font = UIFont(name: "MarkerFelt-Thin", size: 72)
        incorrectLabel.sizeToFit()
        Definitions.outlineTextInLabel(incorrectLabel)
        incorrectLabel.center = CGPointMake(incorrectView.frame.size.width/2.0, incorrectView.frame.size.height/2.0)
        incorrectView.addSubview(incorrectLabel)
        incorrectLabel.transform = CGAffineTransformMakeScale(0.3, 0.3)
        
        UIView.animateWithDuration(animated == YES ? 0.3 : 0.0, delay: 0.0, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
            
            incorrectView.alpha = 1.0
            
            }, completion: { (finished) -> Void in
                
                UIView.animateWithDuration(animated == YES ? 0.3 : 0.0, delay: 0.0, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                    
                    incorrectLabel.alpha = 1.0
                    
                    }, completion: nil)
                UIView.animateWithDuration(animated == YES ? 0.5 : 0.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                    
                    incorrectLabel.transform = CGAffineTransformIdentity
                    
                    }, completion: { (finished) -> Void in
                        
                        UIView.animateWithDuration(animated == YES ? 0.3 : 0.0, delay: 1.0, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                            
                            incorrectView.alpha = 0.0
                            incorrectLabel.transform = CGAffineTransformMakeScale(2.0, 2.0)
                            
                            }, completion: { (finished) -> Void in
                                
                                incorrectView.removeFromSuperview()
                        })
                })
        })
    }
    
    //MARK: - MathProblemTextField Delegate Methods
    
    //Makes sure user isn't entering incompatible characters
    func textField(textField: MathProblemTextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        let alphabetSet = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-")
        let numberSet = NSCharacterSet(charactersInString: "0123456789-")
        
        switch textField.type!
        {
        case "Whole Number":
            return (string as NSString).containsString(".") == NO && (string as NSString).rangeOfCharacterFromSet(numberSet).location != NSNotFound || string == ""
            
        case "Decimal", "Fraction":
            return (string as NSString).rangeOfCharacterFromSet(alphabetSet).location == NSNotFound && (string as NSString).rangeOfCharacterFromSet(numberSet).location != NSNotFound || string == "" || string == "."
            
        default:
            return (string as NSString).rangeOfCharacterFromSet(alphabetSet).location != NSNotFound || (string as NSString).rangeOfCharacterFromSet(numberSet).location != NSNotFound || string == ""
        }
    }
    
    //Move to next text field, or calculte answer if last text field is active
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField === textBoxes!.lastObject
        {
            finalizeEditing(textField)
        }
        else
        {
            textField.resignFirstResponder()
            (textBoxes!.objectAtIndex(textBoxes!.indexOfObject(textField) + 1) as UITextField).becomeFirstResponder()
        }
        
        return NO
    }
    
    //calculate answer and return good or bad
    private func finalizeEditing(textField: UITextField)
    {
        textField.resignFirstResponder()
        textField.endEditing(YES)
        
        var answerResult = 0.0
        
        for textBox in (textBoxes! as Array<AnyObject>)
        {
            let answerBox = textBox as UITextField
            
            answerResult += (answerBox.text as NSString).doubleValue
        }
        checkAnswer(answerResult, animated: YES)
    }
    
    private func answer() -> NSArray
    {
        var answerResult = Array<String>()
        
        for textBox in (textBoxes! as Array<AnyObject>)
        {
            let answerBox = textBox as UITextField
            
            if answerBox.text != nil && answerBox.text != ""
            {
                answerResult.append(answerBox.text)
            }
            else
            {
                answerResult.append("<null>")
            }
        }
        
        return answerResult
    }
    
    //MARK: - Calculator Presentation
    
    //Open the calculator
    func presentCalculator()
    {
        let calculator = CalculatorVC()
        calculator.modalPresentationStyle = .Custom
        calculator.transitioningDelegate = self
        calculator.preferredContentSize = CGSizeMake(304, 508)
        presentViewController(calculator, animated: YES, completion: nil)
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController?
    {
        if presented.classForCoder === CalculatorVC.classForCoder()
        {
            return CalculatorPresentationController(presentedViewController: presented, presentingViewController: presenting)
        }
        return nil
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        if presented.classForCoder === CalculatorVC.classForCoder()
        {
            return CalculatorTransitionManager(isPresenting: YES)
        }
        return nil
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        if dismissed.classForCoder === CalculatorVC.classForCoder()
        {
            return CalculatorTransitionManager(isPresenting: NO)
        }
        return nil
    }
}
