//
//  CESDatabase.swift
//  FloraDummy
//
//  Created by Michael Schloss on 12/12/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import Foundation

private let databaseWebsite = "http://floradummytest.michaelschlosstech.com/appdatabase.php"

private let databasePassword = "12e45"

protocol CESDatabase
{
    /*
    //Constants
    var ActivityID : String { get }
    var ActivityStartTime : String { get }
    var ActivityFinishTime : String { get }
    var ActivityScore : String { get }
    var ActivityData : String { get }
    var StudentID : String { get }
    
    */
    
    //var arrayOfPrompts : Array<NSURLConnection>? { get set }
    
    
}

protocol CESCreationDatabase
{
    //Constants
    var ActivityName : String { get }
    var ActivityDescription : String { get }
    var TotalPoints : String { get }
    var ReleaseDate : String { get }
    var DueDate : String { get }
    var ActivityData : String { get }
    var ClassID : String { get }
    
    /**
    Uploads the activity data to the database
    
    :returns: ActivityID This method will return the activityID upon successful creation, or nil if the upload failed.
    
    */
    func uploadNewActivity(activityData: NSDictionary) -> String?
}

protocol CESUserAccountsDatabase
{
    var UserAccountsDownloaded : String { get }
    
    func downloadUserAccounts()
    
    func inputtedUserInformationIsValid(userInformation: Array<String>) -> Bool
}

private var databaseManagerInstance : DatabaseManager?

//The Database Manager that manages all other databases
class DatabaseManager : NSObject
{
    private var activityCreationDatabaseManager : CESCreationDatabase?
    private var activityDatabaseManager : CESDatabase?
    private var userAccountsDatabaseManager : CESUserAccountsDatabase?
    
    override init()
    {
        fatalError("You cannot initialize this class.  Please call your specific class function to return the proper database")
    }
    
    private init(fromSharedManager: Bool)
    {
        super.init()
        
        activityCreationDatabaseManager = ActivityCreationDatabaseManager()
        activityDatabaseManager = ActivityDatabaseManager()
        userAccountsDatabaseManager = UserAccountsDatabaseManager()
    }
    
    private class func sharedManager() -> DatabaseManager
    {
        if databaseManagerInstance == nil
        {
            databaseManagerInstance = DatabaseManager(fromSharedManager: YES)
        }
        
        return databaseManagerInstance!
    }
    
    class func databaseManagerForActivityClass() -> CESDatabase
    {
        return DatabaseManager.sharedManager().activityDatabaseManager!
    }
    
    class func databaseManagerForCreationClass() -> CESCreationDatabase
    {
        return DatabaseManager.sharedManager().activityCreationDatabaseManager!
    }
    
    class func databaseManagerForPasswordVCClass() -> CESUserAccountsDatabase
    {
        return DatabaseManager.sharedManager().userAccountsDatabaseManager!
    }
}

//Segmented Database for Activity Creation
private class ActivityCreationDatabaseManager : NSObject, CESCreationDatabase, NSURLSessionDelegate
{
    var ActivityName : String { get { return "Activity_Name" } }
    var ActivityDescription : String { get { return "Activity_Description" } }
    var TotalPoints : String { get { return "Activity_Total_Points" } }
    var ReleaseDate : String { get { return "Release_Date" } }
    var DueDate : String { get { return "Due_Date" } }
    var ActivityData : String { get { return "Activity_Data" } }
    var ClassID : String { get { return "Class_ID" } }
    
    var urlSession : NSURLSession
    
    override init()
    {
        let urlSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlSessionConfiguration.allowsCellularAccess = NO
        urlSessionConfiguration.HTTPAdditionalHeaders = ["Accept":"application/json"]
        urlSessionConfiguration.timeoutIntervalForRequest = 15.0
        
        urlSession = NSURLSession(configuration: urlSessionConfiguration)
        
        super.init()
        
        urlSession = NSURLSession(configuration: urlSessionConfiguration, delegate: self, delegateQueue: nil)
    }
    
    private func uploadNewActivity(activityData: NSDictionary) -> String?
    {
        let activityID = arc4random_uniform(UINT32_MAX)
        
        return "Success"
    }
}

//Segmented Database for individual activites
private class ActivityDatabaseManager : NSObject, CESDatabase, NSURLSessionDelegate
{
    private var urlSession : NSURLSession
    
    override init()
    {
        let urlSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlSessionConfiguration.allowsCellularAccess = NO
        urlSessionConfiguration.HTTPAdditionalHeaders = ["Accept":"application/json"]
        urlSessionConfiguration.timeoutIntervalForRequest = 15.0
        
        urlSession = NSURLSession(configuration: urlSessionConfiguration)
        
        super.init()
        
        urlSession = NSURLSession(configuration: urlSessionConfiguration, delegate: self, delegateQueue: nil)
    }
}

//Segmented Database for user account information and comparing
private class UserAccountsDatabaseManager : NSObject, CESUserAccountsDatabase, NSURLSessionDelegate
{
    var UserAccountsDownloaded : String { get { return "User Accounts Downloaded Notification" } }
    
    //The user accounts are not stored in permenant memory for data protection
    private var studentUserAccounts : Array<Dictionary<String, String>>?
    private var teacherUserAccounts : Array<Dictionary<String, String>>?

    private var urlSession : NSURLSession
    private var activeSession : NSURLSessionDataTask?
    
    override init()
    {
        let urlSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlSessionConfiguration.allowsCellularAccess = NO
        urlSessionConfiguration.HTTPAdditionalHeaders = ["Accept":"application/json"]
        urlSessionConfiguration.timeoutIntervalForRequest = 15.0
        
        urlSession = NSURLSession(configuration: urlSessionConfiguration)
        
        super.init()
        
        urlSession = NSURLSession(configuration: urlSessionConfiguration, delegate: self, delegateQueue: nil)
    }
    
    private func downloadTeacherAccounts(completionHandler: (() -> Void))
    {
        let post = "Password=\(databasePassword)&SQLQuery=SELECT * FROM teacher"
        let url = NSURL(string: databaseWebsite)!
        
        let postData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: YES)
        let postLength = String(postData!.length)
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.HTTPBody = postData
        
        activeSession = urlSession.dataTaskWithRequest(request, completionHandler: { (databaseData, urlRespone, error) -> Void in
            
            if error != nil || databaseData == nil
            {
                completionHandler()
                return
            }
            
            let stringData = NSString(data: databaseData, encoding: NSASCIIStringEncoding)
            
            if stringData!.containsString("No Data")
            {
                completionHandler()
                return
            }
            
            let JSONData = NSJSONSerialization.JSONObjectWithData(databaseData, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
            
            let tempUserAccounts = JSONData["Data"] as NSArray
            
            self.teacherUserAccounts = tempUserAccounts as? Array<Dictionary<String, String>>
            
            completionHandler()
            
        })
    }
    
    private func downloadUserAccounts()
    {
        downloadTeacherAccounts { () -> Void in
            
            let post = "Password=\(databasePassword)&SQLQuery=SELECT * FROM student"
            let url = NSURL(string: databaseWebsite)!
            
            let postData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: YES)
            let postLength = String(postData!.length)
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
            request.HTTPBody = postData
            
            self.activeSession = self.urlSession.dataTaskWithRequest(request, completionHandler: { (databaseData, urlRespone, error) -> Void in
                
                if error != nil || databaseData == nil
                {
                    return
                }
                
                let stringData = NSString(data: databaseData, encoding: NSASCIIStringEncoding)
                
                if stringData!.containsString("No Data")
                {
                    return
                }
                
                let JSONData = NSJSONSerialization.JSONObjectWithData(databaseData, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
                
                let tempUserAccounts = JSONData["Data"] as NSArray
                
                self.teacherUserAccounts = tempUserAccounts as? Array<Dictionary<String, String>>
                
                NSNotificationCenter.defaultCenter().postNotificationName(self.UserAccountsDownloaded, object: nil)
            })
        }
    }
    
    private func inputtedUserInformationIsValid(userInformation: Array<String>) -> Bool
    {
        return NO
    }
}

private var mainActivitiesDatabaseManager : MainActivitiesDatabaseManager?

//Segmented Database for the Main Activity Pages
class MainActivitiesDatabaseManager : NSObject, NSURLSessionDelegate, NSURLSessionDataDelegate
{
    private var urlSession : NSURLSession?
    
    private var activeSession : NSURLSessionDataTask?
    
    var activitiesLoaded = NO
    
    override init()
    {
        super.init()
        
        let urlSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlSessionConfiguration.allowsCellularAccess = NO
        urlSessionConfiguration.HTTPAdditionalHeaders = ["Accept":"application/json"]
        urlSessionConfiguration.timeoutIntervalForRequest = 15.0
        
        urlSession = NSURLSession(configuration: urlSessionConfiguration, delegate: self, delegateQueue: NSOperationQueue.currentQueue())
    }
    
    class func sharedManager() -> MainActivitiesDatabaseManager
    {
        if mainActivitiesDatabaseManager == nil
        {
            mainActivitiesDatabaseManager = MainActivitiesDatabaseManager()
        }
        
        return mainActivitiesDatabaseManager!
    }
    
    func loadClassesWithCompletionHandler(completionHandler: ((classes: NSArray) -> Void))
    {
        var gradeNumber = NSUserDefaults.standardUserDefaults().objectForKey("gradeNumber") as String
        if gradeNumber == "Kindergarten"
        {
            gradeNumber = "0"
        }
        
        let post = "Password=\(databasePassword)&SQLQuery=SELECT * FROM class WHERE Grade=\(gradeNumber)"
        let url = NSURL(string: databaseWebsite)!
        
        let postData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: YES)
        let postLength = String(postData!.length)
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.HTTPBody = postData
        
        activeSession = urlSession!.dataTaskWithRequest(request, completionHandler: { (databaseData, urlResponse, error) -> Void in
            
            if error != nil || databaseData == nil
            {
                completionHandler(classes: ["No Data"])
                return
            }
            
            let stringData = NSString(data: databaseData, encoding: NSASCIIStringEncoding)
            
            if stringData!.containsString("No Data")
            {
                completionHandler(classes: ["No Data"])
                return
            }
            
            let JSONData = NSJSONSerialization.JSONObjectWithData(databaseData, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
            
            completionHandler(classes: JSONData["Data"] as NSArray)
        })
        activeSession!.resume()
    }
    
    func loadActivitiesWithCompletionHandler(completionHandler:  (() -> Void) )
    {
        loadClassesWithCompletionHandler { (classes) -> Void in
            
            if classes[0].isKindOfClass(NSDictionary.classForCoder()) == NO
            {
                completionHandler()
                return
            }
            
            let plistPath = NSBundle.mainBundle().pathForResource("Classes", ofType: "plist")
            classes.writeToFile(plistPath!, atomically: YES)
            
            let firstCourseID = classes[0]["Class_ID"] as String
            
            var post = "Password=\(databasePassword)&SQLQuery=SELECT * FROM activity WHERE Class_ID=\(firstCourseID)"
            
            if classes.count > 1
            {
                for index in 1...Int(classes.count - 1)
                {
                    let courseID = classes[index]["Class_ID"] as String
                    
                    post += "&Class_ID=\(courseID)"
                }
            }
            
            let url = NSURL(string: databaseWebsite)!
            
            let postData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: YES)
            let postLength = String(postData!.length)
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
            request.HTTPBody = postData
            
            self.activeSession = self.urlSession!.dataTaskWithRequest(request, completionHandler: { (databaseData, urlResponse, error) -> Void in
                
                self.activitiesLoaded = YES
                
                if error != nil || databaseData == nil
                {
                    completionHandler()
                    return
                }
                
                let stringData = NSString(data: databaseData, encoding: NSASCIIStringEncoding)
                
                if stringData!.containsString("No Data")
                {
                    completionHandler()
                    return
                }
                
                let JSONData = NSJSONSerialization.JSONObjectWithData(databaseData, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
                let activities = JSONData["Data"] as NSArray
                let newActivities = NSMutableArray(array: activities)
                
                for object in newActivities
                {
                    let activity = object as NSDictionary
                    
                    let newActivity = NSMutableDictionary(dictionary: activity)
                    
                    for key in newActivity.allKeys as Array<String>
                    {
                        if newActivity[key] as NSObject == NSNull()
                        {
                            newActivity.setValue("", forKey: key)
                        }
                    }
                    newActivities[(newActivities as NSArray).indexOfObject(activity)] = newActivity as NSDictionary
                }
                
                let plistPath = NSBundle.mainBundle().pathForResource("Activities", ofType: "plist")
                newActivities.writeToFile(plistPath!, atomically: YES)
                
                completionHandler()
            })
            self.activeSession!.resume()
            
        }
    }
}