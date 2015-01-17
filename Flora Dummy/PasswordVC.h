//
//  PasswordVC.h
//  FloraDummy
//
//  Created by Mason Herhusky on 11/4/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "PageVC.h"

@interface PasswordVCTextField : UITextField

@end

@interface PasswordVC : FormattedVC <UITextFieldDelegate>
{
    NSString *username;
    NSString *password;
}

@property (nonatomic, retain) IBOutlet UIButton *submitButton;

@property (nonatomic, retain) IBOutlet UITextField *usernameInput;
@property (nonatomic, retain) IBOutlet UITextField *passwordInput;

@property (nonatomic, retain) IBOutlet UILabel *userLabel;
@property (nonatomic, retain) IBOutlet UILabel *passwordLabel;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;

@end
