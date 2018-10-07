//
//  AAOFolder.h
//  Recordings
//
//  Created by 季风 on 2018/9/24.
//  Copyright © 2018年 fantasywind. All rights reserved.
//

#import "AAOItem.h"

@class AAOStore;
@class AAOItem;
@interface AAOFolder : AAOItem
@property (nonatomic, strong) NSMutableArray<AAOItem *> *contents;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)encodeToDictionay;
- (NSArray *)resortWithChangeItem:(AAOItem *)item;
- (void)addItem:(AAOItem *)item;
- (void)removeItem:(AAOItem *)item;
@end
