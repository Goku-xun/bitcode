//
//  PushTxThirdParty.h
//  bither-ios
//
//  Created by 宋辰文 on 16/5/10.
//  Copyright © 2016年 Bither. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTTx.h"

@interface PushTxThirdParty : NSObject

+(instancetype) instance;
@property (nonatomic,strong) void(^myblock)(id respectObj,BOOL result);

-(void)pushTx:(BTTx*) tx;
-(void)pushTx:(BTTx*) tx block:(void(^)(id respectObj,BOOL result))block;
@end
