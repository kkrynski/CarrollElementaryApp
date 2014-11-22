//
//  ActivityCreationTVC.h
//  FloraDummy
//
//  Created by Zachary Nichols on 11/21/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCreationTVC : UITableViewController
{
    
}

@property(nonatomic, retain) NSMutableArray *pagesArray;

-(NSString *)createJSONForActivity;

@end
