/*

-- Michael Schloss



Herein begins the Database Integration for the FloraDummy App

    This README file will detail the API as I create it.
        *  This API will be built entirely in Swift, but will be fully compatible with all Objective-C files
        *  Any download API (with the exception of activity loading) calls will
           post a notification when they're done
            *  It is your responsibility to pull the data from the plist.
            *  This is only of concern for PasswordVC
        *  Uploading data will require an NSDictionary containing the necessary values
            *  You will be given constants to use as the dictionary's keys


    There are certain rules that each activity must follow, as listed below.  These rules will be constantly
      changing as I develop the API, so nothing here is final.
        *  Activities do not need to keep track of their ActivityID.  PageManager will handle it
        *  You MUST implement the CESDatabaseActivity API if you wish to use restoration.  Its API is
           listed later.




-----------------
----[[ API ]]----
-----------------


    -------------------------------
    -- Database Manager Creation --
    -------------------------------


        **  For Activity Creation, to implement the CESDatabase API, you should store a property with the 
            type "id<ActivityCreationDatabase>"
                (i.e.) id<ActivityCreationDatabase> databaseManager;

            Then call,

                [CESDatabase databaseManagerForCreationClass];

            to be returned the proper Database Manager


        **  For PasswordVC, to implement the CESDatabase API, you should store a property with the type
            "id<UserAccountsDatabase>"
                (i.e.) id<UserAccountsDatabase> databaseManager;

            Then call,

                [CESDatabase databaseManagerForPasswordVCClass];

            to be returned the proper Database Manager


        **  For PageManager, to implement the CESDatabase API, you should store a property with the
            type "id<PageManagerDatabase>"
                (i.e.) id<PageManagerDatabase> databaseManager;

            Then call,

                [CESDatabase databaseManagerForActivityClass];

            to be returned the proper Database Manager




    ---------------
    -- API Calls --
    ---------------

        Each Database Manager has different API calls, as listed below.  Please find the correct
        Database Manager class and follow its instructions




        -------------------------
        -- CESDatabaseActivity --   -- FINAL API
        -------------------------


            -------------------
            -- [[ Methods ]] --
            -------------------

            - (id) saveActivityState        [[OPTIONAL]]
                *  Saves the activity's state.  All inputted information should be placed in an object of
                   your choice
                *  This method should return the object you used to store the user inputted information

            - (void) restoreActivityState:(id)object
                *  Restores the activity's state.  You should decrypt the object and update your display
                *  object is the object you gave in 'saveActivityState'




        ---------------------------------
        -- UserAccountsDatabaseManager --   -- FINAL API
        ---------------------------------


            --------------------
            -- [[ Constants ]] --
            --------------------


            NSString *UserAccountsDownloaded ([UserAccountsDatabaseManager UserAccountsDownloaded])
                *  Use this constant to listen for the notification when user accounts finish
                   downloading


            -------------------
            -- [[ Methods ]] --
            -------------------


            - (void) downloadUserAccounts
                *  Downloads the user accounts for Teachers and Students.  This method should be called
                   immediately in 'viewDidLoad:'
                *  Once the accounts have downloaded, this method sends out the "UserAccountsDownloaded"
                   notification.  Add your class as an observer to properly respond to the finished download

            - (NSString *) inputtedUsernameIsValid:(NSString *)username andPassword:(NSString *)password
                *  Compares the received user account information with the downloaded information.  If no
                   data has been downloaded, this method immediately returns 'UserStateUserInvalid'.
                *  There are three NSString Constants that can be returned:
                    *  'UserStateUserIsStudent' -- If you receive this NSString constant, that means the
                       inputted information is for a Student Account
                    *  'UserStateUserIsTeacher' -- If you receive this NSString constant, that means the
                       inputted information is for a Teacher Account
                    *  'UserStateUserInvalid'   -- If you receive this NSString constant, that means the 
                       inputted information is invalid

            - (BOOL) storeInputtedUsername:(NSString *)username andPassword:(NSString *)password
                *  Stores the inputted Username and Password onto the device.  User information is encrypted
                   first.
                    *  NOTE: This method will do nothing if '- (UserState) inputtedUserInformationIsValid:' 
                       hasn't been called yet, or returned UserStateUserInvalid.
                *  If returned 'true', the information was successfuly stored onto the device.
                   If returned 'false' the information was not successfully stored onto the device.
                    *  You should use this Bool to determine whether or not you can/should dismiss the 
                       PasswordVC.

            NOTE:   You will not have access to the downloaded user accounts.  This is due in part because
                    they are not stored on the device's memory, and in part because they are stored as Swift
                    objects.  They are unreadable to all but the database manager, and are never decrypted.




        -----------------------------
        -- ActivityDatabaseManager --   -- FINAL API
        -----------------------------


            --------------------
            -- [[ Contants ]] --
            --------------------


            NSString *ActivityID
                *  Used for specifying the activityID in the activitySession Dictionary (see below)

            NSString *ActivityGrade
                *  Used for specifying the Grade in the activitySession Dictionary (see below)

            NSString *ActivityData
                *  Used for specifying the Data in the activitySession Dictionary (see below)
                    *  This should be an NSDictionary formatted however you like

            NSString *ActivityStartDate
                *  Used for specifying the Start Date in the activitySession Dictionary (see below)

            NSString *ActivityEndDate
                *  Used for specifying the End Date in the activitySession Dictionary (see below)

            NSString *ActivityStatus
                *  Used for specifying the status of the activity in the activitySession Dictionary
                   (see below)


            -------------------
            -- [[ Methods ]] --
            -------------------

            
            - (NSDictionary *) activityInformationForActivityID:(NSString *)activityID
                *  Returns the Dictionary of data that was initally uploaded with the activity
                *  Returns nil if the activityID is invalid

            - (void) uploadActivitySession:(NSDictionary *)activitySession completion:^(BOOL)completion
                *  Uploads a new activity session, or updates it if it already exists
                *  activitySession is a Dictionary of values corresponding to the constants listed for this
                   class.  They may be in any order
                *  completion is the Completion Handler to be called when the upload finishes
                *  This method immediately returns control to the application and will call the completion 
                   handler upon completion of the upload.  If the activity session failed to upload, or has 
                   an invalid structure, the completion handler will be called with 'NO" for 'uploadSuccess'




        -------------------------------------
        -- ActivityCreationDatabaseManager --   -- FINAL API
        -------------------------------------


            --------------------
            -- [[ Contants ]] --
            --------------------

            
            NSString *ActivityName
                *  Used for specifying the activity's name in the upload dictionary

            NSString *ActivityDescription
                *  Used for specifying the activity's description in the upload dictionary

            NSString *TotalPoints
                *  Used for specifying the activity's total points in the upload dictionary

            NSString *ReleaseDate
                *  Used for specifying the activity's release date in the upload dictionary

            NSString *DueDate
                *  Used for specifying the activity's due date in the upload dictionary

            NSString *ActivityData
                *  Used for specifying the activity's activity data in the upload dictionary

            NSString *ClassID
                *  Used for specifying the activity's class ID in the upload dictionary


            -------------------
            -- [[ Methods ]] --
            -------------------

            - (void) uploadNewActivity:(NSDictionary *)activityData completion:^(NSString *)completion
                *  Uploads the activity data to the database
                *  activityData is the formatted Dictionary of the activities information corresponding to
                   the String constants provided by the class.  The keys may be in any order
                *  completion is the Completion Handler to be called when the activity is uploaded.  
                   Contains a string parameter that will contain the activity's ID if the upload succeeded 
                   or nil if the upload failed
                *  This method immediately returns control to the application and will call the completion 
                   handler upon completion of the upload.  If the activity failed to upload, or has an 
                   invalid structure, the completion handler will be called with a 'nil' activityID


*/







