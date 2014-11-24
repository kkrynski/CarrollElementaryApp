//
//  PageCreationVC.h
//  FloraDummy
//
//  Created by Zachary Nichols on 11/22/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "FormattedVC.h"

#import "Page.h"
#import "ContentCreationVC.h"

@protocol PageCreationDelegate <NSObject>
-(void)updatePage: (Page *)p;
@end

@interface PageCreationVC : FormattedVC<UIPickerViewDataSource, UIPickerViewDelegate, UISplitViewControllerDelegate, ContentCreationDelegate>


@property(nonatomic, retain) Page *page;

@property(nonatomic, retain) IBOutlet UIPickerView *pagePicker;

@property (nonatomic) BOOL  isHidden;

@property (nonatomic, weak) id<PageCreationDelegate>delegate;

- (void)configureView;

@end
