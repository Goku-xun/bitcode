//
//  UIResponder+KKCurnt1stResponsor.m
//  KuarkPay
//
//  Created by toxicanty on 2018/7/3.
//  Copyright © 2018年 toxicanty. All rights reserved.
//

#import "UIResponder+KKCurnt1stResponsor.h"

static __weak id _currentFirstResponder;

@implementation UIResponder (KKCurnt1stResponsor)

+ (id)currentFirstResponder {
    _currentFirstResponder = nil;
    // 通过将target设置为nil，让系统自动遍历响应链
    // 从而响应链当前第一响应者响应我们自定义的方法
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
    return _currentFirstResponder;
}
- (void)findFirstResponder:(id)sender {
    // 第一响应者会响应这个方法，并且将静态变量wty_currentFirstResponder设置为自己
    _currentFirstResponder = self;
}

@end
