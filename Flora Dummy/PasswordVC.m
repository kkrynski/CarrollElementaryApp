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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAccountsWereDownloaded) name: UserAccountsDownloaded object:nil];
    
    accountsWereDownloaded = NO;
    userIsWaiting = NO;
    
    [[CESDatabase databaseManagerForPasswordVCClass] downloadUserAccounts];
    
    
    [self makeMePretty];
}

-(void)userAccountsWereDownloaded
{
    accountsWereDownloaded = YES;
    
    if (userIsWaiting == NO)
    {
        return;
    }
}

- (IBAction)submit:(id)sender
{
    if (accountsWereDownloaded)
    {
        [self checkInfo];
    
        NSLog(@"Submit: accounts were downloaded");

    }else
    {
        userIsWaiting = YES;
        
        // Move on
        
        NSLog(@"Submit: accounts were NOT downloaded");
    }
}

-(void)checkInfo
{
    NSString *tempUsername = usernameInput.text;
    NSString *tempPassword = passwordInput.text;
    
    UserState userState = [[CESDatabase databaseManagerForPasswordVCClass] inputtedUsernameIsValid:tempUsername andPassword:tempPassword];
    
    switch (userState)
    {
        case UserStateUserInvalid:
        {
            // Return
            
            NSLog(@"invalid");

#warning hi
            
            break;
        }
        case UserStateUserIsStudent:
        {
            // Student
            
            BOOL success = [[CESDatabase databaseManagerForPasswordVCClass] storeInputtedUserInformation:tempUsername andPassword:tempPassword];
            
            if (success == NO)
            {
                // Display another error
#warning hi
                NSLog(@"student - no success");

            }else
            {
                // Self dismiss
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
                NSLog(@"student - success");

            }
            
            break;
        }
        case UserStateUserIsTeacher:
        {
            // Teacher
            
            BOOL success = [[CESDatabase databaseManagerForPasswordVCClass] storeInputtedUserInformation:tempUsername andPassword:tempPassword];
            
            if (success == NO)
            {
                // Display another error
#warning hi
                NSLog(@"teacher - no success");

                
            }else
            {
                // Self dismiss
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
                NSLog(@"teacher - success");

            }
            
            break;
        }
            
        default:
            break;
    }
}

-(void)displayErrorWithCode: (int)e
{
    // for e,    0 = invalid username password
    //           1 =
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
