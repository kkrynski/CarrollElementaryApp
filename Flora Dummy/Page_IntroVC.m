//
//  Page_IntroVC.m
//  Flora Dummy
//
//  Created by Zach Nichols on 11/1/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import "Page_IntroVC.h"

@interface Page_IntroVC ()
{

}

@end

@implementation Page_IntroVC
@synthesize titleLabel, summaryTextView, summary;

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
    // Do any additional setup after loading the view from its nib.
    
    summary = @"Welcome to activity foo, where will you learn to blah and bleh by using bluh.\n\nPress ""Next"" to move on or ""Previous"" to move back.";
    
    pageControl.numberOfPages = pageCount.intValue;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateColors
{
    [super updateColors];

    [self outlineTextInTextView:summaryTextView];
    summaryTextView.textColor = primaryColor;
    summaryTextView.backgroundColor = secondaryColor;
    
}

@end
