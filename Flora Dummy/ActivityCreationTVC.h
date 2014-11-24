//
//  ActivityCreationTVC.h
//  FloraDummy
//
//  Created by Zachary Nichols on 11/21/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PageCreationVC.h"

#import "ActivityInfoVC.h"
#import "Activity.h"

@interface ActivityCreationTVC : UITableViewController<PageCreationDelegate, ActivityInfoDelegate>
{
    
}

@property(nonatomic, retain) NSMutableArray *pagesArray;

@property (strong, nonatomic) PageCreationVC *pageCreationVC;

@property(nonatomic, retain) Activity *activity;

@property(nonatomic, retain) ActivityInfoVC *activityInfoVC;
@property (nonatomic, strong) UIPopoverController *activityInfoPopOver;

-(NSString *)createJSONForActivity;

@end
