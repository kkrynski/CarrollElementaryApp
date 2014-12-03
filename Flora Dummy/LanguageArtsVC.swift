//
//  LanguageArtsVC.swift
//  Flora Dummy
//
//  Created by Michael Schloss on 10/25/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class LanguageArtsVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //The current grade
    private var gradeNumber : String?
    
    //The general font for the view
    private var font : UIFont?
    
    //The borderWidth for display views
    private let borderWidth = 2.0
    
    //The colors used in the View Controller
    private var primaryColor : UIColor?
    private var secondaryColor : UIColor?
    
    //List of activities come from the dictionary of courses
    private var courseDictionary : NSDictionary?
    private var activities = NSArray()
    
    //A Page Manager object
    private var pageManager : PageManager?
    
    @IBOutlet var titleLabel : UILabel?
    @IBOutlet var activitiesTable : UITableView?
    @IBOutlet var notificationField : UITextView?
    
    //Get all JSON data on startup
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Set the font
        font = UIFont(name: "Marker Felt", size: 32)
        
        //Do JSON Work
        let mainDirectory = NSBundle.mainBundle().resourcePath
        let fullPath = mainDirectory?.stringByAppendingPathComponent("Carroll.json")
        let jsonFile = NSData(contentsOfFile: fullPath!)
        let jsonDictionary = NSJSONSerialization.JSONObjectWithData(jsonFile!, options: .AllowFragments, error: nil) as NSDictionary
        
        // Get courses/activities
        courseDictionary = jsonDictionary["Courses"] as NSDictionary?
        
        //We don't need to do this everytime, so we only do it once here.
        activitiesTable!.layer.borderWidth = CGFloat(borderWidth)
        activitiesTable!.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    //Everytime the view is shown on screen, make sure all data is updated
    override func viewWillAppear(animated: Bool)
    {
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        
        //Update all colors
        primaryColor = Definitions.colorWithHexString(standardDefaults.objectForKey("primaryColor") as String)
        secondaryColor = Definitions.colorWithHexString(standardDefaults.objectForKey("secondaryColor") as String)
        view.backgroundColor = Definitions.colorWithHexString(standardDefaults.objectForKey("backgroundColor") as String)
        
        primaryColor = .whiteColor()
        
        titleLabel!.textColor = primaryColor
        Definitions.outlineTextInLabel(titleLabel!)
        
        notificationField!.textColor = primaryColor
        notificationField!.backgroundColor = Definitions.lighterColorForColor(view.backgroundColor!);
        Definitions.outlineTextInTextView(notificationField!, forFont: font!)
        //Create the border for the textView
        notificationField!.layer.borderWidth = 2.0
        notificationField!.layer.borderColor = UIColor.whiteColor().CGColor
        //Set the textColor
        notificationField!.textColor = primaryColor
        
        //Set colors for activitiesTable
        activitiesTable!.backgroundColor = Definitions.lighterColorForColor(view.backgroundColor!)
        activitiesTable!.separatorColor = primaryColor
        
        
        //Update the activities for the tableView
        gradeNumber = standardDefaults.objectForKey("gradeNumber") as? String
        let gradeDictionary = courseDictionary!.objectForKey(gradeNumber!) as NSDictionary?
        if gradeDictionary != nil
        {
            activities = gradeDictionary!.objectForKey("LA") as NSArray
        }
        else
        {
            activities = NSArray()
        }
        
        activitiesTable!.reloadData()
    }
    
    //MARK: - Table View Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return activities.count
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 88.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //Get a cell that isn't currently on screen
        var cell = tableView.dequeueReusableCellWithIdentifier("LACell") as UITableViewCell?
        
        //Get the information for the activity for the cell
        let activityDictionary = activities[indexPath.row] as NSDictionary
        
        //Update the titleLabel for the cell to the Activity's Name
        cell!.textLabel.text = activityDictionary.objectForKey("Name") as String!
        cell!.textLabel.font = font
        cell!.textLabel.textColor = primaryColor
        Definitions.outlineTextInLabel(cell!.textLabel)
        
        //Update the cell's colors
        cell!.backgroundColor = .clearColor()
        
        //NOTE: -  Update this line to get an image based on the activity
        cell!.imageView.image = UIImage(named: "117-todo.png")
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        //Visually deselect the cell since we're moving away from the view
        tableView.deselectRowAtIndexPath(indexPath, animated: YES)
        
        //Get the information for the activity for the selected cell
        let activityDictionary = activities[indexPath.row] as NSDictionary
        
        //Create a PageManager for the activity and store it in THIS view controller
        
        ///////////////////////////////////////////////////////////////////////////////////////////
        //
        // Set this as an Activity object
        //
        // Use ClassConversions.h function
        //
        // -(Activity *)activityFromDictionary: (NSDictionary *)dict;
        //
        // Pass in dictionary, set the pageManager.activity = the outputed activity
        //
        pageManager = PageManager(activity: ClassConversions().activityFromDictionary(activityDictionary), forParentViewController: self)
    }
}
