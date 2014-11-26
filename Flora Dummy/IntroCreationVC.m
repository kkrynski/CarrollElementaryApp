//
//  IntroCreationVC.m
//  FloraDummy
//
//  Created by Zachary Nichols on 11/26/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "IntroCreationVC.h"

@interface IntroCreationVC ()
{

}
@end

@implementation IntroCreationVC
@synthesize text, summaryTextView;

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
    summaryTextView = [[UITextView alloc] initWithFrame:CGRectMake(192, 191, 640, 483)];
    [self.view addSubview:summaryTextView];
    
    [self outlineTextInTextView:summaryTextView];
    
    if(!text)
    {
        text = [[NSString alloc] init];
        summaryTextView.text = text;
        
    }else
    {
        summaryTextView.text = text;
    }
}

-(void)forciblySetText:(NSString *)t
{
    if (self.text != nil)
    {
        text = [[NSString alloc] init];
    }
    
    if (summaryTextView)
    {
        summaryTextView.text = text;
    }
    
    [self setText:t];
    
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
        text = summaryTextView.text;
        [_delegate updateIntroWithText:text];
    }
}

@end
