//
//  PushTxThirdParty.m
//  bither-ios
//
//  Created by 宋辰文 on 16/5/10.
//  Copyright © 2016年 Bither. All rights reserved.
//

#import "PushTxThirdParty.h"
#import "NSString+Base58.h"
//#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"
#import "KKNetwork.h"
static PushTxThirdParty* instance;

@implementation PushTxThirdParty{
    AFHTTPSessionManager* manager;
}

+(instancetype)instance{
    if(!instance){
        instance = [[PushTxThirdParty alloc]init];
    }
    return instance;
}

-(instancetype)init{
    if (!(self = [super init])) return nil;
    manager = [AFHTTPSessionManager manager];
    return self;
}

-(void)pushTx:(BTTx*) tx {
    NSString* raw = [NSString hexWithData:tx.toData];
//    [self pushToBlockChainInfo:raw];
//    [self pushToBtcCom:raw];
//    [self pushToChainQuery:raw];
//    [self pushToBlockr:raw];
    //上面4个有问题，请求总是失败
    [self pushToBlockExplorer:raw];
}

-(void)pushTx:(BTTx*) tx block:(void (^)(id, BOOL))block{
    _myblock = block;
    NSString* raw = [NSString hexWithData:tx.toData];
    //    [self pushToBlockChainInfo:raw];
    //    [self pushToBtcCom:raw];
    //    [self pushToChainQuery:raw];
    //    [self pushToBlockr:raw];
    //上面4个有问题，请求总是失败
//    [self pushToBlockExplorer:raw];
    [self pushToKuarkPay:raw];
}

-(void)pushToKuarkPay:(NSString *)raw{
    [self pushToUrl:@"http://192.168.8.54:8889/api/v1/tx/send" key:@"rawtx" rawTx:raw tag:@"KuarkPay"];
}

-(void)pushToUrl:(NSString*)url key:(NSString*)key rawTx:(NSString*)rawTx tag:(NSString*)tag {
    NSLog(@"begin push tx to %@  key=%@   rawTx = %@", tag,key,rawTx);
    [manager POST:url parameters:@{key:rawTx} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"push tx to %@ success responseObject %@", tag,responseObject);
        if (_myblock) _myblock(responseObject,YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"push tx to %@ error =%@", tag,error);
        if (_myblock) _myblock(error,NO);
    }];
}

-(void)pushToBlockChainInfo:(NSString*) raw {
    [self pushToUrl:@"https://blockchain.info/pushtx" key:@"tx" rawTx:raw tag:@"blockchain.info"];
}

-(void)pushToBtcCom:(NSString*) raw {
    [self pushToUrl:@"https://btc.com/api/v1/tx/publish" key:@"hex" rawTx:raw tag:@"BTC.com"];
}

-(void)pushToChainQuery:(NSString*) raw {
    [self pushToUrl:@"https://chainquery.com/bitcoin-api/sendrawtransaction" key:@"transaction" rawTx:raw tag:@"ChainQuery.com"];
}

-(void)pushToBlockr:(NSString*)raw {
    [self pushToUrl:@"https://blockr.io/api/v1/tx/push" key:@"hex" rawTx:raw tag:@"blockr.io"];
}

-(void)pushToBlockExplorer:(NSString*)raw {
    [self pushToUrl:@"https://blockexplorer.com/api/tx/send" key:@"rawtx" rawTx:raw tag:@"BlockExplorer"];
}

@end
