//
//  PinCodeUtil.m
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

#import "PinCodeUtil.h"
#import "UserDefaultsUtil.h"
#import "FXBlurView/FXBlurView.h"

#define kCausePinCodeBackgroundTime (60)

@interface PinCodeUtil ()
@property NSDate *backgroundDate;
@property (nonatomic, assign) BOOL isFirstBecomeActive;
@end

static PinCodeUtil *util;

@implementation PinCodeUtil

+ (PinCodeUtil *)instance {
    if (!util) {
        util = [[PinCodeUtil alloc] init];
    }
    return util;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isFirstBecomeActive = true;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignActive) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)becomeActive {}

- (void)resignActive {}

- (void)addBlur {}

- (void)removeBlur:(UIViewController *)vc {
    if (!vc) {
        return;
    }
    UIView *v = vc.view;
    NSUInteger subViewCount = v.subviews.count;
    NSMutableArray *viewsToRemove = [NSMutableArray new];
    for (NSInteger i = subViewCount - 1; i >= 0; i--) {
        UIView *subView = v.subviews[i];
        if ([subView isKindOfClass:[FXBlurView class]]) {
            [viewsToRemove addObject:subView];
        } else {
            break;
        }
    }
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
}

- (UIViewController *)rootVC {return nil;}

- (UIViewController *)topVC {
    UIViewController *vc = [self rootVC];
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
