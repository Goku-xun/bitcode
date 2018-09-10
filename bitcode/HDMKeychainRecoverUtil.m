//  HDMKeychainRecoverUtil.m
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

#import "HDMKeychainRecoverUtil.h"
#import "BTAddressManager.h"
#import "BTHDMBid+Api.h"
#import "BTUtils.h"
#import "PasswordGetter.h"
#import "NSError+HDMHttpErrorMessage.h"
#import "PeerUtil.h"
#import "BTHDMKeychainRecover.h"
#import "KeyUtil.h"

@interface HDMKeychainRecoverUtil () <PasswordGetterDelegate> {
    PasswordGetter *_passwordGetter;
    SEL afterQRScanSelector;
    NSData *coldRoot;
    BTHDMBid *hdmBid;
    NSString *hdmBidSignature;

}

@property(weak) UIViewController *controller;


@end

@implementation HDMKeychainRecoverUtil {

}

- (instancetype)initWithViewContoller:(UIViewController *)controller {
    self = [super init];
    if (self) {
        self.controller = controller;
        [self firstConfigure];
    }
    return self;
}

- (void)firstConfigure {
    hdmBid = nil;

}

- (BOOL)canRecover {
    return [[BTAddressManager instance] hdmKeychain] == nil;
}

- (void)revovery {
    [self getColdRoot];
}

- (void)getColdRoot {
    if (coldRoot == nil) {
        ;

    }
}


- (void)coldScanned:(NSString *)result {
    coldRoot = [result hexToData];
    if (!coldRoot) {
        [self showMsg:NSLocalizedString(@"hdm_keychain_add_scan_cold", nil)];
        return;
    }

  
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *password = self.passwordGetter.password;
        if (!password) {
            dispatch_async(dispatch_get_main_queue(), ^{
            });
            return;
        }
        [self initHDMBidFromColdRoot];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self server];
        });
    });
}


- (void)server {
    if (!coldRoot && !hdmBid) {
        //serverPressed = YES;
        [self getColdRoot];
        return;
    }
    //  serverPressed = NO;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self initHDMBidFromColdRoot];
        NSError *error;
        NSString *preSign = [hdmBid getPreSignHashAndError:&error];
        if (error && !preSign) {
            dispatch_async(dispatch_get_main_queue(), ^{
            

            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                ;
            });
        }
    });
}


- (void)serverScanned:(NSString *)result {
    if (!hdmBid) {
        return;
    }
    __block NSString *blockResult = [[result hexToData] base64EncodedStringWithOptions:0];
    ;
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


- (void)handleResult:(NSString *)result byReader:(id )reader {}

- (void)showMsg:(NSString *)msg {
    if (self.controller && [self.controller respondsToSelector:@selector(showMsg:)]) {
        [self.controller performSelector:@selector(showMsg:) withObject:msg];
    }
}


- (PasswordGetter *)passwordGetter {
    if (!_passwordGetter) {
        _passwordGetter = [[PasswordGetter alloc] initWithWindow:self.controller.view.window andDelegate:self];
    }
    return _passwordGetter;
}


- (void)beforePasswordDialogShow {}

- (void)afterPasswordDialogDismiss {}

@end
