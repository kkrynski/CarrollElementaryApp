//
//  UIButton_Typical.h
//  Flora Dummy
//
//  Created by Zach Nichols on 2/27/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton_Typical : UIButton
{
    
}

@property(nonatomic, retain) NSMutableArray *gradientColors;

-(void)updateGradient;
-(void)updateGradientForColors: (NSArray *)colors;

@end
