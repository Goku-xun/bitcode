//
//  ZRBaseModel+ZRExtension.m
//  Shuzic
//
//  Created by Tony on 2017/11/5.
//  Copyright © 2017年 深圳跨港通国际贸易有限公司. All rights reserved.
//

#import "ZRBaseModel+ZRExtension.h"

@implementation ZRBaseModel (ZRExtension)

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"ID"];
    }else  if ([key isEqualToString:@"description"]){
        [self setValue:value forKey:@"descriptionT"];
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        [self setValue:[NSString stringWithFormat:@"%@",value] forKey:key];
    }else if ([value isKindOfClass:[NSNull class]] || value==nil) {
        [self setValue:@"" forKey:key];
    }else{
        [super setValue:value forKey:key];
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if (![key isEqualToString:@"id"] && ![key isEqualToString:@"description"])
        NSLog(@"UndefinedKey %@ - value %@ - class:%@",key,value,[self class]);
//    else
//        [super setValue:value forUndefinedKey:key];
    
}

-(NSString *)description{
    return [NSString stringWithFormat:@"%@",[self properties_aps]];
}

/*
 *通过运行时获取当前对象的所有属性的名称，以数组的形式返回
 */
- (NSArray *) allPropertyNames{
    ///存储所有的属性名称
    NSMutableArray *allNames = [[NSMutableArray alloc] init];
    
    ///存储属性的个数
    unsigned int propertyCount = 0;
    
    ///通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);
    
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        ///取出第一个属性
        objc_property_t property = propertys[i];
        
        const char * propertyName = property_getName(property);
        
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }
    
    ///释放
    free(propertys);
    
    return allNames;
}

/*
 *Model 到字典   类似逆向的 setValuesForKeysWithDictionary
 */
- (NSDictionary *)properties_aps
{
    
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i<outCount; i++)
        
    {
        
        objc_property_t property = properties[i];
        
        const char* char_f =property_getName(property);
        
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
        
    }
    
    free(properties);
    
    return props;
    
}

#pragma mark-NSCoding
/*
 *归档
 */
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    NSDictionary *dict=[self properties_aps];
    for (NSString *key in dict) {
        [aCoder encodeObject:dict[key] forKey:key];
    }
}

/*
 *解档
 */
-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self == [super init]) {
        NSArray *keyArr=[self allPropertyNames];
        for (NSString *key in keyArr) {
            NSString *value=[aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
    }
    return self;
}


#pragma mark-NSCopying
-(id)copyWithZone:(NSZone *)zone{
    ZRBaseModel *copy = [[[self class] allocWithZone:zone] init];
    //    copy.name = [self.name copyWithZone:zone];
    NSDictionary *dict=[self properties_aps];
    for (NSString *key in dict) {
        [copy setValue:[dict[key] copyWithZone:zone] forKey:key];
    }
    return copy;
}

+(NSMutableArray *)getDataWithArr:(NSArray *)arr{
    NSMutableArray *arrM=[NSMutableArray array];
    for (NSDictionary *dict in arr) {
        id model=[[[self class] alloc]init];
        [model setValuesForKeysWithDictionary:dict];
        [arrM addObject:model];
    }
    return arrM;
}

-(void)ArchiverFileWithFileName:(NSString *)fileName{
    [NSString ArchiverFileWithModel:self fileName:fileName];
}


+(instancetype)UnarchiverFileWithFileName:(NSString *)fileName{
    ZRBaseModel *model;
    NSString *path=[NSString getFilePathWithName:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        //解档出数据模型
        model = [unarchiver decodeObjectForKey:fileName];
        
        [unarchiver finishDecoding];//一定不要忘记finishDecoding，否则会报错
        return model;
    }
    
    return model;
}

@end
