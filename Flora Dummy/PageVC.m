//
//  PageVC.m
//  Flora Dummy
//
//  Created by Zach Nichols on 11/2/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import "PageVC.h"

#import "PageManager.h"
#import "Page_IntroVC.h"

@interface PageVC ()
{    

}

@end

@implementation PageVC
@synthesize parentManager;
@synthesize titleString, dateString, pageNumber, pageCount, pageDictionary;
@synthesize pageControl;
@synthesize nextButton, previousButton;
@synthesize dateLabel, otherLabel, titleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithParent: (NSObject *)parent
{
    self = [super init];
    if (self)
    {
        // Save reference to parent.
        parentManager = (PageManager *)parent;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIFont *titleFont = [UIFont fontWithName:@"MarkerFelt-Wide" size:72.0];
    UIFont *subtitleFont = [UIFont fontWithName:@"MarkerFelt-Thin" size:36.0];

    // Initialize labels at top of page
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 122, 480, 44)];
    dateLabel.text = [NSString stringWithFormat:@"Date: %@", dateString];
    dateLabel.font = subtitleFont;
    [dateLabel setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:dateLabel];
    
    otherLabel = [[UILabel alloc] initWithFrame:CGRectMake(524, 122, 480, 44)];
    otherLabel.text = [NSString stringWithFormat:@"Page: %i of %i", pageNumber.intValue, pageCount.intValue];
    otherLabel.font = subtitleFont;
    [otherLabel setTextAlignment:NSTextAlignmentRight];
    [self.view addSubview:otherLabel];

    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 20, 971, 94)];
    titleLabel.text = titleString;
    titleLabel.font = titleFont;
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:titleLabel];
    
    // Update the dots at the bottom of the screen
    // to reflect what page we're on.
    [pageControl setCurrentPage: pageNumber.intValue - 1];
    
    // Add buttons as needed
    previousButton = [[UIButton_Typical alloc]
                      initWithFrame:CGRectMake(20, 675, 120, 44)];
    [previousButton addTarget:self action:@selector(goToPreviousPage) forControlEvents:UIControlEventTouchUpInside];

    nextButton = [[UIButton_Typical alloc]
                  initWithFrame:CGRectMake(871, 675, 120, 44)];
    [nextButton addTarget:self action:@selector(goToNextPage) forControlEvents:UIControlEventTouchUpInside];

    // For testing
    //[self outlineButton:nextButton];
    //[self outlineButton:previousButton];
    
    previousButton.titleLabel.font = font;
    nextButton.titleLabel.font = font;
    
    // If there are multiple pages
    if (pageCount.intValue > 0)
    {
        // CHeck if the page is first, last, or middle
        if(pageNumber.intValue == 1)
        {
            // First page
            //
            // Need a Next button and a Quit button
            [previousButton setTitle:@"Quit" forState:UIControlStateNormal];
            [nextButton setTitle:@"Next" forState:UIControlStateNormal];

            
        }else if(pageNumber.intValue == pageCount.intValue)
        {
            // Last page
            //
            // Need a Back button and an Finish button.
            [previousButton setTitle:@"Previous" forState:UIControlStateNormal];
            [nextButton setTitle:@"Finish" forState:UIControlStateNormal];

        }else
        {
            // Need a Back and a Next button
            [previousButton setTitle:@"Previous" forState:UIControlStateNormal];
            [nextButton setTitle:@"Next" forState:UIControlStateNormal];

            
        }
        
        [self.view addSubview:previousButton];
        [self.view addSubview:nextButton];
        
        
    }else
    {
        // Single page
        //
        // Only need finish button
        previousButton = nil;
        [nextButton setTitle:@"Finish" forState:UIControlStateNormal];
        
        [self.view addSubview:nextButton];

    }

}

-(void)viewWillAppear:(BOOL)animated
{
    // Update colors in case the user changed settings
    [self updateColors];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// End activity stops the activity and returns back to the
// subject screen
-(IBAction)endActivity
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Next page moves the activity to the next page,
// and sends signal to page manager to move forward.
-(IBAction)goToNextPage
{
    // If there's a page to go forward to,
    // let page manager go forward
    if (pageNumber.intValue + 1 <= pageCount.intValue)
    {
        [(PageManager *)parentManager goToNextViewController];
    }else
    {
        // End activity because there's nowhere to go
        [self endActivity];
    }
}

// Previous page moves the activity to the previous page,
// and sends signal to page manager to move back.
-(IBAction)goToPreviousPage
{
    // If there's a page to go back to,
    // let page manager go back
    if (pageNumber.intValue -1 > 0)
    {
        [(PageManager *)parentManager goToPreviousViewController];
    }else
    {
        // End activity because there's nowhere to go
        [self endActivity];
    }
}


# pragma mark
# pragma mark Color Stuff

// Updates colors in view
// Subclasses should call this method and then perform additional actions
-(void)updateColors
{
    [super updateColors];
    
    nextButton.backgroundColor = backgroundColor;
    [nextButton setTitleColor:primaryColor forState:UIControlStateNormal];
    previousButton.backgroundColor = backgroundColor;
    [previousButton setTitleColor:primaryColor forState:UIControlStateNormal];
    
    dateLabel.textColor = primaryColor;
    [self outlineTextInLabel:dateLabel];
    
    otherLabel.textColor = primaryColor;
    [self outlineTextInLabel:otherLabel];
    
    titleLabel.textColor = primaryColor;
    [self outlineTextInLabel:titleLabel];
    
}

@end
