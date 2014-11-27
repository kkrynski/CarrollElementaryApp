//
//  MathPopOverVC.h
//  FloraDummy
//
//  Created by Zachary Nichols on 11/26/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MathPopOverDelegate <NSObject>
-(void)returnEquation: (NSString *)e andAnswer: (NSString *)a;
@end

@interface MathPopOverVC : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
{
    
}

@property(nonatomic, retain) NSString *equationString;
@property(nonatomic, retain) NSString *answerString;

@property(nonatomic, retain) IBOutlet UITextView *equationTextView;
@property(nonatomic, retain) IBOutlet UITextView *answerTextView;
@property(nonatomic, retain) IBOutlet UISegmentedControl *answerTypeSegmentedControl;

@property(nonatomic, retain) IBOutlet UIButton *updateButton;

@property (nonatomic, weak) id<MathPopOverDelegate>delegate;

-(id)init;
-(id)initWithEquation: (NSString *)e;
-(id)initWithEquation:(NSString *)e andAnswer: (NSString *)a;

@end