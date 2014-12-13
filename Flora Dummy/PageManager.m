//
//  PageManager.m
//  FloraDummy
//
//  Created by Zachary Nichols on 11/29/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "PageManager.h"

#import "FloraDummy-Swift.h"

#import "Activity.h"
#import "Page.h"
#import "ClassConversions.h"

#import "PageVC.h"
#import "Page_DragAndDropVC.h"
#import "Page_GardenDataVC.h"
#import "Page_QRCodeVC.h"
#import "ModuleVC.h"
#import "QuickQuizVC.h"
#import "VocabVC.h"
//#import "MathProblemVC_Normal.swift"

@interface PageManager ()
{
    // Keep a reference to the current page
    Page *currentPage;
    PageVC *currentVC;
    ClassConversions *cc;
}

@end

@implementation PageManager
@synthesize currentIndex, activity, parentViewController, pageViewController;

-(id)initWithActivity: (Activity *)a forParentViewController: (UIViewController *)parent
{
    self = [super init];
    if (self)
    {
        // Save the activity dictionary
        activity = a;
        
        // Create a page view controller for those oh-so-fine
        // page curls.
        pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        // If we actually have pages, proceed.
        // If not, cancel activity.
        //
        // Note: I'm not actually sure what happens
        //       if there are no pages. It could generate
        //       a black hole that sucks in the universe.
        if (activity.pageArray.count > 0)
        {
            // Save reference to parent view controller
            parentViewController = parent;
            
            // Get the page dictionary
            currentPage = (Page *)[activity.pageArray objectAtIndex:currentIndex.row];
            
            // Go to the very first page
            currentIndex = [NSIndexPath indexPathForItem:0 inSection:0];
            
            // Save that first page
            currentVC = [[PageVC alloc] initWithParent: self];
            
            // Save information that would be helpful to the page.
            
            currentVC.page = currentPage;
            currentVC.pageNumber = [NSNumber numberWithLong: currentIndex.row + 1];
            currentVC.pageCount = [NSNumber numberWithLong:activity.pageArray.count];
            
            // Bring the page to the screen
            [parentViewController presentViewController:pageViewController animated:YES completion:nil];
            
            // Make sure that the page manager keeps up
            [self goToViewControllerAtIndex:currentIndex inDirection:[NSNumber numberWithInt:0]];
        }
    }
    
    return self;
}


# pragma mark
# pragma mark Page Navigation

// This function takes the page manager to a specific page
-(void)goToViewControllerAtIndex: (NSIndexPath *)indexPath inDirection: (NSNumber *) direction
{
    // Make sure the index is valid
    if ((indexPath.row >= 0) || (indexPath.row < activity.pageArray.count))
    {
        // Get the information for the page
        Page *newPage = (Page *)[activity.pageArray objectAtIndex:indexPath.row];
        
        // Update index
        currentIndex = indexPath;
        
        // Create the page
        currentVC = [[PageVC alloc] initWithParent: self];
        
        // Get data and save it to the page
        
        currentVC.page = newPage;
        currentVC.pageNumber = [NSNumber numberWithLong: currentIndex.row + 1];
        currentVC.pageCount = [NSNumber numberWithLong:activity.pageArray.count];
        
        // Bring the page to the big screen
        [self launchAppropriateViewControllerForPage: currentVC inDirection:direction];
        
    }
}

// This function takes the page manager to the next page
-(void)goToNextViewController
{
    NSLog(@"Moving from index: %ld", (long)currentIndex.row);
    
    // Check to make sure the index is valid
    if (currentIndex.row + 1 < activity.pageArray.count)
    {
        // Set direction to forward
        int direction = 1;
        
        // Update index
        currentIndex = [NSIndexPath indexPathForItem:currentIndex.row + 1 inSection:0];
        
        // Use other function to navigate to new page
        [self goToViewControllerAtIndex:currentIndex inDirection:[NSNumber numberWithInt:direction]];
    }
    
    NSLog(@"Moving to index: %ld", currentIndex.row);
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
-(void)launchAppropriateViewControllerForPage: (PageVC *)pageVC inDirection: (NSNumber *)direction
{
    // Gets name of target page
    NSString *name = pageVC.page.pageVCType;
    
    // If the name is valid, continue
    if ((name) && !([name isEqualToString:@""]))
    {
        // If it's the first page, AKA the intro page,
        // create an intro page
        if ([name isEqualToString:@"Introduction"])
        {
            // Create intro page
            Page_IntroVC *introVC = [[Page_IntroVC alloc] initWithNibName:@"Page_IntroVC" bundle:nil];
            introVC.parentManager = self;

            // Save appropriate information to new intro page
            introVC.page = pageVC.page;
            introVC.pageNumber = pageVC.pageNumber;
            introVC.pageCount = pageVC.pageCount;
            introVC.activityTitle = activity.name;
            introVC.summary = (NSString *)[pageVC.page.variableContentDict objectForKey:@"Text"];
            
            [introVC reloadView];
            
            // Set summary text if there is any
            if (((NSString *)[pageVC.page.variableContentDict objectForKey:@"Text"])
                && ![(NSString *)[pageVC.page.variableContentDict objectForKey:@"Text"] isEqualToString:@""])
            {
                introVC.summary = (NSString *)[pageVC.page.variableContentDict objectForKey:@"Text"];
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
            
        }else if ([name isEqualToString:@"Reading"])
        {
            // If it's a reading page
            
            // Create a reading page
            Page_ReadVC *readVC = [[Page_ReadVC alloc] initWithNibName:@"Page_ReadVC" bundle:nil];
            readVC.parentManager = self;
            
            // Save important data to page
            readVC.pageText = [pageVC.page.variableContentDict objectForKey:@"Text"];
            
            readVC.page = pageVC.page;
            readVC.pageNumber = pageVC.pageNumber;
            readVC.pageCount = pageVC.pageCount;
            
            [readVC reloadView];
            
            
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
            dragVC.page = pageVC.page;
            dragVC.pageNumber = pageVC.pageNumber;
            dragVC.pageCount = pageVC.pageCount;
            
            [dragVC reloadView];
            
            
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
        }else if ([name isEqualToString:@"Math"])
        {
            // Create a math vc
            MathProblemVC *mathVC = [[MathProblemVC alloc]init];
            mathVC.parentManager = self;
            
            // Save important data to page
            mathVC.page = pageVC.page;
            mathVC.pageNumber = pageVC.pageNumber;
            mathVC.pageCount = pageVC.pageCount;
            mathVC.mathEquation = (NSString *)[pageVC.page.variableContentDict objectForKey:@"Equation"];
            
            [mathVC reloadView];
            
            
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
            qrVC.page = pageVC.page;
            qrVC.pageNumber = pageVC.pageNumber;
            qrVC.pageCount = pageVC.pageCount;
            
            [qrVC reloadView];
            
            
            qrVC.targetQR = [pageVC.page.variableContentDict objectForKey:@"TargetID"];
            //qrVC.pageDict = page.pageDictionary;
            [pageViewController setViewControllers:[NSArray arrayWithObjects:qrVC, nil] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            
        }else if ([name isEqualToString:@"Sandbox"])
        {
            // Create a reading page
            ModuleVC *mVC = [[ModuleVC alloc]initWithContent:
                             (NSArray *)[pageVC.page.variableContentDict objectForKey:@"ContentArray"]];
            mVC.parentManager = self;
            
            // Save important data to page
            mVC.page = pageVC.page;
            mVC.pageNumber = pageVC.pageNumber;
            mVC.pageCount = pageVC.pageCount;
            
            [mVC reloadView];
            
            [pageViewController setViewControllers:[NSArray arrayWithObjects:mVC, nil] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            
        }else if ([name isEqualToString:@"Quiz Type 1"])
        {
            // Create a reading page
            QuickQuizVC *qVC = [[QuickQuizVC alloc] init];
            qVC.parentManager = self;
            
            // Save important data to page
            qVC.page = pageVC.page;
            qVC.pageNumber = pageVC.pageNumber;
            qVC.pageCount = pageVC.pageCount;
            
            [qVC reloadView];
            
            qVC.question = (NSString *)[pageVC.page.variableContentDict objectForKey:@"Question"];
            qVC.answers = (NSArray *)[pageVC.page.variableContentDict objectForKey:@"Answers"];
            qVC.correctIndex = (NSNumber *)[pageVC.page.variableContentDict objectForKey:@"CorrectIndex"];
            
            [pageViewController setViewControllers:[NSArray arrayWithObjects:qVC, nil] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            
        }else if ([name isEqualToString:@"Quiz Type 2"])
        {
            // Create a reading page
            VocabVC *vVC = [[VocabVC alloc] init];
            vVC.parentManager = self;
            
            // Save important data to page
            vVC.page = pageVC.page;
            vVC.pageNumber = pageVC.pageNumber;
            vVC.pageCount = pageVC.pageCount;
            
            [vVC reloadView];
            
            vVC.question = (NSString *)[pageVC.page.variableContentDict objectForKey:@"Question"];
            vVC.answers = (NSArray *)[pageVC.page.variableContentDict objectForKey:@"Answers"];
            vVC.correctIndex = (NSNumber *)[pageVC.page.variableContentDict objectForKey:@"CorrectIndex"];
            
            [pageViewController setViewControllers:[NSArray arrayWithObjects:vVC, nil] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            
        }else if ([name isEqualToString:@"Counting Tool"])
        {
            SquaresDragAndDrop *squaresDragVC = [[SquaresDragAndDrop alloc] init];
            squaresDragVC.parentManager = self;
            
            // Save important data to page
            squaresDragVC.page = pageVC.page;
            squaresDragVC.pageNumber = pageVC.pageNumber;
            squaresDragVC.pageCount = pageVC.pageCount;
           
            squaresDragVC.numberOfSquares = [(NSNumber *)[squaresDragVC.page.variableContentDict objectForKey:@"Count"] intValue];
 
            [squaresDragVC reloadView];
            
            [pageViewController setViewControllers:[NSArray arrayWithObjects:squaresDragVC, nil] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            
        }
        
    }
}


@end
