//
//  VocabVC.m
//  Flora Dummy
//
//  Created by Riley Shaw on 10/25/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "VocabVC.h"

@interface VocabVC ()
{
    Question *q1;
    Question *q2;
    Question *q3;
    int curQuestion;
    NSArray *questions;
}
@end

@implementation VocabVC
@synthesize questionLabel;

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
    q1 = [[Question alloc] init];
    q1.question = @"ambititous";
    q1.indexOfAnswer = 0;
    NSMutableArray *answers = [[NSMutableArray alloc]init];
    q1.answers = answers;
    [q1.answers addObject:@"Determined"];
    [q1.answers addObject:@"Determined"];
    [q1.answers addObject:@"Determined"];
    [q1.answers addObject:@"Determined"];

    
    q2 = [[Question alloc] init];
    q3 = [[Question alloc] init];
    questions = @[q1, q2, q3];

    questionLabel.text = @"Another word for %@ is:" , [[questions objectAtIndex:curQuestion] question];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)but1:(id)sender {
    if ([[questions objectAtIndex:curQuestion] indexOfAnswer] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @""
                                                       message: @"Correct!"
                                                      delegate: self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"OK",nil];
        
        [alert setTag:1];
        [alert show];
        curQuestion+=1;
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @""
                                                       message: @"Try Again"
                                                      delegate: self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"OK",nil];
        
        [alert setTag:1];
        [alert show];

    }
}

- (IBAction)but2:(id)sender {
    
}

- (IBAction)but3:(id)sender {
    
}

- (IBAction)but4:(id)sender {
    
}

- (IBAction)but5:(id)sender {
    
}

@end
