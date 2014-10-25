//
//  DragObject.h
//  Flora Dummy
//
//  Created by Zach Nichols on 11/22/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragObject : UIImageView
{
    NSNumber *gravityExists;
    NSNumber *gravityConstant;
    
    NSNumber *currentSpeed;
    
    UIViewController *parentViewController;
    
}

@property(nonatomic, retain) NSNumber *gravityExists;
@property(nonatomic, retain) NSNumber *gravityConstant;

@property(nonatomic, retain) NSNumber *currentSpeed;

@property(nonatomic, retain) UIViewController *parentViewController;

- (id)initWithFrame:(CGRect)frame andGravity: (NSNumber *)gravity;
-(void)fall;

@end
