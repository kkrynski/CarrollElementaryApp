//
//  PasswordVC.swift
//  FloraDummy
//
//  Created by Michael Schloss on 2/27/15.
//  Copyright (c) 2015 SGSC. All rights reserved.
//

import UIKit

class PasswordVC: FormattedVC, UITextFieldDelegate
{
    var backgroundView : UIView!
    
    var infoView : UIView!
    private var infoViewConstraints = Array<NSLayoutConstraint>()
    private var newInfoViewConstraints = Array<NSLayoutConstraint>()
    
    private var accountsWereDownloaded = NO
    private var userIsWaiting = NO
    private var timeoutTimer : NSTimer!
    
    private var titleLabel : UILabel!
    private var usernameLabel : UILabel!
    private var passwordLabel : UILabel!
    private var usernameField : UITextField!
    private var passwordField : UITextField!
    private var submitButton : UIButton!
    private var otherLoginButton : UIButton!
    
    private var loadingWheel : UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userAccountsDownloaded", name: UserAccountsDownloaded, object: nil)
        CESDatabase.databaseManagerForPasswordVCClass().downloadUserAccounts()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateColors", name: ColorSchemeDidChangeNotification, object: nil)
        
        //Set up the backgroundView for animation
        backgroundView = UIView()
        backgroundView.alpha = 0.0
        backgroundView.setTranslatesAutoresizingMaskIntoConstraints(NO)
        backgroundView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        backgroundView.layer.rasterizationScale = UIScreen.mainScreen().scale
        backgroundView.layer.shouldRasterize = YES
        view.addSubview(backgroundView)
        view.addConstraint(NSLayoutConstraint(item: backgroundView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: backgroundView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: backgroundView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: backgroundView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        
        //Set up the infoView.  This will will hold all of the login stuff
        infoView = UIView()
        infoView.setTranslatesAutoresizingMaskIntoConstraints(NO)
        infoView.clipsToBounds = YES
        infoView.layer.cornerRadius = 20.0
        infoView.backgroundColor = view.backgroundColor
        infoView.layer.rasterizationScale = UIScreen.mainScreen().scale
        infoView.layer.shouldRasterize = YES
        view.addSubview(infoView)
        infoViewConstraints.append(NSLayoutConstraint(item: infoView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.8, constant: 0.0))
        infoViewConstraints.append(NSLayoutConstraint(item: infoView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.8, constant: 0.0))
        infoViewConstraints.append(NSLayoutConstraint(item: infoView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        infoViewConstraints.append(NSLayoutConstraint(item: infoView, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        view.addConstraints(infoViewConstraints)
        
        switch NSUserDefaults.standardUserDefaults().stringForKey("defaultLogin")!
        {
        case "Student":
            setUpScreenForStudentInView(infoView)
            break
            
        case "Teacher":
            setUpScreenForTeacherInView(infoView)
            break
            
        default:
            break
        }
        
        view.layoutIfNeeded()
        infoView.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        updateColors()
    }
    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?)
    {
        super.dismissViewControllerAnimated(flag, completion: completion)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        timeoutTimer?.invalidate()
    }
    
    override func updateColors()
    {
        super.updateColors()
        
        //Make sure the backgroundColor is correct
        if infoView != nil
        {
            UIView.animateWithDuration(0.3, delay: 0.0, options: .AllowUserInteraction | .AllowAnimatedContent, animations: { () -> Void in
                self.infoView.backgroundColor = self.view.backgroundColor
                
                self.titleLabel.textColor = self.primaryColor
                Definitions.outlineTextInLabel(self.titleLabel)
                
                self.usernameLabel.textColor = self.primaryColor
                Definitions.outlineTextInLabel(self.usernameLabel)
                
                self.passwordLabel.textColor = self.primaryColor
                Definitions.outlineTextInLabel(self.passwordLabel)
                
                self.usernameField.textColor = self.primaryColor
                self.usernameField.backgroundColor = Definitions.darkerColorForColor(self.view.backgroundColor!)
                
                self.passwordField.textColor = self.primaryColor
                self.passwordField.backgroundColor = Definitions.darkerColorForColor(self.view.backgroundColor!)
                
                self.submitButton.titleLabel!.textColor = self.primaryColor
                self.submitButton.backgroundColor = Definitions.darkerColorForColor(self.view.backgroundColor!)
                
                self.otherLoginButton.titleLabel!.textColor = self.primaryColor
                self.otherLoginButton.backgroundColor = Definitions.darkerColorForColor(self.view.backgroundColor!)
                }, completion: nil)
        }
        
        //We want a clear, see-through background
        view.backgroundColor = .clearColor()
    }
    
    private func setUpScreenForStudentInView(view: UIView)
    {
        titleLabel = UILabel()
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(NO)
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "MarkerFelt-Wide", size: 72)
        titleLabel.text = "Please Log In!"
        titleLabel.layer.rasterizationScale = UIScreen.mainScreen().scale
        titleLabel.layer.shouldRasterize = YES
        view.addSubview(titleLabel)
        view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.8, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Top, relatedBy: .Equal, toItem:view, attribute: .Top, multiplier: 1.0, constant: 20.0))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleLabel(height)]", options: NSLayoutFormatOptions(0), metrics: ["height":titleLabel.font.lineHeight], views: ["titleLabel":titleLabel]))
        titleLabel.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        usernameLabel = UILabel()
        usernameLabel.setTranslatesAutoresizingMaskIntoConstraints(NO)
        usernameLabel.textAlignment = .Center
        usernameLabel.font = UIFont(name: "Marker Felt", size: 48)
        usernameLabel.text = "Username"
        usernameLabel.layer.rasterizationScale = UIScreen.mainScreen().scale
        usernameLabel.layer.shouldRasterize = YES
        view.addSubview(usernameLabel)
        view.addConstraint(NSLayoutConstraint(item: usernameLabel, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.5, constant: -60.0))
        view.addConstraint(NSLayoutConstraint(item: usernameLabel, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: -20.0))
        view.addConstraint(NSLayoutConstraint(item: usernameLabel, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: -20.0))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[usernameLabel(height)]", options: NSLayoutFormatOptions(0), metrics: ["height":usernameLabel.font.lineHeight], views: ["usernameLabel":usernameLabel]))
        usernameLabel.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        passwordLabel = UILabel()
        passwordLabel.setTranslatesAutoresizingMaskIntoConstraints(NO)
        passwordLabel.textAlignment = .Center
        passwordLabel.font = UIFont(name: "Marker Felt", size: 48)
        passwordLabel.text = "Password"
        passwordLabel.layer.rasterizationScale = UIScreen.mainScreen().scale
        passwordLabel.layer.shouldRasterize = YES
        view.addSubview(passwordLabel)
        view.addConstraint(NSLayoutConstraint(item: passwordLabel, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.5, constant: -60.0))
        view.addConstraint(NSLayoutConstraint(item: passwordLabel, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 20.0))
        view.addConstraint(NSLayoutConstraint(item: passwordLabel, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: -20.0))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[passwordLabel(height)]", options: NSLayoutFormatOptions(0), metrics: ["height":passwordLabel.font.lineHeight], views: ["passwordLabel":passwordLabel]))
        passwordLabel.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        usernameField = UITextField()
        usernameField.setTranslatesAutoresizingMaskIntoConstraints(NO)
        usernameField.delegate = self
        usernameField.placeholder = "Username"
        usernameField.font = UIFont(name: "Marker Felt", size: 36)
        usernameField.clearButtonMode = .WhileEditing
        usernameField.returnKeyType = .Next
        usernameField.leftView = UIView(frame: CGRectMake(0, 0, 10, 10))
        usernameField.leftViewMode = .Always
        usernameField.layer.cornerRadius = 10.0
        usernameField.layer.shouldRasterize = YES
        usernameField.layer.rasterizationScale = UIScreen.mainScreen().scale
        view.addSubview(usernameField)
        view.addConstraint(NSLayoutConstraint(item: usernameField, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.5, constant: -60.0))
        view.addConstraint(NSLayoutConstraint(item: usernameField, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: -20.0))
        view.addConstraint(NSLayoutConstraint(item: usernameField, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 20.0))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[usernameField(height)]", options: NSLayoutFormatOptions(0), metrics: ["height":usernameField.font.lineHeight * 1.5], views: ["usernameField":usernameField]))
        usernameField.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        passwordField = UITextField()
        passwordField.setTranslatesAutoresizingMaskIntoConstraints(NO)
        passwordField.delegate = self
        passwordField.placeholder = "Password"
        passwordField.secureTextEntry = YES
        passwordField.font = UIFont(name: "Marker Felt", size: 36)
        passwordField.clearButtonMode = .WhileEditing
        passwordField.returnKeyType = .Go
        passwordField.leftView = UIView(frame: CGRectMake(0, 0, 10, 10))
        passwordField.leftViewMode = .Always
        passwordField.layer.cornerRadius = 10.0
        passwordField.layer.shouldRasterize = YES
        passwordField.layer.rasterizationScale = UIScreen.mainScreen().scale
        view.addSubview(passwordField)
        view.addConstraint(NSLayoutConstraint(item: passwordField, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.5, constant: -60.0))
        view.addConstraint(NSLayoutConstraint(item: passwordField, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 20.0))
        view.addConstraint(NSLayoutConstraint(item: passwordField, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 20.0))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[passwordField(height)]", options: NSLayoutFormatOptions(0), metrics: ["height":passwordField.font.lineHeight * 1.5], views: ["passwordField":passwordField]))
        passwordField.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        submitButton = UIButton_Typical()
        submitButton.setTranslatesAutoresizingMaskIntoConstraints(NO)
        submitButton.setTitle("Begin!", forState: .Normal)
        submitButton.titleLabel!.font = UIFont(name: "Marker Felt", size: 42)
        submitButton.addTarget(self, action: "attemptToLogin", forControlEvents: .TouchUpInside)
        submitButton.layer.cornerRadius = 10.0
        submitButton.layer.shouldRasterize = YES
        submitButton.layer.rasterizationScale = UIScreen.mainScreen().scale
        view.addSubview(submitButton)
        view.addConstraint(NSLayoutConstraint(item: submitButton, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.3, constant: -60.0))
        view.addConstraint(NSLayoutConstraint(item: submitButton, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: submitButton, attribute: .Top, relatedBy: .Equal, toItem: usernameField, attribute: .Bottom, multiplier: 1.0, constant: 40.0))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[submitButton(height)]", options: NSLayoutFormatOptions(0), metrics: ["height":submitButton.titleLabel!.font.lineHeight * 1.5], views: ["submitButton":submitButton]))
        submitButton.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        loadingWheel = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        loadingWheel.setTranslatesAutoresizingMaskIntoConstraints(NO)
        loadingWheel.startAnimating()
        loadingWheel.alpha = 0.0
        view.addSubview(loadingWheel)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[loadingWheel(39)]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["loadingWheel":loadingWheel]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[loadingWheel(39)]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["loadingWheel":loadingWheel]))
        view.addConstraint(NSLayoutConstraint(item: loadingWheel, attribute: .CenterX, relatedBy: .Equal, toItem: submitButton, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: loadingWheel, attribute: .CenterY, relatedBy: .Equal, toItem: submitButton, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        view.layoutIfNeeded()
        loadingWheel.transform = CGAffineTransformMakeScale(2.0, 2.0)
        
        otherLoginButton = UIButton_Typical()
        otherLoginButton.setTranslatesAutoresizingMaskIntoConstraints(NO)
        otherLoginButton.setTitle("Are you a teacher? Press here!", forState: .Normal)
        otherLoginButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        otherLoginButton.addTarget(self, action: "switchAccountLoginType", forControlEvents: .TouchUpInside)
        otherLoginButton.layer.cornerRadius = 10.0
        otherLoginButton.layer.shouldRasterize = YES
        otherLoginButton.layer.rasterizationScale = UIScreen.mainScreen().scale
        view.addSubview(otherLoginButton)
        view.addConstraint(NSLayoutConstraint(item: otherLoginButton, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.5, constant: -60.0))
        view.addConstraint(NSLayoutConstraint(item: otherLoginButton, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: otherLoginButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[otherLoginButton(height)]", options: NSLayoutFormatOptions(0), metrics: ["height":otherLoginButton.titleLabel!.font.lineHeight * 1.5], views: ["otherLoginButton":otherLoginButton]))
        otherLoginButton.transform = CGAffineTransformMakeScale(0.0, 0.0)
    }
    
    private func setUpScreenForTeacherInView(view: UIView)
    {
        titleLabel = UILabel()
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(NO)
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 42)
        titleLabel.text = "Please enter your login credentials"
        titleLabel.layer.rasterizationScale = UIScreen.mainScreen().scale
        titleLabel.layer.shouldRasterize = YES
        view.addSubview(titleLabel)
        view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.9, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Top, relatedBy: .Equal, toItem:view, attribute: .Top, multiplier: 1.0, constant: 20.0))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleLabel(height)]", options: NSLayoutFormatOptions(0), metrics: ["height":titleLabel.font.lineHeight], views: ["titleLabel":titleLabel]))
        titleLabel.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        usernameLabel = UILabel()
        usernameLabel.setTranslatesAutoresizingMaskIntoConstraints(NO)
        usernameLabel.textAlignment = .Center
        usernameLabel.font = UIFont(name: "HelveticaNeue-Light", size: 48)
        usernameLabel.text = "Username"
        usernameLabel.layer.rasterizationScale = UIScreen.mainScreen().scale
        usernameLabel.layer.shouldRasterize = YES
        view.addSubview(usernameLabel)
        view.addConstraint(NSLayoutConstraint(item: usernameLabel, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.5, constant: -60.0))
        view.addConstraint(NSLayoutConstraint(item: usernameLabel, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: -20.0))
        view.addConstraint(NSLayoutConstraint(item: usernameLabel, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: -10.0))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[usernameLabel(height)]", options: NSLayoutFormatOptions(0), metrics: ["height":usernameLabel.font.lineHeight], views: ["usernameLabel":usernameLabel]))
        usernameLabel.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        passwordLabel = UILabel()
        passwordLabel.setTranslatesAutoresizingMaskIntoConstraints(NO)
        passwordLabel.textAlignment = .Center
        passwordLabel.font = UIFont(name: "HelveticaNeue-Light", size: 48)
        passwordLabel.text = "Password"
        passwordLabel.layer.rasterizationScale = UIScreen.mainScreen().scale
        passwordLabel.layer.shouldRasterize = YES
        view.addSubview(passwordLabel)
        view.addConstraint(NSLayoutConstraint(item: passwordLabel, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.5, constant: -60.0))
        view.addConstraint(NSLayoutConstraint(item: passwordLabel, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 20.0))
        view.addConstraint(NSLayoutConstraint(item: passwordLabel, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: -10.0))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[passwordLabel(height)]", options: NSLayoutFormatOptions(0), metrics: ["height":passwordLabel.font.lineHeight], views: ["passwordLabel":passwordLabel]))
        passwordLabel.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        usernameField = UITextField()
        usernameField.setTranslatesAutoresizingMaskIntoConstraints(NO)
        usernameField.delegate = self
        usernameField.placeholder = "Username"
        usernameField.font = UIFont(name: "HelveticaNeue-Light", size: 36)
        usernameField.clearButtonMode = .WhileEditing
        usernameField.returnKeyType = .Next
        usernameField.leftView = UIView(frame: CGRectMake(0, 0, 10, 10))
        usernameField.leftViewMode = .Always
        usernameField.layer.cornerRadius = 10.0
        usernameField.layer.shouldRasterize = YES
        usernameField.layer.rasterizationScale = UIScreen.mainScreen().scale
        view.addSubview(usernameField)
        view.addConstraint(NSLayoutConstraint(item: usernameField, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.5, constant: -60.0))
        view.addConstraint(NSLayoutConstraint(item: usernameField, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: -20.0))
        view.addConstraint(NSLayoutConstraint(item: usernameField, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 10.0))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[usernameField(height)]", options: NSLayoutFormatOptions(0), metrics: ["height":usernameField.font.lineHeight * 1.5], views: ["usernameField":usernameField]))
        usernameField.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        passwordField = UITextField()
        passwordField.setTranslatesAutoresizingMaskIntoConstraints(NO)
        passwordField.delegate = self
        passwordField.placeholder = "Password"
        passwordField.secureTextEntry = YES
        passwordField.font = UIFont(name: "HelveticaNeue-Light", size: 36)
        passwordField.clearButtonMode = .WhileEditing
        passwordField.returnKeyType = .Go
        passwordField.leftView = UIView(frame: CGRectMake(0, 0, 10, 10))
        passwordField.leftViewMode = .Always
        passwordField.layer.cornerRadius = 10.0
        passwordField.layer.shouldRasterize = YES
        passwordField.layer.rasterizationScale = UIScreen.mainScreen().scale
        view.addSubview(passwordField)
        view.addConstraint(NSLayoutConstraint(item: passwordField, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.5, constant: -60.0))
        view.addConstraint(NSLayoutConstraint(item: passwordField, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 20.0))
        view.addConstraint(NSLayoutConstraint(item: passwordField, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 10.0))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[passwordField(height)]", options: NSLayoutFormatOptions(0), metrics: ["height":passwordField.font.lineHeight * 1.5], views: ["passwordField":passwordField]))
        passwordField.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        submitButton = UIButton_Typical()
        submitButton.setTranslatesAutoresizingMaskIntoConstraints(NO)
        submitButton.setTitle("Submit", forState: .Normal)
        submitButton.titleLabel!.font = UIFont(name: "Helvetica Neue", size: 32)
        submitButton.addTarget(self, action: "attemptToLogin", forControlEvents: .TouchUpInside)
        submitButton.layer.cornerRadius = 10.0
        submitButton.layer.shouldRasterize = YES
        submitButton.layer.rasterizationScale = UIScreen.mainScreen().scale
        view.addSubview(submitButton)
        view.addConstraint(NSLayoutConstraint(item: submitButton, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.3, constant: -60.0))
        view.addConstraint(NSLayoutConstraint(item: submitButton, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: submitButton, attribute: .Top, relatedBy: .Equal, toItem: usernameField, attribute: .Bottom, multiplier: 1.0, constant: 20.0))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[submitButton(height)]", options: NSLayoutFormatOptions(0), metrics: ["height":submitButton.titleLabel!.font.lineHeight * 1.5], views: ["submitButton":submitButton]))
        submitButton.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        loadingWheel = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        loadingWheel.setTranslatesAutoresizingMaskIntoConstraints(NO)
        loadingWheel.startAnimating()
        loadingWheel.alpha = 0.0
        view.addSubview(loadingWheel)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[loadingWheel(39)]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["loadingWheel":loadingWheel]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[loadingWheel(39)]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["loadingWheel":loadingWheel]))
        view.addConstraint(NSLayoutConstraint(item: loadingWheel, attribute: .CenterX, relatedBy: .Equal, toItem: submitButton, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: loadingWheel, attribute: .CenterY, relatedBy: .Equal, toItem: submitButton, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        view.layoutIfNeeded()
        loadingWheel.transform = CGAffineTransformMakeScale(2.0, 2.0)
        
        otherLoginButton = UIButton_Typical()
        otherLoginButton.setTranslatesAutoresizingMaskIntoConstraints(NO)
        otherLoginButton.setTitle("Are you a Student? Press here!", forState: .Normal)
        otherLoginButton.titleLabel!.font = UIFont(name: "Marker Felt", size: 24)
        otherLoginButton.addTarget(self, action: "switchAccountLoginType", forControlEvents: .TouchUpInside)
        otherLoginButton.layer.cornerRadius = 10.0
        otherLoginButton.layer.shouldRasterize = YES
        otherLoginButton.layer.rasterizationScale = UIScreen.mainScreen().scale
        view.addSubview(otherLoginButton)
        view.addConstraint(NSLayoutConstraint(item: otherLoginButton, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.5, constant: -60.0))
        view.addConstraint(NSLayoutConstraint(item: otherLoginButton, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: otherLoginButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[otherLoginButton(height)]", options: NSLayoutFormatOptions(0), metrics: ["height":otherLoginButton.titleLabel!.font.lineHeight * 1.5], views: ["otherLoginButton":otherLoginButton]))
        otherLoginButton.transform = CGAffineTransformMakeScale(0.0, 0.0)
    }
    
    func switchAccountLoginType()
    {
        for view in infoView.subviews as [UIView]
        {
            view.userInteractionEnabled = NO
            UIView.animateWithDuration(0.5, delay: (Double((infoView.subviews as NSArray).indexOfObject(view)) * 0.05), usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .AllowAnimatedContent, animations: { () -> Void in
                
                view.transform = CGAffineTransformMakeScale(2.0, 2.0)
                view.alpha = 0.0
                
                }, completion: { (finished) -> Void in
                    view.removeFromSuperview()
                    for constraint in self.infoView.constraints() as [NSLayoutConstraint]
                    {
                        if constraint.firstItem === view
                        {
                            self.infoView.removeConstraint(constraint)
                        }
                    }
                    
                    if self.infoView.subviews.count == 0
                    {
                        switch NSUserDefaults.standardUserDefaults().stringForKey("defaultLogin")!
                        {
                        case "Student":
                            NSUserDefaults.standardUserDefaults().setObject("Teacher", forKey: "defaultLogin")
                            self.setUpScreenForTeacherInView(self.infoView)
                            break
                            
                        case "Teacher":
                            NSUserDefaults.standardUserDefaults().setObject("Student", forKey: "defaultLogin")
                            self.setUpScreenForStudentInView(self.infoView)
                            break
                            
                        default:
                            break
                        }
                        
                        self.titleLabel.textColor = self.primaryColor
                        Definitions.outlineTextInLabel(self.titleLabel)
                        
                        self.usernameLabel.textColor = self.primaryColor
                        Definitions.outlineTextInLabel(self.usernameLabel)
                        
                        self.passwordLabel.textColor = self.primaryColor
                        Definitions.outlineTextInLabel(self.passwordLabel)
                        
                        self.usernameField.textColor = self.primaryColor
                        self.usernameField.backgroundColor = Definitions.darkerColorForColor(self.infoView.backgroundColor!)
                        
                        self.passwordField.textColor = self.primaryColor
                        self.passwordField.backgroundColor = Definitions.darkerColorForColor(self.infoView.backgroundColor!)
                        
                        self.submitButton.titleLabel!.textColor = self.primaryColor
                        self.submitButton.backgroundColor = Definitions.darkerColorForColor(self.infoView.backgroundColor!)
                        
                        self.otherLoginButton.titleLabel!.textColor = self.primaryColor
                        self.otherLoginButton.backgroundColor = Definitions.darkerColorForColor(self.infoView.backgroundColor!)
                        
                        for view in self.infoView.subviews as [UIView]
                        {
                            UIView.animateWithDuration(0.8, delay: (Double((self.infoView.subviews as NSArray).indexOfObject(view)) * 0.15), usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .AllowAnimatedContent, animations: { () -> Void in
                                
                                view.transform = CGAffineTransformIdentity
                                
                                }, completion: nil)
                        }
                    }
            })
        }
    }
    
    func userAccountsDownloaded()
    {
        accountsWereDownloaded = YES
        
        if userIsWaiting == YES
        {
            timeoutTimer?.invalidate()
            userIsWaiting = NO
            attemptToLogin()
        }
    }
    
    func attemptToLogin()
    {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        transitionToLoadingState()
        
        if accountsWereDownloaded == NO
        {
            userIsWaiting = YES
            timeoutTimer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: "displayTimeoutAlert", userInfo: nil, repeats: NO)
            return
        }
        
        let userState = CESDatabase.databaseManagerForPasswordVCClass().inputtedUsernameIsValid(usernameField.text, andPassword: passwordField.text)
        
        transitionOutOfLoadingState()
        
        switch userState
        {
        case .UserInvalid:
            
            //TODO: Display Alert
            
            break
            
        case .UserIsStudent:
            if NSUserDefaults.standardUserDefaults().stringForKey("defaultLogin")! == "Student"
            {
                let success = CESDatabase.databaseManagerForPasswordVCClass().storeInputtedUserInformation(usernameField.text, andPassword: passwordField.text)
                
                if success == YES
                {
                    showWelcome()
                }
                else
                {
                    //TODO: Display Alert
                }
            }
            else
            {
                //TODO: Display Alert
            }
            
            break
            
        case .UserIsTeacher:
            if NSUserDefaults.standardUserDefaults().stringForKey("defaultLogin")! == "Teacher"
            {
                let success = CESDatabase.databaseManagerForPasswordVCClass().storeInputtedUserInformation(usernameField.text, andPassword: passwordField.text)
                
                if success == YES
                {
                    showWelcome()
                }
                else
                {
                    //TODO: Display Alert
                }
            }
            else
            {
                //TODO: Display Alert
            }
            break
            
            
        default:
            break
        }
    }
    
    func displayTimeoutAlert()
    {
        transitionOutOfLoadingState()
        
        //TODO: Display Alert
    }
    
    private func transitionToLoadingState()
    {
        submitButton.userInteractionEnabled = NO
        otherLoginButton.userInteractionEnabled = NO
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
            self.submitButton.alpha = 0.0
            self.submitButton.transform = CGAffineTransformMakeScale(0.7, 0.7)
            self.otherLoginButton.alpha = 0.0
            
            self.loadingWheel.alpha = 1.0
            self.loadingWheel.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    private func transitionOutOfLoadingState()
    {
        submitButton.userInteractionEnabled = YES
        otherLoginButton.userInteractionEnabled = YES
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
            self.submitButton.alpha = 1.0
            self.submitButton.transform = CGAffineTransformIdentity
            self.otherLoginButton.alpha = 1.0
            
            self.loadingWheel.alpha = 0.0
            self.loadingWheel.transform = CGAffineTransformMakeScale(2.0, 2.0)
            }, completion: nil)
    }
    
    private func showWelcome()
    {
        for view in infoView.subviews as [UIView]
        {
            view.userInteractionEnabled = NO
            UIView.animateWithDuration(0.5, delay: (Double((infoView.subviews as NSArray).indexOfObject(view)) * 0.05), usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .AllowAnimatedContent, animations: { () -> Void in
                
                view.transform = CGAffineTransformMakeScale(2.0, 2.0)
                view.alpha = 0.0
                
                }, completion: { (finished) -> Void in
                    view.removeFromSuperview()
                    for constraint in self.infoView.constraints() as [NSLayoutConstraint]
                    {
                        if constraint.firstItem === view
                        {
                            self.infoView.removeConstraint(constraint)
                        }
                    }
                    
                    if self.infoView.subviews.count == 0
                    {
                        let plistPath = NSBundle.mainBundle().pathForResource("LoggedInUser", ofType: "plist")!
                        let userInfo = NSArray(contentsOfFile: plistPath)! as [String]
                        
                        let welcomeTitle = UILabel()
                        welcomeTitle.setTranslatesAutoresizingMaskIntoConstraints(NO)
                        welcomeTitle.font = NSUserDefaults.standardUserDefaults().stringForKey("defaultLogin")! == "Student" ? UIFont(name: "MarkerFelt-Wide", size: 72) : UIFont(name: "HelveticaNeue-Medium", size: 64)
                        welcomeTitle.numberOfLines = 0
                        welcomeTitle.textAlignment = .Center
                        welcomeTitle.text = "Welcome\n\(userInfo[4]) \(userInfo[5])!"
                        welcomeTitle.textColor = self.primaryColor
                        Definitions.outlineTextInLabel(welcomeTitle)
                        self.infoView.addSubview(welcomeTitle)
                        self.infoView.addConstraint(NSLayoutConstraint(item: welcomeTitle, attribute: .Top, relatedBy: .Equal, toItem: self.infoView, attribute: .Top, multiplier: 1.0, constant: 0.0))
                        self.infoView.addConstraint(NSLayoutConstraint(item: welcomeTitle, attribute: .Leading, relatedBy: .Equal, toItem: self.infoView, attribute: .Leading, multiplier: 1.0, constant: 0.0))
                        self.infoView.addConstraint(NSLayoutConstraint(item: welcomeTitle, attribute: .Trailing, relatedBy: .Equal, toItem: self.infoView, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
                        self.infoView.addConstraint(NSLayoutConstraint(item: welcomeTitle, attribute: .Bottom, relatedBy: .Equal, toItem: self.infoView, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
                        welcomeTitle.transform = CGAffineTransformMakeScale(0.0, 0.0)
                        
                        NSTimer.scheduledTimerWithTimeInterval(3.8, target: self, selector: "dismissSelf", userInfo: nil, repeats: NO)
                        
                        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .AllowAnimatedContent, animations: { () -> Void in
                            
                            welcomeTitle.transform = CGAffineTransformIdentity
                            
                            }, completion: nil)
                    }
            })
        }
    }
    
    func dismissSelf()
    {
        dismissViewControllerAnimated(YES, completion: nil)
    }
    
    //MARK: - TextField
    
    private var keyboardIsShown = NO
    private var shouldLowerView = YES
    
    func keyboardWillShow(notification: NSNotification)
    {
        if keyboardIsShown == YES
        {
            return
        }
        else
        {
            keyboardIsShown = YES
        }
        
        if let userInfo = notification.userInfo
        {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
            {
                let submitButtonBottom = CGPointMake(0.0, submitButton.frame.origin.y + submitButton.frame.size.height)
                let convertedPoint = self.submitButton.convertPoint(self.submitButton.center, toView: nil)
                
                println(keyboardSize.origin.y)
                
                UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                    
                    self.infoView.transform = CGAffineTransformMakeTranslation(0.0, keyboardSize.origin.y - convertedPoint.y - 40.0)
                    
                    }, completion: nil)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        if shouldLowerView == NO
        {
            return
        }
        
        keyboardIsShown = NO
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
            
            self.infoView.transform = CGAffineTransformIdentity
            
            }, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField.placeholder == "Username"
        {
            shouldLowerView = NO
            textField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        }
        else
        {
            shouldLowerView = YES
            textField.resignFirstResponder()
            attemptToLogin()
        }
        
        return NO
    }
}
