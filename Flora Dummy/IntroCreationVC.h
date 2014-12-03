//
//  IntroCreationVC.h
//  FloraDummy
//
//  Created by Zachary Nichols on 11/26/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FormattedVC.h"

@protocol IntroCreationDelegate <NSObject>
-(void)updateIntroWithText: (NSString *)t;
@end

@interface IntroCreationVC : FormattedVC<UIActionSheetDelegate>
{
    NSString *text;
}

@property(nonatomic, retain) NSString *text;

@property(nonatomic, retain) UITextView *summaryTextView;

@property (nonatomic, weak) id<IntroCreationDelegate>delegate;

-(id)init;
-(id)initWithText: (NSString *)t;

@end