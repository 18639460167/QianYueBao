//
//  BDTranctionViewModel.m
//  QianYueBao
//
//  Created by Black on 17/5/18.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDTranctionViewModel.h"

@implementation BDTranctionViewModel
@synthesize pageIndex;
@synthesize pageSize;
@synthesize total_count;
@synthesize tramsArray;

- (instancetype)init
{
    if (self = [super init])
    {
        pageIndex = 0;
        pageSize = 20;
        total_count = 0;
        self.mid = @"";
        tramsArray = [NSMutableArray new];
    }
    return self;
}

- (void)loadNewListWithMid:(NSString *)mid handler:(BDHandler)complete
{
    self.mid = mid;
    pageSize = 20;
    pageIndex = 0;
    total_count = 0;
    tramsArray  = [NSMutableArray new];
    [self getSettlementList:complete];
}

- (void)loadMore:(BDHandler)complete
{
    if ((pageIndex+1)*pageSize>=total_count)
    {
        if (complete)
        {
            complete(LS(@"Not_More"));
        };
    }
    else
    {
        pageIndex ++;
        [self getSettlementList:complete];
    }
}


#pragma mark - 请求数据
- (void)getSettlementList:(BDHandler)complete
{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[NSString stringWithFormat:@"%d",(int)pageIndex] forKey:@"page"];
    [param setObject:@"20" forKey:@"size"];
    [param setObject:self.mid forKey:@"mid"];
    [HYHttpClient doPost:@"/transaction/list.json" param:param timeInterVal:REQUEST_TIME callback:^(HYHttpsResponse *response) {
        BACK(^{
            MAIN((^{
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
                            [tramsArray removeAllObjects];
                        }
                        id list = [result objectForKey:LIST];
                        if ([list isKindOfClass:[NSArray class]])
                        {
                            for (NSDictionary *dic in list)
                            {
                                BDTransactionModel *model = [BDTransactionModel createModelWithDic:dic];
                                [tramsArray addObject:model];
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

#pragma mark - 获取交易详情
+ (void)getTransDetail:(NSString *)trans_id handle:(void (^)(NSString *, BDTransactionModel *))complete
{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[NSString trimNSNullAsNoValue:trans_id] forKey:@"trans_id"];
    [HYHttpClient doPost:@"/transaction/detail.json" param:param timeInterVal:REQUEST_TIME callback:^(HYHttpsResponse *response) {
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
                        if ([result isKindOfClass:[NSDictionary class]])
                        {
                            BDTransactionModel *model = [BDTransactionModel createModelWithDic:result];
                            complete(REQUEST_SUCCESS,model);
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

#pragma mark - 获取排行榜
+ (void)getTransRankHandler:(void (^)(NSString *, NSArray *))complete
{
    [HYHttpClient doPost:@"/transaction/rank.json" param:nil timeInterVal:REQUEST_TIME callback:^(HYHttpsResponse *response) {
        BACK(^{
            MAIN((^{
                NSLog(@"==%@",response.mResult);
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
                            BDTransRankModel *model = [BDTransRankModel createModelWithDic:dic];
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

@end
