//
//  ScanPrivateKeyDelegate.m
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

#import "BTAddressProvider.h"
#import "ImportPrivateKeySetting.h"

#import "BTAddressManager.h"
#import "BTQRCodeUtil.h"
#import "ImportHDMCold.h"
#import "PeerUtil.h"


#import "AppDelegate.h"
#import "BTWordsTypeManager.h"

@interface CheckPasswordDelegate : NSObject
@property(nonatomic, strong) UIViewController *controller;
@property(nonatomic, strong) NSString *privateKeyStr;
@end

@implementation CheckPasswordDelegate
#pragma mark - Get transactions data option phrase
- (void)onPasswordEntered:(NSString *)password {}
@end


@interface ImportPrivateKeySetting ()
@property(nonatomic, readwrite) BOOL isImportHDM;
@property(nonatomic, readwrite) BOOL isImportHDAccount;
@property NSArray *buttons;
@property (nonatomic,strong)NSString *keyStr;
@end

@implementation ImportPrivateKeySetting

static Setting *importPrivateKeySetting;
+ (Setting *)getImportPrivateKeySetting {
    if (!importPrivateKeySetting) {
        ImportPrivateKeySetting *scanPrivateKeySetting = [[ImportPrivateKeySetting alloc] initWithName:NSLocalizedString(@"Import Private Key", nil) icon:nil];
        __weak ImportPrivateKeySetting *sself = scanPrivateKeySetting;
        [scanPrivateKeySetting setSelectBlock:^(UIViewController *controller) {
            sself.controller = controller;
            NSMutableArray *buttons = [NSMutableArray new];
            UIActionSheet *actionSheet = nil;
            [buttons addObjectsFromArray:@[NSLocalizedString(@"From Bither Private Key QR Code", nil), NSLocalizedString(@"From Private Key Text", nil)]];
            if ([[BTSettings instance] getAppMode] == COLD && ![[BTAddressManager instance] hasHDMKeychain]) {
                [buttons addObjectsFromArray:@[NSLocalizedString(@"import_hdm_cold_seed_qr_code", nil), NSLocalizedString(@"import_hdm_cold_seed_phrase", nil)]];
            }
            if (([BTSettings instance].getAppMode == COLD && ![BTAddressManager instance].hasHDAccountCold) || ([BTSettings instance].getAppMode == HOT && ![BTAddressManager instance].hasHDAccountHot)) {
                [buttons addObjectsFromArray:@[NSLocalizedString(@"import_hd_account_seed_qr_code", nil), NSLocalizedString(@"import_hd_account_seed_phrase", nil)]];
            }
            actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Import Private Key", nil) delegate:sself cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
            for (NSString *title in buttons) {
                [actionSheet addButtonWithTitle:title];
            }
            [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
            actionSheet.cancelButtonIndex = buttons.count;
            sself.buttons = buttons;
            actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            [actionSheet showInView:controller.navigationController.view];
        }];
        importPrivateKeySetting = scanPrivateKeySetting;
    }
    return importPrivateKeySetting;
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex < 0 || buttonIndex >= self.buttons.count || buttonIndex == actionSheet.cancelButtonIndex){
        return;
    }
    NSString *button = [self.buttons objectAtIndex:buttonIndex];
    if ([StringUtil isEmpty:button]) {
        return;
    }
    self.isImportHDM = NO;
    self.isImportHDAccount = NO;
    if ([StringUtil compareString:button compare:NSLocalizedString(@"From Bither Private Key QR Code", nil)]) {
        [self scanQRCodeWithPrivateKey];
    } else if ([StringUtil compareString:button compare:NSLocalizedString(@"From Private Key Text", nil)]) {
        [self importPrivateKey];
    } else if ([StringUtil compareString:button compare:NSLocalizedString(@"import_hdm_cold_seed_qr_code", nil)]) {
        self.isImportHDM = YES;
        [self scanQRCodeWithHDMColdSeed];
    } else if ([StringUtil compareString:button compare:NSLocalizedString(@"import_hdm_cold_seed_phrase", nil)]) {
        self.isImportHDM = YES;
        [self importWithHDMColdPhrase];
    } else if ([StringUtil compareString:button compare:NSLocalizedString(@"import_hd_account_seed_qr_code", nil)]) {
        self.isImportHDAccount = YES;
        [self scanQRCodeWithHDAccount];
    } else if ([StringUtil compareString:button compare:NSLocalizedString(@"import_hd_account_seed_phrase", nil)]) {
        self.isImportHDAccount = YES;
        [self importWithHDAccountPhrase];
    }
}

- (void)scanQRCodeWithHDAccount {}

- (void)importWithHDAccountPhrase {}

- (void)scanQRCodeWithPrivateKey {}

- (void)importPrivateKey {}

- (void)scanQRCodeWithHDMColdSeed {}

- (void)importWithHDMColdPhrase {}

- (void)handleResult:(NSString *)result byReader:(UIViewController *)reader {
    
}

- (BOOL)isHdSeedWithResult:(NSString *)result {
    BOOL isZhCNHDSeed = [self isHdSeedWithResult:result HDQrCodeFlat:ZHCN];
    if (isZhCNHDSeed) {
        return isZhCNHDSeed;
    }
    BOOL isZhTWHDSeed = [self isHdSeedWithResult:result HDQrCodeFlat:ZHTW];
    if (isZhTWHDSeed) {
        return isZhTWHDSeed;
    }
    BOOL isHDSeed = [self isHdSeedWithResult:result HDQrCodeFlat:EN];
    return isHDSeed;
}

- (BOOL)isHdSeedWithResult:(NSString *)result HDQrCodeFlat:(HDQrCodeFlatType)qrCodeFlat {
    NSRange range = [result rangeOfString:[BTQRCodeUtil getHDQrCodeFlat:qrCodeFlat]];
    BOOL isHDSeed = range.location == 0 && range.length == [BTQRCodeUtil getHDQrCodeFlat:qrCodeFlat].length;
    return isHDSeed;
}

- (NSString *)getHDAccountWordList:(NSString *)result {
    BOOL isZhCNHDSeed = [self isHdSeedWithResult:result HDQrCodeFlat:ZHCN];
    if (isZhCNHDSeed) {
        return [BTWordsTypeManager getWordsTypeValue:ZHCN_WORDS];
    }
    BOOL isZhTWHDSeed = [self isHdSeedWithResult:result HDQrCodeFlat:ZHTW];
    if (isZhTWHDSeed) {
        return [BTWordsTypeManager getWordsTypeValue:ZHTW_WORDS];
    }
    
    return [BTWordsTypeManager getWordsTypeValue:EN_WORDS];
}

- (NSString *)getHDAccountBTEncryptDataStr:(NSString *)result {
    BOOL isZhCNHDSeed = [self isHdSeedWithResult:result HDQrCodeFlat:ZHCN];
    BOOL isZhTWHDSeed = [self isHdSeedWithResult:result HDQrCodeFlat:ZHTW];
    if (isZhCNHDSeed || isZhTWHDSeed) {
        return [_result substringFromIndex:3];
    }
    return [_result substringFromIndex:1];
}

#pragma mark - import HDAccount、 HDM、 privateKey Through key Qrcode settings
- (void)importHDAccountAndHDMAccountAndPrivateKeyThroughQrcode:(NSString *)password{}

#pragma mark - import style chose
- (void)onPasswordEntered:(NSString *)password {
    [self importHDAccountAndHDMAccountAndPrivateKeyThroughQrcode:password];

}

- (void)importHDMColdSeedFormQRCode:(NSString *)keyStr password:(NSString *)password dp:(id)dp {
    [dp dismiss];
    ImportHDMCold *importPrivateKey = [[ImportHDMCold alloc] initWithController:self.controller content:keyStr worldList:nil passwrod:password importHDSeedType:HDMColdSeedQRCode];
    [importPrivateKey importHDSeed];
}
- (void)importKeyFormQrcode:(NSString *)keyStr password:(NSString *)password dp:(id)dp {}
- (BOOL)checkPassword:(NSString *)password {
    NSString *checkKeyStr = _result;
    if (self.isImportHDM) {
        checkKeyStr = [checkKeyStr substringFromIndex:1];
    } else if (self.isImportHDAccount) {
        checkKeyStr = [self getHDAccountBTEncryptDataStr:_result];
    }
    BTEncryptData *encryptedData = [[BTEncryptData alloc] initWithStr:checkKeyStr];
    return [encryptedData decrypt:password] != nil;
}

- (NSString *)passwordTitle {
    return NSLocalizedString(@"Enter original password", nil);
}

static CheckPasswordDelegate *checkPasswordDelegate;

//delegate of dialogImportPrivateKey
- (void)onPrivateKeyEntered:(NSString *)privateKey {
    [self showCheckPassword:privateKey];
}

- (void)showCheckPassword:(NSString *)privateKey {}

- (void)showMsg:(NSString *)msg {
    if ([self.controller respondsToSelector:@selector(showMsg:)]) {
        [self.controller performSelector:@selector(showMsg:) withObject:msg];
    }

}
@end


