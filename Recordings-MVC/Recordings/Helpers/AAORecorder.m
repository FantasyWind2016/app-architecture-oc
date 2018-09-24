//
//  AAORecorder.m
//  Recordings
//
//  Created by 季风 on 2018/9/24.
//  Copyright © 2018年 fantasywind. All rights reserved.
//

#import "AAORecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface AAORecorder() <AVAudioRecorderDelegate>
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) AAORecorderUpdateBlock updateBlock;
@property (nonatomic, strong) NSURL *url;
@end

@implementation AAORecorder

- (instancetype)initWithURL:(NSURL *)url updateBlock:(AAORecorderUpdateBlock)updateBlock {
    if (self=[super init]) {
        _updateBlock = updateBlock;
        _url = url;
        NSError *error;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                [self startWithURL:url];
            } else {
                self.updateBlock(0);
            }
        }];
    }
    return self;
}

- (void)startWithURL:(NSURL *)url {
    NSError *error;
    AVAudioRecorder *recorder = [[AVAudioRecorder alloc] initWithURL:url settings:@{AVFormatIDKey: @(kAudioFormatMPEG4AAC), AVSampleRateKey: @(44100.0), AVNumberOfChannelsKey: @(1)} error:&error];
    if (recorder) {
        recorder.delegate = self;
        [recorder record];
        self.audioRecorder = recorder;
        __weak typeof(self) weakSelf = self;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.updateBlock(self.audioRecorder.currentTime);
        }];
    } else {
        self.updateBlock(0);
    }
}

- (void)stop {
    [self.audioRecorder stop];
    [self.timer invalidate];
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag) {
        [self stop];
    } else {
        self.updateBlock(0);
    }
}

@end
