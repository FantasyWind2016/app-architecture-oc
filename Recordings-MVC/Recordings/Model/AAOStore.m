//
//  AAOStore.m
//  Recordings
//
//  Created by 季风 on 2018/9/24.
//  Copyright © 2018年 fantasywind. All rights reserved.
//

#import "AAOStore.h"
#import "AAOFolder.h"
#import "AAORecording.h"

static NSString * storeLocation = @"store.json";

@interface AAOStore()
@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) NSURL *placeholder;
@end

@implementation AAOStore

#pragma mark - class method

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static AAOStore *_store = nil;
    dispatch_once(&onceToken, ^{
        _store = [[AAOStore alloc] initWithURL:[self documentDirectory]];
    });
    return _store;
}

+ (NSURL *)documentDirectory {
    NSError *error;
    return [[NSFileManager defaultManager] URLForDirectory:NSLibraryDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
}

#pragma mark - public

- (NSURL *)fileURLForRecording:(AAORecording *)recording {
    NSURL *url = [self.baseURL URLByAppendingPathComponent:recording.uuid.UUIDString];
    return url ? url : self.placeholder;
}

- (void)saveWithNotifying:(AAOItem *)notifying userInfo:(NSDictionary *)userInfo {
    [self save];
    [[NSNotificationCenter defaultCenter] postNotificationName:AAOStoreChangeNotification object:notifying userInfo:userInfo];
}

- (AAOItem *)itemAtUUIDPath:(NSArray<NSUUID *> *)path {
    return [self.rootFolder itemAtUUIDPath:path];
}

- (void)removeFileForRecording:(AAORecording *)recording {
    NSURL *url = [self fileURLForRecording:recording];
    if (url && ![url isEqual:self.placeholder]) {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtURL:url error:&error];
    }
}

- (instancetype)initWithURL:(NSURL *)url {
    if (self=[super init]) {
        _baseURL = url;
        [self initData];
    }
    return self;
}

#pragma mark - private

- (void)initData {
    _placeholder = nil;
    if (![self initFolder]) {
        _rootFolder = [AAOFolder new];
    }
    self.rootFolder.store = self;
}

- (BOOL)initFolder {
    if (!self.baseURL) {
        return NO;
    }
    NSData *data = [NSData dataWithContentsOfURL:[self.baseURL URLByAppendingPathComponent:storeLocation]];
    if (!data) {
        return NO;
    }
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error || !dict) {
        return NO;
    }
    _rootFolder = [[AAOFolder alloc] initWithDictionary:dict];
    
    return YES;
}

- (BOOL)save {
    if (!self.baseURL) {
        return NO;
    }
    NSDictionary *dict = [self.rootFolder encodeToDictionay];
    if (!dict) {
        return NO;
    }
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    [data writeToURL:[self.baseURL URLByAppendingPathComponent:storeLocation] atomically:YES];
    if (error) {
        return NO;
    }
    return YES;
}

@end
