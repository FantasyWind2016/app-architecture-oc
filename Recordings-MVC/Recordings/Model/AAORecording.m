//
//  AAORecording.m
//  Recordings
//
//  Created by 季风 on 2018/9/24.
//  Copyright © 2018年 fantasywind. All rights reserved.
//

#import "AAORecording.h"
#import "AAOStore.h"

@implementation AAORecording

#pragma mark - override

- (void)deleted {
    [self.store removeFileForRecording:self];
    [super deleted];
}

#pragma mark - getter
- (NSURL *)fileURL {
    return [self.store fileURLForRecording:self];
}
@end
