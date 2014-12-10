//
//  PageVC.m
//  FloraDummy
//
//  Created by Zachary Nichols on 11/29/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "PageVC.h"

#import "PageManager.h"

#import "FloraDummy-Swift.h"

@interface PageVC ()

@end

@implementation PageVC
@synthesize parentManager;
@synthesize pageNumber, pageCount, page;
@synthesize pageControl;
@synthesize nextButton, previousButton;
@synthesize otherLabel;

-(id)initWithParent:(PageManager *)parent
{
    self = [super init];
    if (self)
    {
        // Save reference to parent.
        parentManager = parent;
        viewIsOnScreen = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (otherLabel != nil)
    {
        [otherLabel removeFromSuperview];
        otherLabel = nil;
    }
    if (nextButton != nil)
    {
        [nextButton removeFromSuperview];
        nextButton = nil;
    }
    if (previousButton != nil)
    {
        [previousButton removeFromSuperview];
        previousButton = nil;
    }
    
    //UIFont *titleFont = [UIFont fontWithName:@"MarkerFelt-Wide" size:72.0];
    UIFont *subtitleFont = [UIFont fontWithName:@"MarkerFelt-Thin" size:36.0];
    
    // Initialize labels at top of page
    otherLabel = [[UILabel alloc] init];
    otherLabel.text = [NSString stringWithFormat:@"Page: %i of %i", pageNumber.intValue, pageCount.intValue];
    otherLabel.font = subtitleFont;
    [otherLabel sizeToFit];
    [self.view addSubview:otherLabel];
    
    [otherLabel setCenter:CGPointMake(self.view.frame.size.width - 20 - otherLabel.frame.size.width/2.0, self.topLayoutGuide.length + 20 + otherLabel.frame.size.height/2.0)];
    
    // Update the dots at the bottom of the screen
    // to reflect what page we're on.
    if (pageControl)
        [pageControl setCurrentPage: pageNumber.intValue - 1];
    
    // Add buttons as needed
    if (![pageNumber isEqual:@1] || pageCount.intValue > 0)   //If this is the first page and there's nothing after it, no need for a button
    {
        previousButton = [[UIButton_Typical alloc] init];
        [previousButton addTarget:self action:@selector(goToPreviousPage) forControlEvents:UIControlEventTouchUpInside];
    }
    
    nextButton = [[UIButton_Typical alloc] init];
    [nextButton addTarget:self action:@selector(goToNextPage) forControlEvents:UIControlEventTouchUpInside];
    
    previousButton.titleLabel.font = font;
    nextButton.titleLabel.font = font;
    
    // If there are multiple pages
    if (pageCount.intValue > 0)
    {
        // Check if the page is first, last, or middle
        if (pageNumber.intValue == 1)
        {
            //We're on the first page and there are more pages.
            [previousButton setTitle:@"Quit" forState:UIControlStateNormal];
            [nextButton setTitle:@"Next" forState:UIControlStateNormal];
        }
        else if (pageNumber.intValue == pageCount.intValue)
        {
            //We're on the last page and should only go backwards and/or finish activity
            [previousButton setTitle:@"Previous" forState:UIControlStateNormal];
            [nextButton setTitle:@"Finish" forState:UIControlStateNormal];
            
        }
        else
        {
            //We're in a middle page and need both
            [previousButton setTitle:@"Previous" forState:UIControlStateNormal];
            [nextButton setTitle:@"Next" forState:UIControlStateNormal];
        }
        
        [previousButton sizeToFit];
        [nextButton sizeToFit];
        [previousButton setCenter:CGPointMake(20 + previousButton.frame.size.width/2.0, self.view.frame.size.height - 20 - previousButton.frame.size.height/2.0)];
        [nextButton setCenter:CGPointMake(self.view.frame.size.width - 20 - nextButton.frame.size.width/2.0, self.view.frame.size.height - 20 - nextButton.frame.size.height/2.0)];
        [self.view addSubview:previousButton];
        [self.view addSubview:nextButton];
    }
    else
    {
        //There's only one page in the activity, so we only need the finish button
        [nextButton setTitle:@"Finish" forState:UIControlStateNormal];
        
        [nextButton sizeToFit];
        [nextButton setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height - 20 - nextButton.frame.size.height/2.0)];
        [self.view addSubview:nextButton];
    }
    
    [self reloadView];
    [self updateColors];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    viewIsOnScreen = YES;
}

/**Refreshes the view if information changes*/
-(void) reloadView
{
    if (self.isViewLoaded == NO) return;
    
    otherLabel.text = [NSString stringWithFormat:@"Page: %i of %i", pageNumber.intValue, pageCount.intValue];
    [otherLabel sizeToFit];
    
    //Do a fancy animation on refresh
    
    [UIView animateWithDuration:viewIsOnScreen ? 0.5:0.0 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.1 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent) animations:^
     {
         [otherLabel setCenter:CGPointMake(
                                           self.view.frame.size.width - 20 - otherLabel.frame.size.width/2.0,
                                           20 + otherLabel.frame.size.height/2.0)];
     } completion:nil];
    
    // Update the dots at the bottom of the screen
    // to reflect what page we're on.
    if (pageControl)
        [pageControl setCurrentPage: pageNumber.intValue - 1];
    
    if ((![pageNumber isEqual:@1] || pageCount.intValue > 0) && previousButton == nil)   //If this is the first page and there's nothing after it, no need for a button
    {
        previousButton = [[UIButton_Typical alloc] init];
        [previousButton addTarget:self action:@selector(goToPreviousPage) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // If there are multiple pages
    if (pageCount.intValue > 0)
    {
        // Check if the page is first, last, or middle
        if (pageNumber.intValue == 1)
        {
            //We're on the first page and there are more pages.
            [previousButton setTitle:@"Quit" forState:UIControlStateNormal];
            [nextButton setTitle:@"Next" forState:UIControlStateNormal];
        }
        else if (pageNumber.intValue == pageCount.intValue)
        {
            //We're on the last page and should only go backwards and/or finish activity
            [previousButton setTitle:@"Previous" forState:UIControlStateNormal];
            [nextButton setTitle:@"Finish" forState:UIControlStateNormal];
            
        }
        else
        {
            //We're in a middle page and need both
            [previousButton setTitle:@"Previous" forState:UIControlStateNormal];
            [nextButton setTitle:@"Next" forState:UIControlStateNormal];
        }
        
        [previousButton sizeToFit];
        [nextButton sizeToFit];
        
        //Do a fancy animation
        [UIView animateWithDuration:viewIsOnScreen ? 0.5:0.0 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.1 options:(UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction) animations:^
         {
             [previousButton setCenter:CGPointMake(20 + previousButton.frame.size.width/2.0, self.view.frame.size.height - 20 - previousButton.frame.size.height/2.0)];
             [nextButton setCenter:CGPointMake(self.view.frame.size.width - 20 - nextButton.frame.size.width/2.0, self.view.frame.size.height - 20 - nextButton.frame.size.height/2.0)];
         } completion:nil];
    }
    else
    {
        //There's only one page in the activity, so we only need the finish button
        [nextButton setTitle:@"Finish" forState:UIControlStateNormal];
        
        [nextButton sizeToFit];
        
        //Do a fancy animation
        [UIView animateWithDuration:viewIsOnScreen ? 0.5:0.0 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.1 options:(UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction) animations:^
         {
             [nextButton setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height - 20 - nextButton.frame.size.height/2.0)];
         } completion:nil];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Update colors in case the user changed settings
    [self updateColors];
}

/**Go forward to the next page, or if there is none, dismiss*/
-(IBAction) goToNextPage
{
    
    // If there's a page to go forward to,
    // let page manager go forward
    if (pageNumber.intValue + 1 <= pageCount.intValue)
    {
        [parentManager goToNextViewController];
    }else
    {
        // End activity because there's nowhere to go
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/**Go back to previous page*/
-(IBAction) goToPreviousPage
{
    //If there is a previous page, signal to go back
    if (pageNumber.intValue -1 > 0)
        [parentManager goToPreviousViewController];
    else
        //This shouldn't ever be called, but it's a good failsafe
        [self dismissViewControllerAnimated:YES completion:nil];
}


# pragma mark - Color Stuff

/**Updates colors for objects on screen*/
-(void) updateColors
{
    [super updateColors];
    
    nextButton.backgroundColor = backgroundColor;
    [nextButton setTitleColor:primaryColor forState:UIControlStateNormal];
    
    if (previousButton)
    {
        previousButton.backgroundColor = backgroundColor;
        [previousButton setTitleColor:primaryColor forState:UIControlStateNormal];
    }
    
    otherLabel.textColor = primaryColor;
    [self outlineTextInLabel:otherLabel];
}

@end