//
//  HomeVC.h
//  Flora Dummy
//
//  Created by Zach Nichols on 9/28/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeVC : UIViewController
{
    
}

// Title label holds text like "Welcome!"
@property(nonatomic, retain) IBOutlet UILabel *titleLabel;

// Subtitle label holds minor text, like "Are you ready to learn?"
@property(nonatomic, retain) IBOutlet UILabel *subTitleLabel;

// Home screen image view
@property(nonatomic, retain) IBOutlet UIImageView *homeImageView;

@end
