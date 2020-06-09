//
//  SSOParameter.h
//  SSOLoginDemo
//
//  Created by 邢雷镇 on 2018/11/7.
//  Copyright © 2018年 Rayz. All rights reserved.
//

//#ifndef SSOParameter_h
//#define SSOParameter_h

static NSString *const SHOWTOKENNOTIFICATION               = @"show token notification";

static NSString *const kSSOParamKey = @"kSSOParamKey";

static NSString *const kSSOLogin = @"kSSOLoginKey";
static NSString *const kSSOPwd = @"kSSOPasswordKey";
static NSString *const kSSOToken = @"kSSOTokenKey";

#define kEmptyString(__value) (__value == nil || [__value isKindOfClass:[NSNull class]] || [__value isEqualToString:@""])
#define kSafeString(__value) (__value == nil || [__value isKindOfClass:[NSNull class]] || [__value isEqualToString:@""]) ? @"" : __value

//#endif /* SSOParameter_h */

@interface SSOParameter: NSObject


/**
 指定字符串查找对应key的value

 @param key 指定key
 @param baseString 指定字符串
 @return key对应的value
 */
+ (NSString *)getValueForKey:(NSString *)key baseString:(NSString *)baseString ;

/**
 base64字符串解码

 @param base64String base64编码的字符串
 @return base64解码的字符串
 */
+ (NSString *)base64dencode:(NSString *)base64String ;

/**
 json字符串转字典

 @param jsonString json字符串
 @return 字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString ;

/**
 字典转json字符串

 @param dict 字典
 @return json字符串
 */
+ (NSString *)convertToJsonData:(NSDictionary *)dict ;


/**
 获取项目设置的URL Scheme列表,实际中使用第一个
 
 @return 所有的URL Scheme
 */
+ (NSArray *)getAppUrlScheme;

@end
