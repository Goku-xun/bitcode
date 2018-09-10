//
//  PasswordGetter.m
//  bither-ios
//
//  Created by 宋辰文 on 15/2/2.
//  Copyright (c) 2015年 宋辰文. All rights reserved.
//

#import "PasswordGetter.h"

@interface PasswordGetter (){
    NSString *password;
    NSCondition *condition;
}
@end

@implementation PasswordGetter

- (instancetype)initWithWindow:(UIWindow *)window {
    self = [super init];
    if (self) {
        self.window = window;
        condition = [NSCondition new];
    }
    return self;
}

- (instancetype)initWithWindow:(UIWindow *)window andDelegate:(NSObject <PasswordGetterDelegate> *)delegate {
    self = [super init];
    if (self) {
        self.window = window;
        self.delegate = delegate;
        condition = [NSCondition new];
    }
    return self;
}

- (NSString *)password {
    if (!password) {}
    return password;
}

- (void)setPassword:(NSString *)p {
    password = p;
}

- (BOOL)hasPassword {
    return password != nil;
}

- (void)onPasswordEntered:(NSString *)p {
    password = p;
    [self signalReturn];
}

- (void)signalReturn {
    [condition lock];
    [condition signal];
    [condition unlock];
    if (self.delegate && [self.delegate respondsToSelector:@selector(afterPasswordDialogDismiss)]) {
        [self.delegate afterPasswordDialogDismiss];
    }
}

- (void)dialogPasswordCanceled {
    password = nil;
    [self signalReturn];
}

@end
