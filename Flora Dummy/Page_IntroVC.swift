//
//  Page_IntroVC.swift
//  FloraDummy
//
//  Created by Michael Schloss on 10/31/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class Page_IntroVC: PageVC
{
    var summary = "Welcome to activity foo, where will you learn to blah and bleh by using bluh.\n\nPress \"Next\" to move on or \"Previous\" to move back."
    
    @IBOutlet var summaryTextView : UITextView?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        pageControl.numberOfPages = pageCount.integerValue
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        Definitions.outlineTextInTextView(summaryTextView!, forFont: summaryTextView!.font)
        summaryTextView!.textColor = primaryColor
        summaryTextView!.backgroundColor = secondaryColor
    }
}
