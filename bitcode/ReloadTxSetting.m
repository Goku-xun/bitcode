//
//  ReloadTxSetting.m
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


#import "ReloadTxSetting.h"
#import "PeerUtil.h"
#import "BTAddressManager.h"
#import "BTTxProvider.h"
#import "TransactionsUtil.h"
#import "BTHDAccountProvider.h"
#import "BTHDAccountAddressProvider.h"
#import "UserDefaultsUtil.h"


static double reloadTime;
static Setting *reloadTxsSetting;

@implementation ReloadTxSetting

- (void)showDialogPassword {}
#pragma mark - reload data Prompt box
- (void)onPasswordEntered:(NSString *)password {
    [self doAction];
}
#pragma mark - from_bither Respond to events
- (void) doAction {}

#pragma mark - reload tx data from blockchain.info
- (void)reloadTxFrom_blockChain:(id )dialogProgrees{}
#pragma mark - reload tx data from bither.net
- (void)reloadTx:(id)dialogProgrees {}

+ (Setting *)getReloadTxsSetting {return nil;}
@end
