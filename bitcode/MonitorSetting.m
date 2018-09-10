//
//  MonitorSetting.m
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
//  Created by songchenwen on 15/4/28.
//

#import "BTQRCodeUtil.h"
#import "BTKey.h"
#import "NSString+Base58.h"
#import "BTAddress.h"
#import "BTAddressManager.h"
#import "MonitorSetting.h"


#import "StringUtil.h"
#import "KeyUtil.h"


#import "AppDelegate.h"
#import "PeerUtil.h"


@interface MonitorSetting ()
@property(weak) UIViewController *vc;
@property (nonatomic,copy)NSString *senderResut;
@property NSArray* addressList;
@end

static MonitorSetting *monitorSetting;

@implementation MonitorSetting

+ (MonitorSetting *)getMonitorSetting {
    if (!monitorSetting) {
        monitorSetting = [[MonitorSetting alloc] initWithName:NSLocalizedString(@"add_hd_account_monitor", nil) icon:[UIImage imageNamed:@"scan_button_icon"]];
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

- (void)handleResult:(NSString *)result byReader:(id)reader {}
- (void)handleResult{}

- (void)showMsg:(NSString *)msg {
    if (self.vc && [self.vc respondsToSelector:@selector(showMsg:)]) {
        [self.vc performSelector:@selector(showMsg:) withObject:msg];
    }
}

- (void)processQrCodeContent:(NSString *)content dp:(id )dp {}

- (void)monitorAddressValidationSuccess{}

- (BOOL)checkQrCodeContent:(NSString *)content {
    NSArray *strs = [BTQRCodeUtil splitQRCode:content];
    for (NSString *str in strs) {
        BOOL checkCompress = (str.length == 66) || (str.length == 67 && [str rangeOfString:XRANDOM_FLAG].location != NSNotFound);
        BOOL checkUncompress = (str.length == 130) || (str.length == 131 && [str rangeOfString:XRANDOM_FLAG].location != NSNotFound);
        if (!checkCompress && !checkUncompress) {
            return NO;
        }
    }
    return YES;
}

@end
