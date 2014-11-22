//
//  Content.m
//  FloraDummy
//
//  Created by Zachary Nichols on 11/21/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "Content.h"

@implementation Content
@synthesize type;
@synthesize variableContent;

-(id)initWithContentsOfJSONText: (NSString *)jsonText
{
    if (self = [super init])
    {
        // Initialize
        type = [[NSString alloc] initWithFormat:@""];
        variableContent = [[NSDictionary alloc] initWithObjects:nil forKeys:nil];
        
    }
    return self;
}

@end
