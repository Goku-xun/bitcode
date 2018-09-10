//
//  KeychainSetting.m
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

#import "KeychainSetting.h"
#import "UserDefaultsUtil.h"
#import "KeychainBackupUtil.h"

static Setting *keychainSetting;

@interface KeychainSetting ()

@property(nonatomic) BOOL needCheckKeychainPassword;
@property(nonatomic) BOOL needCheckLocalPassword;

@property(nonatomic, strong) NSString *keychainPassword;
@property(nonatomic, strong) NSString *localPassword;

@end

@implementation KeychainSetting

+ (Setting *)getKeychainSetting; {
    if (!keychainSetting) {
        KeychainSetting *setting = [[KeychainSetting alloc] initWithName:NSLocalizedString(@"keychain_backup", nil) icon:nil];
        [setting setGetValueBlock:^() {
            return [BitherSetting getKeychainMode:[[UserDefaultsUtil instance] getKeychainMode]];
        }];
        __block __weak KeychainSetting *weakSetting = setting;
        [setting setSelectBlock:^(UIViewController *controller) {
            weakSetting.controller = controller;
            KeychainMode keychainMode = [[UserDefaultsUtil instance] getKeychainMode];
            if (keychainMode == Off) {
                
            } else {
                
            }
        }];
        keychainSetting = setting;
    }
    return keychainSetting;
}

#pragma mark - DialogPasswordDelegate

- (void)onPasswordEntered:(NSString *)password; {}

- (BOOL)checkPassword:(NSString *)password; {
    if (self.needCheckKeychainPassword) {
        // check keychain password
        return YES;
    } else if (self.needCheckLocalPassword) {
        // check local password
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)passwordTitle; {
    if (self.needCheckKeychainPassword) {
        return NSLocalizedString(@"input_keychain_password", nil);
    } else if (self.needCheckLocalPassword) {
        return NSLocalizedString(@"input_local_password", nil);
    } else {
        return @"";
    }
}

#pragma mark - DialogKeychainBackupDiffDelegate

- (void)onAccept; {}

- (void)onDeny; {

}

@end
