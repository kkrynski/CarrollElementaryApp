//
//  QuickQuizCreationPopOverVC.h
//  FloraDummy
//
//  Created by Zachary Nichols on 11/26/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuickQuizPopOverDelegate <NSObject>
-(void)returnAnswers: (NSArray *)array andQuestion: (NSString *)q andCorrectIndex: (NSNumber *)n;
@end

@interface QuickQuizCreationPopOverVC : UIViewController
{
    
}

@property(nonatomic, retain) NSString *question;
@property(nonatomic, retain) NSMutableArray *answers;
@property(nonatomic, retain) NSNumber *correctIndex;

@property(nonatomic, retain) IBOutlet UITextView *questionTextView;
@property(nonatomic, retain) IBOutlet UITextField *image1TextField;
@property(nonatomic, retain) IBOutlet UITextField *image2TextField;
@property(nonatomic, retain) IBOutlet UITextField *image3TextField;
@property(nonatomic, retain) IBOutlet UITextField *correctIndexTextField;

@property(nonatomic, retain) IBOutlet UIButton *updateButton;

@property (nonatomic, weak) id<QuickQuizPopOverDelegate>delegate;

-(id)init;

@end