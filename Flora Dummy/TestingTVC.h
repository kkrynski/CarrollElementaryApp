//
//  TestingTVC.h
//  Flora Dummy
//
//  Created by Zachary Nichols on 10/25/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//  Modified by Michael Schloss on 01/20/15.
//

@import UIKit;

@class PageManager;

@interface TestingTVC : UITableViewController <UIViewControllerTransitioningDelegate>
{
    NSArray *tests;
    
    PageManager *activePageManager;
}

@end
