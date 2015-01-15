//
//  SubjectVC.swift
//  FloraDummy
//
//  Created by Michael Schloss on 1/11/15.
//  Copyright (c) 2015 SGSC. All rights reserved.
//

import UIKit

class SubjectVC: FormattedVC, UIViewControllerTransitioningDelegate
{
    //The current grade
    internal var gradeNumber : String?
    
    //The borderWidth for display views
    internal let borderWidth = 2.0
    
    //List of activities come from the dictionary of courses
    internal var courseDictionary : NSDictionary?
    internal var activities = NSMutableArray()
    
    //The feedback views
    internal var loadingView : UIView?
    internal var noActivitiesView : UIView?
    
    //A Page Manager object
    internal var pageManager : PageManager?
    
    @IBOutlet var titleLabel : UILabel?
    @IBOutlet var activitiesTable : UITableView?
    @IBOutlet var notificationField : UITextView?
    
    internal var subjectID = String(-1)
    
    //Get all JSON data on startup
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //We don't need to do this everytime, so we only do it once here.
        activitiesTable!.layer.borderWidth = CGFloat(borderWidth)
        activitiesTable!.layer.borderColor = UIColor.whiteColor().CGColor
        
    }
    
    //Everytime the view is shown on screen, make sure all data is updated
    override func viewWillAppear(animated: Bool)
    {
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "activityDataLoaded", name: ActivityDataLoaded, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "activityDataLoaded", name: UIApplicationSignificantTimeChangeNotification, object: nil)
        
        //Update all colors
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
        activities = NSMutableArray()
        
        let classesPlistPath = NSBundle.mainBundle().pathForResource("Classes", ofType: "plist")
        let activitiesPlistPath = NSBundle.mainBundle().pathForResource("Activities", ofType: "plist")
        
        let classesArray = NSArray(contentsOfFile: classesPlistPath!)
        let activitiesArray = NSArray(contentsOfFile: activitiesPlistPath!)
        
        if activitiesArray != nil && classesArray != nil
        {
            for subjectClass in classesArray as Array<Dictionary<String, String>>
            {
                if subjectClass["Subject_ID"] == subjectID
                {
                    for activity in activitiesArray as Array<Dictionary<String, String>>
                    {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.timeZone = NSTimeZone.localTimeZone()
                        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                        
                        let releaseDate = dateFormatter.dateFromString(activity["Release_Date"]!)!
                        let dueDate = dateFormatter.dateFromString(activity["Due_Date"]!)!
                        
                        if activity["Class_ID"] == subjectClass["Class_ID"] && (releaseDate.compare(NSDate()) == .OrderedAscending || releaseDate.compare(NSDate()) == .OrderedSame) && (dueDate.compare(NSDate()) == .OrderedDescending || dueDate.compare(NSDate()) == .OrderedSame)
                        {
                            activities.addObject(activity)
                        }
                    }
                }
            }
        }
        
        if CESDatabase.databaseManagerForMainActivitiesClass().activitiesLoaded == NO && activities.count == 0
        {
            if loadingView == nil
            {
                showLoadingView()
            }
        }
        else if activities.count == 0
        {
            if noActivitiesView == nil
            {
                showNoActivites()
            }
        }
        else
        {
            if loadingView == nil
            {
                showLittleLoadingView()
            }
        }
        
        activitiesTable!.reloadData()
    }
    
    //Updates the activityTable's data if we went to this screen before it was all downloaded
    func activityDataLoaded()
    {
        activities = NSMutableArray()
        let classesPlistPath = NSBundle.mainBundle().pathForResource("Classes", ofType: "plist")
        let activitiesPlistPath = NSBundle.mainBundle().pathForResource("Activities", ofType: "plist")
        
        let classesArray = NSArray(contentsOfFile: classesPlistPath!)
        let activitiesArray = NSArray(contentsOfFile: activitiesPlistPath!)
        
        if activitiesArray != nil && classesArray != nil
        {
            for subjectClass in classesArray as Array<Dictionary<String, String>>
            {
                if subjectClass["Subject_ID"] == subjectID
                {
                    for activity in activitiesArray as Array<Dictionary<String, String>>
                    {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.timeZone = NSTimeZone.localTimeZone()
                        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                        
                        let releaseDate = dateFormatter.dateFromString(activity["Release_Date"]!)!
                        let dueDate = dateFormatter.dateFromString(activity["Due_Date"]!)!
                        
                        if activity["Class_ID"] == subjectClass["Class_ID"] && (releaseDate.compare(NSDate()) == .OrderedAscending || releaseDate.compare(NSDate()) == .OrderedSame) && (dueDate.compare(NSDate()) == .OrderedDescending || dueDate.compare(NSDate()) == .OrderedSame)
                        {
                            activities.addObject(activity)
                        }
                    }
                }
            }
        }
        
        if activities.count != 0
        {
            UIView.animateWithDuration(transitionLength, delay: 0.0, options: .AllowAnimatedContent, animations: { () -> Void in
                self.loadingView?.alpha = 0.0
                self.noActivitiesView?.alpha = 0.0
                self.activitiesTable!.reloadData()
                }, completion: { (finished) -> Void in
                    self.noActivitiesView?.removeFromSuperview()
                    self.loadingView?.removeFromSuperview()
            })
        }
        else
        {
            showNoActivites()
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    internal func showNoActivites()
    {
        noActivitiesView = UIView(frame: activitiesTable!.frame)
        noActivitiesView!.backgroundColor = Definitions.lighterColorForColor(view.backgroundColor!)
        
        let noActivitiesLabel = UILabel(frame: CGRectMake(0, 0, noActivitiesView!.frame.size.width, noActivitiesView!.frame.size.height))
        noActivitiesLabel.textColor = primaryColor
        noActivitiesLabel.font = font
        noActivitiesLabel.numberOfLines = 0
        noActivitiesLabel.textAlignment = .Center
        noActivitiesLabel.text = "There are no activites in this class for\nLanguage Arts!"
        Definitions.outlineTextInLabel(noActivitiesLabel)
        noActivitiesLabel.sizeToFit()
        noActivitiesLabel.center = CGPointMake(noActivitiesView!.frame.size.width/2.0, noActivitiesView!.frame.size.height/2.0)
        noActivitiesView!.addSubview(noActivitiesLabel)
        
        noActivitiesView!.layer.borderWidth = CGFloat(borderWidth)
        noActivitiesView!.layer.borderColor = UIColor.whiteColor().CGColor
        
        view.addSubview(noActivitiesView!)
    }
    
    internal func showLoadingView()
    {
        loadingView = UIView(frame: activitiesTable!.frame)
        loadingView!.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        
        let wheel = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        wheel.center = CGPointMake(loadingView!.frame.size.width/2.0, loadingView!.frame.size.height/2.0 - 10 - wheel.frame.size.height/2.0)
        wheel.startAnimating()
        loadingView!.addSubview(wheel)
        
        let loadingLabel = UILabel()
        loadingLabel.textColor = primaryColor
        loadingLabel.font = font
        loadingLabel.text = "Loading Activities..."
        Definitions.outlineTextInLabel(loadingLabel)
        loadingLabel.sizeToFit()
        loadingLabel.center = CGPointMake(loadingView!.frame.size.width/2.0, loadingView!.frame.size.height/2.0 + 10 + loadingLabel.frame.size.height/2.0)
        loadingView!.addSubview(loadingLabel)
        
        loadingView!.layer.borderWidth = CGFloat(borderWidth)
        loadingView!.layer.borderColor = UIColor.whiteColor().CGColor
        
        view.addSubview(loadingView!)
    }
    
    func showLittleLoadingView()
    {
        loadingView = UIView(frame: CGRectMake(0, activitiesTable!.frame.size.height - 100, activitiesTable!.frame.size.width, 100))
        loadingView!.backgroundColor = Definitions.lighterColorForColor(view.backgroundColor!)
        
        let loadingLabel = UILabel()
        loadingLabel.textColor = primaryColor
        loadingLabel.font = font
        loadingLabel.text = "Updating Activities..."
        Definitions.outlineTextInLabel(loadingLabel)
        loadingLabel.sizeToFit()
        
        let wheel = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        wheel.startAnimating()
        
        let tempView = UIView(frame: CGRectMake(0, 0, wheel.frame.size.width + 36 + loadingLabel.frame.size.width, 100))
        wheel.center = CGPointMake(8 + wheel.frame.size.width/2.0, tempView.frame.size.height/2.0)
        loadingLabel.center = CGPointMake(tempView.frame.size.width - 8 - loadingLabel.frame.size.width/2.0, tempView.frame.size.height/2.0)
        tempView.addSubview(wheel)
        tempView.addSubview(loadingLabel)
        
        tempView.center = CGPointMake(loadingView!.frame.size.width/2.0, loadingView!.frame.size.height/2.0)
        loadingView!.addSubview(tempView)
        
        loadingView!.layer.borderWidth = CGFloat(borderWidth)
        loadingView!.layer.borderColor = UIColor.whiteColor().CGColor
        loadingView!.layer.shadowOpacity = 0.85
        
        loadingView!.layer.zPosition = 2
        activitiesTable!.addSubview(loadingView!)
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
        var cell = tableView.dequeueReusableCellWithIdentifier("SubjectCell") as UITableViewCell?
        
        //Update the titleLabel for the cell to the Activity's Name
        cell!.textLabel!.text = activities[indexPath.row]/*["Activity_Name"]*/ as? String
        cell!.textLabel!.font = font
        cell!.textLabel!.textColor = primaryColor
        Definitions.outlineTextInLabel(cell!.textLabel!)
        
        //Update the cell's colors
        cell!.backgroundColor = .clearColor()
        
        //NOTE: -  Update this line to get an image based on the activity
        cell!.imageView!.image = UIImage(named: "117-todo.png")
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        //Visually deselect the cell since we're moving away from the view
        tableView.deselectRowAtIndexPath(indexPath, animated: YES)
        UIApplication.sharedApplication().keyWindow?.userInteractionEnabled = NO
        
        let activityLoadingView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        activityLoadingView.clipsToBounds = YES
        activityLoadingView.frame = tableView.cellForRowAtIndexPath(indexPath)!.convertRect(tableView.cellForRowAtIndexPath(indexPath)!.frame, toView: view)
        activityLoadingView.alpha = 0.0
        
        let loadingWheel = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        loadingWheel.startAnimating()
        
        let loadingLabel = UILabel()
        loadingLabel.textColor = primaryColor
        loadingLabel.text = "Loading Activity..."
        loadingLabel.numberOfLines = 0
        loadingLabel.font = font
        Definitions.outlineTextInLabel(loadingLabel)
        loadingLabel.sizeToFit()
        
        let activityLoadingLoadingView = UIView(frame: CGRectMake(0, 0, loadingWheel.frame.size.width + loadingLabel.frame.size.width + 8, activityLoadingView.frame.size.height))
        activityLoadingLoadingView.addSubview(loadingWheel)
        activityLoadingLoadingView.addSubview(loadingLabel)
        loadingWheel.center = CGPointMake(loadingWheel.frame.size.width/2.0, activityLoadingLoadingView.frame.size.height/2.0)
        loadingLabel.center = CGPointMake(activityLoadingLoadingView.frame.size.width - loadingLabel.frame.size.width/2.0, activityLoadingLoadingView.frame.size.height/2.0)
        activityLoadingView.contentView.addSubview(activityLoadingLoadingView)
        activityLoadingLoadingView.center = CGPointMake(activityLoadingView.frame.size.width/2.0, activityLoadingView.frame.size.height/2.0)
        
        view.addSubview(activityLoadingView)
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .AllowAnimatedContent, animations: { () -> Void in
            activityLoadingView.frame = CGRectMake(0, 0, self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)
            activityLoadingView.center = CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)
            activityLoadingView.alpha = 1.0
            
            activityLoadingLoadingView.frame = CGRectMake(0, 0, activityLoadingView.frame.size.width, activityLoadingView.frame.size.height)
            loadingWheel.center = CGPointMake(activityLoadingLoadingView.frame.size.width/2.0, activityLoadingLoadingView.frame.size.height/2.0 - 4 - loadingWheel.frame.size.height/2.0)
            loadingLabel.center = CGPointMake(activityLoadingLoadingView.frame.size.width/2.0, activityLoadingLoadingView.frame.size.height/2.0 + 4 + loadingWheel.frame.size.height/2.0)
            }, completion: { (finished) -> Void in
                //TODO: Fill this in
                //Get the information for the activity for the selected cell
                let activityDictionary = self.activities[indexPath.row] as NSDictionary
                
                //Create a PageManager for the activity and store it in THIS view controller
                //self.pageManager = PageManager(activity: ClassConversions().activityFromDictionary(activityDictionary), forParentViewController: self)
        })
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.fromValue = NSNumber(double: 0.001)
        animation.toValue = NSNumber(double: 10.0)
        animation.duration = 0.3
        activityLoadingView.layer.addAnimation(animation, forKey: "cornerRadius")
        activityLoadingView.layer.cornerRadius = 10.0
    }
    
    //MARK: - ScrollView Methods
    
    //Keeps the small loading view from scrolling with the tableView
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        loadingView?.frame = CGRectMake(0, scrollView.frame.size.height - 100 + scrollView.contentOffset.y, scrollView.frame.size.width, 100)
    }

}
