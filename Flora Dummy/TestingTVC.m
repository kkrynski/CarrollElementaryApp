//
//  TestingTVC.m
//  Flora Dummy
//
//  Created by Zachary Nichols on 10/25/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "TestingTVC.h"

#import "PageManager.h"

#import "ModuleVC.h"
#import "VocabVC.h"
#import "CalculatorVC.h"
#import "QuickQuizVC.h"
#import "PictureQuizVC.h"
#import "PasswordVC.h"
#import "SpellingTestVC.h"
#import "ActivityCreationTVC.h"
#import "ClassConversions.h"

    //Michael's Test Code
#import "FloraDummy-Swift.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TestingTVC ()
{
    // Store the font. Later we'll want to hook this up to the
    // NSUserDefaults, so that it can be changed throughout the app.
    UIFont *font;
    
    // Store a float for border width, which will be used to outline
    // tableviews and textviews
    float borderWidth;
    
    // Store colors for quicker/easier access
    UIColor *primaryColor;
    UIColor *secondaryColor;
    UIColor *backgroundColor;
    
    // Load the color scheme if necessary.
    // Consider removing this line.
    NSDictionary *colorSchemeDictionary;
}
@property(nonatomic, retain) NSMutableArray *tests;


@end

@implementation TestingTVC
@synthesize tests;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tests = [[NSMutableArray alloc]initWithObjects:@"Riley - Calculator", @"Michael - Math Problem", @"Michael - Clock", @"Michael - SquareDrag", @"Zach - Activity Creation", @"Stephen - Picture Quiz", @"Mason - Password", @"Mason - Spelling Test", @"Zach - Module", nil];
    
    // Create our font. Later we'll want to hook this up to the
    // rest of the app for easier change.
    font = [[UIFont alloc]init];
    font = [UIFont fontWithName:@"Marker Felt" size:32.0];
    
    
    // Get data from json file
    NSString *titleDirectory = [[NSBundle mainBundle] resourcePath];
    NSString *fullPath = [titleDirectory stringByAppendingPathComponent:@"Carroll.json"]; // Name of file
    NSData *jsonFile = [NSData dataWithContentsOfFile:fullPath options:NSDataReadingMappedIfSafe error:nil];
    NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonFile options:kNilOptions error:nil];
    
    
    // Get colors data and store it in colorSchemeDictionary
    // The dictionary is currently unused after this point.
    // Consider deleting or modifying
    colorSchemeDictionary = [jsonDictionary valueForKey:@"Colors"];
    
    // Store the border width for the tableview.
    borderWidth = 2.0f;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return tests.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    // For taller, more child-friendly cells.
    // Note: the normal height is 44.0
    return 88.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The following chunk of code is pretty standard. It allows you to
    // reuse cells, meaning that instead of making 1000 cells, it reuses
    // cells that have long since left the screen. This saves memory and
    // keeps the app from crashing.
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Update and format the title label, or the primary label in the cell.
    cell.textLabel.text = (NSString *)[tests objectAtIndex:indexPath.row];
    cell.textLabel.font = font;
    //cell.textLabel.textColor = primaryColor;
    //[self outlineTextInLabel:cell.textLabel];
    
    // Update cell colors
    //cell.backgroundColor = [self lighterColorForColor:backgroundColor];
    //tableView.backgroundColor = [self lighterColorForColor:backgroundColor];
    
    // Changes the color of the lines in between cells.
    //[tableView setSeparatorColor:primaryColor];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The following line keeps the cell from staying selected.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Begin appropriate test
    switch (indexPath.row)
    {
        // Enter appropriate code to launch
        
        case 0:
        {
            // Riley - Calculator
            
            [self launchCalculator];
            
            
            break;
        
        }
        case 1:
        {
            // Michael - Math
            [self launchMathController];
            
            break;
            
        }
        case 2:
        {
            // Michael - Clock
            [self launchClockDrag];
            
            break;
            
        }
        case 3:
        {
            // Michael - SquareDrag
            [self launchSquareDrag];
            
            break;
            
        }
        case 4:
        {
            // Zach - Activity Creation
            
            [self launchActivityCreation];
            
            break;
            
        }case 5:
        {
            // Stephen - Picture Quiz
            
            [self launchPictureQuiz];
            
            break;
            
        }case 6:
        {
            // Mason - Password
            
            [self launchPassword];
            
            break;
            
        }case 7:
        {
            // Mason - Spelling Test
            
            [self launchSpellingTest];
            
            break;
            
        }case 8:
        {
            // Zach - Module
            
            [self launchModule];
            
            break;
            
        }default:
            break;
    }
    
}


// Tests


-(void)launchModule
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
    
    ClassConversions *cc = [[ClassConversions alloc] init];
    
    [[[PageManager alloc]initWithActivity: [cc activityFromDictionary:activityDict] forParentViewController:self] setIsAccessibilityElement:NO];
}

-(void)launchCalculator
{
    /*
    VocabVC *vocabVC = [[VocabVC alloc] init];
    NSString *question = @"ambitious";
    NSArray *answers = [NSArray arrayWithObjects:@"Lazy", @"Determined", @"Content", @"Satisfied", @"",nil]; //Add an empty string if less than 5 answers.
    int indexOfAnswer = 1;
    vocabVC.question = question;
    vocabVC.answers = answers;
    vocabVC.indexOfAnswer = &(indexOfAnswer);
    */
    CalculatorVC *calc = [[CalculatorVC alloc] initWithNibName:@"CalculatorVC" bundle:nil];
    [calc setModalPresentationStyle:UIModalPresentationCustom];
    [calc setTransitioningDelegate:self];
    [calc setPreferredContentSize:CGSizeMake(304, 508)];
    [self presentViewController:calc animated:YES completion:nil];

}

-(void)launchPlants
{
    [self launchQuickQuiz];
}

-(void)launchQuickQuiz
{
    QuickQuizVC *quickQuizVC = [[QuickQuizVC alloc] init];
    
    NSString *question = [NSString stringWithFormat:@"What does a plant NOT need?"];
    
    NSArray *answers = [NSArray arrayWithObjects:[NSString stringWithFormat:@"25-weather"],
                        [NSString stringWithFormat:@"65-note"],
                        [NSString stringWithFormat:@"61-brightness"],
                        nil];
    
    NSNumber *correct = [NSNumber numberWithInt:1]; // Music
    
    quickQuizVC.question = question;
    quickQuizVC.answers = answers;
    quickQuizVC.correctIndex = correct;
    
    [self presentViewController:quickQuizVC animated:YES completion:nil];
}

-(void)launchPictureQuiz
{
    PictureQuizVC *pictureQuizVC = [[PictureQuizVC alloc] init];
    
    
    NSString *imageName = @"65-note";
    NSString *question = [NSString stringWithFormat:@"What animal is this?"];
    NSArray *answers = [[NSArray alloc]initWithObjects:@"Pig", @"Banana", @"Cat", @"Dog", @"Lemur", @"Popcorn", nil];
    //NSArray *answers = @[ @"Pig", @"Banana", @"Cat", @"Dog", @"Lemur", @"Popcorn"];
    NSNumber *correctIndex = [NSNumber numberWithInt:1];

    
     pictureQuizVC.imageName = imageName;
     pictureQuizVC.answers = answers;
     pictureQuizVC.correctIndex = correctIndex;
     pictureQuizVC.question = question;
    
    
    [self presentViewController:pictureQuizVC animated:YES completion:nil];

}

-(void)launchPassword
{
    PasswordVC *passwordVC = [[PasswordVC alloc] init];
    
    NSString *username = [NSString stringWithFormat:@"qwerty"];
    NSString *password = [NSString stringWithFormat:@"qwerty"];
    
    passwordVC.username = username;
    passwordVC.password = password;
    
    [self presentViewController:passwordVC animated:YES completion:nil];
    
}

- (void) launchMathController
{
    MathProblemVC *mathProblemVC = [[MathProblemVC alloc] init];
    mathProblemVC.mathEquation = @"3 + 10 / 5=#w#";
    
    [self presentViewController:mathProblemVC animated:YES completion:nil];
}

- (void) launchClockDrag
{
    ClockDragVC *clockDragVC = [[ClockDragVC alloc] init];
    clockDragVC.startTime = @"04:15:23";
    clockDragVC.endTime = @"08:12:34";
    
    [self presentViewController:clockDragVC animated:YES completion:nil];
}

- (void) launchSquareDrag
{
    SquaresDragAndDrop *squaresDragVC = [[SquaresDragAndDrop alloc] init];
    squaresDragVC.numberOfSquares = 40;
    
    [self presentViewController:squaresDragVC animated:YES completion:nil];
}

- (void) launchSpellingTest
{
    SpellingTestVC *spellingTestVC = [[SpellingTestVC alloc] init];
    //spellingTestVC.mathEquation = @"20 * 800 + 25 / 30 + 10 * 10=#w#";
    
    [self presentViewController:spellingTestVC animated:YES completion:nil];
}

- (void) launchActivityCreation
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ActivityCreation" bundle:nil];
    UIViewController *vc = [sb instantiateInitialViewController];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];

}



#pragma mark Michael's Transition Methods

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
