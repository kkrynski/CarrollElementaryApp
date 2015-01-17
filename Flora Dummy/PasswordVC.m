//
//  PasswordVC.m
//  FloraDummy
//
//  Created by Mason Herhusky on 11/4/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "PasswordVC.h"
#import "FloraDummy-Swift.h"

@implementation PasswordVCTextField : UITextField

- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, CGRectGetMinX(rect), rect.size.height - 10);
    CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor] );
    CGContextSetLineWidth(context, 3.0);
    CGContextStrokePath(context);
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 10)]];
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

@end

@implementation PasswordVC

@synthesize usernameInput, passwordInput;
@synthesize submitButton;
@synthesize userLabel, passwordLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self makeMePretty];
}

- (IBAction)submit:(id)sender
{
    NSString *defaultUsername = @"qwerty";
    NSString *defaultPassword = @"qwerty";
    
    NSString *tempUsername = usernameInput.text;
    NSString *tempPassword = passwordInput.text;
    
    if([tempUsername isEqualToString: defaultUsername] && [tempPassword isEqualToString: defaultPassword])
        [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) makeMePretty
{
    [_titleLabel setTextColor:self.primaryColor];
    
    //userLabel.font = self.font;
    userLabel.textColor = self.primaryColor;
    
    //passwordLabel.font = self.font;
    passwordLabel.textColor = self.primaryColor;
    
    //usernameInput.font = self.font;
    //usernameInput.backgroundColor = self.secondaryColor;
    usernameInput.textColor = self.primaryColor;
    usernameInput.text = @"qwerty";
    
    //passwordInput.font = self.font;
    //passwordInput.backgroundColor = self.secondaryColor;
    passwordInput.textColor = self.primaryColor;
    passwordInput.text = @"qwerty";

    submitButton.titleLabel.font = self.font;
    [submitButton setTitleColor:self.primaryColor forState:UIControlStateNormal];
    
    [Definitions outlineTextInLabel:userLabel];
    [Definitions outlineTextInLabel:_titleLabel];
    [Definitions outlineTextInLabel:passwordLabel];
    [Definitions outlineTextInLabel:submitButton.titleLabel];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:userLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-8]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:userLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-8]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:passwordLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-8]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:passwordLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:8]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:usernameInput attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:8]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:usernameInput attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:userLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:passwordInput attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:8]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:passwordInput attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:passwordLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.placeholder isEqualToString:@"Username"])
    {
        [textField resignFirstResponder];
        [passwordInput becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
        [self submit:nil];
    }
    
    return NO;
}

@end
