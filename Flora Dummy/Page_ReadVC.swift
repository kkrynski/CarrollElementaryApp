//
//  Page_ReadVC.swift
//  FloraDummy
//
//  Created by Michael Schloss on 10/31/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class Page_ReadVC: FormattedVC
{
    var pageText : NSString?
    
    @IBOutlet var summaryTextView : UITextView?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        let formattedString = (pageText! as NSString).stringByReplacingOccurrencesOfString("\\n", withString: "\n") as String
        
        summaryTextView!.text = formattedString
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
