//
//  NSString+ZREXtention.h
//  Shuzic
//
//  Created by 黄武杰 on 2017/6/28.
//  Copyright © 2017年 深圳跨港通国际贸易有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZRBaseModel.h"
#import "ZRBaseModel+ZRExtension.h"

@interface NSString (ZREXtention)
/*
 *获取本地当前时间戳
 */
+(NSTimeInterval)getCurrentTime;
/*
 *将时间戳转化成具体时间
 */
+(NSString *)timeWithTimeIntervalString:(NSString *)timeString;
/*
 *转化成具体时间根据格式
 */
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString formate:(NSString *)fromate;

/*
 *获取倒计时小时  interval 时间戳之差
 */
+ (NSString *)HoursWithTimeInterval:(NSTimeInterval)interval;

/*
 *获取当前时间和传入时间的时间戳之差 返回时事新闻需要的格式
 */
+ (NSString *)IntervalPaddingWithinterval:(NSTimeInterval)interval;
/*
 *将时间戳转化成具体时间
 */
+(NSArray *)WeekDayWithTimeIntervalString:(NSString *)timeString;


/*
 *设置archive路径
 */
+(NSString *)getFilePathWithName:(NSString *)fileName;

/*
 *缓存数据进文件夹
 */
+(void)ArchiverFileWithModel:(NSObject *)model fileName:(NSString *)fileName;

/*
 *解档数据
 */
+(NSObject *)UnarchiverFileWithFileName:(NSString *)fileName;

/*
 *获取汉字转成拼音字符串
 */
+ (NSString *)transformToPinyin:(NSString *)aString;


/*
 *判断字符串是不是手机号码
 */
-(BOOL)isPhoneNumber;

/*
 *判断字符串是不是邮箱
 */
-(BOOL)isEmailAdress;

/*
 *判断字符串是不是密码。 交易密码
 */
-(BOOL)isPassword;

/*
 *判断字符串是不是验证码
 */
-(BOOL)isCode;
/**
 *  URLEncode
 */
- (NSString *)ZRURLEncodedString;
/**
 *  URLDecode
 */
-(NSString *)ZRURLDecodedString;

/*
 *银行卡号码 16-19位
 */
-(BOOL)isBankCard;

/*
 *十六进制转换为普通字符串的。
 */
+ (NSString *)stringFromHexString:(NSString *)hexString;

/*
 *16进制转整数字
 */
+ (NSInteger)numberWithHexString:(NSString *)hexString;
@end
