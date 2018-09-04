//
//  NSString+ZREXtention.m
//  Shuzic
//
//  Created by 黄武杰 on 2017/6/28.
//

#import "NSString+ZREXtention.h"

@implementation NSString (ZREXtention)
+(NSTimeInterval)getCurrentTime{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeInterval=[dat timeIntervalSince1970];
    return timeInterval;
}

+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString{
    NSString *format = @"yyyy年MM月dd日";
        format =  @"yyyy/MM/dd";
     return [self timeWithTimeIntervalString:timeString formate:format];
}

+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString formate:(NSString *)fromate{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT+0800"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:fromate];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
//    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

+(NSArray *)WeekDayWithTimeIntervalString:(NSString *)timeString{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT+0800"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
//    NSString* week = [formatter2 stringFromDate:date];
    return @[[self getWeekDayFordate:date],dateString];
}

//根据时间戳获取星期几
+ (NSString *)getWeekDayFordate:(NSDate *)date
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    
//    NSDate*date =[dateFormat dateFromString:currentStr];
    
    NSArray*weekdays = [NSArray arrayWithObjects: [NSNull null],@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",nil];
        weekdays = [NSArray arrayWithObjects: [NSNull null],@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",nil];
    NSCalendar*calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone*timeZone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit =NSCalendarUnitWeekday;
    
    NSDateComponents*theComponents = [calendar components:calendarUnit fromDate:date];
    
    return[weekdays objectAtIndex:theComponents.weekday];
}

+ (NSString *)HoursWithTimeInterval:(NSTimeInterval)interval{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT+0800"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH : SS"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:interval/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSString *)IntervalPaddingWithinterval:(NSTimeInterval)interval{
   NSTimeInterval curretntInterval = [self getCurrentTime];
    
    return [self getNewsTimeWithInterval:curretntInterval-interval];
}

+(NSString *)getNewsTimeWithInterval:(long long)interval{
    interval=interval/1000;
    NSInteger month=interval/(60*60*24*30);
    NSInteger day=interval/(60*60*24);
    NSInteger hour=(interval/(60*60))%24;
    NSInteger minite=(interval/60)%60;
    
    return month>0?[NSString stringWithFormat:@"%ld个月之前",month]:(day>0?[NSString stringWithFormat:@"%ld天之前",day]:(hour>0?[NSString stringWithFormat:@"%ld小时之前",hour]:[NSString stringWithFormat:@"%ld分钟之前",minite]));
}

+(NSString *)getFilePathWithName:(NSString *)fileName{
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [[array objectAtIndex:0] stringByAppendingPathComponent:fileName];
}

+(void)ArchiverFileWithModel:(ZRBaseModel *)model fileName:(NSString *)fileName{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:model forKey:fileName];
    [archiver finishEncoding];
    [data writeToFile:[self getFilePathWithName:fileName] atomically:YES];
}

+(ZRBaseModel *)UnarchiverFileWithFileName:(NSString *)fileName{
    ZRBaseModel *model;
    NSString *path=[self getFilePathWithName:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        model = [unarchiver decodeObjectForKey:fileName];

        [unarchiver finishDecoding];//don't forget finishDecoding
        return model;
    }
    
    return model;
}


+ (NSString *)transformToPinyin:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSArray *pinyinArray = [str componentsSeparatedByString:@" "];
    NSMutableString *allString = [NSMutableString new];
    
    int count = 0;
    
    for (int  i = 0; i < pinyinArray.count; i++)
    {
        
        for(int i = 0; i < pinyinArray.count;i++)
        {
            if (i == count) {
                [allString appendString:@"#"];//区分第几个字母
            }
            [allString appendFormat:@"%@",pinyinArray[i]];
            
        }
        [allString appendString:@","];
        count ++;
        
    }
    
    NSMutableString *initialStr = [NSMutableString new];//拼音首字母
    
    for (NSString *s in pinyinArray)
    {
        if (s.length > 0)
        {
            
            [initialStr appendString:  [s substringToIndex:1]];
        }
    }
    
    [allString appendFormat:@"#%@",initialStr];
    [allString appendFormat:@",#%@",aString];
    
    return allString;
}



/*
 *判断字符串是不是手机号码
 */
-(BOOL)isPhoneNumber{
//    NSString *phoneRegex =  @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    NSString *phoneRegex =  @"^1(3[0-9]|4[0-9]|5[0-9]|6[0-9]|7[0-9]|8[0-9]|9[0-9])\\d{8}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",phoneRegex];
    
    return [phoneTest evaluateWithObject:self];
}

/*
 *判断字符串是不是邮箱
 */
-(BOOL)isEmailAdress{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

/*
 *判断字符串是不是密码。 交易密码
 */
-(BOOL)isPassword{
    if (self.length==6)
        return YES;
    else
        return NO;
}

/*
 *判断字符串是不是验证码
 */
-(BOOL)isCode{
    if (self.length==6)
        return YES;
    else
        return NO;
}


/**
 *  URLEncode
 */
- (NSString *)ZRURLEncodedString
{
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *unencodedString = self;
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

/**
 *  URLDecode
 */
-(NSString *)ZRURLDecodedString
{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *encodedString = self;
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

/*
 *银行卡号码 16-19位
 */
-(BOOL)isBankCard{
    if (self.length>=16 && self.length<=19) {
        return YES;
    }else{
        return NO;
    }
}

+ (NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    return unicodeString;
}

+ (NSInteger)numberWithHexString:(NSString *)hexString{
    
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    
    int hexNumber;
    
    sscanf(hexChar, "%x", &hexNumber);
    
    return (NSInteger)hexNumber;
}
@end
