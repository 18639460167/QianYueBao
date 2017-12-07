//
//  BDOwnerViewModel.m
//  QianYueBao
//
//  Created by Black on 17/5/12.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDOwnerViewModel.h"

@implementation BDOwnerViewModel
@synthesize pageSize;
@synthesize pageIndex;
@synthesize orderTotal;
@synthesize ownerListArray;

- (instancetype)init
{
    if (self = [super init])
    {
        pageIndex = 0;
        pageSize = 20;
        orderTotal = 0;
        self.keyWord = @"";
        self.isRequestFail = NO;
        ownerListArray = [NSMutableArray new];
    }
    return self;
}

- (void)loadNewOwnerListKey:(NSString *)key handler:(BDHandler)complete
{
    self.isRequestFail = NO;
    pageSize = 20;
    pageIndex = 0;
    orderTotal = 0;
    self.keyWord = key;
    ownerListArray = [NSMutableArray new];
    [self getSearchOwnerList:key handler:complete];
}
- (void)loadMoreOwnerList:(BDHandler)complete
{
    if ((pageIndex+1)*pageSize >= orderTotal)
    {
        if (complete)
        {
            complete(LS(@"Not_More"));
        }
    }
    else
    {
        pageIndex ++;
        [self getSearchOwnerList:self.keyWord handler:complete];
    }
}

#pragma mark - 搜索店铺
- (void)getSearchOwnerList:(NSString *)key handler:(BDHandler)complete
{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[NSString stringWithFormat:@"%d",(int)pageIndex] forKey:@"page"];
    [param setObject:@"20" forKey:@"size"];
    [param setObject:key forKey:@"k"];
    
    [HYHttpClient doPost:@"/merchant/list.json" param:param timeInterVal:REQUEST_TIME callback:^(HYHttpsResponse *response) {
        BACK(^{
            MAIN((^{
                self.isRequestFail = YES;
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
                        orderTotal = [[NSString trimNSNullAsIntValue:[result objectForKey:TOTAL_COUNT]] integerValue];
                        if (pageIndex == 0)
                        {
                            [ownerListArray removeAllObjects];
                        }
                        id list = [result objectForKey:LIST];
                        if ([list isKindOfClass:[NSArray class]])
                        {
                            for (NSDictionary *dic in list)
                            {
                                BDOwnerModel *model = [[BDOwnerModel alloc]initWithDic:dic];
                                [ownerListArray addObject:model];
                            }
                        }
                        self.isRequestFail = NO;
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

#pragma mark - 创建店主
+ (void)createOwner:(BDOwnerModel *)model handler:(BDHandler)complete
{
    NSDictionary *dic = [model ownerWithDic];
    [HYHttpClient doPost:@"/merchant/create.do" param:dic timeInterVal:REQUEST_TIME callback:^(HYHttpsResponse *response) {
        BACK(^{
            MAIN((^{
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
                    id result = [response.mResult objectForKey:RESULT];
                    if ([result isKindOfClass:[NSDictionary class]])
                    {
                        model.account = [NSString trimNSNullAsNoValue:[result objectForKey:@"oid"]];
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

@end
