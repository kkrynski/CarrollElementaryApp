//
//  DragObject.m
//  Flora Dummy
//
//  Created by Zach Nichols on 11/22/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import "DragObject.h"

@implementation DragObject
@synthesize gravityExists, gravityConstant, currentSpeed, parentViewController;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        gravityConstant = nil;
        gravityExists = [NSNumber numberWithBool:false];
        currentSpeed = 0;
        
        parentViewController = [[UIViewController alloc]init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andGravity: (NSNumber *)gravity
{
    self = [super initWithFrame:frame];
    if (self)
    {
        gravityConstant = gravity;
        gravityExists = [NSNumber numberWithBool:true];
        currentSpeed = 0;
        
        parentViewController = [[UIViewController alloc]init];
    }
    return self;
}

-(void)fall
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
