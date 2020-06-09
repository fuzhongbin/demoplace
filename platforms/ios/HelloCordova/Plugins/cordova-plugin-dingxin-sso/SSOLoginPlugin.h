//
//  SSOLoginPlugin.h
//  SSO
//
//  Created by 邢雷镇 on 2018/5/18.
//  Copyright © 2018年 Rayz. All rights reserved.
//

#import <Cordova/CDV.h>
#import <Foundation/Foundation.h>

@interface SSOLoginPlugin : CDVPlugin


/**
 SSO 单点登录

 @param command 参数格式:[@"该应用的urlscheme", @"出现即时调试模式"]
 */
- (void)ssoLogin:(CDVInvokedUrlCommand *)command ;


/**
 查询参数

 @param command 参数格式:[@"urlscheme", @"true"],
 */
//- (void)fetchParams:(CDVInvokedUrlCommand *)command ;

+ (void) handleOpenUrl:(NSURL *)url commandDelegate:(id<CDVCommandDelegate>)commandDelegate;

@end
