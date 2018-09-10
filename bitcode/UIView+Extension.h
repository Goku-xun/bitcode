//
//  UIView+Extension.h
//  bither-ios
//
//  Created by 韩珍 on 2016/10/26.
//  Copyright © 2016年 Bither. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

- (void)cornerRadius:(CGFloat)radius;

- (void)cornerRadius:(CGFloat)radius borderColor:(UIColor*)borderColor borderWidth:(CGFloat)borderWidth;

/*
 *绘制边框虚线
 */
- (void)DashPattern:(NSArray<NSNumber *>*)pattern radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
@end
