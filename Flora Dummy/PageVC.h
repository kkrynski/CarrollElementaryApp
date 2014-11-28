//
//  PageVC.h
//  Flora Dummy
//
//  Created by Zach Nichols on 11/2/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FormattedVC.h"

@class UIButton_Typical, PageManager;

@interface PageVC : FormattedVC
{
    //Only private variables go in here...
}

@property(nonatomic, retain) PageManager *parentManager; //Infinite loop fixed *Michael*

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
-(id) initWithParent:(PageManager *)parent;

// Next page moves the activity to the next page,
// and sends signal to page manager to move forward.
-(IBAction) goToNextPage;

// Previous page moves page to previous page,
// and sends signal to page manager to move back.
-(IBAction) goToPreviousPage;

-(void) reloadView;

@end
