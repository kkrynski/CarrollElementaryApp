//
//  PageVC.h
//  Flora Dummy
//
//  Created by Zach Nichols on 11/2/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FormattedVC.h"
#import "UIButton_Typical.h"

@interface PageVC : FormattedVC
{
    // Reference to parent page manager
    NSObject *parentManager; //do not call PageManager on this page--will create infinite loop
    
    // Title string holds title of page
    NSString *titleString;
    
    // Date string holds due date of assignment
    NSString *dateString;
    
    // Page number is the numeric number of the page, not the index
    NSNumber *pageNumber;
    
    // Page count represents how many pages are in this activity.
    NSNumber *pageCount;
    
    // Page dictionary keeps info about the specific page
    NSDictionary *pageDictionary;
    
    // Page Control allows us to see those dots at the bottom of the screen
    // representing pages.
    IBOutlet UIPageControl *pageControl;
    
}

@property(nonatomic, retain) NSObject *parentManager; //do not call PageManager on this page--will create infinite loop

@property(nonatomic, retain) NSString *titleString;
@property(nonatomic, retain) NSString *dateString;
@property(nonatomic, retain) NSNumber *pageNumber;
@property(nonatomic, retain) NSNumber *pageCount;
@property(nonatomic, retain) NSDictionary *pageDictionary;

@property(nonatomic, retain) IBOutlet UIPageControl *pageControl;

// Buttons for navigation
@property(nonatomic, retain) UIButton_Typical *nextButton;
@property(nonatomic, retain) UIButton_Typical *previousButton;

// Labels for displaying information at top of page
@property(nonatomic, retain) UILabel *dateLabel;
@property(nonatomic, retain) UILabel *otherLabel; //assign meaning to this later
@property(nonatomic, retain) UILabel *titleLabel;

// Custom initialization lets us store reference
// to parent
-(id)initWithParent: (NSObject *)parent;

// End activity stops the activity and returns back to the
// subject screen
-(IBAction)endActivity;

// Next page moves the activity to the next page,
// and sends signal to page manager to move forward.
-(IBAction)goToNextPage;

// Previous page moves page to previous page,
// and sends signal to page manager to move back.
-(IBAction)goToPreviousPage;

@end
