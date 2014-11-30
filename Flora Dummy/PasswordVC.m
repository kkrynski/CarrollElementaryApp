//
//  PasswordVC.m
//  FloraDummy
//
//  Created by Mason Herhusky on 11/4/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "PasswordVC.h"

@interface PasswordVC ()

@end

@implementation PasswordVC
@synthesize username, password;
@synthesize usernameInput, passwordInput;
@synthesize submitButton;
@synthesize userLabel, passwordLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self makeMePretty];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submit:(id)sender
{
    NSString *defaultUsername = @"qwerty";
    NSString *defaultPassword = @"qwerty";
    NSString *tempUsername = usernameInput.text;
    NSString *tempPassword = passwordInput.text;
    if([tempUsername isEqualToString: defaultUsername]) {
        if([tempPassword isEqualToString: defaultPassword] ){
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    NSLog(@"submit");
}

-(void)makeMePretty
{
    userLabel.font = self.font;
    userLabel.textColor = self.primaryColor;
    
    passwordLabel.font = self.font;
    passwordLabel.textColor = self.primaryColor;
    
    usernameInput.font = self.font;
    usernameInput.backgroundColor = self.secondaryColor;
    usernameInput.textColor = self.primaryColor;
    
    passwordInput.font = self.font;
    passwordInput.backgroundColor = self.secondaryColor;
    passwordInput.textColor = self.primaryColor;
    
    submitButton.titleLabel.font = self.font;
    [submitButton setTitleColor:self.primaryColor forState:UIControlStateNormal];
}

@end
