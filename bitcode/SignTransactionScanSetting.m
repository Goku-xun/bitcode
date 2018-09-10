//
//  SignTransactionScanDelegate.m
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

#import "SignTransactionScanSetting.h"
#import "QRCodeTxTransport.h"

static Setting *SignTransactionSetting;

@implementation SignTransactionScanSetting

+ (Setting *)getSignTransactionSetting {
    if (!SignTransactionSetting) {
        SignTransactionScanSetting *setting = [[SignTransactionScanSetting alloc] init];
        SignTransactionSetting = setting;
    }
    return SignTransactionSetting;
}

- (instancetype)init {
    self = [super initWithName:NSLocalizedString(@"Sign Transaction", nil) icon:[UIImage imageNamed:@"scan_button_icon"]];
    if (self) {
        __weak SignTransactionScanSetting *d = self;
        [self setSelectBlock:^(UIViewController *controller) {
     
        }];
    }
    return self;
}

- (void)handleResult:(NSString *)result byReader:(id)reader {}

@end
