//
//  CESDatabase.swift
//  FloraDummy
//
//  Created by Michael Schloss on 12/12/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

//-----------------------------------------------------------------
//-----------------------------------------------------------------
//  Please see the README file for an expanation of the CESDatabase
//-----------------------------------------------------------------
//-----------------------------------------------------------------

import Foundation

private let databaseWebsite = "http://floradummytest.michaelschlosstech.com/appdatabase.php"
private let databaseUploadWebsite = "http://floradummytest.michaelschlosstech.com/uploaddatabase.php"
private let databasePassword = "12e45"
private let databaseEncryptionKey = "I1rObD475i"

private var databaseManagerInstance : DatabaseManager?

//The Database Manager that manages all other databases
class DatabaseManager : NSObject
{
    private var activityCreationDatabaseManager : ActivityCreationDatabaseManager?
    private var activityDatabaseManager : ActivityDatabaseManager?
    private var userAccountsDatabaseManager : UserAccountsDatabaseManager?
    private var mainActivitiesDatabaseManager : MainActivitiesDatabaseManager?
    
    override init()
    {
        fatalError("You cannot initialize this class.  Please call your specific class function to return the proper database")
    }
    
    private init(fromSharedManager: Bool)
    {
        super.init()
        
        databaseManagerInstance = self
        
        activityCreationDatabaseManager = ActivityCreationDatabaseManager(databaseManager: YES)
        activityDatabaseManager = ActivityDatabaseManager(databaseManager: YES)
        userAccountsDatabaseManager = UserAccountsDatabaseManager(databaseManager: YES)
        mainActivitiesDatabaseManager = MainActivitiesDatabaseManager(databaseManager: YES)
    }
    
    private class func sharedManager() -> DatabaseManager
    {
        if databaseManagerInstance == nil
        {
            databaseManagerInstance = DatabaseManager(fromSharedManager: YES)
        }
        
        return databaseManagerInstance!
    }
    
    class func databaseManagerForActivityClass() -> ActivityDatabaseManager
    {
        return DatabaseManager.sharedManager().activityDatabaseManager!
    }
    
    class func databaseManagerForCreationClass() -> ActivityCreationDatabaseManager
    {
        return DatabaseManager.sharedManager().activityCreationDatabaseManager!
    }
    
    class func databaseManagerForPasswordVCClass() -> UserAccountsDatabaseManager
    {
        return DatabaseManager.sharedManager().userAccountsDatabaseManager!
    }
    class func databaseManagerForMainActivitiesClass() -> MainActivitiesDatabaseManager
    {
        return DatabaseManager.sharedManager().mainActivitiesDatabaseManager!
    }
}

//Segmented Database for Activity Creation
class ActivityCreationDatabaseManager : NSObject, NSURLSessionDelegate
{
    var ActivityName : String { get { return "Activity_Name" } }
    var ActivityDescription : String { get { return "Activity_Description" } }
    var TotalPoints : String { get { return "Activity_Total_Points" } }
    var ReleaseDate : String { get { return "Release_Date" } }
    var DueDate : String { get { return "Due_Date" } }
    var ActivityData : String { get { return "Activity_Data" } }
    var ClassID : String { get { return "Class_ID" } }
    
    private var urlSession : NSURLSession
    private var activeSession : NSURLSessionDataTask?
    
    override init()
    {
        fatalError("You cannot initialize this class.  Please call your specific class function to return the proper database")
    }
    
    private init(databaseManager: Bool)
    {
        let urlSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlSessionConfiguration.allowsCellularAccess = NO
        urlSessionConfiguration.HTTPAdditionalHeaders = ["Accept":"application/json"]
        urlSessionConfiguration.timeoutIntervalForRequest = 15.0
        
        urlSession = NSURLSession(configuration: urlSessionConfiguration)
        
        super.init()
        
        urlSession = NSURLSession(configuration: urlSessionConfiguration, delegate: self, delegateQueue: nil)
    }
    
    /**
    Uploads the activity data to the database
    
    :returns: ActivityID. This method will return the activityID upon successful creation, or nil if the upload failed.
    
    */
    func uploadNewActivity(activityData: NSDictionary, completion: ((activityID: String?) -> Void))
    {
        let activityID = arc4random_uniform(UINT32_MAX)
        
        var SQLQuery = "INSERT INTO activity(Activity_ID, Activity_Description, Activity_Total_Points, Release_Date, Due_Date, Activity_Data, Class_ID) VALUES ("
        SQLQuery += String(activityID) + ", "
        SQLQuery += activityData.objectForKey(ActivityDescription) as String + ", "
        SQLQuery += activityData.objectForKey(TotalPoints) as String + ", "
        SQLQuery += "`" + (activityData.objectForKey(ReleaseDate) as String) + "`, "
        SQLQuery += "`" + (activityData.objectForKey(DueDate) as String) + "`, "
        SQLQuery += "`" + (activityData.objectForKey(ActivityData) as String) + "`, "
        SQLQuery += activityData.objectForKey(ClassID) as String + ")"
        
        let post = "Password=\(databasePassword)&SQLQuery=\(SQLQuery)"
        let url = NSURL(string: databaseWebsite)!
        
        let postData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: YES)
        let postLength = String(postData!.length)
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.HTTPBody = postData
        
        activeSession = urlSession.dataTaskWithRequest(request, completionHandler: { (returnData, urlResponse, error) -> Void in
            
            if error != nil || returnData == nil || returnData.length == 0
            {
                completion(activityID: nil)
                return
            }
            
            let stringData = NSString(data: returnData, encoding: NSASCIIStringEncoding)
            
            if stringData!.containsString("Failure")
            {
                completion(activityID: nil)
            }
            else
            {
                completion(activityID: String(activityID))
            }
            
        })
    }
}

//Segmented Database for individual activites
class ActivityDatabaseManager : NSObject, NSURLSessionDelegate
{
    private var urlSession : NSURLSession
    
    var ActivityID : String         { get { return "Activity ID" } }
    var ActivityGrade : String      { get { return "Activity Grade" } }
    var ActivityData : String       { get { return "Activity Data" } }
    var ActivityStartDate : String  { get { return "Activity Start Date" } }
    var ActivityEndDate : String    { get { return "Activity End Data" } }
    var ActivityStatus : String     { get { return "Activity Status" } }
    
    override init()
    {
        fatalError("You cannot initialize this class.  Please call your specific class function to return the proper database")
    }
    
    private init(databaseManager: Bool)
    {
        let urlSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlSessionConfiguration.allowsCellularAccess = NO
        urlSessionConfiguration.HTTPAdditionalHeaders = ["Accept":"application/json"]
        urlSessionConfiguration.timeoutIntervalForRequest = 15.0
        
        urlSession = NSURLSession(configuration: urlSessionConfiguration)
        
        super.init()
        
        urlSession = NSURLSession(configuration: urlSessionConfiguration, delegate: self, delegateQueue: nil)
    }
    
    /**
    
    Returns the Activity Data for the activity with the specified activityID
    
    :param: activityID The activityID of the activity requesting its data
    
    :returns: The Dictionary of data that the activity had previously stored
    
    */
    func activityInformationForActivityID(activityID: String) -> NSDictionary?
    {
        let plistPath = NSBundle.mainBundle().pathForResource("Activities", ofType: "plist")!
        let activities = NSArray(contentsOfFile: plistPath) as Array<Dictionary<String, AnyObject>>
        
        for activity in activities
        {
            if activity["Activity_ID"] as String == activityID
            {
                return activity["Activity_Data"]! as? NSDictionary
            }
        }
        
        return nil
    }
    
    
    
    /**

    Uploads a new activity session, or updates it if it already exists
    
    :param: activitySession A Dictionary of values corresponding to the constants listed for this class.  They may be in any order
    :param: completion The Completion Handler to be called when the upload finishes
    
    */
    func uploadActivitySession(activitySession: Dictionary<String, AnyObject>, completion: ((uploadSuccess: Bool) -> Void))
    {
        
        
        completion(uploadSuccess: NO)
    }
}

//Segmented Database for user account information and comparing
class UserAccountsDatabaseManager : NSObject, NSURLSessionDelegate
{
    
    //The user accounts are not stored in permenant memory for data protection
    private var studentUserAccounts : Array<Dictionary<String, String>>?
    private var teacherUserAccounts : Array<Dictionary<String, String>>?
    
    private var urlSession : NSURLSession
    private var activeSession : NSURLSessionDataTask?
    
    private var inputtedInfoIsValid = NO
    
    override init()
    {
        fatalError("You cannot initialize this class.  Please call your specific class function to return the proper database")
    }
    
    private init(databaseManager: Bool)
    {
        let urlSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlSessionConfiguration.allowsCellularAccess = NO
        urlSessionConfiguration.HTTPAdditionalHeaders = ["Accept":"application/json"]
        urlSessionConfiguration.timeoutIntervalForRequest = 15.0
        
        urlSession = NSURLSession(configuration: urlSessionConfiguration)
        
        super.init()
        
        urlSession = NSURLSession(configuration: urlSessionConfiguration, delegate: self, delegateQueue: nil)
    }
    
    class func UserAccountsDownloaded() -> String
    {
        return "User Accounts Downloaded Notification"
    }
    
    class func UserLoggedIn() -> String
    {
        return "User Logged In Notification"
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
    
    /**
    
    Downloads the user accounts for Teachers and Students.  This method should be called immediately in 'viewDidLoad:'
    
    Once the accounts have downloaded, this method sends out the "UserAccountsDownloaded" notification.  Add your class as an observer to properly respond to the finished download
    
    */
    func downloadUserAccounts()
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
                
                self.studentUserAccounts = tempUserAccounts as? Array<Dictionary<String, String>>
                
                NSNotificationCenter.defaultCenter().postNotificationName(UserAccountsDatabaseManager.UserAccountsDownloaded(), object: nil)
            })
        }
    }
    
    /**
    
    Compares the received user account information with the downloaded information.  If no data has been downloaded, this method returns invalid.
    
    :param: username The inputted username to check
    :param: password The inputted password to check
    
    :returns: This method will return one of three constants upon completion:
    :returns:
    :returns: *  'UserStateUserIsStudent' -- The inputted information is for a Student Account
    :returns: *  'UserStateUserIsTeacher' -- The inputted information is for a Teacher Account
    :returns: *  'UserStateUserInvalid'   -- The inputted information is invalid
    
    */
    func inputtedUsernameIsValid(username: String, andPassword password: String) -> UserState
    {
        let encryptedUserName = username.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: YES)!.AES256EncryptedDataUsingKey(databaseEncryptionKey, error: nil).hexRepresentationWithSpaces(YES, capitals: NO)
        let encryptedPassword = password.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: YES)!.AES256EncryptedDataUsingKey(databaseEncryptionKey, error: nil).hexRepresentationWithSpaces(YES, capitals: NO)
        for userAccount in studentUserAccounts!
        {
            if userAccount["Username"] == encryptedUserName && userAccount["Password"] == encryptedPassword
            {
                inputtedInfoIsValid = YES
                return .UserIsStudent
            }
        }
        
        for userAccount in teacherUserAccounts!
        {
            if userAccount["Username"] == encryptedUserName && userAccount["Password"] == encryptedPassword
            {
                inputtedInfoIsValid = YES
                return .UserIsTeacher
            }
        }
        
        inputtedInfoIsValid = NO
        return .UserInvalid
    }
    
    /**
    
    Stores the inputted Username and Password onto the device.  User information is encrypted first.
    
    * NOTE: This method will immediately return 'false' if '- (UserState) inputtedUserInformationIsValid:' hasn't been called yet, or returned UserStateUserInvalid.
    
    :param: username The inputted username to store
    :param: password The inputted password to store
    
    :returns: If returned 'true', the information was successfuly stored onto the device.
    :returns: If returned 'false' the information was not successfully stored onto the device.
    :returns: You should use this Bool to determine whether or not you can/should dismiss the PasswordVC.
    
    */
    func storeInputtedUserInformation(username: String, andPassword password: String) -> Bool
    {
        if inputtedInfoIsValid == NO
        {
            return NO
        }
        
        let plistPath = NSBundle.mainBundle().pathForResource("LoggedInUser", ofType: "plist")!
        
        let encryptedUserName = username.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: YES)!.AES256EncryptedDataUsingKey(databaseEncryptionKey, error: nil).hexRepresentationWithSpaces(YES, capitals: NO)
        let encryptedPassword = password.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: YES)!.AES256EncryptedDataUsingKey(databaseEncryptionKey, error: nil).hexRepresentationWithSpaces(YES, capitals: NO)
        
        if inputtedUsernameIsValid(username, andPassword: password) != .UserInvalid
        {
            for student in studentUserAccounts!
            {
                if student["Username"] == encryptedUserName && student["Password"] == encryptedPassword
                {
                    NSNotificationCenter.defaultCenter().postNotificationName(UserAccountsDatabaseManager.UserLoggedIn(), object: nil)
                    return NSArray(objects: encryptedUserName, encryptedPassword, student["Student_ID"]!, "Student").writeToFile(plistPath, atomically: YES)
                }
            }
            
            for teacher in teacherUserAccounts!
            {
                if teacher["Username"] == encryptedUserName && teacher["Password"] == encryptedPassword
                {
                    NSNotificationCenter.defaultCenter().postNotificationName(UserAccountsDatabaseManager.UserLoggedIn(), object: nil)
                    return NSArray(objects: encryptedUserName, encryptedPassword, teacher["Teacher_ID"]!, "Teacher").writeToFile(plistPath, atomically: YES)
                }
            }
        }
        
        return NO
    }
}

//Segmented Database for the Main Activity Pages
class MainActivitiesDatabaseManager : NSObject, NSURLSessionDelegate, NSURLSessionDataDelegate
{
    private var urlSession : NSURLSession?
    
    private var activeSession : NSURLSessionDataTask?
    
    var activitiesLoaded = NO
    
    override init()
    {
        fatalError("You cannot initialize this class.  Please call your specific class function to return the proper database")
    }
    
    private init(databaseManager: Bool)
    {
        super.init()
        
        let urlSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlSessionConfiguration.allowsCellularAccess = NO
        urlSessionConfiguration.HTTPAdditionalHeaders = ["Accept":"application/json"]
        urlSessionConfiguration.timeoutIntervalForRequest = 15.0
        
        urlSession = NSURLSession(configuration: urlSessionConfiguration, delegate: self, delegateQueue: NSOperationQueue.currentQueue())
    }
    
    private func loadStudentClassesWithCompletionHandler(completionHandler: ((classesToLoad: NSArray) -> Void))
    {
        let plistPath = NSBundle.mainBundle().pathForResource("LoggedInUser", ofType: "plist")!
        let studentInfo = NSArray(contentsOfFile: plistPath)!
        
        var studentID = studentInfo[3] as String
        
        let post = "Password=\(databasePassword)&SQLQuery=SELECT * FROM student_class WHERE Student_ID=\(studentID)"
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
                completionHandler(classesToLoad: [])
                return
            }
            
            let stringData = NSString(data: databaseData, encoding: NSASCIIStringEncoding)
            
            if stringData!.containsString("No Data")
            {
                completionHandler(classesToLoad: [])
                return
            }
            
            let JSONData = NSJSONSerialization.JSONObjectWithData(databaseData, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
            
            let arrayOfClassIDs = NSMutableArray()
            for student_class in (JSONData["Data"] as Array<Dictionary<String, String>>)
            {
                arrayOfClassIDs.addObject(student_class["Class_ID"]!)
            }
            
            completionHandler(classesToLoad: arrayOfClassIDs)
        })
        activeSession!.resume()
    }
    
    private func loadClassesWithCompletionHandler(completionHandler: ((classes: NSArray) -> Void))
    {
        loadStudentClassesWithCompletionHandler { (classesToLoad) -> Void in
            
            var post = "Password=\(databasePassword)&SQLQuery=SELECT * FROM class WHERE Class_ID=\(classesToLoad[0] as String)"
            if classesToLoad.count > 1
            {
                for index in 1...Int(classesToLoad.count - 1)
                {
                    post += "&Class_ID=\(classesToLoad[index] as String)"
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
            self.activeSession!.resume()
        }
    }
    
    func loadActivities()
    {
        loadClassesWithCompletionHandler { (classes) -> Void in
            
            if classes[0].isKindOfClass(NSDictionary.classForCoder()) == NO
            {
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
                    return
                }
                
                let stringData = NSString(data: databaseData, encoding: NSASCIIStringEncoding)
                
                if stringData!.containsString("No Data")
                {
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
                            if key != "Activity_Data"
                            {
                                newActivity.setValue("", forKey: key)
                            }
                            else
                            {
                                newActivity.setValue(NSDictionary(), forKey: key)
                            }
                        }
                    }
                    newActivities[(newActivities as NSArray).indexOfObject(activity)] = newActivity as NSDictionary
                }
                
                let plistPath = NSBundle.mainBundle().pathForResource("Activities", ofType: "plist")
                newActivities.writeToFile(plistPath!, atomically: YES)
                
                NSNotificationCenter.defaultCenter().postNotificationName(ActivityDataLoaded, object: nil)
            })
            self.activeSession!.resume()
            
        }
    }
}