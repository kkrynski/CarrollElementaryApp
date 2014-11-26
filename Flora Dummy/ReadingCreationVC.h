//
//  ReadingCreationVC.h
//  FloraDummy
//
//  Created by Zachary Nichols on 11/26/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "FormattedVC.h"

@protocol ReadingCreationDelegate <NSObject>
-(void)updateReadingVCWithText: (NSString *)t;
@end

@interface ReadingCreationVC : FormattedVC<UIActionSheetDelegate>
{
    NSString *text;
}

@property(nonatomic, retain) NSString *text;

@property(nonatomic, retain) UITextView *textView;

@property (nonatomic, weak) id<ReadingCreationDelegate>delegate;

-(id)init;
-(id)initWithText: (NSString *)t;

@end