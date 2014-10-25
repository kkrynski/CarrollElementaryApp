//
//  LanguageArtsVC.h
//  Flora Dummy
//
//  Created by Zach Nichols on 9/28/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

// Note: this is bad syntax. You should never import a .h file into a .h, as it
//       could cause an infinite loop of imports. I think we should use
//       @class PageManager.h, but I'm uncertain.
#import "PageManager.h"

@interface LanguageArtsVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
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
