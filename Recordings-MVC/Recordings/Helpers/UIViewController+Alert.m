//
//  UIViewController+Alert.m
//  Recordings
//
//  Created by 季风 on 2018/10/7.
//  Copyright © 2018年 fantasywind. All rights reserved.
//

#import "UIViewController+Alert.h"
#import "NSString+Alert.h"

@implementation UIViewController (Alert)

- (void)modalTextAlertWithTitle:(NSString *)title accept:(NSString *)accept cancel:(NSString *)cancel placeholder:(NSString *)placeholder callback:(CallBackBlock)callback {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [vc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder;
    }];
    if (!cancel || cancel.length==0) {
        cancel = [NSString cancel];
    }
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        callback(nil);
    }];
    [vc addAction:okAction];
    if (!accept || accept.length==0) {
        accept = [NSString ok];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:accept style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        callback(vc.textFields.firstObject.text);
    }];
    [vc addAction:cancelAction];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
