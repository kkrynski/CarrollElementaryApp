//
//  HomeVC.swift
//  Flora Dummy
//
//  Created by Michael Schloss on 10/25/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class HomeVC: UIViewController
{
    //Elements on screen
    @IBOutlet var titleLabel : UILabel?
    @IBOutlet var subTitleLabel : UILabel?
    @IBOutlet var homeImageView : UIImageView?
    
    //Set the colors here for instant loading
    override func viewWillAppear(animated: Bool)
    {
        //Directly set the colors since we don't need to later reference them at anytime
        
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        
        titleLabel!.textColor = Definitions.colorWithHexString(standardDefaults.objectForKey("primaryColor") as String)
        Definitions.outlineTextInLabel(titleLabel!)
        
        subTitleLabel!.textColor = Definitions.colorWithHexString(standardDefaults.objectForKey("secondaryColor") as String)
        Definitions.outlineTextInLabel(subTitleLabel!)
        
        view.backgroundColor = Definitions.colorWithHexString(standardDefaults.objectForKey("backgroundColor") as String)
    }

}
