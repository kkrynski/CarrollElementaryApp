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

NS_CLASS_DEPRECATED_IOS(8_1, 8_1)
///This class is now deprecated.  Please use \b SquareDragAndDrop instead
@interface Page_DragAndDropVC : FormattedVC <UICollisionBehaviorDelegate>
{
    
}

@property (nonatomic, strong) UIImageView *backgroundImage NS_DEPRECATED_IOS(8_1, 8_1);

@property (nonatomic, retain) NSMutableArray *dropTargets NS_DEPRECATED_IOS(8_1, 8_1);
@property (nonatomic, strong) DragObject *currentDragObject NS_DEPRECATED_IOS(8_1, 8_1);
//@property (nonatomic, strong) UIImageView *currentDragObject;
@property (nonatomic, retain) NSMutableArray *dragObjects NS_DEPRECATED_IOS(8_1, 8_1);
@property (nonatomic, assign) CGPoint touchOffset NS_DEPRECATED_IOS(8_1, 8_1);
@property (nonatomic, assign) CGPoint homePosition NS_DEPRECATED_IOS(8_1, 8_1);


@property (strong, nonatomic) UIDynamicAnimator *animator NS_DEPRECATED_IOS(8_1, 8_1);
@property (strong, nonatomic) UIGravityBehavior *g NS_DEPRECATED_IOS(8_1, 8_1);
@property (strong, nonatomic) UICollisionBehavior *c NS_DEPRECATED_IOS(8_1, 8_1);

@property(nonatomic) UITouch* previousTouch NS_DEPRECATED_IOS(8_1, 8_1);
@property(nonatomic) UITouch* currentTouch NS_DEPRECATED_IOS(8_1, 8_1);


@end
