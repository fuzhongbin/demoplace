//
//  SSOLoginPlugin.m
//  SSO
//
//  Created by 邢雷镇 on 2018/5/18.
//  Copyright © 2018年 Rayz. All rights reserved.
//

#import "SSOParameter.h"

@implementation SSOParameter

+ (NSString *)getValueForKey:(NSString *)key baseString:(NSString *)baseString {
    NSArray *paramsArr = [baseString componentsSeparatedByString:@"&"];
    
    for (int i = 0; i < paramsArr.count; i++) {
        NSRange keyRange = [paramsArr[i] rangeOfString:key];
        if (NSNotFound != keyRange.location) {
            NSString *subStr = [paramsArr[i] substringFromIndex:keyRange.location + keyRange.length + 1];
            return kSafeString(subStr);
        }
    }
    return @"";
}

+ (NSString *)base64dencode:(NSString *)base64String {
    if (kEmptyString(base64String)) {
        return @"";
    }
    //NSData *base64data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return kSafeString(string);
}

//- (void)handleLaunchedApp:(NSURL *)url {
//    NSString *host = [url resourceSpecifier];
//    if ([host hasPrefix:@"//"]) {
//        host = [host substringFromIndex:2];
//        NSLog(@"host = %@", host);
//
//        NSArray *parameterArray = [host componentsSeparatedByString:@"&"];
//        __block NSMutableString *beautystr = [[NSMutableString alloc] init];
//        [parameterArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            NSString *str = [parameterArray objectAtIndex:idx];
//            [beautystr appendFormat:@"%@\n", str];
//        }];
//        NSLog(@"beauty = %@", beautystr);
//    }
//}

// 字典转json字符串方法
+ (NSString *)convertToJsonData:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        NSLog(@"json解析失败：%@",err);
        return @{};
    }
    return dic;
}

+ (NSArray *)getAppUrlScheme {
    NSArray *urlArray = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    return urlArray ? urlArray: @[];
}
@end
