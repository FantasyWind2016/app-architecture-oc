//
//  AAOStore.h
//  Recordings
//
//  Created by 季风 on 2018/9/24.
//  Copyright © 2018年 fantasywind. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const AAOStoreChangeNotification = @"StoreChanged";

@class AAORecording;
@class AAOItem;
@class AAOFolder;
@interface AAOStore : NSObject
@property (nonatomic, strong) AAOFolder *rootFolder;
+ (instancetype)shared;

- (NSURL *)fileURLForRecording:(AAORecording *)recording;
- (void)saveWithNotifying:(AAOItem *)item userInfo:(NSDictionary *)userInfo;
- (AAOItem *)itemAtUUIDPath:(NSArray<NSUUID *> *)path;
- (void)removeFileForRecording:(AAORecording *)recording;
@end
