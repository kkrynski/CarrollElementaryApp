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
    private let primaryColor : UIColor?
    private let secondaryColor : UIColor?
    private let backgroundColor : UIColor?
    
    @IBOutlet var titleLabel : UILabel?
    @IBOutlet var subTitleLabel : UILabel?
    @IBOutlet var homeImageView : UIImageView?
    
    //Set the colors here for instant loading
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        let standardDefaults = NSUserDefaults.standardUserDefaults()
    }

    //Required in Swift.  Blank because we don't use it.
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
