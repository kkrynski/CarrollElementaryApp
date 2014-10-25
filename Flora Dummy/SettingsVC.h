//
//  SettingsVC.h
//  Flora Dummy
//
//  Created by Zach Nichols on 9/28/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsVC : UIViewController
{
    
}

// Title label holds the name of the screen
@property(nonatomic, retain) IBOutlet UILabel *titleLabel;

// The following labels describe what type of buttons
// are available for user selection.
@property (nonatomic, retain) IBOutlet UILabel *gradeLabel;
@property (nonatomic, retain) IBOutlet UILabel *colorLabel;

// Note: Consider finding a more efficient/dynamic way to
//       store buttons. Consider using button tags to hold
//       grade information. Try to avoid a tag of 0, as this
//       is the default

// Buttons for grade
@property(nonatomic, retain) IBOutlet UIButton *kindergartenButton;
@property(nonatomic, retain) IBOutlet UIButton *firstButton;
@property(nonatomic, retain) IBOutlet UIButton *secondButton;
@property(nonatomic, retain) IBOutlet UIButton *thirdButton;
@property(nonatomic, retain) IBOutlet UIButton *fourthButton;
@property(nonatomic, retain) IBOutlet UIButton *fifthButton;
@property(nonatomic, retain) IBOutlet UIButton *sixthButton;

// Color combination buttons
@property(nonatomic, retain) IBOutlet UIButton *purpleButton;
@property(nonatomic, retain) IBOutlet UIButton *redButton;
@property(nonatomic, retain) IBOutlet UIButton *pinkButton;
@property(nonatomic, retain) IBOutlet UIButton *orangeButton;
@property(nonatomic, retain) IBOutlet UIButton *yellowButton;
@property(nonatomic, retain) IBOutlet UIButton *greenButton;
@property(nonatomic, retain) IBOutlet UIButton *blueButton;

// Functions for when either type of button is pressed
-(IBAction)colorButtonPressed:(id)sender;
-(IBAction)gradeButtonPressed:(id)sender;

@end
