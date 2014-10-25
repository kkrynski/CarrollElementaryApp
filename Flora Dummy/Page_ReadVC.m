//
//  Page_ReadVC.m
//  Flora Dummy
//
//  Created by Zach Nichols on 11/9/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import "Page_ReadVC.h"

@interface Page_ReadVC ()
{
    
}

@end

@implementation Page_ReadVC
@synthesize summaryTextView, pageText;

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
    
    //summaryTextView = [[UITextView alloc] initWithFrame:CGRectMake(33, 72, 971, 602)];
    summaryTextView.text = pageText;
    
    super.titleLabel.frame = CGRectMake(super.titleLabel.frame.origin.x,
                                 super.titleLabel.frame.origin.y,
                                 super.titleLabel.frame.size.width,
                                 super.dateLabel.frame.size.height); // on purpose
    super.titleLabel.font = super.dateLabel.font;
    
    super.dateLabel.frame = CGRectMake(super.dateLabel.frame.origin.x,
                                 20,
                                 super.dateLabel.frame.size.width,
                                 super.dateLabel.frame.size.height);
    super.otherLabel.frame = CGRectMake(super.otherLabel.frame.origin.x,
                                 20,
                                 super.otherLabel.frame.size.width,
                                 super.otherLabel.frame.size.height);

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
