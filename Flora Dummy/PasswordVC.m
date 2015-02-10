//
//  PasswordVC.m
//  FloraDummy
//
//  Created by Mason Herhusky on 11/4/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//  Modified by Michael Schloss and Zack Nichols on 1/24/15 - 2/8/15
//

#import "PasswordVC.h"
#import "FloraDummy-Swift.h"

@implementation PasswordVCTextField : UITextField

- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, CGRectGetMinX(rect), rect.size.height - 15);
    CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextSetStrokeColorWithColor(context, [[ColorManager sharedManager] currentColor].secondaryColor.CGColor);
    CGContextSetLineWidth(context, 3.0);
    CGContextStrokePath(context);
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 10)]];
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

@end

@implementation PasswordVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:userLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-4]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:userLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-4]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:passwordLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-4]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:passwordLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:4]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:usernameInput attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:4]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:usernameInput attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:userLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:passwordInput attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:4]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:passwordInput attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:passwordLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self.view layoutIfNeeded];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAccountsWereDownloaded) name:UserAccountsDownloaded object:nil];
    
    accountsWereDownloaded = NO;
    userIsWaiting = NO;
    
    [[CESDatabase databaseManagerForPasswordVCClass] downloadUserAccounts];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateColors) name:ColorSchemeDidChangeNotification object:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateColors];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    loadingWheel = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loadingWheel.center = submitButton.center;
    [loadingWheel startAnimating];
    loadingWheel.transform = CGAffineTransformMakeScale(1.3, 1.3);
    loadingWheel.alpha = 0.0;
    [self.view addSubview:loadingWheel];
}

- (void) dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [super dismissViewControllerAnimated:flag completion:completion];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void) transitionToLoadingState
{
    [submitButton setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.7 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent) animations:^
    {
        submitButton.alpha = 0.0;
        submitButton.transform = CGAffineTransformMakeScale(0.7, 0.7);
        
        loadingWheel.transform = CGAffineTransformIdentity;
        loadingWheel.alpha = 1.0;
    } completion:nil];
}

- (void) transitionOutOfLoadingState
{
    [submitButton setUserInteractionEnabled:YES];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.7 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent) animations:^
    {
        submitButton.alpha = 1.0;
        submitButton.transform = CGAffineTransformIdentity;
        
        loadingWheel.transform = CGAffineTransformMakeScale(1.3, 1.3);
        loadingWheel.alpha = 0.0;
    } completion:nil];
}

- (void) userAccountsWereDownloaded
{
    accountsWereDownloaded = YES;
    
    if (userIsWaiting == NO)
    {
        return;
    }
    else
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        userIsWaiting = NO;
        [self checkInfo];
    }
}

- (IBAction) submit:(id)sender
{
    [self transitionToLoadingState];
    
    if (accountsWereDownloaded)
    {
        
        NSLog(@"Submit: accounts were downloaded");

        
        [self checkInfo];
    }
    else
    {
        userIsWaiting = YES;
        [self performSelector:@selector(databaseTimeout) withObject:nil afterDelay:4];
    }
}

- (void) databaseTimeout
{
    [self transitionOutOfLoadingState];
    
    UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Login Timout" message:@"We're sorry, but we couldn't log you in.\n\nPlease try again or ask your teacher for assistance." preferredStyle:UIAlertControllerStyleAlert];
    [error addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:error animated:YES completion:nil];
}

- (void) checkInfo
{
    UserState userState = [[CESDatabase databaseManagerForPasswordVCClass] inputtedUsernameIsValid:usernameInput.text andPassword:passwordInput.text];
    
    switch (userState)
    {
            //The username and password combination is invalid
        case UserStateUserInvalid:
        {
            NSLog(@"User Is Invalid");
            
            [self transitionOutOfLoadingState];

            UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Incorrect Information" message:@"We're sorry, but that username and password combination is incorrect.\n\nPlease try again." preferredStyle:UIAlertControllerStyleAlert];
            [error addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:error animated:YES completion:nil];
            
            break;
        }
            
            //The username and password combination is to a student account
        case UserStateUserIsStudent:
        {
            BOOL success = [[CESDatabase databaseManagerForPasswordVCClass] storeInputtedUserInformation:usernameInput.text andPassword:passwordInput.text];
            
            [self transitionOutOfLoadingState];
            
            if (success == NO)
            {
                NSLog(@"Student - No success storing information");
                
                //Display another error
                UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Unexpected Error" message:@"We're sorry, but there's been an error logging you in.\n\nPlease try again and ask your teacher for assistance." preferredStyle:UIAlertControllerStyleAlert];
                [error addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:error animated:YES completion:nil];
            }
            else
            {
                NSLog(@"Student - Success storing information");
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
            break;
        }
            
            //The username and password combination is to a teacher account
        case UserStateUserIsTeacher:
        {
            BOOL success = [[CESDatabase databaseManagerForPasswordVCClass] storeInputtedUserInformation:usernameInput.text andPassword:passwordInput.text];
            
            [self transitionOutOfLoadingState];
            
            if (success == NO)
            {
                NSLog(@"Teacher - No success storing information");
                
                //Display another error
                UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Unexpected Error" message:@"We're sorry, but there's been an error logging you in.\n\nPlease try again and ask your teacher for assistance." preferredStyle:UIAlertControllerStyleAlert];
                [error addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:error animated:YES completion:nil];
            }
            else
            {
                NSLog(@"Teacher - Success storing information");
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
            break;
        }
            
        default:
            break;
    }
}

- (void) updateColors
{
    [super updateColors];
    
    [UIView transitionWithView:self.view duration:self.presentingViewController == nil ? 0.0:0.3 options:(UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [titleLabel setTextColor:self.primaryColor];
        
        userLabel.textColor = self.primaryColor;
        passwordLabel.textColor = self.primaryColor;
        
        usernameInput.textColor = self.primaryColor;
        usernameInput.text = @"qwerty";
        [usernameInput setNeedsDisplay];
        
        passwordInput.textColor = self.primaryColor;
        passwordInput.text = @"qwerty";
        [passwordInput setNeedsDisplay];
        
        submitButton.titleLabel.font = self.font;
        [submitButton setTitleColor:self.primaryColor forState:UIControlStateNormal];
        
        [Definitions outlineTextInLabel:userLabel];
        [Definitions outlineTextInLabel:titleLabel];
        [Definitions outlineTextInLabel:passwordLabel];
        [Definitions outlineTextInLabel:submitButton.titleLabel];
    } completion:nil];
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
