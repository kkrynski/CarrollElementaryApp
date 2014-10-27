//
//  QuickQuizVC.h
//  Flora Dummy
//
//  Created by Zachary Nichols on 10/26/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PageVC.h"

@interface QuickQuizVC : PageVC
{
    NSString *question;
    NSArray *answers;
    NSNumber *correctIndex;
}

@property(nonatomic, retain) NSString *question;
@property(nonatomic, retain) NSArray *answers;
@property(nonatomic, retain) NSNumber *correctIndex;

@property(nonatomic, retain) IBOutlet UILabel *questionLabel;

@property(nonatomic, retain) IBOutlet UIButton *option1Button;
@property(nonatomic, retain) IBOutlet UIButton *option2Button;
@property(nonatomic, retain) IBOutlet UIButton *option3Button;

-(IBAction)optionSelected:(id)sender;

@end
