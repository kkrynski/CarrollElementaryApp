//
//  Page_ReadVC.h
//  Flora Dummy
//
//  Created by Zach Nichols on 11/9/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PageVC.h"

@interface Page_ReadVC : PageVC
{
    
}

@property(nonatomic, retain) NSString *pageText;

@property(nonatomic, retain) IBOutlet UITextView *summaryTextView;

@end
