//
//  Page_IntroVC.h
//  Flora Dummy
//
//  Created by Zach Nichols on 11/1/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageVC.h"

@interface Page_IntroVC : PageVC
{
    
}

@property(nonatomic, retain) IBOutlet UITextView *summaryTextView;
@property(nonatomic, retain) NSString *summary;

@end
