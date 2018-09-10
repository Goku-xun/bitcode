//
//  ImportBip38PrivateKeySetting.m
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

#import "ImportBip38PrivateKeySetting.h"
#import "BTPasswordSeed.h"
#import "BTKey+BIP38.h"
#import "AppDelegate.h"
#import "PeerUtil.h"

@interface CheckPasswordBip38Delegate : NSObject
@property(nonatomic, strong) UIViewController *controller;
@property(nonatomic, strong) NSString *privateKeyStr;
@end

@implementation CheckPasswordBip38Delegate

- (void)onPasswordEntered:(NSString *)password {
    
}

@end


@implementation ImportBip38PrivateKeySetting

static Setting *importPrivateKeySetting;


+ (Setting *)getImportBip38PrivateKeySetting {
    if (!importPrivateKeySetting) {
        ImportBip38PrivateKeySetting *scanPrivateKeySetting = [[ImportBip38PrivateKeySetting alloc] initWithName:NSLocalizedString(@"Import BIP38-private key", nil) icon:nil];
        __weak ImportBip38PrivateKeySetting *sself = scanPrivateKeySetting;
        [scanPrivateKeySetting setSelectBlock:^(UIViewController *controller) {
            sself.controller = controller;
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Import BIP38-private key", nil)
                                                                     delegate:sself cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:NSLocalizedString(@"From BIP38-private key QR Code", nil), NSLocalizedString(@"From BIP38-private key text", nil), nil];

            actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            [actionSheet showInView:controller.navigationController.view];
        }];
        importPrivateKeySetting = scanPrivateKeySetting;
    }
    return importPrivateKeySetting;
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
   
}

- (void)handleResult:(NSString *)result byReader:(UIViewController *)reader {
  
}

- (void)importKeyFormQrcode:(NSString *)keyStr password:(NSString *)password dp:(id)dp {
}

- (BOOL)checkPassword:(NSString *)password {
    _key = [BTKey keyWithBIP38Key:_result andPassphrase:password];
    return _key != nil;
}

- (void)onPasswordEntered:(NSString *)password {
    [self showCheckPassword:[_key privateKey]];
}

- (NSString *)passwordTitle {
    return NSLocalizedString(@"Enter password of BIP38-private key", nil);
}


//delegate of dialogImportPrivateKey
- (void)onPrivateKeyEntered:(NSString *)privateKey {
    _result = privateKey;
}

static CheckPasswordBip38Delegate *checkPasswordDelegate;

- (void)showCheckPassword:(NSString *)privateKey {
    checkPasswordDelegate = [[CheckPasswordBip38Delegate alloc] init];
    checkPasswordDelegate.controller = self.controller;
    checkPasswordDelegate.privateKeyStr = privateKey;

}

- (void)showMsg:(NSString *)msg {
    if ([self.controller respondsToSelector:@selector(showMsg:)]) {
        [self.controller performSelector:@selector(showMsg:) withObject:msg];
    }

}

@end
