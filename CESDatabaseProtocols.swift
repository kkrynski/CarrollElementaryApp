//
//  CESDatabaseProtocols.swift
//  FloraDummy
//
//  Created by Michael Schloss on 1/21/15.
//  Copyright (c) 2015 SGSC. All rights reserved.
//

//--These are the protocols for the CESDatabase--\\

import Foundation
import UIKit

@objc protocol ActivityCreation
{
    /**
    The settings for the activity, returned in an NSDictionary
    
    When returning the settings, please format the dictionary as such:
        * Key: SettingName
        * Value: Setting Type
    
    (i.e.) [NSDictionary dictionaryWithObjectsAndKeys:"BOOL", "Should Present Horizontally", "String", "Text For Introduction", nil]
    */
    func settingsForActivity() -> NSDictionary
}

@objc protocol CESDatabaseActivity
{
    /**
    The reference to the PageManager instance that is holding your activity.
    
    \note This could be nil.  Please watch out for nil pageManagerParents
    */
    var pageManagerParent: PageManager? { get set }
    
    /**
    Saves the Activity's state.  All user inputted data, taps, and movements (if necessary) should be saved into an object of your choice
    
    :returns: An immutable copy of an object the activity used to store its information
    */
    optional func saveActivityState() -> AnyObject!
    
    /**
    Restores the activity's state to what the user last left it as.  Any changes should be decoded from 'object' and updated on screen
    
    :param: object The object given in 'saveActivityState'
    */
    optional func restoreActivityState(object: AnyObject!)
}

@objc protocol PageManagerDatabase
{
    /**
    
    Returns the Activity Session for the activity with the specified activityID
    
    :param: activityID The activityID of the activity requesting its data
    
    :returns: The Session of data that was initally uploaded with the activity
    
    */
    func activitySessionForActivityID(activityID: String, activity: Activity) -> ActivitySession
    
    /**
    
    Uploads a new activity session, or updates it if it already exists.
    
    This method immediately returns control to the application and will call the completion handler upon completion of the upload.  If the activity session failed to upload, or has an invalid structure, the completion handler will be called with 'NO" for 'uploadSuccess'
    
    :param: activitySession A Dictionary of values corresponding to the constants listed for this class.  They may be in any order
    :param: completion The Completion Handler to be called when the upload finishes
    
    */
    func uploadActivitySession(activitySession: ActivitySession, completion: ((uploadSuccess: Bool) -> Void))
}

@objc protocol ActivityCreationDatabase
{
    /**
    
    Uploads the activity data to the database.
    
    This method immediately returns control to the application and will call the completion handler upon completion of the upload.  If the activity failed to upload, or has an invalid structure, the completion handler will be called with a 'nil' activityID
    
    :param: activityData The Activity object you created
    :param: completion The Completion Handler to be called when the activity is uploaded.  Contains a string parameter that will contain the activity's ID if the upload succeeded or nil if the upload failed
    
    */
    func uploadNewActivity(activityData: Activity, completion: ((activityID: String?) -> Void))
}

@objc protocol UserAccountsDatabase
{
    /**
    
    Downloads the user accounts for Teachers and Students.  This method should be called immediately in 'viewDidLoad:'
    
    Once the accounts have downloaded, this method sends out the "UserAccountsDownloaded" notification.  Add your class as an observer to properly respond to the finished download
    
    */
    func downloadUserAccounts()
    
    /**
    
    Compares the received user account information with the downloaded information.  If no data has been downloaded, this method returns invalid.
    
    :param: username The inputted username to check
    :param: password The inputted password to check
    
    :returns: This method will return one of three constants upon completion:
    :returns: *  'UserStateUserIsStudent' -- The inputted information is for a Student Account
    :returns: *  'UserStateUserIsTeacher' -- The inputted information is for a Teacher Account
    :returns: *  'UserStateUserInvalid'   -- The inputted information is invalid
    
    */
    func inputtedUsernameIsValid(username: String, andPassword password: String) -> UserState
    
    /**
    
    Stores the inputted Username and Password onto the device.  User information is encrypted first.
    
    * NOTE: This method will immediately return 'false' if 'inputtedUserInformationIsValid:' hasn't been called yet, or returned UserStateUserInvalid.
    
    :param: username The inputted username to store
    :param: password The inputted password to store
    
    :returns: If returned 'true', the information was successfuly stored onto the device.
    :returns: If returned 'false' the information was not successfully stored onto the device.
    :returns: You should use this Bool to determine whether or not you can/should dismiss the PasswordVC.
    
    */
    func storeInputtedUserInformation(username: String, andPassword password: String) -> Bool
}

@objc protocol MainActivitiesDatabase
{
    func loadUserActivities()
    
    var activitiesLoaded : Bool { get }
    
    func activityForActivityDictionary(activityDict: NSDictionary) -> Activity
}
