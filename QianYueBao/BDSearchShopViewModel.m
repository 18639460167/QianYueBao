//
//  BDSearchShopViewModel.m
//  QianYueBao
//
//  Created by Black on 17/5/8.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDSearchShopViewModel.h"

@implementation BDSearchShopViewModel
@synthesize orderTotal;
@synthesize pageIndex;
@synthesize pageSize;
@synthesize total_count;
@synthesize week_sale;
@synthesize signListArray;

- (instancetype)init
{
    if (self = [super init])
    {
        signListArray = [NSMutableArray new];
        pageIndex = 0;
        pageSize = 20;
        orderTotal = 0;
        total_count = @"0";
        week_sale = @"0";
    }
    return self;
}

- (void)loadNewSignList:(NSString *)keyWord handler:(BDHandler)complete
{
    pageIndex = 0;
    total_count = @"0";
    week_sale = @"0";
    self.keyWord = keyWord;
    signListArray = [[NSMutableArray alloc]init];
    [self getSearchSignList:keyWord handler:complete];
}

- (void)loadMoreSignList:(BDHandler)complete
{
    if ((pageIndex +1)*pageSize>=[total_count integerValue])
    {
        complete(LS(@"Not_More"));
    }
    else
    {
        pageIndex ++;
        [self getSearchSignList:self.keyWord handler:complete];
    }
}

#pragma mark - search action
- (void)getSearchSignList:(NSString *)keyWord handler:(BDHandler)complete
{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[NSString stringWithFormat:@"%d",(int)pageIndex] forKey:@"page"];
    [param setObject:@"20" forKey:@"size"];
    [param setObject:keyWord forKey:@"k"];
    
    [HYHttpClient doPost:@"/shop/search.do" param:param timeInterVal:REQUEST_TIME callback:^(HYHttpsResponse *response) {
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
                        pageIndex = [[NSString trimNSNullAsIntValue:[result objectForKey:@"page"]] integerValue];
                        total_count = [NSString trimNSNullAsIntValue:[result objectForKey:@"total_count"]];
                        week_sale = [NSString trimNSNullAsFloatero:[result objectForKey:@"week_sale"]];
                        if (pageIndex == 0)
                        {
                            [signListArray removeAllObjects];
                        }
                        id list = [result objectForKey:@"list"];
                        if ([list isKindOfClass:[NSArray class]])
                        {
                            for (NSDictionary *dic in list)
                            {
                                BDSignListModel *model = [[BDSignListModel alloc]initWithDic:dic];
                                [signListArray addObject:model];
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

@end
