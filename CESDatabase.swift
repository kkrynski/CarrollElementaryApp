//
//  CESDatabase.swift
//  FloraDummy
//
//  Created by Michael Schloss on 12/12/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import Foundation

protocol CESDatabase
{
    
}

private var databaseManagerInstance : DatabaseManager?

class DatabaseManager : NSObject
{
    private var activityCreationDatabaseManager : CESDatabase?
    private var activityDatabaseManager : CESDatabase?
    
    override init()
    {
        fatalError("You cannot initialize this class.  Please call \"+ (id<CESDatabase>) databaseManagerForClass:(Class)sender\"")
    }
    
    private init(fromSharedManager: Bool)
    {
        super.init()
        
        activityCreationDatabaseManager = ActivityCreationDatabaseManager()
        activityDatabaseManager = ActivityDatabaseManager()
    }
    
    private class func sharedManager() -> DatabaseManager
    {
        if databaseManagerInstance == nil
        {
            databaseManagerInstance = DatabaseManager(fromSharedManager: YES)
        }
        
        return databaseManagerInstance!
    }
    
    class func databaseManagerForClass(sender: AnyClass) -> CESDatabase
    {
        if sender === PageCreationVC.classForCoder()
        {
            return DatabaseManager.sharedManager().activityCreationDatabaseManager!
        }
        return DatabaseManager.sharedManager().activityDatabaseManager!
    }
}

private class ActivityCreationDatabaseManager : NSObject, CESDatabase
{
    
}

private class ActivityDatabaseManager : NSObject, CESDatabase
{
    
}