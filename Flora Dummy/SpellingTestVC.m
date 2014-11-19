//
//  SpellingTestVC.m
//  FloraDummy
//
//  Created by Mason Herhusky on 11/11/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "SpellingTestVC.h"
#import "AudioController.h"

@interface SpellingTestVC ()

@end


@implementation SpellingTestVC
@synthesize word;
@synthesize title;
@synthesize input;
@synthesize submit;
@synthesize playSound;

-(IBAction)PlayButtonPressed {
    [_audioController playSystemSound];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _audioController = [[AudioController alloc]init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender {
    if([self.input.text isEqualToString: self.word]) {
        [self dismissViewControllerAnimated:YES completion:nil];
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