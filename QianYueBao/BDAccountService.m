//
//  BDAccountService.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/28.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDAccountService.h"

@implementation BDAccountService

+ (instancetype)sharedService
{
    static dispatch_once_t once;
    static BDAccountService *sharedService;
    dispatch_once(&once, ^{
        sharedService = [[self alloc]init];
    });
    return sharedService;
}

/**
 *  是否第一次登录
 *
 */
- (BOOL)checkVersion
{
    NSString *key = @"CFBundleShortVersionString";
    NSString *verson = [[[NSBundle mainBundle]infoDictionary]objectForKey:key];
    NSString *saveVersion = USER_DEFAULT(key);
    if ([verson isEqualToString:saveVersion])
    {
        return NO;
    }
    else
    {
        SET_USER_DEFAULT(verson, key);
        SYN_USER_DEFAULT;
        return YES;
    }
}

- (void)saveWithDic:(NSDictionary *)dic
{
    NSString *userName = [NSString trimNSNullAsNoValue:[dic objectForKey:@"user_name"]];
    NSString *userId = [NSString trimNSNullAsNoValue:[dic objectForKey:@"id"]];
    userId = [NSString stringWithFormat:@"table_%@",userId];
    NSString *token = [NSString trimNSNullAsNoValue:[dic objectForKey:@"access_token"]];
    SET_USER_DEFAULT(token, AccessToken);
    SET_USER_DEFAULT(userId, User_ID);
    SET_USER_DEFAULT(userName, User_Name);
    SYN_USER_DEFAULT;
}

- (void)logout
{
    REMOVE_USER_DEFAULT(AccessToken);
    REMOVE_USER_DEFAULT(User_ID);
    REMOVE_USER_DEFAULT(User_Name);
    SYN_USER_DEFAULT;
    
}

@end
