//
//  Login4AUserInfo.h
//  Login4ASDK
//
//  Created by xiongwenjie on 2019/1/16.
//  Copyright © 2019年 xiongwenjie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,Login4AStatus){
    Login4AStatusOpenFail = -1, //打开移动应用门户App失败，检查是否安装移动应用门户。
    Login4AStatusSuccess = 0,//返回4A数据成功
};

NS_ASSUME_NONNULL_BEGIN

@interface Login4AUserInfo : NSObject
/**用户ID*/
@property (nonatomic, copy) NSString *userId;
/**账号*/
@property (nonatomic, copy) NSString *userAccount;
/**账号密码64*/
@property (nonatomic, copy) NSString *userBase64Pwd;
/**token*/
@property (nonatomic, copy) NSString *token;

/**状态码*/
@property (nonatomic, assign) Login4AStatus status;
@end

NS_ASSUME_NONNULL_END
