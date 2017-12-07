//
//  BDSettleMentModel.m
//  QianYueBao
//
//  Created by Black on 17/5/18.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDSettleMentModel.h"

@implementation BDSettleMentModel
- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.amount = [NSString trimNSNullAsFloatero:[dic objectForKey:@"amount"]];
        self.batch_no = [NSString trimNSNullAsNoValue:[dic objectForKey:@"batch_no"]];
        self.create_time = [NSString trimNSNullASTimeValue:[dic objectForKey:@"create_time"] withStyle:@"-1"];
        self.finish_time = [NSString trimNSNullASTimeValue:[dic objectForKey:@"finish_time"] withStyle:@"-1"];
        self.mid = [NSString trimNSNullAsNoValue:[dic objectForKey:@"mid"]];
        self.oid = [NSString trimNSNullAsNoValue:[dic objectForKey:@"oid"]];
        self.settlement_id = [NSString trimNSNullAsNoValue:[dic objectForKey:@"settlement_id"]];
        NSString *stratus = [NSString trimNSNullASDefault:[dic objectForKey:@"settlement_status"] andDefault:@"100"];
        self.settleStatus = [self getStatus:stratus];
        self.currency_sign = [NSString trimNSNullAsNoValue:[dic objectForKey:@"currency_sign"]];
    }
    return self;
}

- (BDSettleStatus)getStatus:(NSString *)message
{
    BDSettleStatus status = BDSettleStatus_Unknow;
    if ([message isEqualToString:@"-1"])
    {
        status = BDSettleStatus_Fail;
    }
    else if ([message isEqualToString:@"1"])
    {
        status = BDSettleStatus_Success;
    }
    else if ([message isEqualToString:@"0"])
    {
        status = BDSettleStatus_Progress;
    }
    return status;
}

@end
