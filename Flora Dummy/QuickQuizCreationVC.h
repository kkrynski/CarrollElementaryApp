//
//  QuickQuizCreationVC.h
//  FloraDummy
//
//  Created by Zachary Nichols on 11/26/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "FormattedVC.h"
#import "QuickQuizCreationPopOverVC.h"

@protocol QuickQuizCreationDelegate <NSObject>
-(void)updateQuizWithAnswers: (NSArray *)array andQuestion: (NSString *)q andCorrectIndex: (NSNumber *)n;
@end

@interface QuickQuizCreationVC : FormattedVC<QuickQuizPopOverDelegate>

@property(nonatomic, retain) NSString *question;
@property(nonatomic, retain) NSMutableArray *answers;
@property(nonatomic, retain) NSNumber *correctIndex;

@property(nonatomic, retain) IBOutlet UILabel *questionLabel;

@property(nonatomic, retain) IBOutlet UIButton *option1Button;
@property(nonatomic, retain) IBOutlet UIButton *option2Button;
@property(nonatomic, retain) IBOutlet UIButton *option3Button;

@property (nonatomic, weak) id<QuickQuizCreationDelegate>delegate;

@property(nonatomic, retain) QuickQuizCreationPopOverVC *quizPicker;
@property (nonatomic, strong) UIPopoverController *quizPickerPopOver;

@end
