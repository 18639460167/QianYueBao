//
//  BDSignListModel.m
//  QianYueBao
//
//  Created by Black on 17/5/9.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDSignListModel.h"

@implementation BDSignListModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.create_time = [NSString trimNSNullASTimeValue:[dic objectForKey:@"create_time"] withStyle:@"0"];
        self.upadte_time = [NSString trimNSNullASTimeValue:[dic objectForKey:@"update_time"] withStyle:@"0"];
        self.sign_mid = [NSString trimNSNullASDefault:[dic objectForKey:@"mid"] andDefault:@"-1"];
        self.title = [NSString trimNSNullAsNoValue:[dic objectForKey:@"title"]];
        NSString *status = [NSString trimNSNullASDefault:[dic objectForKey:@"publish_status"] andDefault:@"-2"];
        self.contract_status = [self tradeStatus:status];
        
        self.comp_platform = [NSMutableArray new];
        [self.comp_platform addObject:[self getTradeStatus:self.contract_status]];
        id object = [dic objectForKey:@"comp_platform"];
        if ([object isKindOfClass:[NSArray class]])
        {
            for (NSString *comp in object)
            {
                [self.comp_platform addObject:comp];
            }
        }
    }
    return self;
}

- (instancetype)initWithDetail:(BDSignDetailModel *)model
{
    if (self = [super init])
    {
        self.title = model.basicModel.title;
        self.upadte_time = model.currentTime;
        self.contract_status = model.status;
        self.sign_mid = model.signID;
        self.comp_platform = [NSMutableArray new];
        [self.comp_platform addObject:[self getTradeStatus:self.contract_status]];
        for (NSString *message in model.basicModel.comp_platform_val)
        {
            [self.comp_platform addObject:message];
        }
    }
    return self;
}

- (TradeStatus)tradeStatus:(NSString *)status
{
    TradeStatus tradeStatus = TradeStatus_UnKnow;
    if ([status isEqualToString:@"-1"])
    {
        tradeStatus = TradeStatus_Fail;
    }
    else if ([status isEqualToString:@"1"])
    {
        tradeStatus = TradeStatus_Finish;
    }
    else if ([status isEqualToString:@"0"])
    {
        tradeStatus = TradeStatus_Process;
    }
    else if ([status isEqualToString:@"2"])
    {
        tradeStatus = TradeStatus_Wait;
    }
    else
    {
        tradeStatus = TradeStatus_UnKnow;
    }
    return tradeStatus;
}

- (NSString *)getTradeStatus:(TradeStatus)status
{
    NSString *tradeStatus = LS(@"Unknow");
    switch (status)
    {
        case TradeStatus_Finish:
        {
            tradeStatus = LS(@"Has_Been_Signed");
        }
            break;
        case TradeStatus_Process:
        {
            tradeStatus = LS(@"Under_Review");
        }
            break;
        case TradeStatus_Fail:
        {
            tradeStatus = LS(@"Review_Fail");
        }
            break;
        case TradeStatus_Wait:
        {
            tradeStatus = LS(@"Wait_Submit");
        }
            break;
            
        default:
            break;
    }
    return tradeStatus;
}


@end
