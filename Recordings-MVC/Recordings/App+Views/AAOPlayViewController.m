//
//  AAOPlayViewController.m
//  Recordings
//
//  Created by 季风 on 2018/9/24.
//  Copyright © 2018年 fantasywind. All rights reserved.
//

#import "AAOPlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AAOPlayer.h"
#import "AAOStore.h"
#import "AAORecording.h"
#import "AAOUtil.h"
#import "NSString+text.h"

@interface AAOPlayViewController () <UITextFieldDelegate, AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIStackView *activeItemElements;
@property (weak, nonatomic) IBOutlet UILabel *noRecordingLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (nonatomic, strong) AAOPlayer *audioPlayer;
@end

@implementation AAOPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    [self updateForChangedRecording];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeChanged:) name:AAOStoreChangeNotification object:nil];
}

- (void)storeChanged:(NSNotification *)notification {
    if (![notification.object isKindOfClass:[AAOItem class]]) {
        return;
    }
    AAOItem *item = (AAOItem *)notification.object;
    if (item != self.recording) {
        return;
    }
    [self updateForChangedRecording];
}

- (void)updateForChangedRecording {
    if (self.recording && self.recording.fileURL) {
        __weak typeof(self) weakSelf = self;
        self.audioPlayer = [[AAOPlayer alloc] initWithURL:self.recording.fileURL updateBlock:^(NSTimeInterval time) {
            __strong typeof(self) strongSelf = weakSelf;
            if (time>0) {
                [self updateProgressDisplaysWithProgress:time duration:strongSelf.audioPlayer.duration];
            } else {
                self.recording = nil;
            }
        }];
        if (self.audioPlayer) {
            [self updateProgressDisplaysWithProgress:0 duration:self.audioPlayer.duration];
            self.navigationItem.title = self.recording.name;
            self.nameTextField.text = self.recording.name;
            self.activeItemElements.hidden = false;
            self.noRecordingLabel.hidden = true;
        } else {
            self.recording = nil;
        }
    } else {
        [self updateProgressDisplaysWithProgress:0 duration:0];
        self.audioPlayer = nil;
        self.navigationItem.title = nil;
        self.activeItemElements.hidden = true;
        self.noRecordingLabel.hidden = false;
    }
}

- (void)updateProgressDisplaysWithProgress:(NSTimeInterval)progress duration:(NSTimeInterval)duration {
    self.progressLabel.text = [AAOUtil timeString:progress];
    self.durationLabel.text = [AAOUtil timeString:duration];
    self.progressSlider.maximumValue = duration;
    self.progressSlider.value = progress;
    [self updatePlayButton];
}

- (void)updatePlayButton {
    if (self.audioPlayer.isPlaying) {
        [self.playButton setTitle:[NSString pause] forState:UIControlStateNormal];
    } else if (self.audioPlayer.isPaused) {
        [self.playButton setTitle:[NSString resume] forState:UIControlStateNormal];
    } else {
        [self.playButton setTitle:[NSString play] forState:UIControlStateNormal];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (!self.recording) {
        return;
    }
    if (textField.text.length==0) {
        return;
    }
    self.recording.name = textField.text;
    self.navigationItem.title = self.recording.name;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (IBAction)setProgress:(id)sender {
    if (!self.progressSlider) {
        return;
    }
    [self.audioPlayer setProgress:self.progressSlider.value];
}

- (IBAction)play:(id)sender {
    [self.audioPlayer togglePlay];
    [self updatePlayButton];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.recording = nil;
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    [coder encodeObject:self.recording.uuidPath forKey:[NSString uuidPathKey]];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    id uuidPath = [coder decodeObjectForKey:[NSString uuidPathKey]];
    if (![uuidPath isKindOfClass:[NSArray class]]) {
        return;
    }
    AAOItem *recording = [[AAOStore shared] itemAtUUIDPath:(NSArray *)uuidPath];
    
    if ([recording isKindOfClass:[AAORecording class]]) {
        self.recording = (AAORecording *)recording;
    }
}

@end
