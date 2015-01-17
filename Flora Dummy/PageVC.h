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

NS_CLASS_DEPRECATED_IOS(8_0, 8_1)
///This class is now deprecated.  Please use \b FormattedVC instead
@interface PageVC : FormattedVC
{
    //Only private variables go in here...
    
    BOOL viewIsOnScreen DEPRECATED_ATTRIBUTE;
}

@property(nonatomic, retain) PageManager *parentManager DEPRECATED_ATTRIBUTE; //Infinite loop fixed *Michael*

@property(nonatomic, retain) Page *page DEPRECATED_ATTRIBUTE;

@property(nonatomic, retain) NSNumber *pageNumber DEPRECATED_ATTRIBUTE;
@property(nonatomic, retain) NSNumber *pageCount DEPRECATED_ATTRIBUTE;

@property(nonatomic, retain) IBOutlet UIPageControl *pageControl DEPRECATED_ATTRIBUTE;

// Buttons for navigation
@property(nonatomic, retain) UIButton_Typical *nextButton DEPRECATED_ATTRIBUTE;
@property(nonatomic, retain) UIButton_Typical *previousButton DEPRECATED_ATTRIBUTE;

// Labels for displaying information at top of page
@property(nonatomic, retain) UILabel *otherLabel DEPRECATED_ATTRIBUTE; //assign meaning to this later

// Custom initialization lets us store reference
// to parent
-(id) initWithParent:(PageManager *)parent;

// Next page moves the activity to the next page,
// and sends signal to page manager to move forward.
-(IBAction) goToNextPage DEPRECATED_ATTRIBUTE;

// Previous page moves page to previous page,
// and sends signal to page manager to move back.
-(IBAction) goToPreviousPage DEPRECATED_ATTRIBUTE;

-(void) reloadView DEPRECATED_ATTRIBUTE;



@end
