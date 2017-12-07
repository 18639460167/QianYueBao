//
//  BDLoginViewModel.h
//  QianYueBao
//
//  Created by Black on 17/5/2.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDLoginViewModel : NSObject

/**
 *  用户登录
 *
 *  @param name     帐号
 *  @param psw      密码
 *  @param cpmplete 返回信息
 */
+ (void)loginWithUserName:(NSString *)name password:(NSString *)psw complete:(actionHandle)complete;

+ (void)logoutHandler:(actionHandle)complete;
@end
