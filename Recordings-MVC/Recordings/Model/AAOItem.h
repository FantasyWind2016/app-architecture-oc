//
//  AAOItem.h
//  Recordings
//
//  Created by 季风 on 2018/9/24.
//  Copyright © 2018年 fantasywind. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const AAONotifyKeyChangeReason = @"reason";
static NSString * const AAONotifyKeyNewValue = @"newValue";
static NSString * const AAONotifyKeyOldValue = @"oldValue";
static NSString * const AAONotifyKeyParentFolder = @"parentFolder";
static NSString * const AAONotifyChangeReasonRenamed = @"renamed";
static NSString * const AAONotifyChangeReasonAdded = @"added";
static NSString * const AAONotifyChangeReasonRemoved = @"removed";

static NSString *AAOFolderKeyName = @"name";
static NSString *AAOFolderKeyUUID = @"uuid";

static NSString *AAOFolderKeyContents = @"contents";
static NSString *AAOFolderKeyType = @"type";
static NSString *AAOFolderKeyTypeFolder = @"folder";
static NSString *AAOFolderKeyTypeRecording = @"recording";

@class AAOFolder;
@class AAOStore;
@interface AAOItem : NSObject
@property (nonatomic, strong) NSUUID *uuid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, weak) AAOStore *store;
@property (nonatomic, weak) AAOFolder *parent;
@property (nonatomic, strong, readonly) NSArray<NSUUID *> *uuidPath;

- (instancetype)initWithName:(NSString *)name uuid:(NSUUID *)uuid;
- (AAOItem *)itemAtUUIDPath:(NSArray<NSUUID *> *)path;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)encodeToDictionay;
- (void)deleted;
@end
