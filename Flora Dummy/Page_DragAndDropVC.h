//
//  Page_DragAndDropVC.h
//  Flora Dummy
//
//  Created by Zach Nichols on 11/15/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PageVC.h"
#import "DragObject.h"

@interface Page_DragAndDropVC : PageVC<UICollisionBehaviorDelegate>
{
    
}

@property (nonatomic, strong) UIImageView *backgroundImage;

@property (nonatomic, retain) NSMutableArray *dropTargets;
@property (nonatomic, strong) DragObject *currentDragObject;
//@property (nonatomic, strong) UIImageView *currentDragObject;
@property (nonatomic, retain) NSMutableArray *dragObjects;
@property (nonatomic, assign) CGPoint touchOffset;
@property (nonatomic, assign) CGPoint homePosition;


@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIGravityBehavior *g;
@property (strong, nonatomic) UICollisionBehavior *c;

@property(nonatomic) UITouch* previousTouch;
@property(nonatomic) UITouch* currentTouch;


@end
