//
//  KKUTXOModel.m
//  KuarkPay
//
//  Created by 黄武杰 on 2018/5/2.
//  Copyright © 2018年 toxicanty. All rights reserved.
//

#import "KKUTXOModel.h"
//#import "KKNetwork.h"
#import "NSString+Base58.h"
#import "NSData+Hash.h"
@implementation KKUTXOModel

-(void)getUTXOWith:(NSString *)btcAdress success:(void(^)(id respectObj))success failure:(void(^)(NSError *error))failure{
    /*需要恢复钱包才能生成比特币地址*/
    if (btcAdress == nil) return;
    NSMutableArray *temp = [NSMutableArray array];
//    [KKNetwork getBTCUTXOWithPaarameters:@[btcAdress] success:^(id respectObj) {
////        if (![utxo isKindOfClass:[NSArray class]]){
////            success(utxo);
////            return;
////        }
//        NSArray *utxo = respectObj[@"data"][@"utxos"];
//        NSLog(@"%@",utxo);
//        NSMutableArray *tempUTXO = [NSMutableArray array];
//        for (int i=0; i<[utxo count]; i++) {
//            NSDictionary *dict = utxo[i];
//            KKUTXOModel *model =[[KKUTXOModel alloc]init];
//            [model setValuesForKeysWithDictionary:dict];
//            model.index = i;
//            [tempUTXO addObject:model];
//            [temp addObject:model];
//        }
//        [temp sortUsingComparator:^NSComparisonResult(KKUTXOModel *obj1, KKUTXOModel *obj2) {
//            return obj1.outValue > obj2.outValue;
//        }];
//        self.data = [temp copy];
//        //缓存数据
//        [self ArchiverFileWithFileName:NSStringFromClass([self class])];
//        success(self.data);
//    } failure:^(NSError *error) {
//        failure(error);
//    }];
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([@"satoshis" isEqualToString:key]) {
        _satoshis = [NSString stringWithFormat:@"%@",value];
        _outValue = [value integerValue];
    }else if ([@"vout" isEqualToString:key]) {
        _vout = value;
        _outSn = [value integerValue];

    }else if ([@"txid" isEqualToString:key]) {
        _txid = value;
        /*hash需要逆序一下。拼接时需要逆序在这里完成 ?*/
//        _prev_tx_hash = [_txid hexToData];

        _prev_tx_hash = [_txid hexToData].reverse;
        
    }else if ([@"scriptPubKey" isEqualToString:key]){
        _scriptPubKey = value;
        _script = [_scriptPubKey hexToData];
    }else if ([@"txId" isEqualToString:key]){//接入wallet-scan
        [self setValue:value forKey:@"txid"];
    }else if ([@"amount" isEqualToString:key]){//接入wallet-scan
        [self setValue:value forKey:@"satoshis"];
    }else{
        [super setValue:value forKey:key];
    }
}


@end
