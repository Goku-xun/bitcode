//
//  KKUTXOModel.h
//  KuarkPay
//
//  Created by 黄武杰 on 2018/5/2.
//  Copyright © 2018年 toxicanty. All rights reserved.
//

#import "ZRBaseModel.h"

@interface KKUTXOModel : ZRBaseModel

@property (nonatomic,strong) NSString *address ;// 181mp8kYPgSMcDD9BffuJFhUPauPZkGip4;
@property (nonatomic,strong) NSString *amount ;// "5.706e-05";
@property (nonatomic,strong) NSString *confirmations ;// 844;
@property (nonatomic,strong) NSString *height ;// 519995;
@property (nonatomic,strong) NSString *satoshis ;// 5706;
@property (nonatomic,strong) NSString *scriptPubKey ;// 76a9144cee49c798d67431b084467cab90400834ed217b88ac;
@property (nonatomic,strong) NSString *txid ;// 84007aba8e05622f8123b9796e46e946229630e4054a19672e4595b16a552461;
@property (nonatomic,strong) NSString *vout ;// 1;
@property (nonatomic) NSInteger outValue;
@property (nonatomic,copy) NSArray *data;
/*hash*/
@property (nonatomic,strong) NSData *prev_tx_hash;
/*脚本是对的，直接转成16进制*/
@property (nonatomic,strong) NSData *script;
@property (nonatomic) NSInteger outSn;
/*顺序*/
@property (nonatomic) NSInteger index;

/*
 *传入url
 */
-(void)getUTXOUrl:(NSString *)url btcAdress:(NSString *)btcAdress success:(void(^)(id respectObj))success failure:(void(^)(NSError *error))failure;
@end
