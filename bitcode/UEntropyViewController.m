//
//  UEntropyViewController.m
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

#import "UEntropyViewController.h"
#import "UEntropyCamera.h"
#import "UEntropySensor.h"
#import "UEntropyAnimatedTransition.h"
#import "KeyUtil.h"
#import "PlaySoundUtil.h"

#define kMicViewHeight (100)

@interface UEntropyViewController () <UEntropyCollectorDelegate, UIViewControllerTransitioningDelegate> {
    NSString *password;
    BOOL isFinishing;

    void(^cancelBlock)(void);

    UIProgressView *pv;
    UIView *vOverlayTop;
    UIView *vOverlayBottom;
    UIImageView *ivOverlayTop;
    UIImageView *ivOverlayBottom;
}
@property UEntropyCollector *collector;
@property(weak) NSObject <UEntropyViewControllerDelegate> *delegate;
@end

@implementation UEntropyViewController

- (instancetype)initWithPassword:(NSString *)inPassword andDelegate:(NSObject <UEntropyViewControllerDelegate> *)delegate {
    self = [super init];
    if (self) {
        password = inPassword;
        self.transitioningDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *dimmer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    dimmer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    dimmer.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:dimmer];

    SensorVisualizerView *vSensor = [[SensorVisualizerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kSensorVisualizerViewItemSize - 10, self.view.frame.size.width, kSensorVisualizerViewItemSize)];
    vSensor.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    vSensor.showMic = false;
    [self.view addSubview:vSensor];

    self.collector = [[UEntropyCollector alloc] initWithDelegate:self];
    [self.collector addSource:[[UEntropyCamera alloc] initWithViewController:self.view andCollector:self.collector],
                              [[UEntropySensor alloc] initWithView:vSensor andCollecor:self.collector],
                    nil];
  
    [self configureOverlay];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.collector onPause];
    [self.collector stop];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startAnimation];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)startAnimation {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ivOverlayTop.hidden = NO;
        ivOverlayBottom.hidden = NO;
        [UIView animateWithDuration:0.6 animations:^{
            vOverlayTop.frame = CGRectMake(0, -vOverlayTop.frame.size.height, vOverlayTop.frame.size.width, vOverlayTop.frame.size.height);
            vOverlayBottom.frame = CGRectMake(0, self.view.frame.size.height, vOverlayBottom.frame.size.width, vOverlayBottom.frame.size.height);
        }                completion:nil];
        [PlaySoundUtil playSound:@"xrandom_open_sound" callback:^{
            [self startGenerate];
        }];
    });
}

- (void)stopAnimationWithCompletion:(void (^)())completion {
    [UIView animateWithDuration:0.4 animations:^{
        vOverlayTop.frame = CGRectMake(0, 0, vOverlayTop.frame.size.width, vOverlayTop.frame.size.height);
        vOverlayBottom.frame = CGRectMake(0, self.view.frame.size.height - vOverlayBottom.frame.size.height, vOverlayBottom.frame.size.width, vOverlayBottom.frame.size.height);
    }                completion:^(BOOL finished) {
        ivOverlayTop.hidden = YES;
        ivOverlayBottom.hidden = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), completion);
    }];
    [PlaySoundUtil playSound:@"xrandom_close_sound" callback:nil];
}

- (void)close:(id)sender {
    if (isFinishing) {
        return;
    }
    __block __weak UEntropyViewController *c = self;
    ;
}

- (void)onNoSourceAvailable {
    [self.collector onPause];
    NSLog(@"no source available");
}

- (void)onProgress:(float)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        [pv setProgress:progress animated:YES];
    });
}

- (void)onSuccess {
    [self.collector stop];
    [self.collector onPause];
    [self onProgress:1];
    dispatch_async(dispatch_get_main_queue(), ^{
        isFinishing = YES;
        __weak __block UEntropyViewController *c = self;
        void(^block)() = ^{
            [c stopAnimationWithCompletion:^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(successFinish:)]) {
                    [self.delegate successFinish:self];
                } else {
                    [c dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        };
       
    });
}

- (void)onFailed {}


- (BOOL)testShouldCancel {
    if (cancelBlock) {
        [self.collector stop];
        [self.collector onPause];
        dispatch_async(dispatch_get_main_queue(), cancelBlock);
        return YES;
    }
    return NO;
}

- (void)startGenerate {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(onUEntropyGeneratingWithController:collector:andPassword:)]) {
            [self.delegate onUEntropyGeneratingWithController:self collector:self.collector andPassword:password];
        } else {
            [self onFailed];
        }
    });
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)configureOverlay {}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[UEntropyAnimatedTransition alloc] initWithPresenting:YES];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if (dismissed == self) {
        return [[UEntropyAnimatedTransition alloc] initWithPresenting:NO];
    }
    return nil;
}

@end
