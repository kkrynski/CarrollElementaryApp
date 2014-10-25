//
//  UIButton_Typical.m
//  Flora Dummy
//
//  Created by Zach Nichols on 2/27/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "UIButton_Typical.h"

@implementation UIButton_Typical
@synthesize gradientColors;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addTarget: self action: @selector(clickedDown:) forControlEvents: UIControlEventTouchDown];
        [self addTarget: self action: @selector(clickReleased:) forControlEvents: UIControlEventTouchUpInside];
        
        //gradientColors = [[NSMutableArray alloc] initWithObjects:(id)[UIColor whiteColor], (id)[UIColor lightGrayColor], nil];
        //self.backgroundColor = [UIColor greenColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    /*
     // Super LBTQI+ code: Creates rainbow gradient
     // Draw a custom gradient
     CAGradientLayer *btnGradient = [CAGradientLayer layer];
     btnGradient.frame = readMoreButton.bounds;
     btnGradient.colors = [NSArray arrayWithObjects:
     (id)[[UIColor redColor] CGColor],
     (id)[[UIColor orangeColor] CGColor],
     (id)[[UIColor yellowColor] CGColor],
     (id)[[UIColor greenColor] CGColor],
     (id)[[UIColor blueColor] CGColor],
     (id)[[UIColor purpleColor] CGColor],
     nil];
     [readMoreButton.layer insertSublayer:btnGradient atIndex:0]; 
     */
}

/*-(void)updateGradient
{
    CAGradientLayer *btnGradient = [CAGradientLayer layer];
    btnGradient.frame = self.bounds;
    btnGradient.colors = gradientColors;
    [self.layer insertSublayer:btnGradient atIndex:0];
}

-(void)updateGradientForColors: (NSArray *)colors
{
    gradientColors = [colors mutableCopy];
    
    [self updateGradient];
}*/


-(void)clickedDown:(id)sender
{
    UIButton *b = (UIButton *)sender;
    
    [b.layer removeAllAnimations];
    
    [UIView animateWithDuration:0.20 animations:^{
        b.alpha = 0.60;
    }];

    
}

-(void)clickReleased:(id)sender
{
    UIButton *b = (UIButton *)sender;
    
    [b.layer removeAllAnimations];

    [UIView animateWithDuration:0.3 animations:^{
        b.alpha = 1.0;
    }];

}

@end
