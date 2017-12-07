//
//  BDSettleMentViewModel.m
//  QianYueBao
//
//  Created by Black on 17/5/18.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDSettleMentViewModel.h"

@implementation BDSettleMentViewModel
@synthesize pageIndex;
@synthesize pageSize;
@synthesize total_count;
@synthesize settlementArray;

- (instancetype)init
{
    if (self = [super init])
    {
        pageIndex = 0;
        pageSize = 20;
        total_count = 0;
        self.mid = @"";
        settlementArray = [NSMutableArray new];
    }
    return self;
}

- (void)loadNewListWithMid:(NSString *)mid handler:(BDHandler)complete
{
    self.mid = mid;
    pageSize = 20;
    pageIndex = 0;
    total_count = 0;
    settlementArray  = [NSMutableArray new];
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

#pragma mark - 请求数据
- (void)getSettlementList:(BDHandler)complete
{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[NSString stringWithFormat:@"%d",(int)pageIndex] forKey:@"page"];
    [param setObject:@"20" forKey:@"size"];
    [param setObject:self.mid forKey:@"mid"];
    [HYHttpClient doPost:@"/settlement/list.json" param:param timeInterVal:REQUEST_TIME callback:^(HYHttpsResponse *response) {
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
                            [settlementArray removeAllObjects];
                        }
                        id list = [result objectForKey:LIST];
                        if ([list isKindOfClass:[NSArray class]])
                        {
                            for (NSDictionary *dic in list)
                            {
                                BDSettleMentModel *model = [[BDSettleMentModel alloc]initWithDic:dic];
                                [settlementArray addObject:model];
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

#pragma mark - 获取清算详情

+ (void)getSettleDeatil:(NSString *)mid handler:(void (^)(NSString *, NSArray *))complete
{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:mid forKey:@"settlement_id"];
    [HYHttpClient doPost:@"/settlement/detail.json" param:param timeInterVal:REQUEST_TIME callback:^(HYHttpsResponse *response) {
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
                        NSArray *array = [NSString trimNsNullAsArray:[result objectForKey:@"trans_list"]];
                        NSMutableArray *dataArray = [NSMutableArray new];
                        for (NSDictionary *dic in array)
                        {
                            BDTransactionModel *model = [BDTransactionModel createModelWithDic:dic];
                            [dataArray addObject:model];
                        }
                        complete(REQUEST_SUCCESS,dataArray);
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
