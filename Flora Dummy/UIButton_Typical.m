//
//  UIButton_Typical.m
//  Flora Dummy
//
//  Created by Zach Nichols on 2/27/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "UIButton_Typical.h"
#import "FloraDummy-Swift.h"

@implementation UIButton_Typical
@synthesize gradientColors;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addTarget: self action: @selector(clickedDown:) forControlEvents: UIControlEventTouchDown];
        [self addTarget: self action: @selector(clickedDown:) forControlEvents: UIControlEventTouchDragEnter];
        [self addTarget: self action: @selector(clickReleased:) forControlEvents: UIControlEventTouchUpInside];
        [self addTarget: self action: @selector(clickReleased:) forControlEvents: UIControlEventTouchDragExit];
    }
    return self;
}

- (void) setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [Definitions outlineTextInLabel:self.titleLabel];
}

-(void)clickedDown:(id)sender
{
    UIButton *b = (UIButton *)sender;
    
    [b.layer removeAllAnimations];
    
    [UIView animateWithDuration:0.20 animations:^
     {
         b.alpha = 0.60;
     }];
}

-(void)clickReleased:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    [button.layer removeAllAnimations];
    
    [UIView animateWithDuration:0.3 animations:^
     {
         button.alpha = 1.0;
     }];
}

@end
