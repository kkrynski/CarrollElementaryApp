//
//  PasswordVC.m
//  FloraDummy
//
//  Created by Mason Herhusky on 11/4/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//  Modified by Michael Schloss and Zack Nichols on 1/24/15 - 1/25/15
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
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor] );
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
    [self makeMePretty];
    
    [self.view layoutIfNeeded];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAccountsWereDownloaded) name:UserAccountsDownloaded object:nil];
    
    accountsWereDownloaded = NO;
    userIsWaiting = NO;
    
    [[CESDatabase databaseManagerForPasswordVCClass] downloadUserAccounts];
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

- (void) makeMePretty
{
    [titleLabel setTextColor:self.primaryColor];
    
    userLabel.textColor = self.primaryColor;
    passwordLabel.textColor = self.primaryColor;
    
    usernameInput.textColor = self.primaryColor;
    usernameInput.text = @"qwerty";
    
    passwordInput.textColor = self.primaryColor;
    passwordInput.text = @"qwerty";

    submitButton.titleLabel.font = self.font;
    [submitButton setTitleColor:self.primaryColor forState:UIControlStateNormal];
    
    [Definitions outlineTextInLabel:userLabel];
    [Definitions outlineTextInLabel:titleLabel];
    [Definitions outlineTextInLabel:passwordLabel];
    [Definitions outlineTextInLabel:submitButton.titleLabel];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:userLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-4]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:userLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-4]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:passwordLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-4]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:passwordLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:4]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:usernameInput attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:4]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:usernameInput attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:userLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:passwordInput attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:4]];
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

/*
 --------------------
 -- [[ Constants ]] --
 --------------------
 
 
 NSString *UserAccountsDownloaded ([UserAccountsDatabaseManager UserAccountsDownloaded])
 *  Use this constant to listen for the notification when user accounts finish
 downloading
 
 
 -------------------
 -- [[ Methods ]] --
 -------------------
 
 
 - (void) downloadUserAccounts
 *  Downloads the user accounts for Teachers and Students.  This method should be called
 immediately in 'viewDidLoad:'
 *  Once the accounts have downloaded, this method sends out the "UserAccountsDownloaded"
 notification.  Add your class as an observer to properly respond to the finished download
 
 - (NSString *) inputtedUsernameIsValid:(NSString *)username andPassword:(NSString *)password
 *  Compares the received user account information with the downloaded information.  If no
 data has been downloaded, this method immediately returns 'UserStateUserInvalid'.
 *  There are three NSString Constants that can be returned:
 *  'UserStateUserIsStudent' -- If you receive this NSString constant, that means the
 inputted information is for a Student Account
 *  'UserStateUserIsTeacher' -- If you receive this NSString constant, that means the
 inputted information is for a Teacher Account
 *  'UserStateUserInvalid'   -- If you receive this NSString constant, that means the
 inputted information is invalid
 
 - (BOOL) storeInputtedUsername:(NSString *)username andPassword:(NSString *)password
 *  Stores the inputted Username and Password onto the device.  User information is encrypted
 first.
 *  NOTE: This method will do nothing if '- (UserState) inputtedUserInformationIsValid:'
 hasn't been called yet, or returned UserStateUserInvalid.
 *  If returned 'true', the information was successfuly stored onto the device.
 If returned 'false' the information was not successfully stored onto the device.
 *  You should use this Bool to determine whether or not you can/should dismiss the
 PasswordVC.
 
 NOTE:   You will not have access to the downloaded user accounts.  This is due in part because
 they are not stored on the device's memory, and in part because they are stored as Swift
 objects.  They are unreadable to all but the database manager, and are never decrypted.
 */



@end
