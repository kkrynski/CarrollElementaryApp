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

-(id)init
{
    if (self = [super init])
    {
        // Initialize
        type = [[NSString alloc] initWithFormat:@""];
        variableContent = [[NSDictionary alloc] initWithObjects:nil forKeys:nil];
        
    }
    return self;
}

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

-(void)setFrame: (NSArray *)elements
{
    bounds = CGRectMake([(NSNumber *)[elements objectAtIndex:0] floatValue],
                        [(NSNumber *)[elements objectAtIndex:1] floatValue],
                        [(NSNumber *)[elements objectAtIndex:2] floatValue],
                        [(NSNumber *)[elements objectAtIndex:3] floatValue]);
}

-(CGRect)getFrame
{
    return bounds;
}

-(NSArray *)arrayForBounds
{
    return @[[NSNumber numberWithFloat:bounds.origin.x],
             [NSNumber numberWithFloat:bounds.origin.y],
             [NSNumber numberWithFloat:bounds.size.width],
             [NSNumber numberWithFloat:bounds.size.height]];
}

@end
