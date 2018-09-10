//
//  HDMHotAddUtil.m
//  bither-ios
//
//  Created by 宋辰文 on 15/2/2.
//  Copyright (c) 2015年 宋辰文. All rights reserved.
//

#import "HDMHotAddUtil.h"
#import "PasswordGetter.h"
#import "UEntropyViewController.h"
#import "BTHDMKeychain.h"
#import "BTAddressManager.h"
#import "BTUtils.h"
#import "BitherSetting.h"
#import "BTHDMBid.h"
#import "NSError+HDMHttpErrorMessage.h"
#import "PeerUtil.h"
#import "BTHDMBid+Api.h"


#define kSaveProgress (0.1)
#define kStartProgress (0.01)
#define kProgressKeyRate (0.5)
#define kProgressEncryptRate (0.5)
#define kMinGeneratingTime (2.4)

@interface HDMHotAddUtil () <PasswordGetterDelegate, UEntropyViewControllerDelegate> {
    PasswordGetter *_passwordGetter;
    NSData *coldRoot;
    BTHDMBid *hdmBid;
    BOOL hdmKeychainLimit;
    SEL afterQRScanSelector;
    BOOL serverPressed;
    __weak UIWindow *_window;
    HDMSingular *singular;
}
@property(weak) UIViewController <HDMHotAddUtilDelegate> *controller;
@property(readonly, weak) UIWindow *window;
@property(readonly) PasswordGetter *passwordGetter;
@end

@implementation HDMHotAddUtil
- (instancetype)initWithViewContoller:(UIViewController <HDMHotAddUtilDelegate> *)controller {
    self = [super init];
    if (self) {
        self.controller = controller;
        [self firstConfigure];
    }
    return self;
}

- (void)firstConfigure {
    singular = [[HDMSingular alloc] initWithController:self.controller andDelegate:self];
    serverPressed = NO;
    hdmBid = nil;
    [self refreshHDMLimit];
    [self findCurrentStep];
}

- (void)refreshHDMLimit {
    hdmKeychainLimit = [BTAddressManager instance].hasHDMKeychain;
}

- (void)hot {
    if (hdmKeychainLimit) {
        return;
    }
    if (singular.isInSingularMode) {
        return;
    }
    ;
}

// MARK: hot xrandom
- (void)hotWithXRandom {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.passwordGetter.delegate = nil;
        NSString *password = self.passwordGetter.password;
        self.passwordGetter.delegate = self;
        if (!password) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (singular.shouldGoSingularMode) {
                [singular setPassword:password];
                [singular hot:YES];
            } else {
                [singular runningWithoutSingularMode];
                UEntropyViewController *uentropy = [[UEntropyViewController alloc] initWithPassword:password andDelegate:self];
                [self.controller presentViewController:uentropy animated:YES completion:nil];
            }
        });
    });
}

- (void)onUEntropyGeneratingWithController:(UEntropyViewController *)controller collector:(UEntropyCollector *)collector andPassword:(NSString *)password {
    float progress = kStartProgress;
    float itemProgress = 1.0 - kStartProgress - kSaveProgress;
    NSTimeInterval startGeneratingTime = [[NSDate date] timeIntervalSince1970];
    [collector onResume];
    [collector start];
    [controller onProgress:progress];
    XRandom *xrandom = [[XRandom alloc] initWithDelegate:collector];
    if (controller.testShouldCancel) {
        return;
    }
    BTHDMKeychain *keychain = nil;
    while (!keychain) {
        @try {
            NSData *seed = [xrandom randomWithSize:32];
            keychain = [[BTHDMKeychain alloc] initWithMnemonicSeed:seed password:password andXRandom:YES];
        }
        @catch (NSException *exception) {
            NSLog(@"generate HDM keychain error %@", exception.debugDescription);
        }
    }
    progress += itemProgress * kProgressKeyRate;
    [controller onProgress:progress];
    [BTAddressManager instance].hdmKeychain = keychain;
    progress += itemProgress * kProgressEncryptRate;
    [controller onProgress:progress];
    [collector stop];
    while ([[NSDate new] timeIntervalSince1970] - startGeneratingTime < kMinGeneratingTime) {

    }
    [controller onSuccess];
}

- (void)successFinish:(UEntropyViewController *)controller {
    __weak __block HDMHotAddUtil *s = self;
    [controller dismissViewControllerAnimated:YES completion:^{
        [s.controller moveToCold:YES andCompletion:nil];
    }];
}

- (void)getPermisionFor:(NSString *)mediaType completion:(void (^)(BOOL))completion {}

- (void)getPermissions:(void (^)(void))completion {
    __weak __block HDMHotAddUtil *s = self;
}

- (void)cold {
    if (hdmKeychainLimit) {
        return;
    }
    if (singular.isInSingularMode) {
        return;
    }
    ;
}

- (void)coldScanned:(NSString *)result {
    coldRoot = [result hexToData];
    if (!coldRoot) {
        [self showMsg:NSLocalizedString(@"hdm_keychain_add_scan_cold", nil)];
        return;
    }
    NSUInteger count = HDM_ADDRESS_PER_SEED_PREPARE_COUNT - [BTAddressManager instance].hdmKeychain.uncompletedAddressCount;
  
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if (count > 0) {
            NSString *password = self.passwordGetter.password;
            if (!password) {
                
                return;
            }
            [[BTAddressManager instance].hdmKeychain prepareAddressesWithCount:(UInt32) count password:password andColdExternalPub:[NSData dataWithBytes:coldRoot.bytes length:coldRoot.length]];
        }
        [self initHDMBidFromColdRoot];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
}

- (void)initHDMBidFromColdRoot {
    if (hdmBid) {
        return;
    }
    BTBIP32Key *root = [[BTBIP32Key alloc] initWithMasterPubKey:[NSData dataWithBytes:coldRoot.bytes length:coldRoot.length]];
    BTBIP32Key *key = [root deriveSoftened:0];
    NSString *address = key.key.address;
    [root wipe];
    [key wipe];
    hdmBid = [[BTHDMBid alloc] initWithHDMBid:address];
}

- (void)server {
    if (hdmKeychainLimit) {
        return;
    }
    if (singular.isInSingularMode) {
        return;
    }
    if (!coldRoot && !hdmBid) {
        serverPressed = YES;
        [self cold];
        return;
    }
    serverPressed = NO;
    
}

- (void)serverScanned:(NSString *)result {
    if (!hdmBid) {
        return;
    }
    
}

- (void)handleResult:(NSString *)result byReader:(id)reader {
    if ([BTUtils isEmpty:result]) {
        return;
    }
   
}

- (void)findCurrentStep {
    [self.controller moveToHot:NO andCompletion:nil];
    if ([BTAddressManager instance].hdmKeychain) {
        [self.controller moveToCold:NO andCompletion:nil];
        if ([BTAddressManager instance].hdmKeychain.uncompletedAddressCount > 0) {
            [self.controller moveToServer:NO andCompletion:nil];
            if (hdmKeychainLimit) {
                [self.controller moveToFinal:NO andCompletion:nil];
            }
        } else if (hdmKeychainLimit) {
            [self.controller moveToServer:NO andCompletion:nil];
            [self.controller moveToFinal:NO andCompletion:nil];
        }
    }
}

- (void)showMsg:(NSString *)msg {
    if (self.controller && [self.controller respondsToSelector:@selector(showMsg:)]) {
        [self.controller performSelector:@selector(showMsg:) withObject:msg];
    }
}

- (void)beforePasswordDialogShow {
 
}

- (void)afterPasswordDialogDismiss {}

- (BOOL)isHDMKeychainLimited {
    return hdmKeychainLimit;
}

- (UIWindow *)window {
    if (!_window) {
        _window = self.controller.view.window;
    }
    return _window;
}

- (PasswordGetter *)passwordGetter {
    if (!_passwordGetter) {
        _passwordGetter = [[PasswordGetter alloc] initWithWindow:self.window andDelegate:self];
    }
    return _passwordGetter;
}

- (void)setSingularModeAvailable:(BOOL)available {
    [self.controller setSingularModeAvailable:available];
}

- (void)onSingularModeBegin {
    [self.controller onSingularModeBegin];
}

- (BOOL)shouldGoSingularMode {
    return [self.controller shouldGoSingularMode];
}

- (void)singularHotFinish {
    [self.controller moveToCold:YES andCompletion:^{
        [singular cold];
    }];
}

- (void)singularColdFinish {
    [self.controller moveToServer:YES andCompletion:^{
        [singular server];
    }];
}

- (void)singularServerFinishWithWords:(NSArray *)words andColdQr:(NSString *)qr {
    [self.controller moveToFinal:YES andCompletion:^{
        [self.controller singularServerFinishWithWords:words andColdQr:qr];
    }];
}

- (void)singularShowNetworkFailure {
    [self.controller singularShowNetworkFailure];
}

- (BOOL)canCancel {
    if (singular) {
        return !singular.isInSingularMode;
    }
    return YES;
}


@end
