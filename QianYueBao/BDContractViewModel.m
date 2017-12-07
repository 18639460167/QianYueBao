//
//  BDContractViewModel.m
//  QianYueBao
//
//  Created by Black on 17/5/22.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDContractViewModel.h"

@implementation BDContractViewModel
@synthesize pageIndex;
@synthesize pageSize;
@synthesize total_count;
@synthesize contractArray;

- (instancetype)init
{
    if (self = [super init])
    {
        pageIndex = 0;
        pageSize = 20;
        total_count = 0;
        self.mid = @"";
        contractArray = [NSMutableArray new];
    }
    return self;
}

- (void)loadNewListWithMid:(NSString *)mid handler:(BDHandler)complete
{
    self.mid = mid;
    pageSize = 20;
    pageIndex = 0;
    total_count = 0;
    contractArray  = [NSMutableArray new];
    [self getSettlementList:complete];
}

- (void)loadMore:(BDHandler)complete
{
    if ((pageIndex+1)*pageSize>=total_count)
    {
        if (complete)
        {
            complete(LS(@"Not_More"));
        }
    }
    else
    {
        pageIndex ++;
        [self getSettlementList:complete];
    }
}

#pragma mark - 获取合同列表
- (void)getSettlementList:(BDHandler)complete
{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:self.mid forKey:@"mid"];
    [HYHttpClient doPost:@"/contract/list.json" param:param timeInterVal:REQUEST_TIME callback:^(HYHttpsResponse *response) {
        BACK(^{
            MAIN((^{
                NSLog(@"==%@",response.mResult);
                self.isRequestFial = YES;
                if (response.mStatus == HY_HTTP_UNLOGIN)
                {
                    complete(NEED_LOGIN);
                }
                else if (response.mStatus == HY_HTTP_UNRIGHTMESSAGE)
                {
                    id jsObject=response.mResult;
                    if ([jsObject isKindOfClass:[NSDictionary class]])
                    {
                        complete([NSString trimNSNullAsNoValue:[jsObject objectForKey:@"errmsg"]]);
                    }
                    else
                    {
                        complete(LS(@"Disconnect_Internet"));
                    }
                }
                else if (response.mStatus == HY_HTTP_OK)
                {
                    id jsObject = response.mResult;
                    id result = [jsObject objectForKey:RESULT];
                    if ([result isKindOfClass:[NSDictionary class]])
                    {
                        pageIndex = [[NSString trimNSNullAsIntValue:[result objectForKey:PAGE]] integerValue];
                        total_count = [[NSString trimNSNullAsIntValue:[result objectForKey:TOTAL_COUNT]] integerValue];
                        if (pageIndex == 0)
                        {
                            [contractArray removeAllObjects];
                        }
                        id list = [result objectForKey:LIST];
                        if ([list isKindOfClass:[NSArray class]])
                        {
                            for (NSDictionary *dic in list)
                            {
                                BDContractModel *model = [[BDContractModel alloc]initWithDic:dic];
                                [contractArray addObject:model];
                            }
                        }
                        self.isRequestFial = NO;
                        complete(REQUEST_SUCCESS);
                    }
                    else
                    {
                        complete(LS(@"Disconnect_Internet"));
                    }
                }
                else
                {
                    complete(LS(@"Disconnect_Internet"));
                }
            }));
        });
        
    }];

}


+ (void)getContractList:(NSString *)mid handler:(void (^)(NSString *, NSArray *))complete
{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:mid forKey:@"mid"];
    [HYHttpClient doPost:@"/contract/list.json" param:param timeInterVal:REQUEST_TIME callback:^(HYHttpsResponse *response) {
        BACK(^{
            MAIN((^{
                if (response.mStatus == HY_HTTP_UNLOGIN)
                {
                    complete(NEED_LOGIN,nil);
                }
                else if (response.mStatus == HY_HTTP_UNRIGHTMESSAGE)
                {
                    id jsObject=response.mResult;
                    if ([jsObject isKindOfClass:[NSDictionary class]])
                    {
                        complete([NSString trimNSNullAsNoValue:[jsObject objectForKey:@"errmsg"]],nil);
                    }
                    else
                    {
                        complete(LS(@"Disconnect_Internet"),nil);
                    }
                }
                else if (response.mStatus == HY_HTTP_OK)
                {
                    id jsObject = response.mResult;
                    id result = [jsObject objectForKey:RESULT];
                    if ([result isKindOfClass:[NSArray class]])
                    {
                        NSMutableArray *modelArray = [NSMutableArray new];
                        for (NSDictionary *dic in result)
                        {
                            BDContractModel *model = [[BDContractModel alloc]initWithDic:dic];
                            [modelArray addObject:model];
                        }
                        complete(REQUEST_SUCCESS,modelArray);
                    }
                    else
                    {
                        complete(LS(@"Disconnect_Internet"),nil);
                    }
                }
                else
                {
                    complete(LS(@"Disconnect_Internet"),nil);
                }
            }));
        });

    }];
}

#pragma mark - 修改合同
+ (void)updateContract:(NSString *)mid contractModel:(BDContractModel *)model handler:(BDHandler)complete
{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[NSString trimNSNullAsNoValue:mid] forKey:@"mid"];
    [param setObject:[NSString trimNSNullAsFloatero:model.premium_rate] forKey:@"mdr"];
    [param setObject:[NSString getMessageWithArray:model.payment_channel] forKey:@"payment_channel"];
    [param setObject:[NSString trimNSNullAsNoValue:model.settlement_term] forKey:@"settlement_term"];
    [param setObject:[NSString getMessageWithArray:model.contract_image] forKey:@"contract_image"];
    NSLog(@"==%@",param);
    [HYHttpClient doPost:@"/contract/update.do" param:param timeInterVal:REQUEST_TIME callback:^(HYHttpsResponse *response) {
        BACK(^{
            MAIN((^{
                NSLog(@"contract==%@",response.mResult);
                if (response.mStatus == HY_HTTP_UNLOGIN)
                {
                    complete(NEED_LOGIN);
                }
                else if (response.mStatus == HY_HTTP_UNRIGHTMESSAGE)
                {
                    id jsObject=response.mResult;
                    if ([jsObject isKindOfClass:[NSDictionary class]])
                    {
                        complete([NSString trimNSNullAsNoValue:[jsObject objectForKey:@"errmsg"]]);
                    }
                    else
                    {
                        complete(LS(@"Disconnect_Internet"));
                    }
                }
                else if (response.mStatus == HY_HTTP_OK)
                {
                    complete(REQUEST_SUCCESS);
                }
                else
                {
                    complete(LS(@"Disconnect_Internet"));
                }
            }));
        });
    }];
}

@end
