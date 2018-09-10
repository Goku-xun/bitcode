//
//  HDMResetServerPasswordUtil.m
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
//  Created by songchenwen on 2015/3/12.
//

#import "HDMResetServerPasswordUtil.h"
#import "PasswordGetter.h"

#import "BTHDMBid+Api.h"
#import "NSError+HDMHttpErrorMessage.h"

@interface HDMResetServerPasswordUtil () <PasswordGetterDelegate> {
    PasswordGetter *passwordGetter;
    BTHDMBid *hdmBid;
    NSString *serverSignature;
    NSCondition *hdmIdCondition;
}
@end

@implementation HDMResetServerPasswordUtil
- (instancetype)initWithViewController:(UIViewController *)vc {
    self = [super init];
    if (self) {
        [self configureWithViewController:vc dialogProgress:nil andPassword:nil];
    }
    return self;
}

- (instancetype)initWithViewController:(UIViewController  *)vc andDialogProgress:(id)dp {
    self = [super init];
    if (self) {
        [self configureWithViewController:vc dialogProgress:dp andPassword:nil];
    }
    return self;
}

- (instancetype)initWithViewController:(UIViewController *)vc andPassword:(NSString *)password {
    self = [super init];
    if (self) {
        [self configureWithViewController:vc dialogProgress:nil andPassword:password];
    }
    return self;
}

- (instancetype)initWithViewController:(UIViewController  *)vc dialogProgress:(id)dp andPassword:(NSString *)password {
    self = [super init];
    if (self) {
        [self configureWithViewController:vc dialogProgress:dp andPassword:password];
    }
    return self;
}

- (void)configureWithViewController:(UIViewController  *)v dialogProgress:(id)d andPassword:(NSString *)p {
   
}

- (void)setPassword:(NSString *)password {
    passwordGetter.password = password;
}

- (BOOL)changeServerPassword {
    hdmBid = [BTHDMBid getHDMBidFromDb];
    serverSignature = nil;
 
    NSError *error;
    __block NSString *pre = [hdmBid getPreSignHashAndError:&error];
    if (error) {
        [self showMsg:error.msg];
        return NO;
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
        ;
    });
    [hdmIdCondition lock];
    [hdmIdCondition wait];
    [hdmIdCondition unlock];
    if (!serverSignature) {
        return NO;
    }
    NSString *password = passwordGetter.password;
    if (!password) {
        return NO;
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
        ;
    });
    [hdmBid changeBidPasswordWithSignature:serverSignature andPassword:password andError:&error];
    if (error) {
        if (error.isHttp400) {
            [self showMsg:error.msg];
        } else {
            [self showMsg:NSLocalizedString(@"hdm_keychain_add_sign_server_qr_code_error", nil)];
        }
        return NO;
    }
    return YES;
}


- (void)showMsg:(NSString *)msg {
 
}


- (void)handleResult:(NSString *)result byReader:(id)reader {
    serverSignature = result;
    ;
}

- (void)handleScanCancelByReader:(id )reader {
    serverSignature = nil;
    [hdmIdCondition lock];
    [hdmIdCondition signal];
    [hdmIdCondition unlock];
}

- (void)beforePasswordDialogShow {
  
}

- (void)afterPasswordDialogDismiss {
  
}
@end
