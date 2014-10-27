//
//  PageManager.h
//  Flora Dummy
//
//  Created by Zach Nichols on 11/2/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageManager : NSObject
{
    // This is an array to hold the pages of the activity
    NSArray *pageArray;
    
    // We must also keep track of what index we are on,
    // just like a page number (but not quite)
    NSIndexPath *currentIndex;
    
    // Also, we'll need the activity dictionary to tell us
    // various details about the activity, such as due date.
    NSDictionary *activityDict;
    
    // Keep a reference to the controller that called and
    // saved this PageManager.
    UIViewController *parentViewController;
    
    // I BELIEVE this helps create that page-turning effect.
    UIPageViewController *pageViewController;
}

@property(nonatomic, retain) IBOutlet NSArray *pageArray;
@property(nonatomic, retain) IBOutlet NSIndexPath *currentIndex;

@property(nonatomic, retain) NSDictionary *activityDict;

@property(nonatomic, retain) UIViewController *parentViewController;
@property(nonatomic, retain) UIPageViewController *pageViewController;

// Custom intialization method allows us to load an activity
// dictionary and set a reference to the parent view controller.
-(id)initWithActivity: (NSDictionary *)dictionary forParentViewController: (UIViewController *)parent;

// These are some handy-dandy functions we can use to navigate
// through the activity. It's 12:23 AM, and handy-dandy just
// felt like a good word to use. Props if you read this.
-(void)goToViewControllerAtIndex: (NSIndexPath *)indexPath;
-(void)goToNextViewController;
-(void)goToPreviousViewController;

@end
