//
//  BTKeyParameter.h
//  bitheri
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
//  limitations under the License.#import <Foundation/Foundation.h>

#import "openssl/bn.h"
#import <UIKit/UIKit.h>
#define ECKEY_MAX_N @"fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141"
#define ECKEY_MIN_N @"00"

@interface BTKeyParameter : NSObject

+ (BIGNUM *)maxN;

+ (BIGNUM *)minN;

@end
