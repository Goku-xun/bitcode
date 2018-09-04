//
//  bitcode.h
//  bitcode
//
//  Created by Tony on 2018/9/3.
//  Copyright © 2018年 KK. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for bitcode.
FOUNDATION_EXPORT double bitcodeVersionNumber;

//! Project version string for bitcode.
FOUNDATION_EXPORT const unsigned char bitcodeVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <bitcode/PublicHeader.h>

#import <Foundation/Foundation.h>

#define BASE58_ALPHABET @"123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
#define BITCOIN_ADDRESS_VAILD @"[123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz]{20,40}"

#define BITCOIN_TESTNET    0
#define SATOSHIS           100000000
#define PARALAX_RATIO      0.25
#define SEGUE_DURATION     0.3

#if BITCOIN_TESTNET
#warning testnet build
#endif

#if !DEBUG
#define NSLog(...)
#endif

// defines for building third party libs

#define OPENSSL_NO_HW
#define OPENSSL_NO_GOST
#define OPENSSL_NO_INLINE_ASM "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

