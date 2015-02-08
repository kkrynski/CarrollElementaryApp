//
//  VocabVC.h
//  Flora Dummy
//
//  Created by Riley Shaw on 10/25/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "PageVC.h"




@interface VocabVC : FormattedVC
@property (nonatomic,retain) IBOutlet UILabel *questionLabel;
@property (nonatomic,retain) IBOutlet UIButton *butAnswer1;
@property (nonatomic,retain) IBOutlet UIButton *butAnswer2;
@property (nonatomic,retain) IBOutlet UIButton *butAnswer3;
@property (nonatomic,retain) IBOutlet UIButton *butAnswer4;
@property (nonatomic,retain) IBOutlet UIButton *butAnswer5;

@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) NSArray *answers;
@property (nonatomic, assign) NSNumber *correctIndex;

@end
