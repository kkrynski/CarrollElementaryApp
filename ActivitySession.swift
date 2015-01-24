//
//  ActivitySession.swift
//  FloraDummy
//
//  Created by Michael Schloss on 1/17/15.
//  Copyright (c) 2015 SGSC. All rights reserved.
//

import Foundation
import UIKit

class ActivitySession : NSObject
{
    ///The Activity's ID
    var activityID = "000000"
    
    ///The Activity's Grade
    var grade = "000"
    
    ///The Activity's Data
    var activityData = Array<Dictionary<NSNumber, AnyObject>>()
    
    ///The Activity's Start Date
    var startDate = NSDate()
    
    ///The Activity's End Date
    var endDate : NSDate? = nil
    
    ///The Activity's Status
    var status = "Not Started"
    
    override init()
    {
        super.init()
    }
}
