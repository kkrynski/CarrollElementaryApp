//
//  ContentCreationVC.h
//  FloraDummy
//
//  Created by Zachary Nichols on 11/23/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "FormattedVC.h"

#import "ContentPopOverVC.h"

@protocol ContentCreationDelegate <NSObject>
-(void)updateContentArray: (NSArray *)cArray;
@end

@interface ContentCreationVC : FormattedVC<ContentPickerDelegate, UIActionSheetDelegate>
{
    NSMutableArray *contentArray;
}

@property(nonatomic, retain) NSMutableArray *contentArray;
@property(nonatomic, retain) NSString *pageType;

@property(nonatomic, retain) ContentPopOverVC *contentPicker;
@property (nonatomic, strong) UIPopoverController *contentPickerPopOver;

@property (nonatomic, weak) id<ContentCreationDelegate>delegate;

-(id)init;
-(id)initWithPageType: (NSString *)pT;
-(id)initWithContent: (NSArray *)cArray andPageType: (NSString *)pT;

@end
