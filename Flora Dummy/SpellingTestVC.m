//
//  SpellingTestVC.m
//  FloraDummy
//
//  Created by Mason Herhusky on 11/11/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "SpellingTestVC.h"
@import AVFoundation;

@interface SpellingTestVC ()
{
    AVAudioPlayer *audioPlayer;
}

@end


@implementation SpellingTestVC

@synthesize word, title, input, submit, playSound;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:word withExtension:@"wav"];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
}

- (IBAction) playSound:(id)sender
{
    [audioPlayer play];
    
    NSLog(@"Play Sound File Pressed");
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) submit:(id)sender
{
    if([self.input.text isEqualToString: self.word])
    {
       //[self dismissViewControllerAnimated:YES completion:nil];
    }
    NSLog(@"Submit Button Pressed");
}

@end