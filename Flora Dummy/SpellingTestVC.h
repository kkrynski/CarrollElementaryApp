//
//  SpellingTestVC.h
//  FloraDummy
//
//  Created by Mason Herhusky on 11/11/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "PageVC.h"


@class AudioController;

@interface SpellingTestVC : PageVC {
    
    
}

@property(nonatomic,retain) AudioController* audioController;
@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *word;
@property(nonatomic,retain) IBOutlet UIButton *submit;
@property(nonatomic,retain) IBOutlet UIButton *playSound;
@property(nonatomic,retain) IBOutlet UITextField *input;


@end
