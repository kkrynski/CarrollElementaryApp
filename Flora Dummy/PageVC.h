//
//  PageVC.h
//  FloraDummy
//
//  Created by Zachary Nichols on 11/29/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "FormattedVC.h"

#import "Page.h"

@class UIButton_Typical, PageManager;

@interface PageVC : FormattedVC
{
    //Only private variables go in here...
}

@property(nonatomic, retain) PageManager *parentManager; //Infinite loop fixed *Michael*

@property(nonatomic, retain) Page *page;

@property(nonatomic, retain) NSNumber *pageNumber;
@property(nonatomic, retain) NSNumber *pageCount;

@property(nonatomic, retain) IBOutlet UIPageControl *pageControl;

// Buttons for navigation
@property(nonatomic, retain) UIButton_Typical *nextButton;
@property(nonatomic, retain) UIButton_Typical *previousButton;

// Labels for displaying information at top of page
@property(nonatomic, retain) UILabel *otherLabel; //assign meaning to this later

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
