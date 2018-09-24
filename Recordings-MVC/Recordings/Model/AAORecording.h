//
//  AAORecording.h
//  Recordings
//
//  Created by 季风 on 2018/9/24.
//  Copyright © 2018年 fantasywind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAOItem.h"

@interface AAORecording : AAOItem
@property (nonatomic, strong, readonly) NSURL *fileURL;
@end
