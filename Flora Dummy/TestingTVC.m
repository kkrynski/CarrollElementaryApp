//
//  TestingTVC.m
//  Flora Dummy
//
//  Created by Zachary Nichols on 10/25/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//  Modified by Michael Schloss on 01/20/15.
//

#import "TestingTVC.h"
#import "FloraDummy-Swift.h"

#import "ModuleVC.h"
#import "VocabVC.h"
#import "CalculatorVC.h"
#import "QuickQuizVC.h"
#import "PictureQuizVC.h"
#import "PasswordVC.h"
#import "SpellingTestVC.h"
#import "ActivityCreationTVC.h"
#import "ClassConversions.h"
#import "MicrophoneVC.h"

@implementation TestingTVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    //Tells the tableView to clear cells when a ViewController dismisses
    [self setClearsSelectionOnViewWillAppear:YES];
    
    //Add your Activity names here
    tests = [[NSArray alloc] initWithObjects:
             @"Riley - Calculator",
             @"Michael - Math Problem",
             @"Michael - Clock",
             @"Michael - SquareDrag",
             @"Zach - Activity Creation",
             @"Stephen - Picture Quiz",
             @"Mason - Password",
             @"Mason - Spelling Test",
             @"Mason - Microphone",
             @"Zach - Module",
             nil];
}

#pragma mark - TableView DataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    //Return the number of sections.
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Return the number of rows in the section.
    return tests.count;
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeveloperPortalCell"];
    
    //Update and format the title label, or the primary label in the cell.
    cell.textLabel.text = [tests objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:30];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Activity *activity = [[Activity alloc] init];
    activity.activityDescription = @"This is a test Activity";
    activity.name = @"Test Activity";
    
    ActivitySession *testSession = [[ActivitySession alloc] init];
    
    NSMutableArray *testSessionData;
    
    FormattedVC *viewControllerToPresent;
    
    //Begin appropriate test
    NSString *selectedTest = [tests objectAtIndex:indexPath.row];
    
    if ([selectedTest isEqualToString:@"Riley - Calculator"])
    {
        FormattedVC *viewControllerToPresent = [[CalculatorVC alloc] initWithNibName:@"CalculatorVC" bundle:nil];
        
        [(CalculatorVC *)viewControllerToPresent setModalPresentationStyle:UIModalPresentationCustom];
        [(CalculatorVC *)viewControllerToPresent setTransitioningDelegate:self];
        [(CalculatorVC *)viewControllerToPresent setPreferredContentSize:CGSizeMake(304, 508)];
        
        [self presentViewController:viewControllerToPresent animated:YES completion:nil];
        return;
    }
    else if ([selectedTest isEqualToString:@"Michael - Math Problem"])
    {
        testSessionData = [NSMutableArray arrayWithObjects:
                           [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:
                                                                       [NSDictionary dictionaryWithObjectsAndKeys:@"3 + 2=#w#", @"Equation", nil],
                                                                       [[NSNull alloc] init], nil], [NSNumber numberWithInteger:ActivityViewControllerTypeMathProblem], nil], nil];
        
        MathProblemVC *mathProblem = [[MathProblemVC alloc] init];
        mathProblem.mathEquation = @"3 + 2=#w#";
        
        [self presentViewController:mathProblem animated:YES completion:nil];
        return;
    }
    else if ([selectedTest isEqualToString:@"Michael - Clock"])
    {
        viewControllerToPresent = [[ClockDragVC alloc] init];
        ((ClockDragVC *)viewControllerToPresent).startTime = @"04:15:23";
        ((ClockDragVC *)viewControllerToPresent).endTime = @"08:12:34";
        
        [self presentViewController:viewControllerToPresent animated:YES completion:nil];
        return;
    }
    else if ([selectedTest isEqualToString:@"Michael - SquareDrag"])
    {
        viewControllerToPresent = [[SquaresDragAndDrop alloc] init];
        ((SquaresDragAndDrop *) viewControllerToPresent).numberOfSquares = 40;
        
        [self presentViewController:viewControllerToPresent animated:YES completion:nil];
        return;
    }
    else if ([selectedTest isEqualToString:@"Zach - Activity Creation"])
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ActivityCreation" bundle:nil];
        FormattedVC *viewControllerToPresent = [sb instantiateInitialViewController];
        
        viewControllerToPresent.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        [self presentViewController:viewControllerToPresent animated:YES completion:nil];
        return;
    }
    else if ([selectedTest isEqualToString:@"Stephen - Picture Quiz"])
    {
        viewControllerToPresent = [[PictureQuizVC alloc] init];
        
        NSString *imageName = @"65-note";
        NSString *question = [NSString stringWithFormat:@"What animal is this?"];
        NSArray *answers = [[NSArray alloc]initWithObjects:@"Pig", @"Banana", @"Cat", @"Dog", @"Lemur", @"Popcorn", nil];
        NSNumber *correctIndex = [NSNumber numberWithInt:1];
        
        ((PictureQuizVC *) viewControllerToPresent).imageName = imageName;
        ((PictureQuizVC *) viewControllerToPresent).answers = answers;
        ((PictureQuizVC *) viewControllerToPresent).correctIndex = correctIndex;
        ((PictureQuizVC *) viewControllerToPresent).question = question;
        
        [self presentViewController:viewControllerToPresent animated:YES completion:nil];
        return;
    }
    else if ([selectedTest isEqualToString:@"Mason - Password"])
    {
        viewControllerToPresent = [[PasswordVC alloc] init];
        
        [self presentViewController:viewControllerToPresent animated:YES completion:nil];
        return;
    }
    else if ([selectedTest isEqualToString:@"Mason - Spelling Test"])
    {
        viewControllerToPresent = [[SpellingTestVC alloc] init];
        ((SpellingTestVC *) viewControllerToPresent).word = @"world";
        
        [self presentViewController:viewControllerToPresent animated:YES completion:nil];
        return;
    }
    else if ([selectedTest isEqualToString:@"Mason - Microphone"])
    {
        viewControllerToPresent = [[MicrophoneVC alloc] init];
        
        [self presentViewController:viewControllerToPresent animated:YES completion:nil];
        return;
    }
    else
    {
        UIAlertController *error = [UIAlertController alertControllerWithTitle:@"We're Sorry" message:[NSString stringWithFormat:@"This activity is not compatible.\n\nPlease update \"%@\" for NewPageManager.\n\nAfter you've done so, implement the activity in TestingTVC", selectedTest] preferredStyle:UIAlertControllerStyleAlert];
        [error addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:error animated:YES completion:nil];
        return;
    }
    
    testSession.activityData = testSessionData;
    
    [[NewPageManager alloc] initWithNibName:nil bundle:nil activitySession:testSession forActivity:activity withParent:self];
    
    //pageManager.currentActivitySession = testSession;
    
    //[self presentViewController:pageManager animated:YES completion:nil];
}

-(void) launchModule
{
    /*Page_ReadVC *prVC = [[Page_ReadVC alloc] initWithParent:self];
     prVC.titleString = self.name;
     prVC.pageText = self.description;
     
     [self presentViewController:prVC animated:YES completion:nil];*/
    
    // Get the information for the activity selected
    NSMutableDictionary *activityDict = [[NSMutableDictionary alloc] init];;
    [activityDict setObject:@"Garden Stuff" forKey:@"Name"];
    [activityDict setObject:@"Page_Reading" forKey:@"VCName"];
    [activityDict setObject:@"Module" forKey:@"Symbol"];
    [activityDict setObject:[NSNumber numberWithBool:0] forKey:@"Completed"];
    [activityDict setObject:[NSDate date] forKey:@"Date"];
    
    NSMutableDictionary *page1 = [[NSMutableDictionary alloc] init];
    [page1 setObject:@"Bananas" forKey:@"PageText"];
    [page1 setObject:@"Page_IntroVC" forKey:@"PageVC"];
    
    
    
    
    
    NSMutableDictionary *page2 = [[NSMutableDictionary alloc] init];
    [page2 setObject:@"Bananas 2" forKey:@"PageText"];
    [page2 setObject:@"ModuleVC" forKey:@"PageVC"];
    
    
    NSMutableArray *a = [[NSMutableArray alloc] init];
    
    
    
    NSMutableDictionary *t = [[NSMutableDictionary alloc] init];
    [t setValue:@"TextView" forKey:@"Type"];
    [t setValue:@[[NSNumber numberWithFloat:540],
                  [NSNumber numberWithFloat:180],
                  [NSNumber numberWithFloat:300],
                  [NSNumber numberWithFloat:200]] forKey:@"Bounds"];
    
    NSMutableDictionary *tt = [[NSMutableDictionary alloc] init];
    [tt setValue:@"TEXTTEXTTEXT" forKey:@"Text"];
    [t setValue:tt forKey:@"Specials"];
    
    
    
    NSMutableDictionary *i = [[NSMutableDictionary alloc] init];
    [i setValue:@"Image" forKey:@"Type"];
    [i setValue:@[[NSNumber numberWithFloat:540],
                  [NSNumber numberWithFloat:400],
                  [NSNumber numberWithFloat:300],
                  [NSNumber numberWithFloat:300]] forKey:@"Bounds"];
    NSMutableDictionary *ii = [[NSMutableDictionary alloc] init];
    [ii setValue:[NSString stringWithFormat:@"apple_red"] forKey:@"Image"];
    [i setValue:ii forKey:@"Specials"];
    
    
    NSMutableDictionary *g = [[NSMutableDictionary alloc] init];
    [g setValue:@"GIF" forKey:@"Type"];
    [g setValue:@[[NSNumber numberWithFloat:20],
                  [NSNumber numberWithFloat:180],
                  [NSNumber numberWithFloat:500],
                  [NSNumber numberWithFloat:500]] forKey:@"Bounds"];
    NSMutableDictionary *gg = [[NSMutableDictionary alloc] init];
    [gg setValue: [NSArray arrayWithObjects:
                   [NSString stringWithFormat:@"Wind1"],
                   [NSString stringWithFormat:@"Wind2"],
                   [NSString stringWithFormat:@"Wind3"],
                   [NSString stringWithFormat:@"Wind4"],
                   nil]
          forKey:@"GIFs"];
    [gg setValue:[NSNumber numberWithFloat:0.35] forKey:@"GIFDuration"];
    [g setObject:gg forKey:@"Specials"];
    
    [a addObjectsFromArray:@[t, i, g]];
    
    [page2 setObject:a forKey:@"Content"];
    
    
    
    
    
    [activityDict setObject:[NSArray arrayWithObjects:page1, page2, nil] forKey:@"PageArray"];
    
    // Create a PageManager for the activity and store it in THIS view controller.
    
    // ClassConversions *cc = [[ClassConversions alloc] init];
    
    //[self presentViewController:[cc activityFromDictionary:activityDict] animated:YES completion:nil];
}

#pragma mark - Michael's Transition Methods

- (UIPresentationController *) presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    if ([presented isKindOfClass:[CalculatorVC class]])
    {
        return [[CalculatorPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    if ([presented isKindOfClass:[CalculatorVC class]])
        return [[CalculatorTransitionManager alloc] initWithIsPresenting:YES];
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController:(UIViewController *)dismissed
{
    if ([dismissed isKindOfClass:[CalculatorVC class]])
        return [[CalculatorTransitionManager alloc] initWithIsPresenting:NO];
    return nil;
}

@end
