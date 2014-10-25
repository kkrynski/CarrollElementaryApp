//
//  MathProblemVC_Normal.h
//  Flora Dummy
//
//  Created by Zach Nichols on 1/29/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "PageVC.h"

@interface MathProblemVC_Normal : PageVC
{
    UIView *problemBoxView;
    UIView *mathBoxView;
    
    NSString *mathEquation;

}

@property(nonatomic, retain) UIView *problemBoxView;
@property(nonatomic, retain) UIView *mathBoxView;

@property(nonatomic, retain) NSString *mathEquation;

@property(nonatomic, retain) NSArray *buttonsArray;
@property(nonatomic, retain) NSArray *buttonsInfoArray;
@property(nonatomic, retain) NSArray *boxesArray;
@property(nonatomic, retain) NSArray *boxesInfoArray;

@end
