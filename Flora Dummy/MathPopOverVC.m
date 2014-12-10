//
//  MathPopOverVC.m
//  FloraDummy
//
//  Created by Zachary Nichols on 11/26/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "MathPopOverVC.h"

@interface MathPopOverVC ()

@end

@implementation MathPopOverVC
@synthesize equationString, answerString;
@synthesize equationTextView, answerTypeSegmentedControl, answerTextView;
@synthesize updateButton;

///////////// Init Methods ///////////////////////////


-(id)init
{
    if (self = [super init])
    {
        // Initialize
        equationString = [[NSString alloc] init];
        answerString = [[NSString alloc] init];
    }
    return self;
}

-(id)initWithEquation: (NSString *)e
{
    if (self = [super init])
    {
        // Initialize
        equationString = [[NSString alloc] initWithString:e];
        answerString = [[NSString alloc] init];
    }
    return self;
}

-(id)initWithEquation:(NSString *)e andAnswer: (NSString *)a
{
    if (self = [super init])
    {
        // Initialize
        equationString = [[NSString alloc] initWithString:e];
        answerString = [[NSString alloc] initWithString:a];
    }
    return self;
}

///////////////////////////////////////////////////////


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (equationString != nil)
    {
        equationTextView.text = equationString;
        
    }else
    {
        equationString = [[NSString alloc] init];
        equationTextView.text = @"";
    }
    
    if (answerString != nil)
    {
        answerTextView.text = answerString;
        
    }else
    {
        equationString = [[NSString alloc] init];
        answerTextView.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(IBAction)updateContent
{
    //Notify the delegate if it exists.
    if (_delegate != nil)
    {
        [self packageContent];
        
        [_delegate returnEquation:equationString andAnswer:answerString];
    }
}

-(void)packageContent
{
    if (equationTextView.text)
    {
        equationString = equationTextView.text;
    
    }else
    {
        equationString = [NSString stringWithFormat:@""];
    }
    
    if (answerTextView.text)
    {
        answerString = answerTextView.text;
    
    }else
    {
        answerString = [NSString stringWithFormat:@""];
    }
    
}


@end
