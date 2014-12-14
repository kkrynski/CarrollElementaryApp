/*

-- Michael Schloss



Herein begins the Database Integration for the FloraDummy App

    This README file will detail the API as I create it.

        *  This API will be built entirely in Swift, but will be fully compatible with all Objective-C files
        *  As of the current moment, all API calls will return an NSDictionary of data.
            *  The current layout of the NSDictionary is undecided right now,
               but I will update this file as I figure out the structure
        

        *  Uploading data will require an NSDictionary containing the necessary values
            *  You will be given constants to use as the dictionary's keys


    There are certain rules that each activity must follow, as listed below.  These rules will be constantly
      changing as I develop the API, so nothing here is final.  PLEASE NOTE: Zach's Activity Creation will 
      follow seperate rules later on in this README.

        *  Each activity will be responsible for keeping track of their current ActivityID.  This ID will be
           used to update the activity's data/grades
        *  You will be unable to interact with the Database beyond updating specific values and downloading 
           any existing data for the activity.  This is to keep from accidental (or even purposeful)
           overwrites
        *  In the interest of data protection, you will only be given access to the respective table your
           activity requires


----[[ API ]]----


    -- Database Manager creation

        **  For Activity Creation, to implement the CESDatabase API, you must store a property with the type
            "id<CESCreationDatabase>"
                (i.e.) id<CESCreationDatabase> databaseManager;

            Then call,

                [DatabaseManager databaseManagerForCreationClass];

            to be returned the proper Database Manager


        **  For PasswordVC, to implement the CESDatabase API, you must store a property with the type
            "id<CESUserAccountsDatabase>"
                (i.e.) id<CESUserAccountsDatabase> databaseManager;

           Then call,

                [DatabaseManager databaseManagerForPasswordVCClass];

           to be returned the proper Database Manager


        **  For PasswordVC, to implement the CESDatabase API, you must store a property with the type
            "id<CESUserAccountsDatabase>"
                (i.e.) id<CESUserAccountsDatabase> databaseManager;

            Then call,

                [DatabaseManager databaseManagerForPasswordVCClass];

            to be returned the proper Database Manager


    -- API Calls

        Each Database Manager has different API calls, as listed below.  Please find the correct
        Database Manager class and follow its instructions

*/