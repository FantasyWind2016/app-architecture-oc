//
//  AAOFolder.m
//  Recordings
//
//  Created by 季风 on 2018/9/24.
//  Copyright © 2018年 fantasywind. All rights reserved.
//

#import "AAOFolder.h"
#import "AAORecording.h"
#import "AAOStore.h"

@implementation AAOFolder

- (instancetype)init {
    if (self=[self initWithName:nil uuid:nil]) {
        
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name uuid:(NSString *)uuid {
    if (self=[super initWithName:name uuid:uuid]) {
        _contents = [@[] mutableCopy];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [self initWithName:dict[AAOFolderKeyName] uuid:dict[AAOFolderKeyUUID]];
    
    NSMutableArray *tempArray = [@[] mutableCopy];
    NSArray *array = dict[AAOFolderKeyContents];
    for (NSDictionary *data in array) {
        AAOItem *item;
        if ([data[AAOFolderKeyType] isEqualToString:AAOFolderKeyTypeFolder]) {
            item = [[AAOFolder alloc] initWithDictionary:data];
        } else if ([data[AAOFolderKeyType] isEqualToString:AAOFolderKeyTypeRecording]) {
            item = [[AAORecording alloc] initWithDictionary:data];
        }
        [tempArray addObject:item];
    }
    [tempArray enumerateObjectsUsingBlock:^(AAOItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.parent = self;
    }];
    _contents = tempArray;
    return self;
}

- (NSDictionary *)encodeToDictionay {
    NSMutableDictionary *dict = [@{} mutableCopy];
    [dict setValue:AAOFolderKeyTypeFolder forKey:AAOFolderKeyType];
    [dict setValue:self.name forKey:AAOFolderKeyName];
    [dict setValue:self.uuid.UUIDString forKey:AAOFolderKeyUUID];
    NSMutableArray *tempArray = [@[] mutableCopy];
    [self.contents enumerateObjectsUsingBlock:^(AAOItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempArray addObject:[obj encodeToDictionay]];
    }];
    [dict setValue:tempArray forKey:AAOFolderKeyContents];
    return [dict copy];
}

- (void)deleted {
    __weak typeof(self) weakSelf = self;
    [self.contents enumerateObjectsUsingBlock:^(AAOItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __weak typeof(self) strongSelf = weakSelf;
        [strongSelf.contents removeObject:obj];
    }];
    [super deleted];
}

- (void)addItem:(AAOItem *)item {
    assert(item!=nil);
    if ([self.contents indexOfObject:item]!=NSNotFound) {
        return;
    }
    [self.contents addObject:item];
    [self.contents sortedArrayUsingComparator:^NSComparisonResult(AAOItem *  _Nonnull obj1, AAOItem *  _Nonnull obj2) {
        return obj1.name < obj2.name;
    }];
    item.parent = self;
    NSInteger index = [self.contents indexOfObject:item];
    
    [self.store saveWithNotifying:item userInfo:@{AAONotifyKeyChangeReason: AAONotifyChangeReasonAdded, AAONotifyKeyNewValue: @(index), AAONotifyKeyParentFolder: self}];
}

- (NSArray *)resortWithChangeItem:(AAOItem *)item {
    NSUInteger oldIndex = [self.contents indexOfObject:item];
    [self.contents sortedArrayUsingComparator:^NSComparisonResult(AAOItem *  _Nonnull obj1, AAOItem *  _Nonnull obj2) {
        return obj1.name < obj2.name;
    }];
    NSUInteger newIndex = [self.contents indexOfObject:item];
    return @[@(oldIndex), @(newIndex)];
}

- (void)removeItem:(AAOItem *)item {
    if ([self.contents indexOfObject:item]==NSNotFound) {
        return;
    }
    NSUInteger oldIndex = [self.contents indexOfObject:item];
    [item deleted];
    [self.contents removeObject:item];
    
    [self.store saveWithNotifying:item userInfo:@{AAONotifyKeyChangeReason: AAONotifyChangeReasonRemoved, AAONotifyKeyOldValue: @(oldIndex), AAONotifyKeyParentFolder: self}];
}

- (AAOItem *)itemAtUUIDPath:(NSArray<NSUUID *> *)path {
    if (path.count<=1) {
        return [super itemAtUUIDPath:path];
    }
    if (![path.firstObject isEqual:self.uuid]) {
        return nil;
    }
    NSArray *sub = [path subarrayWithRange:NSMakeRange(1, path.count-1)];
    if (sub.firstObject == nil) {
        return nil;
    }
    __block AAOItem *item;
    [self.contents enumerateObjectsUsingBlock:^(AAOItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.uuid isEqual:sub.firstObject]) {
            item = obj;
            *stop = YES;
        }
    }];
    return [item itemAtUUIDPath:sub];
}

#pragma mark - setter
- (void)setStore:(AAOStore *)store {
    [super setStore:store];
    [self.contents enumerateObjectsUsingBlock:^(AAOItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.store = store;
    }];
}

@end
