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

//NSString *question;
//NSArray *answers;
//int *indexOfAnswer;
- (void)viewDidLoad
{

    questionLabel.text = [NSString stringWithFormat:@"%@ %@ %@", @"Another word for", _question,@"is:"];
    if([_answers objectAtIndex:0] != nil){
        [_butAnswer1 setTitle:[_answers objectAtIndex:0] forState:UIControlStateNormal];
    }
    if([_answers objectAtIndex:1] != nil){
        [_butAnswer2 setTitle:[_answers objectAtIndex:1] forState:UIControlStateNormal];
    }
    if([_answers objectAtIndex:2] != nil){
        [_butAnswer3 setTitle:[_answers objectAtIndex:2] forState:UIControlStateNormal];
    }
    if([_answers objectAtIndex:3] != nil){
        [_butAnswer4 setTitle:[_answers objectAtIndex:3] forState:UIControlStateNormal];
    }
    if([_answers objectAtIndex:4] != nil){
        [_butAnswer5 setTitle:[_answers objectAtIndex:4] forState:UIControlStateNormal];
    }
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)but1:(id)sender {
    if(![[_answers objectAtIndex:0] isEqualToString:@""]){
        if (_indexOfAnswer == 0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @""
                                                           message: @"Correct!"
                                                          delegate: self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"OK",nil];
            
            [alert setTag:1];
            [alert show];
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


}

- (IBAction)but2:(id)sender {
   if(![[_answers objectAtIndex:1] isEqualToString:@""]){
        if (_indexOfAnswer == 1) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @""
                                                           message: @"Correct!"
                                                          delegate: self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"OK",nil];
            
            [alert setTag:1];
            [alert show];
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

    
}

- (IBAction)but3:(id)sender {
     if(![[_answers objectAtIndex:2] isEqualToString:@""]){
        if (_indexOfAnswer == 2) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @""
                                                           message: @"Correct!"
                                                          delegate: self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"OK",nil];
            
            [alert setTag:1];
            [alert show];
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
    
}

- (IBAction)but4:(id)sender {
     if(![[_answers objectAtIndex:3] isEqualToString:@""]){
        if (_indexOfAnswer == 3) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @""
                                                       message: @"Correct!"
                                                      delegate: self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"OK",nil];
        
            [alert setTag:1];
            [alert show];
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
    
}

- (IBAction)but5:(id)sender {
     if(![[_answers objectAtIndex:4] isEqualToString:@""]){
        if (_indexOfAnswer == 4) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @""
                                                       message: @"Correct!"
                                                      delegate: self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"OK",nil];
        
            [alert setTag:1];
            [alert show];
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
}

@end
