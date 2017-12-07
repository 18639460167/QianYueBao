//
//  BDLoginViewModel.m
//  QianYueBao
//
//  Created by Black on 17/5/2.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDLoginViewModel.h"

@implementation BDLoginViewModel

+ (void)loginWithUserName:(NSString *)name password:(NSString *)psw complete:(actionHandle)complete
{
    NSMutableDictionary*param = [[NSMutableDictionary alloc]init];
    [param setObject:psw forKey:@"psw"];
    [param setObject:name forKey:@"username"];
    
    [HYHttpClient noHeadPost:@"/sso/login.do" param:param timeInterVal:REQUEST_TIME callback:^(HYHttpsResponse *response) {
        BACK(^{
            MAIN((^{
                id jsObject=response.mResult;
                if (response.mStatus == HY_HTTP_FAILED)
                {
                    complete(LS(@"Disconnect_Internet"));
                }
                else if (response.mStatus == HY_HTTP_OK)
                {
                    id result = [jsObject objectForKey:RESULT];
                    if ([result isKindOfClass:[NSDictionary class]])
                    {
                        [[BDAccountService sharedService] saveWithDic:result];
                        complete(REQUEST_SUCCESS);
                    }
                    else
                    {
                        complete(LS(@"Disconnect_Internet"));
                    }
                }
                else
                {
                    if ([jsObject isKindOfClass:[NSDictionary class]])
                    {
                        complete([NSString trimNSNullAsNoValue:[jsObject objectForKey:ERRMSG]]);
                    }
                    else
                    {
                        complete(LS(@"Disconnect_Internet"));
                    }
                }
            }));
        });
    }];
}

#pragma mark - 退出登录
+ (void)logoutHandler:(actionHandle)complete
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [HYHttpClient doPost:@"/sso/logout.do" param:param timeInterVal:REQUEST_TIME callback:^(HYHttpsResponse *response) {
        BACK(^{
            MAIN((^{
                id jsObject=response.mResult;
                [[BDAccountService sharedService] logout];
                if (response.mStatus==HY_HTTP_FAILED)
                {
                    complete(LS(@"Disconnect_Internet"));
                }
                else if (response.mStatus==HY_HTTP_UNRIGHTMESSAGE)
                {
                    complete([NSString trimNSNullAsNoValue:[jsObject objectForKey:ERRMSG]]);
                }
                else
                {
                    complete(NEED_LOGIN);
                }
            }));
        });
    }];
}

@end
