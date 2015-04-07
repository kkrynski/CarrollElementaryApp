//
//  VocabVC.m
//  Flora Dummy
//
//  Created by Riley Shaw on 10/25/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "VocabVC.h"
#import "FloraDummy-Swift.h"

@implementation VocabVC
@synthesize questionLabel;

- (void) viewDidLoad
{
    [super viewDidLoad];
    questionLabel.text = [NSString stringWithFormat:@"  %@",_question];
    questionLabel.font = self.font;
    questionLabel.textColor = primaryColor;

    if(![[_answers objectAtIndex:0] isEqualToString:@""])
    {
        [_butAnswer1 setTitle:[NSString stringWithFormat:@"  %@",(NSString *)[_answers objectAtIndex:0]] forState:UIControlStateNormal];
        _butAnswer1.titleLabel.font = self.font;
        [_butAnswer1 setTitleColor:primaryColor forState:UIControlStateNormal];
        [Definitions outlineButton:_butAnswer1];
    }
    if(![[_answers objectAtIndex:1] isEqualToString:@""])
    {
        [_butAnswer2 setTitle:[NSString stringWithFormat:@"  %@",(NSString *)[_answers objectAtIndex:1]] forState:UIControlStateNormal];
        _butAnswer2.titleLabel.font = self.font;
        [_butAnswer2 setTitleColor:primaryColor forState:UIControlStateNormal];
        [Definitions outlineButton:_butAnswer2];
    }
    if(![[_answers objectAtIndex:2] isEqualToString:@""])
    {
        [_butAnswer3 setTitle:[NSString stringWithFormat:@"  %@",(NSString *)[_answers objectAtIndex:2]] forState:UIControlStateNormal];
        _butAnswer3.titleLabel.font = self.font;
        [_butAnswer3 setTitleColor:primaryColor forState:UIControlStateNormal];
        [Definitions outlineButton:_butAnswer3];
    }
    if(![[_answers objectAtIndex:3] isEqualToString:@""])
    {
        [_butAnswer4 setTitle:[NSString stringWithFormat:@"  %@",(NSString *)[_answers objectAtIndex:3]] forState:UIControlStateNormal];
        _butAnswer4.titleLabel.font = self.font;
        [_butAnswer4 setTitleColor:primaryColor forState:UIControlStateNormal];
        [Definitions outlineButton:_butAnswer4];
    }
    if(![[_answers objectAtIndex:4] isEqualToString:@""])
    {
        [_butAnswer5 setTitle:[NSString stringWithFormat:@"  %@",(NSString *)[_answers objectAtIndex:4]] forState:UIControlStateNormal];
        _butAnswer5.titleLabel.font = self.font;
        [_butAnswer5 setTitleColor:primaryColor forState:UIControlStateNormal];
        [Definitions outlineButton:_butAnswer5];
    }
   
    
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction) but1:(id)sender {
    if(![[_answers objectAtIndex:0] isEqualToString:@""]){
        if (_correctIndex.intValue == 0) {
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

- (IBAction) but2:(id)sender {
    if(![[_answers objectAtIndex:1] isEqualToString:@""]){
        if (_correctIndex.intValue == 1) {
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

- (IBAction) but3:(id)sender {
    if(![[_answers objectAtIndex:2] isEqualToString:@""]){
        if (_correctIndex.intValue == 2) {
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

- (IBAction) but4:(id)sender {
    if(![[_answers objectAtIndex:3] isEqualToString:@""]){
        if (_correctIndex.intValue == 3) {
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

- (IBAction) but5:(id)sender {
    if(![[_answers objectAtIndex:4] isEqualToString:@""]){
        if (_correctIndex.intValue == 4) {
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
