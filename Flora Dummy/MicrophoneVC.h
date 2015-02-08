//
//  MicrophoneVC.h
//  FloraDummy
//
//  Created by Mason Herhusky on 11/22/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "PageVC.h"
@import AVFoundation;

@interface MicrophoneVC : FormattedVC <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    IBOutlet UIButton *recordPauseButton;
    IBOutlet UIButton *playButton;
    IBOutlet UIButton *stopButton;
    
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
}

@end
