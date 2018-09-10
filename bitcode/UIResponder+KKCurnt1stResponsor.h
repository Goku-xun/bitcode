//
//  UIResponder+KKCurnt1stResponsor.h
//  KuarkPay
//
//  Created by toxicanty on 2018/7/3.
//  Copyright © 2018年 toxicanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (KKCurnt1stResponsor)

+ (id)currentFirstResponder;

- (void)findFirstResponder:(id)sender;

@end
