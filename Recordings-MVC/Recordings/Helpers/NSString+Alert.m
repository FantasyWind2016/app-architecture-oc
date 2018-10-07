//
//  NSString+Alert.m
//  Recordings
//
//  Created by 季风 on 2018/10/7.
//  Copyright © 2018年 fantasywind. All rights reserved.
//

#import "NSString+Alert.h"

@implementation NSString (Alert)

+ (NSString *)ok {
    return NSLocalizedStringWithDefaultValue(@"OK", nil, [NSBundle mainBundle], nil, nil);
}

+ (NSString *)cancel {
    return NSLocalizedStringWithDefaultValue(@"Cancel", nil, [NSBundle mainBundle], nil, @"");
}

@end
