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
    
    BOOL viewIsOnScreen NS_DEPRECATED_IOS(8_1, 8_1);
}

@property(nonatomic, retain) PageManager *parentManager NS_DEPRECATED_IOS(8_1, 8_1); //Infinite loop fixed *Michael*

@property(nonatomic, retain) Page *page NS_DEPRECATED_IOS(8_1, 8_1);

@property(nonatomic, retain) NSNumber *pageNumber NS_DEPRECATED_IOS(8_1, 8_1);
@property(nonatomic, retain) NSNumber *pageCount NS_DEPRECATED_IOS(8_1, 8_1);

@property(nonatomic, retain) IBOutlet UIPageControl *pageControl NS_DEPRECATED_IOS(8_1, 8_1);

// Buttons for navigation
@property(nonatomic, retain) UIButton_Typical *nextButton NS_DEPRECATED_IOS(8_1, 8_1);
@property(nonatomic, retain) UIButton_Typical *previousButton NS_DEPRECATED_IOS(8_1, 8_1);

// Labels for displaying information at top of page
@property(nonatomic, retain) UILabel *otherLabel NS_DEPRECATED_IOS(8_1, 8_1); //assign meaning to this later

// Custom initialization lets us store reference
// to parent
-(id) initWithParent:(PageManager *)parent;

// Next page moves the activity to the next page,
// and sends signal to page manager to move forward.
-(IBAction) goToNextPage NS_DEPRECATED_IOS(8_1, 8_1);

// Previous page moves page to previous page,
// and sends signal to page manager to move back.
-(IBAction) goToPreviousPage NS_DEPRECATED_IOS(8_1, 8_1);

-(void) reloadView NS_DEPRECATED_IOS(8_1, 8_1);



@end
