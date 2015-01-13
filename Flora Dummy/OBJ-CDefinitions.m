//
//  OBJ-CDefinitions.m
//  FloraDummy
//
//  Created by Michael Schloss on 11/28/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "OBJ-CDefinitions.h"

//Private Defininitions class for UITabBar Transition
@implementation OBJ_CDefinitions

+ (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber
{
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

+ (UIView*)addShadowToView:(UIView*)view reverse:(BOOL)reverse
{
    UIView* containerView = view.superview;
    
    //Create a view with the same frame
    UIView* viewWithShadow = [[UIView alloc] initWithFrame:view.frame];
    
    //Replace the view that we are adding a shadow to
    [containerView insertSubview:viewWithShadow aboveSubview:view];
    [view removeFromSuperview];
    
    //Create a shadow
    UIView* shadowView = [[UIView alloc] initWithFrame:viewWithShadow.bounds];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = shadowView.bounds;
    gradient.colors = @[(id)[UIColor colorWithWhite:0.0 alpha:0.0].CGColor,
                        (id)[UIColor colorWithWhite:0.0 alpha:0.5].CGColor];
    gradient.startPoint = CGPointMake(reverse ? 0.0 : 1.0, 0.0);
    gradient.endPoint = CGPointMake(reverse ? 1.0 : 0.0, 0.0);
    [shadowView.layer insertSublayer:gradient atIndex:1];
    
    //Add the original view into our new view
    view.frame = view.bounds;
    [viewWithShadow addSubview:view];
    
    //Place the shadow on top
    [viewWithShadow addSubview:shadowView];
    
    return viewWithShadow;
}

+ (NSArray*)createSnapshots:(UIView*)view afterScreenUpdates:(BOOL) afterUpdates
{
    UIView* containerView = view.superview;
    
    //Snapshot the left-hand side of the view
    CGRect snapshotRegion = CGRectMake(0, 0, view.frame.size.width / 2, view.frame.size.height);
    UIView *leftHandView = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
    leftHandView.frame = snapshotRegion;
    [containerView addSubview:leftHandView];
    
    //Snapshot the right-hand side of the view
    snapshotRegion = CGRectMake(view.frame.size.width / 2, 0, view.frame.size.width / 2, view.frame.size.height);
    UIView *rightHandView = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
    rightHandView.frame = snapshotRegion;
    [containerView addSubview:rightHandView];
    
    //Send the view that was snapshotted to the back
    [containerView sendSubviewToBack:view];
    
    return @[leftHandView, rightHandView];
}

+ (UIView *) createSnapshotFromView:(UIView *)view afterUpdates:(BOOL)afterUpdates location:(CGFloat)offset left:(BOOL)left withNumberOfFolds:(int)folds
{
    CGSize size = view.frame.size;
    UIView *containerView = view.superview;
    float foldWidth = size.width * 0.5 / (float)folds;
    
    UIView* snapshotView;
    
    if (!afterUpdates)
    {
        //Create a regular snapshot
        CGRect snapshotRegion = CGRectMake(offset, 0.0, foldWidth, size.height);
        snapshotView = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
    }
    else
    {
        //For the to- view for some reason the snapshot takes a while to create. Here we place the snapshot within another view, with the same bckground color, so that it is less noticeable when the snapshot initially renders
        snapshotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, foldWidth, size.height)];
        snapshotView.backgroundColor = view.backgroundColor;
        CGRect snapshotRegion = CGRectMake(offset, 0.0, foldWidth, size.height);
        UIView* snapshotView2 = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
        [snapshotView addSubview:snapshotView2];
    }
    
    //Create a shadow
    UIView* snapshotWithShadowView = [OBJ_CDefinitions addShadowToView:snapshotView reverse:left];
    
    //Add to the container
    [containerView addSubview:snapshotWithShadowView];
    
    //Set the anchor to the left or right edge of the view
    snapshotWithShadowView.layer.anchorPoint = CGPointMake( left ? 0.0 : 1.0, 0.5);
    
    return snapshotWithShadowView;
}

@end
