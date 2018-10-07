//
//  AAOPlayer.m
//  Recordings
//
//  Created by 季风 on 2018/9/24.
//  Copyright © 2018年 fantasywind. All rights reserved.
//

#import "AAOPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface AAOPlayer() <AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) AAOPlayerUpdateBlock updateBlock;
@end

@implementation AAOPlayer

- (instancetype)initWithURL:(NSURL *)url updateBlock:(AAOPlayerUpdateBlock)updateBlock {
    if (self=[super init]) {
        _updateBlock = updateBlock;
        NSError *error;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        _audioPlayer = player;
        _audioPlayer.delegate = self;
    }
    return self;
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

- (void)togglePlay {
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer pause];
        [self.timer invalidate];
        self.timer = nil;
    } else {
        [self.audioPlayer play];
        
        __weak typeof(self) weakSelf = self;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.updateBlock(strongSelf.audioPlayer.currentTime);
        }];
    }
}

- (void)setProgress:(NSTimeInterval)time {
    self.audioPlayer.currentTime = time;
}

#pragma mark - getter
- (NSTimeInterval)duration {
    return self.audioPlayer.duration;
}

- (BOOL)isPlaying {
    return self.audioPlayer.isPlaying;
}

- (BOOL)isPaused {
    return !self.audioPlayer.isPlaying && self.audioPlayer.currentTime > 0;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self.timer invalidate];
    self.timer = nil;
    self.updateBlock(flag ? self.audioPlayer.currentTime : 0);
}

@end
