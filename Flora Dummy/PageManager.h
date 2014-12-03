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

@interface PageManager : NSObject
{
    
    // We must also keep track of what index we are on,
    // just like a page number (but not quite)
    NSIndexPath *currentIndex;
    
    // Also, we'll need the activity dictionary to tell us
    // various details about the activity, such as due date.
    Activity *activity;
    
    // Keep a reference to the controller that called and
    // saved this PageManager.
    UIViewController *parentViewController;
    
    // I BELIEVE this helps create that page-turning effect.
    UIPageViewController *pageViewController;
}

@property(nonatomic, retain) IBOutlet NSIndexPath *currentIndex;

@property(nonatomic, retain) Activity *activity;

@property(nonatomic, retain) UIViewController *parentViewController;
@property(nonatomic, retain) UIPageViewController *pageViewController;

// Custom intialization method allows us to load an activity
// dictionary and set a reference to the parent view controller.
-(id)initWithActivity: (Activity *)a forParentViewController: (UIViewController *)parent;

// These are some handy-dandy functions we can use to navigate
// through the activity. It's 12:23 AM, and handy-dandy just
// felt like a good word to use. Props if you read this.
//-(void)goToViewControllerAtIndex: (NSIndexPath *)indexPath;
-(void)goToNextViewController;
-(void)goToPreviousViewController;

@end
