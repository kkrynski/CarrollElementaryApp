//
//  ScienceVC.swift
//  Flora Dummy
//
//  Created by Michael Schloss on 10/25/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class ScienceVC: SubjectVC, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate
{
    override init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        subjectID = "2"
        subjectName = "Science"
    }
}
