//
//  PageVC.m
//  Flora Dummy
//
//  Created by Zach Nichols on 11/2/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import "PageVC.h"

#import "PageManager.h"

#import "FloraDummy-Swift.h"

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

-(id)initWithParent:(PageManager *)parent
{
    self = [super init];
    if (self)
    {
        // Save reference to parent.
        parentManager = parent;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIFont *titleFont = [UIFont fontWithName:@"MarkerFelt-Wide" size:72.0];
    UIFont *subtitleFont = [UIFont fontWithName:@"MarkerFelt-Thin" size:36.0];
    
    // Initialize labels at top of page
    dateLabel = [[UILabel alloc] init];
    if (dateString == nil || [dateString isEqualToString:@""])
        dateLabel.text = @"Date: N/A";
    else
        dateLabel.text = [NSString stringWithFormat:@"Date: %@", dateString];
    dateLabel.font = subtitleFont;
    [dateLabel sizeToFit];
    [self.view addSubview:dateLabel];
    
    otherLabel = [[UILabel alloc] init];
    otherLabel.text = [NSString stringWithFormat:@"Page: %i of %i", pageNumber.intValue, pageCount.intValue];
    otherLabel.font = subtitleFont;
    [otherLabel sizeToFit];
    [self.view addSubview:otherLabel];
    
    if (titleString)    //If we don't have a title, don't display the titleLabel.
    {
        titleLabel = [[UILabel alloc] init];
        titleLabel.text = titleString;
        titleLabel.font = titleFont;
        [titleLabel sizeToFit];
        [titleLabel setCenter:CGPointMake(self.view.frame.size.width/2.0, 20 + self.topLayoutGuide.length + titleLabel.frame.size.height/2.0)];
        [self.view addSubview:titleLabel];
        
        [dateLabel setCenter:CGPointMake(20 + dateLabel.frame.size.width/2.0, titleLabel.frame.size.height + titleLabel.frame.origin.y + 8 + dateLabel.frame.size.height/2.0)];
        [otherLabel setCenter:CGPointMake(self.view.frame.size.width - 20 - otherLabel.frame.size.width/2.0, titleLabel.frame.size.height/2.0 + titleLabel.center.y + 8 + otherLabel.frame.size.height/2.0)];
    }
    else
    {
        [dateLabel setCenter:CGPointMake(20 + dateLabel.frame.size.width/2.0, self.topLayoutGuide.length + 20 + dateLabel.frame.size.height/2.0)];
        [otherLabel setCenter:CGPointMake(self.view.frame.size.width - 20 - otherLabel.frame.size.width/2.0, self.topLayoutGuide.length + 20 + otherLabel.frame.size.height/2.0)];
    }
    
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

/**Refreshes the view if information changes*/
-(void) reloadView
{
    if (self.isViewLoaded == NO) return;
    
    // Edit labels at top of page
    if (dateString == nil || [dateString isEqualToString:@""])
        dateLabel.text = @"Date: N/A";
    else
        dateLabel.text = [NSString stringWithFormat:@"Date: %@", dateString];
    
    otherLabel.text = [NSString stringWithFormat:@"Page: %i of %i", pageNumber.intValue, pageCount.intValue];
    
    if (titleString && titleLabel == nil)   //We didn't orginially have a title
    {
        titleLabel = [[UILabel alloc] init];
        titleLabel.text = titleString;
        titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:72.0];
        [titleLabel sizeToFit];
        titleLabel.alpha = 0.0;
        if (self.topLayoutGuide)
            [titleLabel setCenter:CGPointMake(self.view.frame.size.width/2.0, 20 + self.topLayoutGuide.length + titleLabel.frame.size.height/2.0)];
        else
            [titleLabel setCenter:CGPointMake(self.view.frame.size.width/2.0, 20 + titleLabel.frame.size.height/2.0)];
        [self.view addSubview:titleLabel];
        
        //Do a fancy animation on refresh
        [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction) animations:^
         {
             titleLabel.alpha = 0.0;
         } completion:nil];
        
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.1 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent) animations:^
         {
             [dateLabel setCenter:CGPointMake(20 + dateLabel.frame.size.width/2.0, titleLabel.frame.size.height + titleLabel.frame.origin.y + 8 + dateLabel.frame.size.height/2.0)];
             [otherLabel setCenter:CGPointMake(self.view.frame.size.width - 20 - otherLabel.frame.size.width/2.0, titleLabel.frame.size.height/2.0 + titleLabel.center.y + 8 + otherLabel.frame.size.height/2.0)];
         } completion:nil];
    }
    titleLabel.text = titleString;
    
    // Update the dots at the bottom of the screen
    // to reflect what page we're on.
    if (pageControl)
        [pageControl setCurrentPage: pageNumber.intValue - 1];
    
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
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.1 options:(UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction) animations:^
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
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.1 options:(UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction) animations:^
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
        [(PageManager *)parentManager goToNextViewController];
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
    
    dateLabel.textColor = primaryColor;
    [self outlineTextInLabel:dateLabel];
    
    otherLabel.textColor = primaryColor;
    [self outlineTextInLabel:otherLabel];
    
    if (titleLabel)
    {
        titleLabel.textColor = primaryColor;
        [self outlineTextInLabel:titleLabel];
    }
}

@end
