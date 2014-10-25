//
//  LanguageArtsVC.swift
//  Flora Dummy
//
//  Created by Michael Schloss on 10/25/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class LanguageArtsVC: UIViewController/*, UITableViewDelegate, UITableViewDataSource*/
{
    //The current grade
    private var gradeNumber : String?
    
    //The general font for the view
    private let font = UIFont(name: "MarkerFelt", size: 32)
    
    //The borderWidth for display views
    private let borderWidth = 2.0
    
    //The colors used in the View Controller
    private var primaryColor : UIColor?
    private var secondaryColor : UIColor?
    
    //List of activities come from the dictionary of courses
    private var courseDictionary : NSDictionary?
    private var activities : NSArray?
    
    @IBOutlet var titleLabel : UILabel?
    @IBOutlet var activitiesTable : UITableView?
    @IBOutlet var notificationField : UITextView?
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        
        //Update all colors
        primaryColor = Definitions.colorWithHexString(standardDefaults.objectForKey("primaryColor") as String)
        secondaryColor = Definitions.colorWithHexString(standardDefaults.objectForKey("secondaryColor") as String)
        view.backgroundColor = Definitions.colorWithHexString(standardDefaults.objectForKey("backgroundColor") as String)
        
        primaryColor = .whiteColor()
        
        titleLabel!.textColor = primaryColor
        Definitions.outlineTextInLabel(titleLabel!)
        
        notificationField!.textColor = primaryColor
        //notificationField!.backgroundColor = ;
        //Definitions.outlineTextInLabel(notificationField!)
        
        //activitiesTable!.backgroundColor =
        
        //Do JSON Work
        let mainDirectory = NSBundle.mainBundle().resourcePath
        let fullPath = mainDirectory?.stringByAppendingPathComponent("Carroll.json")
        let jsonFile = NSData(contentsOfFile: fullPath!)
        let jsonDictionary = NSJSONSerialization.JSONObjectWithData(jsonFile!, options: .AllowFragments, error: nil) as NSDictionary
        
        // Get courses/activities
        courseDictionary = jsonDictionary["Cources"] as? NSDictionary
        
        activitiesTable!.layer.borderWidth = CGFloat(borderWidth)
        activitiesTable!.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    
}
