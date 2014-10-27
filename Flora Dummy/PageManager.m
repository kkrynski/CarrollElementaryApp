//
//  PageManager.m
//  Flora Dummy
//
//  Created by Zach Nichols on 11/2/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import "PageManager.h"

#import "PageVC.h"
#import "Page_IntroVC.h"
#import "Page_ReadVC.h"
#import "Page_DragAndDropVC.h"
#import "MathProblemVC_Normal.h"
#import "Page_GardenDataVC.h"
#import "Page_QRCodeVC.h"
#import "ModuleVC.h"

@interface PageManager ()
{
    // Keep a reference to the current page
    PageVC *currentPage;
}

@end

@implementation PageManager
@synthesize currentIndex, pageArray, activityDict, parentViewController, pageViewController;

-(id)initWithActivity: (NSDictionary *)dictionary forParentViewController: (UIViewController *)parent
{
    // Save the activity dictionary
    activityDict = dictionary;
    
    // Save the page array while you're at it
    pageArray = (NSArray *)[activityDict objectForKey:@"PageArray"];
    
    // Create a page view controller for those oh-so-fine
    // page curls.
    pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    // If we actually have pages, proceed.
    // If not, cancel activity.
    //
    // Note: I'm not actually sure what happens
    //       if there are no pages. It could generate
    //       a black hole that sucks in the universe.
    if (pageArray.count > 0)
    {
        // Save reference to parent view controller
        parentViewController = parent;
        
        // Get the page dictionary
        NSDictionary *pageDictionary = (NSDictionary *)[pageArray objectAtIndex:currentIndex.row];

        // Go to the very first page
        currentIndex = [NSIndexPath indexPathForItem:0 inSection:0];
        
        // Save that first page
        currentPage = [[PageVC alloc] initWithParent: self];
        
        // Save information that would be helpful to the page.
        currentPage.pageDictionary = pageDictionary;
        currentPage.titleString = (NSString *)[activityDict objectForKey:@"Name"];
        currentPage.dateString = (NSString *)[activityDict objectForKey:@"Date"];
        currentPage.pageNumber = [NSNumber numberWithInt: currentIndex.row + 1];
        currentPage.pageCount = [NSNumber numberWithInt:pageArray.count];
        
        // Bring the page to the screen
        [parentViewController presentModalViewController:pageViewController animated:YES];

        // Make sure that the page manager keeps up
        [self goToViewControllerAtIndex:currentIndex inDirection:[NSNumber numberWithInt:0]];
    }
    
    return self;
}


# pragma mark
# pragma mark Page Navigation

// This function takes the page manager to a specific page
-(void)goToViewControllerAtIndex: (NSIndexPath *)indexPath inDirection: (NSNumber *) direction
{
    // Make sure the index is valid
    if ((indexPath.row >= 0) || (indexPath.row < pageArray.count))
    {
        // Get the information for the page
        NSArray *pagesArray = (NSArray *)[activityDict objectForKey:@"PageArray"];
        NSDictionary *pageDictionary = (NSDictionary *)[pagesArray objectAtIndex:indexPath.row];
        
        // Update index
        currentIndex = indexPath;
        
        // Create the page
        currentPage = [[PageVC alloc] initWithParent: self];
        
        // Get data and save it to the page
        currentPage.pageDictionary = pageDictionary;
        currentPage.titleString = (NSString *)[activityDict objectForKey:@"Name"];
        currentPage.dateString = (NSString *)[activityDict objectForKey:@"Date"];
        currentPage.pageNumber = [NSNumber numberWithInt: currentIndex.row + 1];
        currentPage.pageCount = [NSNumber numberWithInt:pagesArray.count];
        
        // Bring the page to the big screen
        [self launchAppropriateViewControllerForPage: currentPage inDirection:direction];

    }
}

// This function takes the page manager to the next page
-(void)goToNextViewController
{
    NSLog(@"Moving from index: %i", currentIndex.row);
    
    // Check to make sure the index is valid
    if (currentIndex.row + 1 < pageArray.count)
    {
        // Set direction to forward
        int direction = 1;
        
        // Update index
        currentIndex = [NSIndexPath indexPathForItem:currentIndex.row + 1 inSection:0];
        
        // Use other function to navigate to new page
        [self goToViewControllerAtIndex:currentIndex inDirection:[NSNumber numberWithInt:direction]];
    }
    
    NSLog(@"Moving to index: %i", currentIndex.row);
}

// This function takes the page manager to the previous page
-(void)goToPreviousViewController
{
    // Check to make sure the index is valid
    if (currentIndex.row - 1 >= 0)
    {
        // Set direction to forward
        int direction = -1;
        
        // Update index
        currentIndex = [NSIndexPath indexPathForItem:currentIndex.row - 1 inSection:0];
        
        // Use other function to navigate to new page
        [self goToViewControllerAtIndex:currentIndex inDirection:[NSNumber numberWithInt:direction]];
    }
}

// This function keeps navigating through pages until a given
// page is found. It then brings this page to the screen.
-(void)launchAppropriateViewControllerForPage: (PageVC *)page inDirection: (NSNumber *)direction
{
    // Gets name of target page
    NSString *name = [page.pageDictionary objectForKey:@"PageVC"];
    
    // If the name is valid, continue
    if ((name) && !([name isEqualToString:@""]))
    {
        // If it's the first page, AKA the intro page,
        // create an intro page
        if ([name isEqualToString:@"Page_IntroVC"])
        {
            // Create intro page
            Page_IntroVC *introVC = [[Page_IntroVC alloc]init];
            introVC.parentManager = self;
            
            // Save appropriate information to new intro page
            introVC.pageDictionary = page.pageDictionary;
            introVC.titleString = page.titleString;
            introVC.dateString = page.dateString;
            introVC.pageNumber = page.pageNumber;
            introVC.pageCount = page.pageCount;
            
            // Set summary text if there is any
            if (((NSString *)[page.pageDictionary objectForKey:@"PageText"])
                && ![(NSString *)[page.pageDictionary objectForKey:@"PageText"] isEqualToString:@""])
            {
                introVC.summary = (NSString *)[page.pageDictionary objectForKey:@"PageText"];
            }
            
            
            //[parentViewController dismissViewControllerAnimated:NO completion:nil];
            //[parentViewController presentViewController:introVC animated:NO completion:nil];
            
            //pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
            
           
            //[parentViewController presentModalViewController:pageViewController animated:YES];

            // If the direction is 0, bring this page to the screen
            //
            // If the direction > 1, go forward and use the page animation
            // to make a cool forward effect.
            //
            // If the direction < 1, go back and use the page animation
            // to make a cool back effect.

            if (direction.intValue == 0)
            {
                [pageViewController setViewControllers:[NSArray arrayWithObjects:introVC, nil] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            }else if (direction.intValue >= 0)
            {
                [pageViewController setViewControllers:[NSArray arrayWithObjects:introVC, nil] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
            }else
            {
                [pageViewController setViewControllers:[NSArray arrayWithObjects:introVC, nil] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
            }
            
            /*if (parentViewController.modalViewController != nil)
            {
                [parentViewController dismissViewControllerAnimated:NO completion:nil];
                [parentViewController presentModalViewController:introVC animated:NO];
            } else
            {
                [parentViewController presentModalViewController:introVC animated:YES];
            }*/
            
        }else if ([name isEqualToString:@"Page_ReadVC"])
        {
            // If it's a reading page
            
            // Create a reading page
            Page_ReadVC *readVC = [[Page_ReadVC alloc]init];
            readVC.parentManager = self;
            
            // Save important data to page
            readVC.pageText = [page.pageDictionary objectForKey:@"PageText"];
            
            readVC.pageDictionary = page.pageDictionary;
            readVC.titleString = page.titleString;
            readVC.dateString = page.dateString;
            readVC.pageNumber = page.pageNumber;
            readVC.pageCount = page.pageCount;
            
            
            
            //[parentViewController presentModalViewController:pageViewController animated:YES];
            
            // If the direction is 0, bring this page to the screen
            //
            // If the direction > 1, go forward and use the page animation
            // to make a cool forward effect.
            //
            // If the direction < 1, go back and use the page animation
            // to make a cool back effect.
            if (direction.intValue == 0)
            {
                [pageViewController setViewControllers:[NSArray arrayWithObjects:readVC, nil] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            }else if (direction.intValue >= 0)
            {
                [pageViewController setViewControllers:[NSArray arrayWithObjects:readVC, nil] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
            }else
            {
                [pageViewController setViewControllers:[NSArray arrayWithObjects:readVC, nil] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
            }
            
        }else if ([name isEqualToString:@"Page_DragAndDropVC"])
        {
            // Create a drag and drop VC
            Page_DragAndDropVC *dragVC = [[Page_DragAndDropVC alloc]init];
            dragVC.parentManager = self;
            
            // Save important data to page
            dragVC.pageDictionary = page.pageDictionary;
            dragVC.titleString = page.titleString;
            dragVC.dateString = page.dateString;
            dragVC.pageNumber = page.pageNumber;
            dragVC.pageCount = page.pageCount;
            
            
            // If the direction is 0, bring this page to the screen
            //
            // If the direction > 1, go forward and use the page animation
            // to make a cool forward effect.
            //
            // If the direction < 1, go back and use the page animation
            // to make a cool back effect.
            if (direction.intValue == 0)
            {
                [pageViewController setViewControllers:[NSArray arrayWithObjects:dragVC, nil] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            }else if (direction.intValue >= 0)
            {
                [pageViewController setViewControllers:[NSArray arrayWithObjects:dragVC, nil] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
            }else
            {
                [pageViewController setViewControllers:[NSArray arrayWithObjects:dragVC, nil] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
            }
        }else if ([name isEqualToString:@"MathProblemVC_Normal"])
        {
            // Create a math vc
            MathProblemVC_Normal *mathVC = [[MathProblemVC_Normal alloc]init];
            mathVC.parentManager = self;
            
            // Save important data to page
            mathVC.pageDictionary = page.pageDictionary;
            mathVC.titleString = page.titleString;
            mathVC.dateString = page.dateString;
            mathVC.pageNumber = page.pageNumber;
            mathVC.pageCount = page.pageCount;
            
            
            // If the direction is 0, bring this page to the screen
            //
            // If the direction > 1, go forward and use the page animation
            // to make a cool forward effect.
            //
            // If the direction < 1, go back and use the page animation
            // to make a cool back effect.
            if (direction.intValue == 0)
            {
                [pageViewController setViewControllers:[NSArray arrayWithObjects:mathVC, nil] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            }else if (direction.intValue >= 0)
            {
                [pageViewController setViewControllers:[NSArray arrayWithObjects:mathVC, nil] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
            }else
            {
                [pageViewController setViewControllers:[NSArray arrayWithObjects:mathVC, nil] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
            }
        }else if ([name isEqualToString:@"Page_GardenDataVC"])
        {
            // Create a drag and drop VC
            Page_GardenDataVC *gardenVC = [[Page_GardenDataVC alloc]init];

            UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:gardenVC];
            
            [pageViewController setViewControllers:[NSArray arrayWithObjects:navCon, nil] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            
        }else if ([name isEqualToString:@"Page_QRCodeVC"])
        {
            // Create a qr code reader
            Page_QRCodeVC *qrVC = [[Page_QRCodeVC alloc]init];
            qrVC.parentManager = self;

            // Save important data to page
            qrVC.pageDictionary = page.pageDictionary;
            qrVC.titleString = page.titleString;
            qrVC.dateString = page.dateString;
            qrVC.pageNumber = page.pageNumber;
            qrVC.pageCount = page.pageCount;
            
            qrVC.targetQR = [page.pageDictionary objectForKey:@"TargetID"];
            qrVC.pageDict = page.pageDictionary;
            [pageViewController setViewControllers:[NSArray arrayWithObjects:qrVC, nil] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        }else if ([name isEqualToString:@"Page_QR_DetailVC"])
        {
            // Create a reading page
            Page_ReadVC *readVC = [[Page_ReadVC alloc]init];
            readVC.parentManager = self;
            
            // Save important data to page
            readVC.pageText = [page.pageDictionary objectForKey:@"PageText"];
            
            readVC.pageDictionary = page.pageDictionary;
            readVC.titleString = page.titleString;
            readVC.dateString = page.dateString;
            readVC.pageNumber = page.pageNumber;
            readVC.pageCount = page.pageCount;
            
            
            [pageViewController setViewControllers:[NSArray arrayWithObjects:readVC, nil] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        }else if ([name isEqualToString:@"ModuleVC"])
        {
            // Create a reading page
            ModuleVC *mVC = [[ModuleVC alloc]initWithContent:
                             (NSArray *)[page.pageDictionary objectForKey:@"Content"]];
            mVC.parentManager = self;
            
            // Save important data to page
            mVC.pageDictionary = page.pageDictionary;
            mVC.titleString = page.titleString;
            mVC.dateString = page.dateString;
            mVC.pageNumber = page.pageNumber;
            mVC.pageCount = page.pageCount;
            
            
            [pageViewController setViewControllers:[NSArray arrayWithObjects:mVC, nil] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        }


        
    }
}


@end
