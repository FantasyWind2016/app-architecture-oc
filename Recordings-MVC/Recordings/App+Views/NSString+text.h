//
//  NSString+text.h
//  Recordings
//
//  Created by 季风 on 2018/10/7.
//  Copyright © 2018年 fantasywind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (text)
+ (NSString *)uuidPathKey;
+ (NSString *)showFolder;
+ (NSString *)showRecorder;
+ (NSString *)showPlayer;
+ (NSString *)createFolder;
+ (NSString *)recordings;
+ (NSString *)create;
+ (NSString *)folderName;

+ (NSString *)pause;
+ (NSString *)resume;
+ (NSString *)play;

+ (NSString *)saveRecording;
+ (NSString *)save;
+ (NSString *)nameForRecording;
@end
