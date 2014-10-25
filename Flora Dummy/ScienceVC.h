//
//  ScienceVC.h
//  Flora Dummy
//
//  Created by Zach Nichols on 9/28/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PageManager.h"

@interface ScienceVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    PageManager *pageManager;
}

// Title label holds title of subject
@property(nonatomic, retain) IBOutlet UILabel *titleLabel;

// Activities table view holds the list of activities
@property(nonatomic, retain) IBOutlet UITableView *activitiesTableView;

// Notifications text field holds text of temporary or minor importance,
// such as: "Don't forget to double check your answers!"
@property(nonatomic, retain) IBOutlet UITextView *notificationTextField;

// Page Manager is used to control navigation amongst an activity's screens
// It is importance to hold the value here, in the parent controller, so that
// it retains its internal variables and data.
@property(nonatomic, retain) PageManager *pageManager;

@end