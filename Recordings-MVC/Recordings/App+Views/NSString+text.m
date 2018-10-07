//
//  NSString+text.m
//  Recordings
//
//  Created by 季风 on 2018/10/7.
//  Copyright © 2018年 fantasywind. All rights reserved.
//

#import "NSString+text.h"

@implementation NSString (text)

+ (NSString *)uuidPathKey {
    return @"uuidPath";
}
+ (NSString *)showFolder {
    return @"showFolder";
}

+ (NSString *)showRecorder {
    return @"showRecorder";
}

+ (NSString *)showPlayer {
    return @"showPlayer";
}

+ (NSString *)createFolder {
    return NSLocalizedStringWithDefaultValue(@"Create Folder", nil, [NSBundle mainBundle], nil, @"Header for folder creation dialog");
}

+ (NSString *)create {
    return NSLocalizedStringWithDefaultValue(@"Create", nil, [NSBundle mainBundle], nil, @"Confirm button for folder creation dialog");
}

+ (NSString *)folderName {
    return NSLocalizedStringWithDefaultValue(@"Folder Name", nil, [NSBundle mainBundle], nil, @"Placeholder for text field where folder name should be entered.");
}

+ (NSString *)recordings {
    return NSLocalizedStringWithDefaultValue(@"Recordings", nil, [NSBundle mainBundle], nil, @"Heading for the list of recorded audio items and folders.");
}

+ (NSString *)pause {
    return NSLocalizedStringWithDefaultValue(@"Pause", nil, [NSBundle mainBundle], nil, @"");
}

+ (NSString *)resume {
    return NSLocalizedStringWithDefaultValue(@"Resume playing", nil, [NSBundle mainBundle], nil, @"");
}

+ (NSString *)play {
    return NSLocalizedStringWithDefaultValue(@"Play", nil, [NSBundle mainBundle], nil, @"");
}

+ (NSString *)saveRecording {
    return NSLocalizedStringWithDefaultValue(@"Save recording", nil, [NSBundle mainBundle], nil, @"Heading for audio recording save dialog");
}

+ (NSString *)save {
    return NSLocalizedStringWithDefaultValue(@"Save", nil, [NSBundle mainBundle], nil, @"Confirm button text for audio recoding save dialog");
}

+ (NSString *)nameForRecording {
    return NSLocalizedStringWithDefaultValue(@"Name for recording", nil, [NSBundle mainBundle], nil, @"Placeholder for audio recording name text field");
}
@end
