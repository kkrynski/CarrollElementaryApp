//
//  ContentPopOverVC.h
//  FloraDummy
//
//  Created by Zachary Nichols on 11/23/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Content.h"

@protocol ContentPickerDelegate <NSObject>
-(void)updatedContent:(Content *)c;
@end

@interface ContentPopOverVC : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, retain) Content *content;
@property(nonatomic, retain) NSString *pageType;

@property(nonatomic, retain) IBOutlet UIPickerView *contentTypePicker;

@property(nonatomic, retain) IBOutlet UITextField *xField;
@property(nonatomic, retain) IBOutlet UITextField *yField;
@property(nonatomic, retain) IBOutlet UITextField *widthField;
@property(nonatomic, retain) IBOutlet UITextField *heightField;

@property(nonatomic, retain) IBOutlet UILabel *variableContentLabel;
@property(nonatomic, retain) IBOutlet UITextView *variableContentTextView;

@property(nonatomic, retain) IBOutlet UIButton *addButton;

@property (nonatomic, weak) id<ContentPickerDelegate>delegate;

-(id)init;
-(id)initWithPageType: (NSString *)pT;
-(id)initWithContent: (Content *)c;
-(id)initWithContent: (Content *)c andPageType: (NSString *)pT;
-(IBAction)addButtonPressed;

@end
