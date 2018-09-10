//
//  HDMResetServerPasswordUtil.h
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

#import <Foundation/Foundation.h>
@interface HDMResetServerPasswordUtil : NSObject
- (instancetype)initWithViewController:(UIViewController *)vc;

- (instancetype)initWithViewController:(UIViewController *)vc andDialogProgress:(id)dp;

- (instancetype)initWithViewController:(UIViewController *)vc andPassword:(NSString *)password;

- (instancetype)initWithViewController:(UIViewController *)vc dialogProgress:(id)dp andPassword:(NSString *)password;

- (void)setPassword:(NSString *)password;

- (BOOL)changeServerPassword;

@end
