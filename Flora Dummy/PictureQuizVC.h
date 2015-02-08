//
//  PictureQuizVC.h
//  FloraDummy
//
//  Created by Zachary Nichols on 11/1/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "PageVC.h"

@interface PictureQuizVC : FormattedVC
{
    NSString *imageName;
    NSString *question;
    NSArray *answers;
    NSNumber *correctIndex;
    
}

@property(nonatomic, retain) NSString *imageName;
@property(nonatomic, retain) NSString *question;
@property(nonatomic, retain) NSArray *answers;
@property(nonatomic, retain) NSNumber *correctIndex;


@property(nonatomic, retain) IBOutlet UIImageView *imageView;

@property(nonatomic, retain) IBOutlet UILabel *questionLabel;
@property(nonatomic, retain) IBOutlet UIButton *button0;
@property(nonatomic, retain) IBOutlet UIButton *button1;
@property(nonatomic, retain) IBOutlet UIButton *button2;
@property(nonatomic, retain) IBOutlet UIButton *button3;
@property(nonatomic, retain) IBOutlet UIButton *button4;
@property(nonatomic, retain) IBOutlet UIButton *button5;



@end
