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
        *  In the interest of data protection, you will only be given access to the Activity table.  You
           will not be able to see or interact with the Subject, Teacher, Student, Class, Student_Class, or
           Activity_Session tables


    [[ API ]]

        To implement the CESDatabase API, you must store a property with the type "id<CESDatabase>"
            (i.e.) id<CESDatabase> databaseManager;


        To grab the active database manager for your class, call:

            + (id<CESDatabase>) databaseManagerForClass:(Class)sender
                *  You must supply this method with your class.  (i.e.) [myClass class]




*/