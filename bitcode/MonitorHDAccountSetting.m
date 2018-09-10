//
//  MonitorHDAccountSetting.m
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
//
//  Created by songchenwen on 15/7/16.
//

#import "BTAddressManager.h"
#import "MonitorHDAccountSetting.h"

#import "StringUtil.h"
#import "BTQRCodeUtil.h"
#import "PeerUtil.h"
#import "AppDelegate.h"
#import "BTQRCodeUtil.h"
#import "BTHDAccount.h"

@interface MonitorHDAccountSetting ()
@property(weak) UIViewController *vc;
@property (nonatomic,strong) NSString *senderResult;
@property BTBIP32Key* xpub;
@end

static MonitorHDAccountSetting *monitorSetting;

@implementation MonitorHDAccountSetting


+ (MonitorHDAccountSetting *)getMonitorHDAccountSetting {
    if (!monitorSetting) {
        monitorSetting = [[MonitorHDAccountSetting alloc] initWithName:NSLocalizedString(@"monitor_cold_hd_account", nil) icon:[UIImage imageNamed:@"scan_button_icon"]];
    }
    return monitorSetting;
}

- (instancetype)initWithName:(NSString *)name icon:(UIImage *)icon {
    self = [super initWithName:name icon:icon];
    if (self) {
        [self configureSetting];
    }
    return self;
}

- (void)configureSetting {}
#pragma mark - import HDAccount
- (void)handleResult:(NSString *)result byReader:(id)reader {}
- (void)showMsg:(NSString *)msg {
    if (self.vc && [self.vc respondsToSelector:@selector(showMsg:)]) {
        [self.vc performSelector:@selector(showMsg:) withObject:msg];
    }
}

- (void)processQrCodeContent:(NSString *)content dp:(id)dp {}

- (BOOL)isRepeatHD:(NSString *)firstAddress {
    BTHDAccount *hdAccountHot = [[BTAddressManager instance] hdAccountHot];
    if (hdAccountHot == nil) {
        return false;
    }
    BTHDAccountAddress *addressHot = [hdAccountHot addressForPath:EXTERNAL_ROOT_PATH atIndex:0];
    if ([firstAddress isEqualToString:addressHot.address]) {
        return true;
    }
    return false;
}

-(void)accountValidatedSuccess {}

@end
