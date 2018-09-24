//
//  AAOPlayer.h
//  Recordings
//
//  Created by 季风 on 2018/9/24.
//  Copyright © 2018年 fantasywind. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^AAOPlayerUpdateBlock)(NSTimeInterval);

@interface AAOPlayer : NSObject
- (instancetype)initWithURL:(NSURL *)url updateBlock:(AAOPlayerUpdateBlock)updateBlock;
@end
