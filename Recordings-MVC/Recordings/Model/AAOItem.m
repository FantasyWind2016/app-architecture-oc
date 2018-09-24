//
//  AAOItem.m
//  Recordings
//
//  Created by 季风 on 2018/9/24.
//  Copyright © 2018年 fantasywind. All rights reserved.
//

#import "AAOItem.h"
#import "AAOFolder.h"
#import "AAOStore.h"

@implementation AAOItem

#pragma mark - public
- (instancetype)initWithName:(NSString *)name uuid:(NSUUID *)uuid {
    if (self=[super init]) {
        _name = name;
        _uuid = uuid;
        _store = nil;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [self initWithName:dict[AAOFolderKeyName] uuid:dict[AAOFolderKeyUUID]];
    return self;
}

- (NSDictionary *)encodeToDictionay {
    NSMutableDictionary *dict = [@{} mutableCopy];
    [dict setValue:self.name forKey:AAOFolderKeyName];
    [dict setValue:self.uuid forKey:AAOFolderKeyUUID];
    return [dict copy];
}

- (void)deleted {
    self.parent = nil;
}

- (AAOItem *)itemAtUUIDPath:(NSArray<NSUUID *> *)path {
    if (path.count == 0) {
        return nil;
    }
    if ([path.firstObject isEqual:self.uuid]) {
        return self;
    }
    return nil;
}

#pragma mark - getter

- (NSArray<NSUUID *> *)uuidPath {
    NSMutableArray *path = [[self.parent uuidPath] mutableCopy];
    [path addObject:self.uuid];
    return path;
}

#pragma mark - setter
- (void)setParent:(AAOFolder *)parent {
    _parent = parent;
    self.store = parent.store;
}

- (void)setName:(NSString *)name {
    _name = name;
    if (!self.parent) {
        return;
    }
    NSArray *array = [self.parent resortWithChangeItem:self];
    [self.store saveWithNotifying:self userInfo:@{AAONotifyKeyChangeReason: AAONotifyChangeReasonRenamed, AAONotifyKeyOldValue: array[0], AAONotifyKeyNewValue: array[1], AAONotifyKeyParentFolder: self.parent}];
}

@end
