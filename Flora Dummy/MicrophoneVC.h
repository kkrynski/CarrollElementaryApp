//
//  MicrophoneVC.h
//  FloraDummy
//
//  Created by Mason Herhusky on 11/22/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "PageVC.h"
@protocol AVAudioPlayerDelegate;
@protocol AVAudioRecorderDelegate;
#import <AVFoundation/AVFoundation.h>

@interface MicrophoneVC : PageVC <AVAudioRecorderDelegate, AVAudioPlayerDelegate> {

}
    @property(nonatomic,retain) IBOutlet UIButton *recordPauseButton;
    @property(nonatomic,retain) IBOutlet UIButton *playButton;
    @property(nonatomic,retain) IBOutlet UIButton *stopButton;

@end
