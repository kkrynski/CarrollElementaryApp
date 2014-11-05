//
//  PasswordVC.h
//  FloraDummy
//
//  Created by Mason Herhusky on 11/4/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "PageVC.h"

@interface PasswordVC : PageVC
{
    

}

@property(nonatomic,retain) NSString *username;
@property(nonatomic,retain) NSString *password;
@property(nonatomic,retain) IBOutlet UIButton *submit;
@property(nonatomic,retain) IBOutlet UITextField *usernameInput;
@property(nonatomic,retain) IBOutlet UITextField *passwordInput;

@end
