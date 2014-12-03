//
//  MathCreationVC.m
//  FloraDummy
//
//  Created by Zachary Nichols on 11/26/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "MathCreationVC.h"

#import "MathPopOverVC.h"

@interface MathCreationVC ()

@end

@implementation MathCreationVC
@synthesize equation, answer;

-(id)init
{
    if (self = [super init])
    {
        // Initialize
        equation = [[NSString alloc] init];
        answer = [[NSString alloc] init];

    }
    return self;
}

-(id)initWithEquation: (NSString *)e;
{
    if (self = [super init])
    {
        // Initialize
        equation = [[NSString alloc] initWithString:e];
        answer = [[NSString alloc] init];
    }
    return self;
}

-(id)initWithEquation: (NSString *)e andAnswer: (NSString *)a
{
    if (self = [super init])
    {
        // Initialize
        equation = [[NSString alloc] initWithString:e];
        answer = [[NSString alloc] initWithString:a];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(presentPopOver:)];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItems = @[editButton, saveButton];
    
    for (UIView *v in self.view.subviews)
    {
        [v removeFromSuperview];
    }
}


-(IBAction)presentPopOver: (id)sender
{
    if (_mathPicker == nil)
    {
        //Create the ColorPickerViewController.
        _mathPicker = [[MathPopOverVC alloc] init];
        
        if (equation != nil)
        {
            [_mathPicker setEquationString:equation];
        }
        if (answer != nil)
        {
            [_mathPicker setAnswerString:answer];
        }
        
        //Set this VC as the delegate.
        _mathPicker.delegate = self;
        
    }
    
    if (_mathPickerPopOver == nil)
    {
        //The color picker popover is not showing. Show it.
        _mathPickerPopOver = [[UIPopoverController alloc] initWithContentViewController:_mathPicker];
        _mathPickerPopOver.popoverContentSize = CGSizeMake(self.mathPicker.view.frame.size.width, self.mathPicker.view.frame.size.height);
        [_mathPickerPopOver presentPopoverFromBarButtonItem:(UIBarButtonItem *) sender  permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else
    {
        //The color picker popover is showing. Hide it.
        [_mathPickerPopOver dismissPopoverAnimated:YES];
        _mathPickerPopOver = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)save
{
    //Notify the delegate if it exists.
    if (_delegate != nil)
    {
        //text = textView.text;
        [_delegate updateMathVCWithEquation:equation andAnswer:answer];
    }
}

#pragma mark - MathPopOverDelegate

-(void)returnEquation: (NSString *)e andAnswer: (NSString *)a
{
    equation = e;
    answer = a;
    
    [_mathPickerPopOver dismissPopoverAnimated:YES];
    _mathPickerPopOver = nil;
    _mathPicker = nil;
}

@end
