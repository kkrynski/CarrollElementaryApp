//
//  PictureQuizVC.m
//  FloraDummy
//
//  Created by Zachary Nichols on 11/1/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "PictureQuizVC.h"

#import "FloraDummy-Swift.h"

@interface PictureQuizVC ()

@end

@implementation PictureQuizVC

@synthesize answers, question, imageName, correctIndex;
@synthesize imageView, questionLabel, button0, button1, button2, button3, button4, button5;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self populate];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)populate
{
    [button0 setTitle:(NSString *)[answers objectAtIndex:0] forState:UIControlStateNormal];
    
    questionLabel.text = question;
    
    imageView.image = [UIImage imageNamed:imageName];
}

@end
