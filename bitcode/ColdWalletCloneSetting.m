//
//  CloneQrCodeSetting.m
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


#import "ColdWalletCloneSetting.h"
#import "BTQRCodeUtil.h"
#import "KeyUtil.h"
#import "CloneQrCodeSetting.h"
#import "BTAddressManager.h"
#import "BTWordsTypeManager.h"


static Setting *CloneScanSetting;
static Setting *CloneQrSetting;

@implementation ColdWalletCloneSetting

- (instancetype)init {
    self = [super initWithName:NSLocalizedString(@"Cold Wallet Clone", nil) icon:[UIImage imageNamed:@"scan_button_icon"]];
    if (self) {
        __weak ColdWalletCloneSetting *d = self;
        ;
    }
    return self;
}

- (void)handleResult:(NSString *)result byReader:(id )reader {}

- (void)onPasswordEntered:(NSString *)password {}

- (BOOL)notToCheckPassword {
    return YES;
}

- (NSString *)passwordTitle {
    return NSLocalizedString(@"Enter source password", nil);
}

- (void)showMsg:(NSString *)msg {
    if ([self.controller respondsToSelector:@selector(showMsg:)]) {
        [self.controller performSelector:@selector(showMsg:) withObject:msg];
    }
}

+ (Setting *)getCloneSetting {
    if ([BTAddressManager instance].privKeyAddresses.count > 0 || [[BTAddressManager instance] hasHDMKeychain] || [BTAddressManager instance].hasHDAccountCold) {
        if (!CloneQrSetting) {
            CloneQrSetting = [[CloneQrCodeSetting alloc] init];
        }
        return CloneQrSetting;
    } else {
        if (!CloneScanSetting) {
            CloneScanSetting = [[ColdWalletCloneSetting alloc] init];
        }
        return CloneScanSetting;
    }
}

@end
