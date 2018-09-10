//
//  UIView+Extension.m
//  bither-ios
//
//  Created by 韩珍 on 2016/10/26.
//  Copyright © 2016年 Bither. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)cornerRadius:(CGFloat)radius
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius  = radius;
}

- (void)cornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius  = radius;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}


- (void)DashPattern:(NSArray<NSNumber *>*)pattern radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    //    self.constraints
    CGFloat width = self.bounds.size.width * scaleTo375;
    CGFloat height = width * (430.0 / 688);//(430.0 / 688)宽高比
    
    CGRect bounds = self.bounds;
    bounds.size.width = width;
    bounds.size.height = height;
    self.bounds = bounds;
    
    borderLayer.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    //    borderLayer.path = [UIBezierPath bezierPathWithRect:borderLayer.bounds].CGPath;
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:radius].CGPath;
    //    borderLayer.lineWidth = 1. / [[UIScreen mainScreen] scale];
    borderLayer.lineWidth = borderWidth;
    //虚线边框
    borderLayer.lineDashPattern = pattern;
    //实线边框
    //    borderLayer.lineDashPattern = nil;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = borderColor.CGColor;
    [self.layer addSublayer:borderLayer];
    
}
@end
