//
//  LoginToken.h
//  LoginA4SDK
//
//  Created by xiongwenjie on 2018/11/19.
//  Copyright © 2018年 xiongwenjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Login4AUserInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface LoginToken : NSObject
/**
 获取4A用户信息
 @param scheme app的scheme
 @param block 获取用户信息回调
 */
+(void)getUserInfoFromMobileStoreWithScheme:(NSString *)scheme
                                      block:(void (^)(Login4AUserInfo *userInfo))block;


/**
 监听openUrl回调，在application:openURL:options:调用
 @param url 跳转进app带入的url
 */
+(void)monitorOpenURL:(nonnull NSURL *)url;


@end

NS_ASSUME_NONNULL_END
