//Using a lot of code from Ray Wenderlich...

#import "AudioController.h"
@import AVFoundation;

@interface AudioController () <AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioSession *audioSession;
@property (assign) SystemSoundID wordSound;
@end

#pragma mark - Public
@implementation AudioController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureSystemSound];
    }
    return self;
}


- (void)playSystemSound {
    AudioServicesPlaySystemSound(self.wordSound);
    
}

#pragma mark - Private


- (void)configureSystemSound {
    // This is the simplest way to play a sound.
    // But note with System Sound services you can only use:
    // File Formats (a.k.a. audio containers or extensions): CAF, AIF, WAV
    // Data Formats (a.k.a. audio encoding): linear PCM (such as LEI16) or IMA4
    // Sounds must be 30 sec or less
    // And only one sound plays at a time!
    
    NSString *wordPath = [[NSBundle mainBundle] pathForResource:@"hello" ofType:@"wav"];
    NSURL *wordURL = [NSURL fileURLWithPath:wordPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)wordURL, &_wordSound);

}
#pragma mark - AVAudioPlayerDelegate methods


@end