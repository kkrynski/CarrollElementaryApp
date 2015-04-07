//
//  PasswordVC.h
//  FloraDummy
//
//  Created by Mason Herhusky on 11/4/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

@interface PasswordVCTextField : UITextField

@end

@class FormattedVC;

@interface PasswordVC : FormattedVC <UITextFieldDelegate>
{    
    BOOL accountsWereDownloaded;
    BOOL userIsWaiting;
    
    IBOutlet UIButton *submitButton;
    IBOutlet UITextField *usernameInput;
    IBOutlet UITextField *passwordInput;
    IBOutlet UILabel *userLabel;
    IBOutlet UILabel *passwordLabel;
    IBOutlet UILabel *titleLabel;
    
    UIActivityIndicatorView *loadingWheel;
}

@property (nonatomic, retain) IBOutlet UIView *backgroundView;
@property (nonatomic, retain) IBOutlet UIView *infoView;

@end
