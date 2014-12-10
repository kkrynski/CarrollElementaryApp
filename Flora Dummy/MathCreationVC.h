//
//  MathCreationVC.h
//  FloraDummy
//
//  Created by Zachary Nichols on 11/26/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "FormattedVC.h"
#import "MathPopOverVC.h"

@protocol MathCreationDelegate <NSObject>
-(void)updateMathVCWithEquation: (NSString *)e andAnswer: (NSString *)a;
@end

@interface MathCreationVC : FormattedVC<MathPopOverDelegate>
{
    NSString *equation;
    NSString *answer;
}

@property(nonatomic, retain) NSString *equation;
@property(nonatomic, retain) NSString *answer;

@property(nonatomic, retain) MathPopOverVC *mathPicker;
@property (nonatomic, strong) UIPopoverController *mathPickerPopOver;

@property (nonatomic, weak) id<MathCreationDelegate>delegate;

-(id)init;
-(id)initWithEquation: (NSString *)e;
-(id)initWithEquation: (NSString *)e andAnswer: (NSString *)a;


@end
