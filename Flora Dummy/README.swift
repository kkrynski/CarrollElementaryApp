/*

-- Michael Schloss



Herein begins the Database Integration for the FloraDummy App

    This README file will detail the API as I create it.

        *  This API will be built entirely in Objective-C, but will be fully compatible with all Swift files
        *  As of the current moment, all API calls will return an NSDictionary of data.
            *  The current layout of the NSDictionary is undecided right now,
               but I will update this file as I figure out the structure
        

        *  Uploading data will require an NSDictionary containing the necessary values
            *  You will be given constants to use as the dictionary's keys


    There are certain rules that each activity must follow.  These rules will be constantly changing 
      as I develop the API, so nothing here is final.  PLEASE NOTE: Zach's Activity Creation will follow
      seperate rules later on in this README.

        *  Each activity will be responsible for keeping track of their current ActivityID.  This ID will be
           used to update the activity's data
        *  

*/