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
@synthesize name, modDate, releaseDate, dueDate, iconImageName, activityID;
@synthesize pageArray;

-(id)init
{
    self = [super init];
    if (self)
    {
        // Initialize
        self.name = [[NSString alloc] initWithFormat:@""];
        self.modDate = [[NSDate alloc] init];
        self.releaseDate = [[NSDate alloc] init];
        self.dueDate = [[NSDate alloc] init];
        self.iconImageName = [[NSString alloc] initWithFormat:@"117-todo"]; // Default image name
        self.activityID = [[NSString alloc] initWithFormat:@""];
        self.pageArray = [[NSArray alloc] initWithObjects:nil];
        
    }
    return self;
}

-(id)initWithContentsOfJSONText: (NSString *)jsonText
{
    self = [super init];
    if (self)
    {
        // Initialize
        self.name = [[NSString alloc] initWithFormat:@""];
        self.modDate = [[NSDate alloc] init];
        self.releaseDate = [[NSDate alloc] init];
        self.dueDate = [[NSDate alloc] init];
        self.iconImageName = [[NSString alloc] initWithFormat:@"117-todo"]; // Default image name
        self.activityID = [[NSString alloc] initWithFormat:@""];
        self.pageArray = [[NSArray alloc] initWithObjects:nil];
        
    }
    return self;
}


@end
