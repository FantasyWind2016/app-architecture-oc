//
//  UIViewController+Alert.h
//  Recordings
//
//  Created by 季风 on 2018/10/7.
//  Copyright © 2018年 fantasywind. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CallBackBlock)(NSString *string);
@interface UIViewController (Alert)
- (void)modalTextAlertWithTitle:(NSString *)title accept:(NSString *)accept cancel:(NSString *)cancel placeholder:(NSString *)placeholder callback:(CallBackBlock)callback;
@end
