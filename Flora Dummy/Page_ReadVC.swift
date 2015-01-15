//
//  Page_ReadVC.swift
//  FloraDummy
//
//  Created by Michael Schloss on 10/31/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class Page_ReadVC: PageVC
{
    
    var pageText : NSString?
    
    @IBOutlet var summaryTextView : UITextView?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        let formattedString = (pageText! as NSString).stringByReplacingOccurrencesOfString("\\n", withString: "\n") as String
        
        summaryTextView!.text = formattedString
        
        //Frame overrides
        
        //otherLabel.frame = CGRectMake(otherLabel.frame.origin.x, 20, otherLabel.frame.size.width, otherLabel.frame.size.height)
    }

    //Color Theme setting
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        Definitions.outlineTextInTextView(summaryTextView!, forFont: summaryTextView!.font)
        
        summaryTextView!.textColor = primaryColor
        summaryTextView!.backgroundColor = secondaryColor
    }
}
