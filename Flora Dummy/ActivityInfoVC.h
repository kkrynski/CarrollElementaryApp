//
//  ActivityInfoVC.h
//  FloraDummy
//
//  Created by Zachary Nichols on 11/23/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Activity.h"

@protocol ActivityInfoDelegate <NSObject>
-(void)finishSavingActivity: (Activity *)a;
@end

@interface ActivityInfoVC : UIViewController

@property(nonatomic, retain) Activity *activity;

@property(nonatomic, retain) IBOutlet UITextField *nameField;
@property(nonatomic, retain) IBOutlet UIDatePicker *releasePicker;
@property(nonatomic, retain) IBOutlet UIDatePicker *duePicker;
@property(nonatomic, retain) IBOutlet UITextField *imageField;
@property(nonatomic, retain) IBOutlet UIButton *saveButton;

@property (nonatomic, weak) id<ActivityInfoDelegate>delegate;

-(id)init;
-(id)initWithActivity: (Activity *)a;
-(IBAction)save:(id)sender;

@end
