//
//  VocabCreationVC.h
//  FloraDummy
//
//  Created by Zachary Nichols on 11/26/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "FormattedVC.h"



@protocol VocabCreationDelegate <NSObject>
-(void)updateVocabWithAnswers: (NSArray *)array andQuestion: (NSString *)q andCorrectIndex: (NSNumber *)n;
@end

@interface VocabCreationVC : FormattedVC

@property(nonatomic, retain) NSString *question;
@property(nonatomic, retain) NSMutableArray *answers;
@property(nonatomic, retain) NSNumber *correctIndex;

@property(nonatomic, retain) IBOutlet UITextView *questionTextView;

@property(nonatomic, retain) NSMutableArray *answerFields; // will be tagged with index
@property(nonatomic, retain) IBOutlet UISegmentedControl *correctIndexSegmentedControl;

@property (nonatomic, weak) id<VocabCreationDelegate>delegate;

//@property(nonatomic, retain) QuickQuizCreationPopOverVC *quizPicker;
@property (nonatomic, strong) UIPopoverController *quizPickerPopOver;

@end
