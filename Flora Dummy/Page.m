//
//  Page.m
//  FloraDummy
//
//  Created by Zachary Nichols on 11/21/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "Page.h"

#import "Content.h"

@implementation Page
@synthesize pageVCType;
@synthesize variableContentDict;

-(id)init
{
    if (self = [super init])
    {
        // Initialize
        pageVCType = [[NSString alloc] initWithFormat:@""];
        variableContentDict = [[NSDictionary alloc] init];
        
    }
    return self;
}

-(id)initWithContentsOfJSONText: (NSString *)jsonText
{
    if (self = [super init])
    {
        // Initialize
        pageVCType = [[NSString alloc] initWithFormat:@""];
        variableContentDict = [[NSDictionary alloc] init];
        
    }
    return self;
}

@end
