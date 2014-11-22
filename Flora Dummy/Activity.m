//
//  Activity.m
//  FloraDummy
//
//  Created by Zachary Nichols on 11/21/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "Activity.h"

#import "Page.h"

@implementation Activity
@synthesize name, dueDate, iconImageName, activityID;
@synthesize pageArray;

-(id)initWithContentsOfJSONText: (NSString *)jsonText
{
    if (self = [super init])
    {
        // Initialize
        name = [[NSString alloc] initWithFormat:@""];
        dueDate = [[NSDate alloc] init];
        iconImageName = [[NSString alloc] initWithFormat:@"117-todo"]; // Default image name
        activityID = [[NSString alloc] initWithFormat:@""];
        pageArray = [[NSArray alloc] initWithObjects:nil];
        
    }
    return self;
}

@end
