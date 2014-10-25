//
//  Page_QRCodeVC.h
//  Flora Dummy
//
//  Created by Zach Nichols on 3/12/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

#import "ZBarSDK.h"

#import "PageVC.h"
#import "UIButton_Typical.h"

@interface Page_QRCodeVC : PageVC <ZBarReaderDelegate>
{
    
}

@property (nonatomic, retain) ZBarReaderViewController *reader;
@property (strong, nonatomic) UINavigationController *qrNav;

@property(nonatomic, retain) IBOutlet UITextView *hintTextView;
@property(nonatomic, retain) IBOutlet UIImageView *solvedImageView;

@property (strong, nonatomic) NSNumber *targetQR;
@property (strong, nonatomic) NSDictionary *pageDict;

@property (strong, nonatomic) NSNumber *alreadySolved;

@end
