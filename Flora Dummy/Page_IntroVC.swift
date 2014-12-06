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
    
    private var titleLabel : UILabel?
    
    var activityTitle : String?
        {
        set
        {
            titleLabel = UILabel()
            titleLabel!.text = activityTitle
            titleLabel!.font = UIFont(name: "MarkerFelt", size: 72)
            titleLabel!.sizeToFit()
            if isViewLoaded() == YES
            {
                titleLabel!.center = CGPointMake(self.view.frame.size.width/2.0, self.otherLabel.frame.size.height + self.otherLabel.frame.origin.y + 8 + titleLabel!.frame.size.height/2.0)
                self.view.addSubview(titleLabel!)
            }
        }
        get
        {
            return titleLabel?.text
        }
    }
    
    @IBOutlet var summaryTextView : UITextView?
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        pageControl?.numberOfPages = pageCount.integerValue
        
        summaryTextView!.text = summary
        Definitions.outlineTextInTextView(summaryTextView!, forFont: summaryTextView!.font)
        summaryTextView!.textColor = primaryColor
        summaryTextView!.backgroundColor = secondaryColor
        
        if titleLabel != nil
        {
            titleLabel!.center = CGPointMake(self.view.frame.size.width/2.0, self.otherLabel.frame.size.height + self.otherLabel.frame.origin.y + 8 + titleLabel!.frame.size.height/2.0)
            self.view.addSubview(titleLabel!)
        }
    }
}
