//
//  CESDatabase.swift
//  FloraDummy
//
//  Created by Michael Schloss on 12/12/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//


//--------------------------------------------------------------------------------\\
//---------------------------------------------------------------------------------\\
//  Please see the CESDatabaseProtocols file for an expanation of the CESDatabase  ||
//---------------------------------------------------------------------------------//
//--------------------------------------------------------------------------------//

import Foundation

private let databaseWebsite         = "http://cescomet.michaelschlosstech.com"
private let readFile                = "appdatabase.php"
private let uploadFile              = "uploaddatabase.php"
private let databasePassword        = "7AZ-hSz-X7p-HGB"
private let databaseEncryptionKey   = "I1rObD475i"

private var databaseManagerInstance : CESDatabase!
private var urlSession : NSURLSession!

///The Database Manager that manages all other databases
class CESDatabase : NSObject, NSURLSessionDelegate
{
    private var activityCreationDatabaseManager : ActivityCreationDatabase!
    private var pageManagerDatabaseManager      : PageManagerDatabase!
    private var userAccountsDatabaseManager     : UserAccountsDatabase!
    private var mainActivitiesDatabaseManager   : MainActivitiesDatabase!
    
    override init()
    {
        fatalError("You cannot initialize this class.  Please call your specific class function to return the proper database")
    }
    
    private init(fromSharedManager: Bool)
    {
        super.init()
        
        databaseManagerInstance = self
        
        activityCreationDatabaseManager = ActivityCreationDatabaseManager(databaseManager: YES)
        pageManagerDatabaseManager      = PageManagerDatabaseManager(databaseManager: YES)
        userAccountsDatabaseManager     = UserAccountsDatabaseManager(databaseManager: YES)
        mainActivitiesDatabaseManager   = MainActivitiesDatabaseManager(databaseManager: YES)
        
        let urlSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlSessionConfiguration.allowsCellularAccess = NO
        urlSessionConfiguration.HTTPAdditionalHeaders = ["Accept":"application/json"]
        urlSessionConfiguration.timeoutIntervalForRequest = 15.0
        
        urlSession = NSURLSession(configuration: urlSessionConfiguration, delegate: self, delegateQueue: nil)
    }
    
    private class func sharedManager() -> CESDatabase
    {
        if databaseManagerInstance == nil
        {
            databaseManagerInstance = CESDatabase(fromSharedManager: YES)
        }
        
        return databaseManagerInstance
    }
    
    class func databaseManagerForPageManagerClass() -> PageManagerDatabase
    {
        return CESDatabase.sharedManager().pageManagerDatabaseManager
    }
    
    class func databaseManagerForCreationClass() -> ActivityCreationDatabase
    {
        return CESDatabase.sharedManager().activityCreationDatabaseManager
    }
    
    class func databaseManagerForPasswordVCClass() -> UserAccountsDatabase
    {
        return CESDatabase.sharedManager().userAccountsDatabaseManager
    }
    
    class func databaseManagerForMainActivitiesClass() -> MainActivitiesDatabase
    {
        return CESDatabase.sharedManager().mainActivitiesDatabaseManager
    }
}

//Private Database for Activity Creation
@objc private class ActivityCreationDatabaseManager : ActivityCreationDatabase
{
    init()
    {
        fatalError("You cannot initialize this class.  Please call your specific class function to return the proper database")
    }
    
    private init(databaseManager: Bool)
    {
        
    }
    
    func uploadNewActivity(activityData: Activity, completion: ((activityID: String?) -> Void))
    {
        if isValidActivity(activityData) == NO
        {
            completion(activityID: nil)
            return
        }
        
        var activityID : UInt32
        
        do
        {
            activityID = arc4random_uniform(UINT32_MAX)
        }
            while activityID != 1
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(activityData.activityData, forKey: "activityData")
        archiver.finishEncoding()
        
        var SQLQuery = "INSERT INTO activity(Activity_ID, Activity_Name, Activity_Description, Activity_Total_Points, Quiz, Release_Date, Due_Date, Activity_Data, Class_ID) VALUES ("
        SQLQuery += String(activityID) + ", "
        SQLQuery += activityData.name + ", "
        SQLQuery += "`\(activityData.description)`, "
        SQLQuery += String(activityData.totalPoints) + ", "
        SQLQuery += String(Int(activityData.quizMode)) + ", "
        SQLQuery += "`" + (dateFormatter.stringFromDate(activityData.releaseDate)) + "`, "
        SQLQuery += "`" + (dateFormatter.stringFromDate(activityData.dueDate)) + "`, "
        SQLQuery += "`" + (data.hexRepresentationWithSpaces(YES, capitals: NO)) + "`, "
        SQLQuery += activityData.classID + ")"
        
        let post = "Password=\(databasePassword)&SQLQuery=\(SQLQuery)"
        let url = NSURL(string: databaseWebsite.stringByAppendingPathComponent(uploadFile))!
        
        let postData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: YES)
        let postLength = String(postData!.length)
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.HTTPBody = postData
        
        let uploadActivitySession = urlSession.dataTaskWithRequest(request, completionHandler: { (returnData, urlResponse, error) -> Void in
            
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
        uploadActivitySession.resume()
    }
    
    private func isValidActivity(activityInformation: Activity) -> Bool
    {
        return activityInformation.name != "" && activityInformation.activityDescription != "" && activityInformation.totalPoints != -1 && activityInformation.releaseDate != NSDate() && activityInformation.dueDate != NSDate() && activityInformation.activityData != NSDictionary() && activityInformation.classID != ""
    }
}

//Private Database for Page Manager
@objc private class PageManagerDatabaseManager: PageManagerDatabase
{
    
    init()
    {
        fatalError("You cannot initialize this class.  Please call your specific class function to return the proper database")
    }
    
    private init(databaseManager: Bool)
    {
        
    }
    
    func activitySessionForActivityID(activityID: String, activity: Activity) -> ActivitySession
    {
        let newActivitySession = ActivitySession()
        newActivitySession.activityID = activityID
        
        let plistPathActivitySessions = NSBundle.mainBundle().pathForResource("ActivitySessions", ofType: "plist")!
        let storedSessions = NSArray(contentsOfFile: plistPathActivitySessions) as Array<Dictionary<String, String>>?
        
        var activitySessions : Array<Dictionary<String, String>>
        
        if storedSessions != nil
        {
            activitySessions = storedSessions!
            for activitySession in activitySessions
            {
                if activitySession["Activity_ID"] == activityID    //Found ActivitySession
                {
                    newActivitySession.grade = activitySession["Score"]!
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.timeZone = NSTimeZone.localTimeZone()
                    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                    newActivitySession.startDate = dateFormatter.dateFromString(activitySession["Start_Date_Time"]!)!
                    newActivitySession.endDate = dateFormatter.dateFromString(activitySession["Finish_Date_Time"]!)!
                    
                    newActivitySession.status = activitySession["Status"]!
                    
                    let activityData = activitySession["Activity_Data"]!
                    let data = NSData().dataFromHexString(activityData)
                    let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                    newActivitySession.activityData = unarchiver.decodeObjectForKey("activityData") as Array<Dictionary<NSNumber, AnyObject>>
                    unarchiver.finishDecoding()
                    
                    return newActivitySession
                }
            }
            
            newActivitySession.activityData = activity.activityData as Array<Dictionary<NSNumber, AnyObject>>
            
            return newActivitySession
        }
        else
        {
            newActivitySession.activityData = activity.activityData as Array<Dictionary<NSNumber, AnyObject>>
            
            return newActivitySession
        }
    }
    
    func uploadActivitySession(activitySession: ActivitySession, completion: ((uploadSuccess: Bool) -> Void))
    {
        if isValidActivitySession(activitySession) == NO
        {
            completion(uploadSuccess: NO)
            return
        }
        
        let plistPath = NSBundle.mainBundle().pathForResource("LoggedInUser", ofType: "plist")
        let userLoginInfo = NSArray(contentsOfFile: plistPath!)
        
        let plistPathActivitySessions = NSBundle.mainBundle().pathForResource("ActivitySessions", ofType: "plist")!
        let activitySessions = NSArray(contentsOfFile: plistPathActivitySessions) as Array<Dictionary<String, AnyObject>>
        
        var SQLQuery : String
        
        for foundActivitySession in activitySessions
        {
            if foundActivitySession["Activity_ID"] as String == activitySession.activityID as String
            {
                //Update its activitySession entry
                let dateFormatter = NSDateFormatter()
                dateFormatter.timeZone = NSTimeZone.localTimeZone()
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                
                let data = NSMutableData()
                let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
                archiver.encodeObject(activitySession.activityData, forKey: "activityData")
                archiver.finishEncoding()
                
                if activitySession.endDate != nil
                {
                    SQLQuery = "UPDATE `activity_session` SET `Start_Date_Time`=`\(dateFormatter.stringFromDate(activitySession.startDate))`,`Finish_Date_Time`=`\(dateFormatter.stringFromDate(activitySession.endDate!))`,`Score`=`\(activitySession.grade)`,`Activity_Data`=`\(data.hexRepresentationWithSpaces(YES, capitals: NO))`,`Status`=`\(activitySession.status)` WHERE `Student_ID`=`\(userLoginInfo!.objectAtIndex(3) as String)` AND`Activity_ID`=`\(activitySession.activityID)`"
                }
                else
                {
                    SQLQuery = "UPDATE `activity_session` SET `Start_Date_Time`=`\(dateFormatter.stringFromDate(activitySession.startDate))`,`Score`=`\(activitySession.grade)`,`Activity_Data`=`\(data.hexRepresentationWithSpaces(YES, capitals: NO))`,`Status`=`\(activitySession.status)` WHERE `Student_ID`=`\(userLoginInfo!.objectAtIndex(3) as String)` AND`Activity_ID`=`\(activitySession.activityID)`"
                }
                
                let post = "Password=\(databasePassword)&SQLQuery=\(SQLQuery)"
                let url = NSURL(string: databaseWebsite.stringByAppendingPathComponent(uploadFile))!
                
                let postData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: YES)
                let postLength = String(postData!.length)
                
                let request = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "POST"
                request.setValue(postLength, forHTTPHeaderField: "Content-Length")
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
                request.HTTPBody = postData
                
                let uploadActivitySessionSession = urlSession.dataTaskWithRequest(request, completionHandler: { (returnData, urlResponse, error) -> Void in
                    
                    if error != nil || returnData == nil || returnData.length == 0
                    {
                        completion(uploadSuccess: NO)
                        return
                    }
                    
                    let stringData = NSString(data: returnData, encoding: NSASCIIStringEncoding)
                    
                    if stringData!.containsString("Failure")
                    {
                        completion(uploadSuccess: NO)
                    }
                    else
                    {
                        completion(uploadSuccess: YES)
                    }
                    
                })
                uploadActivitySessionSession.resume()
                return
            }
        }
        
        //We couldn't find a current activitySession
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(activitySession.activityData, forKey: "activityData")
        archiver.finishEncoding()
        
        if activitySession.endDate != nil
        {
            SQLQuery = "INSERT INTO activity_session(Activity_ID, Student_ID, Score, Activity_Data, Start_Date_Time, Finish_Date_Time, Status) VALUES ("
        }
        else
        {
            SQLQuery = "INSERT INTO activity_session(Activity_ID, Student_ID, Score, Activity_Data, Start_Date_Time, Status) VALUES ("
        }
        SQLQuery += activitySession.activityID + ", "
        SQLQuery += userLoginInfo!.objectAtIndex(3) as String + ", "
        SQLQuery += activitySession.grade + ", "
        SQLQuery += "`" + (data.hexRepresentationWithSpaces(YES, capitals: NO)) + "`, "
        SQLQuery += "`" + (dateFormatter.stringFromDate(activitySession.startDate)) + "`, "
        if activitySession.endDate != nil
        {
            SQLQuery += "`" + (dateFormatter.stringFromDate(activitySession.endDate!)) + "`, "
        }
        SQLQuery += "`" + (activitySession.status) + "`, "
        
        let post = "Password=\(databasePassword)&SQLQuery=\(SQLQuery)"
        let url = NSURL(string: databaseWebsite.stringByAppendingPathComponent(uploadFile))!
        
        let postData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: YES)
        let postLength = String(postData!.length)
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.HTTPBody = postData
        
        let newActivitySessionUploadSession = urlSession.dataTaskWithRequest(request, completionHandler: { (returnData, urlResponse, error) -> Void in
            
            if error != nil || returnData == nil || returnData.length == 0
            {
                completion(uploadSuccess: NO)
                return
            }
            
            let stringData = NSString(data: returnData, encoding: NSASCIIStringEncoding)
            
            if stringData!.containsString("Failure")
            {
                completion(uploadSuccess: NO)
            }
            else
            {
                completion(uploadSuccess: YES)
            }
            
        })
        newActivitySessionUploadSession.resume()
    }
    
    private func isValidActivitySession(activityInformation: ActivitySession) -> Bool
    {
        return activityInformation.activityID != "000000" && activityInformation.grade != "000" && activityInformation.activityData.isEmpty != NO && activityInformation.startDate != NSDate() && activityInformation.endDate != NSDate() && activityInformation.status != "Not Started"
    }
}

//Private Database for user account information and comparing
@objc private class UserAccountsDatabaseManager : UserAccountsDatabase
{
    //The user accounts are not stored in permenant memory for data protection
    private var studentUserAccounts : Array<Dictionary<String, String>>?
    private var teacherUserAccounts : Array<Dictionary<String, String>>?
    
    private var teachersDownloaded = NO
    private var studentsDownloaded = NO
    
    private var inputtedInfoIsValid = NO
    
    init()
    {
        fatalError("You cannot initialize this class.  Please call your specific class function to return the proper database")
    }
    
    private init(databaseManager: Bool)
    {
        
    }
    
    func downloadTeacherAccounts()
    {
        println("Loading Teachers")
        
        let post = "Password=\(databasePassword)&SQLQuery=SELECT * FROM teacher"
        let url = NSURL(string: databaseWebsite.stringByAppendingPathComponent(readFile))!
        
        let postData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: YES)
        let postLength = String(postData!.length)
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.HTTPBody = postData
        
        let activeSessionTeachers = urlSession.dataTaskWithRequest(request, completionHandler: { (databaseData, urlRespone, error) -> Void in
            
            if error != nil || databaseData == nil
            {
                println("There's been an error")
                return
            }
            
            let stringData = NSString(data: databaseData, encoding: NSASCIIStringEncoding)
            
            if stringData!.containsString("No Data")
            {
                println("There are no teachers")
                return
            }
            
            let JSONData = NSJSONSerialization.JSONObjectWithData(databaseData, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
            
            let tempUserAccounts = JSONData["Data"] as NSArray
            
            self.teacherUserAccounts = tempUserAccounts as? Array<Dictionary<String, String>>
            
            self.teachersDownloaded = YES
            self.checkForAllInformationDownloaded()
            
        })
        
        activeSessionTeachers.resume()
    }
    
    func downloadStudentAccounts()
    {
        println("Loading Students")
        
        let post = "Password=\(databasePassword)&SQLQuery=SELECT * FROM student"
        let url = NSURL(string: databaseWebsite.stringByAppendingPathComponent(readFile))!
        
        let postData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: YES)
        let postLength = String(postData!.length)
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.HTTPBody = postData
        
        let activeSessionStudents = urlSession.dataTaskWithRequest(request, completionHandler: { (databaseData, urlRespone, error) -> Void in
            
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
            
            self.studentsDownloaded = YES
            self.checkForAllInformationDownloaded()
        })
        
        activeSessionStudents.resume()
    }
    
    func downloadUserAccounts()
    {
        downloadStudentAccounts()
        downloadTeacherAccounts()
    }
    
    func checkForAllInformationDownloaded()
    {
        if studentsDownloaded == YES && teachersDownloaded == YES
        {
            NSNotificationCenter.defaultCenter().postNotificationName(UserAccountsDownloaded, object: nil)
        }
    }
    
    func inputtedUsernameIsValid(username: String, andPassword password: String) -> UserState
    {
        let encryptedUserName = username.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: YES)!.AES256EncryptedDataUsingKey(databaseEncryptionKey, error: nil).hexRepresentationWithSpaces(YES, capitals: NO).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " "))
        let encryptedPassword = password.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: YES)!.AES256EncryptedDataUsingKey(databaseEncryptionKey, error: nil).hexRepresentationWithSpaces(YES, capitals: NO).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " "))
        
        for userAccount in studentUserAccounts!
        {
            if userAccount["Student_User_Name"] == encryptedUserName && userAccount["Student_Password"] == encryptedPassword
            {
                inputtedInfoIsValid = YES
                return .UserIsStudent
            }
        }
        
        for userAccount in teacherUserAccounts!
        {
            if userAccount["Teacher_User_Name"] == encryptedUserName && userAccount["Teacher_Password"] == encryptedPassword
            {
                inputtedInfoIsValid = YES
                return .UserIsTeacher
            }
        }
        
        inputtedInfoIsValid = NO
        return .UserInvalid
    }
    
    func storeInputtedUserInformation(username: String, andPassword password: String) -> Bool
    {
        if inputtedInfoIsValid == NO
        {
            return NO
        }
        
        let plistPath = NSBundle.mainBundle().pathForResource("LoggedInUser", ofType: "plist")!
        
        let encryptedUserName = username.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: YES)!.AES256EncryptedDataUsingKey(databaseEncryptionKey, error: nil).hexRepresentationWithSpaces(YES, capitals: NO).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " "))
        let encryptedPassword = password.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: YES)!.AES256EncryptedDataUsingKey(databaseEncryptionKey, error: nil).hexRepresentationWithSpaces(YES, capitals: NO).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " "))
        
        if inputtedUsernameIsValid(username, andPassword: password) != .UserInvalid
        {
            for student in studentUserAccounts!
            {
                if student["Student_User_Name"] == encryptedUserName && student["Student_Password"] == encryptedPassword
                {
                    let success = NSArray(objects: encryptedUserName, encryptedPassword, student["Student_ID"]!, "Student", student["Student_FName"]!, student["Student_LName"]!).writeToFile(plistPath, atomically: YES)
                    
                    if success == YES
                    {
                        NSNotificationCenter.defaultCenter().postNotificationName(UserLoggedIn, object: nil)
                        return success
                    }
                    else
                    {
                        return success
                    }
                }
            }
            
            for teacher in teacherUserAccounts!
            {
                if teacher["Teacher_User_Name"] == encryptedUserName && teacher["Teacher_Password"] == encryptedPassword
                {
                    let success = NSArray(objects: encryptedUserName, encryptedPassword, teacher["Teacher_ID"]!, "Teacher", teacher ["Teacher_FName"]!, teacher["Teacher_LName"]!).writeToFile(plistPath, atomically: YES)
                    
                    if success == YES
                    {
                        NSNotificationCenter.defaultCenter().postNotificationName(UserLoggedIn, object: nil)
                        return success
                    }
                    else
                    {
                        return success
                    }
                }
            }
        }
        
        return NO
    }
}

//Private Database for the Main Activity Pages
@objc private class MainActivitiesDatabaseManager : MainActivitiesDatabase
{
    private var _activitiesLoaded = NO
    var activitiesLoaded : Bool { get { return _activitiesLoaded } }
    
    private var activitySessionsDownloaded = NO
    
    init()
    {
        fatalError("You cannot initialize this class.  Please call your specific class function to return the proper database")
    }
    
    private init(databaseManager: Bool)
    {
        
    }
    
    private func loadActivitySessions()
    {
        println("Loading Activity Sessions...")
        
        let plistPath = NSBundle.mainBundle().pathForResource("LoggedInUser", ofType: "plist")!
        let studentInfo = NSArray(contentsOfFile: plistPath)!
        var studentID = studentInfo[2] as String
        
        let post = "Password=\(databasePassword)&SQLQuery=SELECT * FROM activity_session WHERE Student_ID=\(studentID)"
        let url = NSURL(string: databaseWebsite.stringByAppendingPathExtension(readFile)!)!
        
        let postData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: YES)
        let postLength = String(postData!.length)
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.HTTPBody = postData
        
        let activitySessionsSession = urlSession.dataTaskWithRequest(request, completionHandler: { (databaseData, urlResponse, error) -> Void in
            
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
            let activitySessions = JSONData["Data"] as NSArray
            let newActivitySessions = NSMutableArray(array: activitySessions)
            
            for object in newActivitySessions
            {
                let activitySession = object as NSDictionary
                let newActivitySession = NSMutableDictionary(dictionary: activitySession)
                
                newActivitySessions[(newActivitySessions as NSArray).indexOfObject(activitySession)] = newActivitySession as NSDictionary
            }
            
            let plistPath = NSBundle.mainBundle().pathForResource("ActivitySessions", ofType: "plist")
            newActivitySessions.writeToFile(plistPath!, atomically: YES)
            
            self.activitySessionsDownloaded = YES
            self.checkForActivityInformationLoaded()
        })
        activitySessionsSession.resume()
    }
    
    private func loadStudentClassesWithCompletionHandler(completionHandler: ((classesToLoad: NSArray) -> Void))
    {
        println("Loading Student Classes...")
        
        let plistPath = NSBundle.mainBundle().pathForResource("LoggedInUser", ofType: "plist")!
        let studentInfo = NSArray(contentsOfFile: plistPath)!
        var studentID = studentInfo[2] as String
        
        let post = "Password=\(databasePassword)&SQLQuery=SELECT * FROM student_class WHERE Student_ID=\(studentID)"
        let url = NSURL(string: databaseWebsite.stringByAppendingPathExtension(readFile)!)!
        
        let postData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: YES)
        let postLength = String(postData!.length)
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.HTTPBody = postData
        
        let activeStudentClassesSession = urlSession.dataTaskWithRequest(request, completionHandler: { (databaseData, urlResponse, error) -> Void in
            
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
        activeStudentClassesSession.resume()
    }
    
    private func loadClassesWithCompletionHandler(completionHandler: ((classes: NSArray) -> Void))
    {
        loadStudentClassesWithCompletionHandler { (classesToLoad) -> Void in
            
            println("Loading Classes...")
            
            if classesToLoad.count == 0
            {
                completionHandler(classes: [])
                return
            }
            
            var post = "Password=\(databasePassword)&SQLQuery=SELECT * FROM class WHERE Class_ID=\(classesToLoad[0] as String)"
            if classesToLoad.count > 1
            {
                for index in 1...Int(classesToLoad.count - 1)
                {
                    post += "&Class_ID=\(classesToLoad[index] as String)"
                }
            }
            
            let url = NSURL(string: databaseWebsite.stringByAppendingPathExtension(readFile)!)!
            
            let postData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: YES)
            let postLength = String(postData!.length)
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
            request.HTTPBody = postData
            
            let activeClassesSession = urlSession.dataTaskWithRequest(request, completionHandler: { (databaseData, urlResponse, error) -> Void in
                
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
            activeClassesSession.resume()
        }
    }
    
    private func loadActivities()
    {
        loadClassesWithCompletionHandler { (classes) -> Void in
            
            println("Loading Activities...")
            
            if classes.count == 0
            {
                NSNotificationCenter.defaultCenter().postNotificationName(ActivityDataLoaded, object: nil)
                return
            }
            
            if classes[0].isKindOfClass(NSDictionary.classForCoder()) == NO
            {
                NSNotificationCenter.defaultCenter().postNotificationName(ActivityDataLoaded, object: nil)
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
            
            let url = NSURL(string: databaseWebsite.stringByAppendingPathExtension(readFile)!)!
            
            let postData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: YES)
            let postLength = String(postData!.length)
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
            request.HTTPBody = postData
            
            let activeActivitiesSession = urlSession.dataTaskWithRequest(request, completionHandler: { (databaseData, urlResponse, error) -> Void in
                
                self._activitiesLoaded = YES
                
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
                        if newActivity[key] != nil
                        {
                            if newActivity[key]! as NSObject == NSNull()
                            {
                                newActivity[key] = "Null"
                            }
                        }
                        else
                        {
                            newActivity[key] = "Null"
                        }
                    }
                    
                    newActivities[(newActivities as NSArray).indexOfObject(activity)] = newActivity as NSDictionary
                }
                
                let plistPath = NSBundle.mainBundle().pathForResource("Activities", ofType: "plist") as String!
                newActivities.writeToFile(plistPath, atomically: YES)
                
                self.checkForActivityInformationLoaded()
            })
            activeActivitiesSession.resume()
            
        }
    }
    
    func loadUserActivities()
    {
        if NSUserDefaults.standardUserDefaults().stringForKey("defaultLogin") == "Student"
        {
            loadActivities()
            loadActivitySessions()
        }
    }
    
    private func checkForActivityInformationLoaded()
    {
        if _activitiesLoaded == YES && activitySessionsDownloaded == YES
        {
            NSNotificationCenter.defaultCenter().postNotificationName(ActivityDataLoaded, object: nil)
        }
    }
    
    func activityForActivityDictionary(activityDict: NSDictionary) -> Activity
    {
        let activityToReturn = Activity()
        
        activityToReturn.activityID = activityDict["Activity_ID"] as String
        activityToReturn.activityDescription = activityDict["Activity_Description"] as String
        activityToReturn.name = activityDict["Activity_Name"] as String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        activityToReturn.releaseDate = dateFormatter.dateFromString(activityDict["Release_Date"] as String)
        activityToReturn.dueDate = dateFormatter.dateFromString(activityDict["Due_Date"] as String)
        
        let activityData = activityDict["Activity_Data"] as String?
        if activityData != "Null"
        {
            let data = NSData().dataFromHexString(activityData)
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
            activityToReturn.activityData = unarchiver.decodeObjectForKey("activityData") as Array<Dictionary<NSNumber, AnyObject>>
            unarchiver.finishDecoding()
        }
        
        if (activityDict["Quiz"] as String).toInt() == 0
        {
            activityToReturn.quizMode = NO
        }
        else
        {
            activityToReturn.quizMode = YES
        }
        
        activityToReturn.classID = activityDict["Class_ID"] as String
        activityToReturn.totalPoints = (activityDict["Activity_Total_Points"] as String).toInt()!
        
        return activityToReturn
    }
}