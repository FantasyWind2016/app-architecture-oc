//
//  AAOUtil.m
//  Recordings
//
//  Created by 季风 on 2018/9/24.
//  Copyright © 2018年 fantasywind. All rights reserved.
//

#import "AAOUtil.h"

@interface AAOUtil ()
@end

@implementation AAOUtil

+ (NSString *)timeString:(NSTimeInterval)time {
    return [[self formatter] stringFromTimeInterval:time];
}

+ (NSDateComponentsFormatter *)formatter {
    NSDateComponentsFormatter *_formatter = [NSDateComponentsFormatter new];
    _formatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
    _formatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
    _formatter.allowedUnits = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return _formatter;
}

@end

