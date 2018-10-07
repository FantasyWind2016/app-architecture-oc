//
//  AAORecordViewController.m
//  Recordings
//
//  Created by 季风 on 2018/9/24.
//  Copyright © 2018年 fantasywind. All rights reserved.
//

#import "AAORecordViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AAORecorder.h"
#import "AAORecording.h"
#import "AAOUtil.h"
#import "AAOStore.h"
#import "AAOFolder.h"
#import "NSString+text.h"
#import "UIViewController+Alert.h"

@interface AAORecordViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@property (nonatomic, strong) AAORecorder *audioRecorder;
@property (nonatomic, strong) AAORecording *recording;

@end

@implementation AAORecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeLabel.text = [AAOUtil timeString:0];
    self.recording = [[AAORecording alloc] initWithName:@"" uuid:[NSUUID UUID].UUIDString];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSURL *url = [self.folder.store fileURLForRecording:self.recording];
    __weak typeof(self) weakSelf = self;
    self.audioRecorder = [[AAORecorder alloc] initWithURL:url updateBlock:^(NSTimeInterval time) {
        __strong typeof(self) strongSelf = weakSelf;
        if (time>0) {
            strongSelf.timeLabel.text = [AAOUtil timeString:time];
        } else {
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}

- (IBAction)stop:(id)sender {
    [self.audioRecorder stop];
    [self modalTextAlertWithTitle:[NSString saveRecording] accept:[NSString save] cancel:nil placeholder:[NSString nameForRecording] callback:^(NSString *string) {
        if (string.length>0) {
            [self.recording setName:string];
            [self.folder addItem:self.recording];
        } else {
            [self.folder deleted];
        }
        [self dismissViewControllerAnimated:true completion:nil];
    }];
}

@end
