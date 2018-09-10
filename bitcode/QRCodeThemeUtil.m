//
//  QrUtil.m
//  bither-ios
//
//  Copyright 2014 http://Bither.net
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "QRCodeThemeUtil.h"
#import "UIImage+ImageWithColor.h"
@import UIKit;

@implementation QRCodeThemeUtil

+ (UIImage *)qrCodeOfContent:(NSString *)content andSize:(CGFloat)size margin:(CGFloat)margin withTheme:(QRCodeTheme *)theme {
    if (content == nil) return nil;        
    
    CGFloat marginRatio = margin / size;
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:[content dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *outputImage = [filter outputImage];
    if (theme.fg != [UIColor blackColor] || theme.fg != [UIColor whiteColor]) {
        CIFilter *maskToAlpha = [CIFilter filterWithName:@"CIMaskToAlpha" keysAndValues:@"inputImage", outputImage, nil];
        outputImage = maskToAlpha.outputImage;
        CGSize outSize = CGSizeApplyAffineTransform(outputImage.extent.size, CGAffineTransformMakeScale(1.0f / [UIScreen mainScreen].scale, 1.0f / [UIScreen mainScreen].scale));
        CIImage *bg = [CIImage imageWithCGImage:[UIImage imageWithColor:theme.bg size:outSize].CGImage];
        CIImage *fg = [CIImage imageWithCGImage:[UIImage imageWithColor:theme.fg size:outSize].CGImage];
        CIFilter *alphaBlendFilter = [CIFilter filterWithName:@"CIBlendWithAlphaMask" keysAndValues:@"inputImage", bg, @"inputBackgroundImage", fg, @"inputMaskImage", outputImage, nil];
        outputImage = alphaBlendFilter.outputImage;
    }

    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];

    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:1
                                   orientation:UIImageOrientationUp];
    CFRelease(cgImage);
    size = fmaxf(size * 2, image.size.width * 10);
    UIGraphicsBeginImageContext(CGSizeMake(size + size * marginRatio * 2, size + size * marginRatio * 2));
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(cgContext, kCGInterpolationNone);
    [[UIImage imageWithColor:theme.bg] drawInRect:CGRectMake(0, 0, size + size * marginRatio * 2, size + size * marginRatio * 2)];
    [image drawInRect:CGRectMake(size * marginRatio, size * marginRatio, size, size)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)qrCodeOfContent:(NSString *)content andSize:(CGFloat)size withTheme:(QRCodeTheme *)theme {
    return [QRCodeThemeUtil qrCodeOfContent:content andSize:size margin:0 withTheme:theme];
}
@end

static NSMutableArray *themes;

@implementation QRCodeTheme

- (instancetype)initWithFg:(UIColor *)fg bg:(UIColor *)bg {
    self = [super init];
    if (self) {
        self.fg = fg;
        self.bg = bg;
    }
    return self;
}

+ (void)firstInitArray {
    if (themes == nil || themes.count == 0) {
        themes = [[NSMutableArray alloc] init];
    }
}

+ (QRCodeTheme *)yellow {
    [QRCodeTheme firstInitArray];
    return [themes objectAtIndex:0];
}

+ (QRCodeTheme *)green {
    [QRCodeTheme firstInitArray];
    return [themes objectAtIndex:1];
}

+ (QRCodeTheme *)blue {
    [QRCodeTheme firstInitArray];
    return [themes objectAtIndex:2];
}

+ (QRCodeTheme *)red {
    [QRCodeTheme firstInitArray];
    return [themes objectAtIndex:3];
}

+ (QRCodeTheme *)purple {
    [QRCodeTheme firstInitArray];
    return [themes objectAtIndex:4];
}

+ (QRCodeTheme *)black {
    [QRCodeTheme firstInitArray];
    return [themes objectAtIndex:5];
}

+ (NSArray *)themes {
    [QRCodeTheme firstInitArray];
    return themes;
}

+ (NSInteger)indexOfTheme:(QRCodeTheme *)theme {
    [QRCodeTheme firstInitArray];
    return [themes indexOfObject:theme];
}

@end
