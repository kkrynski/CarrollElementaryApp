//
//  ReadingCreationVC.m
//  FloraDummy
//
//  Created by Zachary Nichols on 11/26/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "ReadingCreationVC.h"

@interface ReadingCreationVC ()

@end

@implementation ReadingCreationVC
@synthesize text, textView;

-(id)init
{
    if (self = [super init])
    {
        // Initialize
        text = [[NSString alloc] init];
    }
    return self;
}

-(id)initWithText: (NSString *)t
{
    if (self = [super init])
    {
        // Initialize
        text = [[NSString alloc] initWithString:t];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItems = @[saveButton];
    
    for (UIView *v in self.view.subviews)
    {
        [v removeFromSuperview];
    }
    
    // Draw textview
    textView = [[UITextView alloc] initWithFrame:CGRectMake(33, 72, 971, 602)];
    [self.view addSubview:textView];
    
    [self outlineTextInTextView:textView];
    
    if(!text)
    {
        text = [[NSString alloc] init];
        textView.text = text;
        
    }else
    {
        textView.text = text;
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
        text = textView.text;
        [_delegate updateReadingVCWithText:text];
    }
}

@end
