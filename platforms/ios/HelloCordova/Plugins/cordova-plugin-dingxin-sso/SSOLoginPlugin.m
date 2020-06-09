//
//  SSOLoginPlugin.m
//  SSO
//
//  Created by 邢雷镇 on 2018/5/18.
//  Copyright © 2018年 Rayz. All rights reserved.
//

#import "SSOLoginPlugin.h"

#import <Login4ASDK/Login4ASDK.h>

#import "SSOParameter.h"



@implementation SSOLoginPlugin{
    CDVInvokedUrlCommand *tmpCmd;
    NSDictionary *ssoParam;
    BOOL is4ALogin;
}

+ (instancetype)sharedInstance {
    static SSOLoginPlugin *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [SSOLoginPlugin new];
    });
    return _instance;
}

- (void)ssoLogin:(CDVInvokedUrlCommand *)command {
    [SSOLoginPlugin sharedInstance]->is4ALogin = true;
    [SSOLoginPlugin sharedInstance]->tmpCmd = command;
    BOOL isDebug = NO;
    // 独立发起登录
    NSArray *args = command.arguments;
    if (args.count == 2) { // 开启/关闭调试模式
        isDebug = true;
    }
    
    if (isDebug) {// 开启了调试模式
        NSString *msg = @"";
        if ([SSOLoginPlugin sharedInstance]->ssoParam && [SSOLoginPlugin sharedInstance]->ssoParam.count) {
            msg = [NSString stringWithFormat:@"数据:%@", [SSOLoginPlugin sharedInstance]->ssoParam];
        }
        [self showAlert:msg finish:^{
            if (![msg isEqualToString:@""]) {
                // 已有参数直接登录
                [self launchParamsLogin:[SSOLoginPlugin sharedInstance]->ssoParam command:command];
            } else {
                // 无参数则使用4A登录
                [self sso4ALogin:command];
            }
        }];
    } else {
        NSString *msg = @"";
        if ([SSOLoginPlugin sharedInstance]->ssoParam && [SSOLoginPlugin sharedInstance]->ssoParam.count) {
            msg = [NSString stringWithFormat:@"数据:%@", [SSOLoginPlugin sharedInstance]->ssoParam];
        }
        if (![msg isEqualToString:@""]) {
            // 已有参数直接登录
            [self launchParamsLogin:[SSOLoginPlugin sharedInstance]->ssoParam command:command];
        } else {
            // 无参数则使用4A登录
            [self sso4ALogin:command];
        }
    }

    

//            // 使用4A登录。如果没有token，就使用账号+密码登录
//            NSArray *urlTypeArray = [SSOParameter getAppUrlScheme];
//            NSArray *urlSchemeArray = urlTypeArray.count ? [urlTypeArray[0] objectForKey:@"CFBundleURLSchemes"] : nil;
//            if ( [urlSchemeArray isKindOfClass:[NSArray class]] && urlSchemeArray.count ) {
//                [LoginToken getUserInfoFromMobileStoreWithScheme:kSafeString(urlSchemeArray[0]) block:^(Login4AUserInfo * userInfo) {
//                    if (userInfo) {
//                        NSDictionary *dic = @{@"token": kSafeString(userInfo.token),
//                                              @"username": kSafeString(userInfo.userAccount),
//                                              @"password": [SSOParameter base64dencode:kSafeString(userInfo.userBase64Pwd)]
//                                              };
//                        NSString *msg = [SSOParameter convertToJsonData:dic];
//                        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:msg];
//                        [self.commandDelegate sendPluginResult:result callbackId:tmpCommand.callbackId];
//                    } else {
//                        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"参数为空"];
//                        [self.commandDelegate sendPluginResult:result callbackId:tmpCommand.callbackId];
//                    }
//                }];
//            } else {
//
//                CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"URL Scheme设置出错"];
//                [self.commandDelegate sendPluginResult:result callbackId:tmpCommand.callbackId];
//            }

}
// 已有参数直接登录
- (void)launchParamsLogin: (NSDictionary *)params command:(CDVInvokedUrlCommand *)command {
    [SSOLoginPlugin sharedInstance]->is4ALogin = false;
    [SSOLoginPlugin sharedInstance]->tmpCmd = nil;
    
    NSString *msg = [SSOParameter convertToJsonData:params];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:msg];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
// 4A账号登录
- (void)sso4ALogin:(CDVInvokedUrlCommand *)command{
    NSArray *args = command.arguments;
    // 无参数，使用4A账号登录
    BOOL param1Valid = ([args[0] isKindOfClass:[NSString class]] && ![args[0] isEqualToString:@""]);
    BOOL validScheme = NO;
    
    if (param1Valid) { // 传入参数有效
        NSArray *types = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
        if (types && types.count) {
            for (int i=0; i < types.count; i++) {
                NSArray *schemes = [types[i] objectForKey:@"CFBundleURLSchemes"];
                for (int j = 0; j < schemes.count; j++) {
                    NSString *schemeStr = schemes[j];
                    if ([schemeStr.lowercaseString isEqualToString:[args[0] lowercaseString]]) {
                        validScheme = true; // 项目设置有效
                    }
                }
            }
        }
    } else {
        [SSOLoginPlugin sharedInstance]->is4ALogin = false;
        [SSOLoginPlugin sharedInstance]->tmpCmd = nil;
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"无效的URL Scheme参数!"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    
    if (validScheme) {
        [LoginToken getUserInfoFromMobileStoreWithScheme:args[0] block:^(Login4AUserInfo * userInfo) {
            [SSOLoginPlugin sharedInstance]->is4ALogin = false;
            [SSOLoginPlugin sharedInstance]->tmpCmd = nil;
            
            if (userInfo.status != Login4AStatusSuccess) {
                NSString *content = @"打开移动应用门户失败，请检查是否安装移动应用门户App";
                [self showErrorAlert];
                
                CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:content];
                [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                return ;
            }
            
            if (userInfo && ![kSafeString(userInfo.userAccount) isEqualToString:@""]) {
                NSDictionary *dic = @{@"token": kSafeString(userInfo.token),
                                      @"username": kSafeString(userInfo.userAccount),
                                      @"password": [SSOParameter base64dencode:kSafeString(userInfo.userBase64Pwd)]
                                      };
                NSString *msg = [SSOParameter convertToJsonData:dic];
                CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:msg];
                [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            } else {
                CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"4A登录返回失败!"];
                [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            }
        }];
    } else {
        [SSOLoginPlugin sharedInstance]->is4ALogin = false;
        [SSOLoginPlugin sharedInstance]->tmpCmd = nil;
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"项目设置URL Scheme无效!"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
}
+ (void)handleOpenUrl:(NSURL *)url commandDelegate:(id<CDVCommandDelegate>)commandDelegate{
    // 4A登录SDK token返回空时，SDK没有回调，不清楚原因
    NSString *baseStr = [url.absoluteString stringByRemovingPercentEncoding];
    
    NSString *token = [SSOParameter getValueForKey:@"token" baseString:baseStr];
    if ([SSOLoginPlugin sharedInstance]->is4ALogin) {
        // 4A登录,只加密密码,另外需要校验token是否为空
        if (([kSafeString(token) isEqualToString:@""] || [token.lowercaseString rangeOfString:@"null"].location != NSNotFound ) && [SSOLoginPlugin sharedInstance]->tmpCmd != nil) {
            CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"4A登录返回失败!"];
            [commandDelegate sendPluginResult:result callbackId:[SSOLoginPlugin sharedInstance]->tmpCmd.callbackId];
            
            [SSOLoginPlugin sharedInstance]->is4ALogin = false;
            [SSOLoginPlugin sharedInstance]->tmpCmd = nil;
            
        } else {
            [LoginToken monitorOpenURL:url];
        }
    } else {
        /**
        // 启动传参,全部加密
        NSString *baseStr = [url.absoluteString stringByRemovingPercentEncoding];
        
        NSString *token = [SSOParameter getValueForKey:@"token" baseString:baseStr]; */
        NSString *username = [SSOParameter getValueForKey:@"username" baseString:baseStr];
        NSString *password = [SSOParameter getValueForKey:@"password" baseString:baseStr];
        
        NSString *decodeToken = [[SSOParameter base64dencode:token] isEqualToString:@""] ? token : [SSOParameter base64dencode:token]; // 区分base64解密
        NSMutableDictionary *ssoParams = [[NSMutableDictionary alloc] init];
        
        [ssoParams setValue: decodeToken forKey:@"token"];
        [ssoParams setValue:[SSOParameter base64dencode:username] forKey:@"username"];
            /*
             @{@"token":[SSOParameter base64dencode:token],
             @"username":[SSOParameter base64dencode:username],
             @"password":[SSOParameter base64dencode:password]}
             */
        if ( [[url resourceSpecifier] rangeOfString:@"userAccount"].location != NSNotFound) {
            username = [SSOParameter getValueForKey:@"userAccount" baseString:[url resourceSpecifier]];
            [ssoParams setValue:username forKey:@"username"]; // 未加密
        }
        if ([[url resourceSpecifier] containsString:@"userBase64Pwd"]) {
            password = [SSOParameter getValueForKey:@"userBase64Pwd" baseString:[url resourceSpecifier]];
        }
        [ssoParams setValue:[SSOParameter base64dencode:password] forKey:@"password"];
        
        NSString *js = [NSString stringWithFormat:@"handleOpenUrl(%@)", [SSOParameter convertToJsonData:ssoParams]];
        [commandDelegate evalJs:js];
        [SSOLoginPlugin sharedInstance]->ssoParam = ssoParams;
    }
    
}



- (void)showAlert:(NSString *)msg finish:(void (^)())finish{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"调试模式" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [alert dismissViewControllerAnimated:true completion:nil];
    }];
    [alert addAction:action];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:finish];
}


- (void)showErrorAlert {
    NSString *content = @"打开移动应用门户失败，请检查是否安装移动应用门户App";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:content preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

@end
