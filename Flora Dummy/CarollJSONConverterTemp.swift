//
//  CarollJSONConverterTemp.swift
//  FloraDummy
//
//  Created by Michael Schloss on 2/8/15.
//  Copyright (c) 2015 SGSC. All rights reserved.
//

import UIKit

class CarollJSONConverterTemp: NSObject
{
    override init()
    {
        super.init()
        
        let filePath = NSBundle.mainBundle().pathForResource("Carroll", ofType: "json")
        let JSONData = NSData(contentsOfFile: filePath!)
        
        let JSONStuff = NSJSONSerialization.JSONObjectWithData(JSONData!, options: .allZeros, error: nil) as NSDictionary
        
        //println(JSONStuff)
    }
}
