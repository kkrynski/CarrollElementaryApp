//
//  GardenDetailVC.h
//  Flora Dummy
//
//  Created by Zach Nichols on 2/20/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIButton_Typical.h"
#import "PageManager.h"
#import "FormattedVC.h"

@interface GardenDetailVC : UIViewController
{
    NSString *name;
    NSString *description;
    
    UIFont *font;
}

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *description;

@property(nonatomic, retain) UIFont *font;

@property(nonatomic, retain) UILabel *nameLabel;
@property(nonatomic, retain) UITextView *descriptionTextView;
@property(nonatomic, retain) UIButton_Typical *readMoreButton;

@property(nonatomic, retain) UIViewController *parent;

@property(nonatomic, retain) PageManager *pageManager;

@end
