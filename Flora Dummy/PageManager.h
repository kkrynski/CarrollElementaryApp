//
//  PageManager.h
//  FloraDummy
//
//  Created by Zachary Nichols on 11/29/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

#import "Activity.h"

NS_CLASS_DEPRECATED_IOS(8_0, 8_1)
///This class is now deprecated.  Please switch to \b NewPageManager
@interface PageManager : NSObject
{
    
    // We must also keep track of what index we are on,
    // just like a page number (but not quite)
    NSIndexPath *currentIndex NS_DEPRECATED_IOS(8_1, 8_1);
    
    // Also, we'll need the activity dictionary to tell us
    // various details about the activity, such as due date.
    Activity *activity NS_DEPRECATED_IOS(8_1, 8_1);
    
    // Keep a reference to the controller that called and
    // saved this PageManager.
    UIViewController *parentViewController NS_DEPRECATED_IOS(8_1, 8_1);
    
    // I BELIEVE this helps create that page-turning effect.
    UIPageViewController *pageViewController NS_DEPRECATED_IOS(8_1, 8_1);
}

@property(nonatomic, retain) IBOutlet NSIndexPath *currentIndex NS_DEPRECATED_IOS(8_1, 8_1);

@property(nonatomic, retain) Activity *activity NS_DEPRECATED_IOS(8_1, 8_1);

@property(nonatomic, retain) UIViewController *parentViewController NS_DEPRECATED_IOS(8_1, 8_1);
@property(nonatomic, retain) UIPageViewController *pageViewController NS_DEPRECATED_IOS(8_1, 8_1);

// Custom intialization method allows us to load an activity
// dictionary and set a reference to the parent view controller.
-(id)initWithActivity: (Activity *)a forParentViewController: (UIViewController *)parent NS_DEPRECATED_IOS(8_1, 8_1);

// These are some handy-dandy functions we can use to navigate
// through the activity. It's 12:23 AM, and handy-dandy just
// felt like a good word to use. Props if you read this.
//-(void)goToViewControllerAtIndex: (NSIndexPath *)indexPath;
-(void)goToNextViewController NS_DEPRECATED_IOS(8_1, 8_1);
-(void)goToPreviousViewController NS_DEPRECATED_IOS(8_1, 8_1);

@end
