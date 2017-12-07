//
//  BDHomeViewModel.m
//  QianYueBao
//
//  Created by Black on 17/5/8.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDHomeViewModel.h"

@implementation BDHomeViewModel
@synthesize orderTotal;
@synthesize pageIndex;
@synthesize pageSize;
@synthesize total_count;
@synthesize week_sale;
@synthesize signListArray;
@synthesize tradeStatus;
@synthesize RequestFail;
@synthesize currency_sign;

- (instancetype)init
{
    if (self = [super init])
    {
        signListArray = [NSMutableArray new];
        pageIndex = 0;
        pageSize = 20;
        orderTotal = 0;
        tradeStatus = TradeStatus_Finish;
        total_count = @"0";
        week_sale = @"0";
        RequestFail = NO;
    }
    return self;
}

- (void)loadNewSignList:(BDHandler)complete
{
    pageIndex = 0;
    total_count = @"0";
    week_sale = @"0";
    orderTotal = 0;
    currency_sign = @"";
    signListArray = [[NSMutableArray alloc]init];
    [self getSignList:complete];
}
- (void)loadMoreSignList:(BDHandler)complete
{
    if ((pageIndex +1)*pageSize>=[total_count integerValue])
    {
        if (complete)
        {
            complete(LS(@"Not_More"));
        }
    }
    else
    {
        pageIndex ++;
        [self getSignList:complete];
    }
}

- (BOOL)canLoadMore
{
    if ((pageIndex +1)*pageSize>=[total_count integerValue])
    {
        return  NO;
    }
    return YES;
}

#pragma mark - 数据处理
- (void)getSignList:(BDHandler)complete
{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[NSString stringWithFormat:@"%d",(int)pageIndex] forKey:@"page"];
    [param setObject:@"20" forKey:@"size"];
    [param setObject:[self getStatus:tradeStatus] forKey:@"publish_status"];
    [HYHttpClient doPost:@"/shop/list.json" param:param timeInterVal:REQUEST_TIME callback:^(HYHttpsResponse *response) {
        BACK(^{
            MAIN((^{
                NSLog(@"%@",response.mResult);
                self.RequestFail = YES;
                if (response.mStatus == HY_HTTP_UNLOGIN)
                {
                    complete(NEED_LOGIN);
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
                        currency_sign = [NSString trimNSNullAsNoValue:[result objectForKey:@"currency_sign"]];
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
                        self.RequestFail = NO;
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

- (NSString *)getStatus:(TradeStatus)status
{
    NSString *message = @"2";
    switch (status)
    {
        case TradeStatus_Finish:
            message = @"1";
            break;
        case TradeStatus_Process:
            message = @"0";
            break;
        case TradeStatus_Fail:
            message = @"-1";
            break;
            
        default:
            break;
    }
    return message;
}

#pragma mark - 加载本地数据
- (void)loadFmdbDataWithArray:(NSMutableArray *)modelArray
{
    NSArray *arr = [[BDFmdbModel shareInstance] queryWithTableName:READ_SHOP_SIGN(User_ID)];
    NSMutableArray *fmArray = [NSMutableArray new];
    for (int i=0; i<arr.count; i++)
    {
        id obj = arr[i];
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            BDSignDetailModel *model = [[BDSignDetailModel alloc]initWithFmdbDic:obj];
            BDSignListModel *listModel = [[BDSignListModel alloc]initWithDetail:model];
            listModel.detailID = [obj objectForKey:@"id"];
            listModel.detailModel = model;
            listModel.isFmdb = YES;
            [fmArray addObject:listModel];
        }
    }
    for (BDSignListModel *model in fmArray)
    {
        int a=-1;
        for (int i=0; i<modelArray.count; i++)
        {
            BDSignListModel *kModel = modelArray[i];
            if ([model.sign_mid isEqualToString:@"-1"])
            {
                continue;
            }
            else
            {
                if ([kModel.sign_mid isEqualToString:model.sign_mid])
                {
                    a = i;
                    continue;
                }
            }
        }
        if (a == -1)
        {
            [modelArray insertObject:model atIndex:0];
        }
        else
        {
            [modelArray replaceObjectAtIndex:a withObject:model];
        }
    }
}

#pragma mark - 获取商户详细信息
+ (void)merchantShopDetail:(NSString *)mid handler:(void (^)(NSString *, BDSignDetailModel *))complete
{
    NSMutableDictionary *param  =[NSMutableDictionary new];
    [param setObject:mid forKey:@"mid"];
    [HYHttpClient doPost:@"/shop/detail.json" param:param timeInterVal:REQUEST_TIME callback:^(HYHttpsResponse *response) {
        BACK(^{
            MAIN((^{
                if (response.mStatus == HY_HTTP_UNLOGIN)
                {
                    complete(NEED_LOGIN,nil);
                }
                else if (response.mStatus == HY_HTTP_OK)
                {
                    id jsObject = response.mResult;
                    if ([jsObject isKindOfClass:[NSDictionary class]])
                    {
                        id result = [jsObject objectForKey:RESULT];
                        if ([result isKindOfClass:[NSDictionary class]])
                        {
                            BDSignDetailModel *model = [[BDSignDetailModel alloc]initWithDic:result];
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
                }
                else
                {
                    complete(LS(@"Disconnect_Internet"),nil);
                }
            }));
        });

    }];
}

#pragma mark - 创建新店铺

+ (void)merchantCreateShop:(BDSignDetailModel *)model status:(TradeStatus)status handler:(BDHandler)complete
{
    if (status == TradeStatus_Fail)
    {
        [self resubmitShopMessage:model handler:complete];
    }
    else
    {
        NSDictionary *dic = [model getModelDicWithMid:nil];
        [HYHttpClient doPost:@"/shop/create.do" param:dic timeInterVal:REQUEST_TIME callback:^(HYHttpsResponse *response) {
            BACK(^{
                MAIN((^{
                    NSLog(@"==%@",response.mResult);
                    if (response.mStatus == HY_HTTP_UNLOGIN)
                    {
                        complete(NEED_LOGIN);
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

}

#pragma mark - 修改店铺信息
+ (void)updateShopMessage:(NSString *)mid shop:(BDSignDetailModel *)model hadnler:(BDHandler)complete
{
    NSDictionary *param = [model getModelDicWithMid:mid];
    [HYHttpClient doPost:@"/shop/update.do" param:param timeInterVal:REQUEST_TIME callback:^(HYHttpsResponse *response) {
        BACK(^{
            MAIN((^{
                if (response.mStatus == HY_HTTP_UNLOGIN)
                {
                    complete(NEED_LOGIN);
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

#pragma mark - 重新提交
+ (void)resubmitShopMessage:(BDSignDetailModel *)model handler:(BDHandler)complete
{
    [BDContractViewModel updateContract:model.basicModel.mID contractModel:model.contractModel handler:^(id value) {
        if ([value isEqualToString:REQUEST_SUCCESS])
        {
            [self updateShopMessage:model.basicModel.mID shop:model hadnler:^(id value) {
                complete(value);
            }];
        }
        else
        {
            BACK(^{
                MAIN((^{
                    complete(value);
                }));
            });
            
        }
    }];
}

@end
