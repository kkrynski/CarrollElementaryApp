//
//  SpellingTestVC.m
//  FloraDummy
//
//  Created by Mason Herhusky on 11/11/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "SpellingTestVC.h"
@import AVFoundation;

@interface SpellingTestVC () {
    AVAudioPlayer *audioPlayer;
}

@end


@implementation SpellingTestVC
@synthesize word;
@synthesize title;
@synthesize input;
@synthesize submit;
@synthesize playSound;

- (void)viewDidLoad {
    [super viewDidLoad];
    //word = @"hello";
    NSURL *url = [[NSBundle mainBundle] URLForResource:word withExtension:@"wav"];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
   
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)PlayButtonPressed {
    //The call below uses AudioServicesPlaySystemSound to play
    //the word sound.
   // [_audioController playSystemSound];
    
    [audioPlayer play];
    NSLog(@"PlayButtonPressed");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender {
    if([self.input.text isEqualToString: self.word]) {
       // [self dismissViewControllerAnimated:YES completion:nil];
    }
    NSLog(@"submit");
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end