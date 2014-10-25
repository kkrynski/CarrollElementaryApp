//
//  MathProblemVC_Normal.m
//  Flora Dummy
//
//  Created by Zach Nichols on 1/29/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "MathProblemVC_Normal.h"
#import "EquationFormatter.h"

@interface MathProblemVC_Normal ()
{
    // These constants define the margins for the large "problem" box
    float MARGIN_OUTSIDE_TOP;
    float MARGIN_OUTSIDE_SIDE;
    float MARGIN_OUTSIDE_BOTTOM;
    
    // These constants define the margins for the problem box,
    // the area where entire problem is viewed.
    float MARGIN_PB_TOP;
    float MARGIN_PB_SIDE;
    float MARGIN_PB_BOTTOM;
    float PB_X;
    float PB_Y;
    float PB_WIDTH;
    float PB_HEIGHT;
    
    // These constants define the margins for the math box,
    // the area where math equation is viewed.
    float MARGIN_MB_TOP;
    float MARGIN_MB_SIDE;
    float MARGIN_MB_BOTTOM;
    float MB_WIDTH;
    float MB_HEIGHT;
    
    // These constants define the frames and margins for buttons
    float BUTTON_MARGIN_TOP;
    float BUTTON_MARGIN_SIDE;
    float BUTTON_MARGIN_BOTTOM;
    float BUTTON_MARGIN_BETWEEN;
    float BUTTON_HEIGHT;
    float BUTTON_WIDTH;
    
    // These constants define the frame for the text boxes,
    // the labels that make up the given equation.
    float TB_HEIGHT;
    float TB_WIDTH;
    
    // These constants define the frame for the answer boxes,
    // the labels where students type in answer.
    float AB_HEIGHT;
    float AB_WIDTH;
    
    // These constants define the frame for the operations boxes,
    // the labels that show the operators, like +=-/* etc.
    float OB_HEIGHT;
    float OB_WIDTH;
    
    // These constants define the spacing for math, text, and operator boxes
    float MATHEMATICS_TOP;
    float MATHEMATICS_BOTTOM;
    float MATHEMATICS_BETWEEN;
    float MATHEMATICS_MARGIN_SIDE;
    
}
@end

@implementation MathProblemVC_Normal
@synthesize problemBoxView, mathBoxView;
@synthesize buttonsArray, boxesArray, buttonsInfoArray, boxesInfoArray;
@synthesize mathEquation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!mathEquation || [mathEquation isEqualToString:@""])
    {
        mathEquation = [NSString stringWithFormat:@"_2_+_4_=_?_"];

    }
    
    EquationFormatter *eqFormatter = [[EquationFormatter alloc] init];
    
    boxesInfoArray = [eqFormatter returnBoxesForEquationString:mathEquation];
    
    
    // Dummy data
    // Remove later and replace with JSON data
    /*NSMutableDictionary *textBoxDict = [[NSMutableDictionary alloc]init];
    [textBoxDict setObject:@"Text" forKey:@"Type"];
    [textBoxDict setObject:@"Num_Plain" forKey:@"Subtype"];

    NSMutableDictionary *internalDict = [[NSMutableDictionary alloc]init];
    [internalDict setObject:@"Num_Plain" forKey:@"Type"];
    [internalDict setObject:[NSNumber numberWithInt:10] forKey:@"Value"];
    
    [textBoxDict setObject:@[internalDict] forKey:@"V_Objects"];
    
    NSMutableDictionary *operationsDict = [[NSMutableDictionary alloc]init];
    [operationsDict setObject:@"Operator" forKey:@"Type"];
    [operationsDict setObject:@"=" forKey:@"Subtype"];

    //[operationsDict setObject:nil forKey:@"V_Objects"];
    
    
    NSMutableDictionary *answerBoxDict = [[NSMutableDictionary alloc]init];
    [answerBoxDict setObject:@"Answer" forKey:@"Type"];
    [answerBoxDict setObject:@"Num_Plain" forKey:@"Subtype"];

    internalDict = nil;
    internalDict = [[NSMutableDictionary alloc]init];
    [internalDict setObject:@"Num_Plain" forKey:@"Type"];

    //[internalDict setObject:[NSNumber numberWithInt:10] forKey:@"Value"];
    
    [answerBoxDict setObject:internalDict forKey:@"V_Objects"];*/
    
    //boxesInfoArray = [NSArray arrayWithObjects:textBoxDict, operationsDict, answerBoxDict, nil];
    
    
    NSMutableDictionary *submitButtonDict = [[NSMutableDictionary alloc]init];
    [submitButtonDict setObject:@"Submit" forKey:@"Type"];
    [submitButtonDict setObject:@"Submit" forKey:@"Name"];
    
    NSMutableDictionary *helpButtonDict = [[NSMutableDictionary alloc]init];
    [helpButtonDict setObject:@"Help" forKey:@"Type"];
    [helpButtonDict setObject:@"Help" forKey:@"Name"];
    
    buttonsInfoArray = [NSArray arrayWithObjects:submitButtonDict, helpButtonDict, nil];
    
    // Double check to make sure orientation is correct.
    // iOS 7 introduced a bug where sometimes the VC
    // doesn't know which orientation it's supposed to be.
    // Thus, in landscape, it creates a landscape VC but
    // any reference to its frame will result in portrait
    // values.
    CGRect r = self.view.bounds;
    
    if (r.size.height > r.size.width)
    {
        float w = r.size.width;
        r.size.width = r.size.height;
        r.size.height = w;
    }
    
    self.view.bounds = r;
    
    // Define constants for spacing/sizing
    
    // These constants define the margins for the problem box,
    // the area where entire problem is viewed.
    MARGIN_PB_TOP = 20;
    MARGIN_PB_SIDE = 37;
    MARGIN_PB_BOTTOM = 20;
    PB_X = MARGIN_PB_SIDE;
    PB_Y = self.dateLabel.frame.origin.y + self.dateLabel.frame.size.height + MARGIN_PB_TOP;
    PB_WIDTH = self.view.bounds.size.width - (2 * MARGIN_PB_SIDE);
    PB_HEIGHT = self.previousButton.frame.origin.y - PB_Y - MARGIN_MB_TOP - MARGIN_MB_BOTTOM;
    
    // These constants define the margins for the math box,
    // the area where math equation is viewed.
    MARGIN_MB_TOP = 30;
    MARGIN_MB_SIDE = 30;
    MARGIN_MB_BOTTOM = 180;
    MB_WIDTH = PB_WIDTH - (2 * MARGIN_MB_SIDE);
    MB_HEIGHT = PB_HEIGHT - MARGIN_MB_TOP - MARGIN_MB_BOTTOM;
    
    // These constants define the frames and margins for buttons
    BUTTON_MARGIN_TOP = 10;
    BUTTON_MARGIN_BOTTOM = 10;
    BUTTON_MARGIN_BETWEEN = 10;
    BUTTON_HEIGHT = 60;
    BUTTON_WIDTH = 160;
    BUTTON_MARGIN_SIDE = (PB_WIDTH - (buttonsInfoArray.count * BUTTON_WIDTH) + ((buttonsInfoArray.count -1) * BUTTON_MARGIN_BETWEEN)) / 2;

    // These constants define the frames for the text boxes,
    // the labels that make up the given equation.
    TB_HEIGHT = 100;
    TB_WIDTH = 200;
    
    // These constants define the frames for the answer boxes,
    // the labels where students type in answer.
    AB_HEIGHT = 100;
    AB_WIDTH = 200;
    
    // These constants define the frames for the operations boxes,
    // the labels that show the operators, like +=-/* etc.
    OB_HEIGHT = 100;
    OB_WIDTH = 100;
    
    // These constants define the spacing for math, text, and operator boxes
    MATHEMATICS_TOP = (MB_HEIGHT - AB_HEIGHT) / 2;
    MATHEMATICS_BOTTOM = (MB_HEIGHT - AB_HEIGHT) / 2;;
    MATHEMATICS_BETWEEN = 10;
    
    float boxesWidth = 0;
    for (NSDictionary *boxInfo in boxesInfoArray)
    {
        NSString *type = [boxInfo objectForKey:@"Type"];
        
        if ([type isEqualToString:@"Text"])
        {
            boxesWidth += TB_WIDTH;
            
        }else if ([type isEqualToString:@"Operator"])
        {
            boxesWidth += OB_WIDTH;
            
        }else if ([type isEqualToString:@"Answer"])
        {
            boxesWidth += AB_WIDTH;
        }
    }

    MATHEMATICS_MARGIN_SIDE = (MB_WIDTH - boxesWidth - ((boxesInfoArray.count -1) * MATHEMATICS_BETWEEN)) / 2;

    //backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(33, 72, 971, 602)];

    // Add subviews
    problemBoxView = [[UIView alloc] initWithFrame:CGRectMake(PB_X, PB_Y, PB_WIDTH, PB_HEIGHT)];
    problemBoxView.backgroundColor = [super lighterColorForColor:backgroundColor];
    [self.view addSubview:problemBoxView];
    
    mathBoxView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN_MB_SIDE, MARGIN_MB_TOP, MB_WIDTH, MB_HEIGHT)];
    mathBoxView.backgroundColor = backgroundColor;
    [problemBoxView addSubview:mathBoxView];
    
}

-(void)updateColors
{
    [super updateColors];
    
    problemBoxView.backgroundColor = [super lighterColorForColor:backgroundColor];
    [super outlineView:problemBoxView];
    
    mathBoxView.backgroundColor = backgroundColor;
    [super outlineView:mathBoxView];
    
    [self populateMathBox];
    [self populateButtons];

}

-(void)populateMathBox
{
    UIFont *numberFont = [UIFont fontWithName:@"MarkerFelt-Wide" size:72.0];
    
    float xCoordinate = MATHEMATICS_MARGIN_SIDE;
    for (NSDictionary *boxInfo in boxesInfoArray)
    {
        NSString *type = [boxInfo objectForKey:@"Type"];
        
        if ([type isEqualToString:@"Text"])
        {
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoordinate, MATHEMATICS_TOP, TB_WIDTH, TB_HEIGHT)];
            
            // Vertical objects is an array, so for now
            // just take the first one
            NSDictionary *internalDict = [(NSArray *)[boxInfo objectForKey:@"V_Objects"] objectAtIndex:0];
            textLabel.text = [NSString stringWithFormat:@"%.0f", [(NSNumber *)[internalDict objectForKey:@"Value"] floatValue]];
            
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.textColor = primaryColor;
            textLabel.font = numberFont;
            textLabel.textAlignment = NSTextAlignmentCenter;
            
            [mathBoxView addSubview:textLabel];
            
            xCoordinate +=TB_WIDTH;
            
        }else if ([type isEqualToString:@"Operator"])
        {
            UILabel *operatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoordinate, MATHEMATICS_TOP, OB_WIDTH, OB_HEIGHT)];
            
            NSString *subtype = (NSString *)[boxInfo objectForKey:@"Subtype"];
            
            if ([subtype isEqualToString:@"="])
            {
                
            }else if ([subtype isEqualToString:@"+"])
            {

            }
            operatorLabel.text = subtype;

            operatorLabel.backgroundColor = [UIColor clearColor];
            operatorLabel.textColor = primaryColor;
            operatorLabel.font = numberFont;
            operatorLabel.textAlignment = NSTextAlignmentCenter;

            [mathBoxView addSubview:operatorLabel];
            
            xCoordinate += OB_WIDTH;
            
        }else if ([type isEqualToString:@"Answer"])
        {
            UITextView *answerView = [[UITextView alloc] initWithFrame:CGRectMake(xCoordinate, MATHEMATICS_TOP, AB_WIDTH, AB_HEIGHT)];
            
            [super outlineView:answerView];
            
            answerView.backgroundColor = [super lighterColorForColor:backgroundColor];
            answerView.textColor = primaryColor;
            answerView.font = numberFont;
            answerView.textAlignment = NSTextAlignmentCenter;

            [mathBoxView addSubview:answerView];
            
            xCoordinate += AB_WIDTH;
        }
        
        xCoordinate += MATHEMATICS_BETWEEN;
    }

}

-(void)populateButtons
{
    UIFont *buttonFont = [UIFont fontWithName:@"MarkerFelt-Wide" size:36.0];
    
    float xCoordinate = BUTTON_MARGIN_SIDE;
    for (NSDictionary *buttonInfo in buttonsInfoArray)
    {
        NSString *type = (NSString *)[buttonInfo objectForKey:@"Type"];
        NSString *name = (NSString *)[buttonInfo objectForKey:@"Name"];

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(xCoordinate,
                                                                      BUTTON_MARGIN_TOP + MB_HEIGHT + mathBoxView.frame.origin.y,
                                                                      BUTTON_WIDTH,
                                                                      BUTTON_HEIGHT)];
        [super outlineButton:button];

        [button setTitle:name forState:UIControlStateNormal];
        
        button.titleLabel.textColor = primaryColor;
        button.titleLabel.font = buttonFont;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        if ([type isEqualToString:@"Submit"])
        {
            
            
        }else if ([type isEqualToString:@"Help"])
        {

            
        }
        
        [problemBoxView addSubview:button];
        
        xCoordinate +=BUTTON_WIDTH;
        xCoordinate += MATHEMATICS_BETWEEN;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
