//
//  BDTransactionModel.m
//  QianYueBao
//
//  Created by Black on 17/5/18.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDTransactionModel.h"

@implementation BDTransactionModel

+ (instancetype)createModelWithDic:(NSDictionary *)dic
{
    BDTransactionModel *model = [[BDTransactionModel alloc]initWithDic:dic];
    return model;
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.out_trans_id = [NSString trimNSNullAsNoValue:[dic objectForKey:@"out_trans_id"]];
        self.pay_time = [NSString trimNSNullASTimeValue:[dic objectForKey:@"pay_time"] withStyle:@"-1"];
        self.payment_channel = [NSString trimNSNullAsNoValue:[dic objectForKey:@"payment_channel"]];
        self.payment_channel_icon = [NSString trimNSNullAsNoValue:[dic objectForKey:@"payment_channel_icon"]];
        self.payment_channel_name  =[NSString trimNSNullAsNoValue:[dic objectForKey:@"payment_channel_name"]];
        self.settle_amount = [NSString trimNSNullAsFloatero:[dic objectForKey:@"settle_amount"]];
        self.settlement_status = [NSString trimNSNullAsIntValue:[dic objectForKey:@"settlement_status"]];
        self.trans_amount = [NSString trimNSNullAsFloatero:[dic objectForKey:@"trans_amount"]];
        self.trans_amount_cny = [NSString trimNSNullAsNoValue:[dic objectForKey:@"trans_amount_cny"]];
        self.trans_id  =[NSString trimNSNullAsNoValue:[dic objectForKey:@"trans_id"]];
        
        self.finsh_status = [self getTransWthStatus:[NSString trimNSNullAsNoValue:[dic objectForKey:@"finish_status"]]];
        self.currency_sign = [NSString trimNSNullAsNoValue:[dic objectForKey:@"currency_sign"]];
        self.refund_reason  =[NSString trimNSNullAsNoValue:[dic objectForKey:@"refund_reason"]];
        self.refund_reason_type = [NSString trimNSNullASDefault:[dic objectForKey:@"refund_reason_type"] andDefault:@"-2"];
        self.refund_time = [NSString trimNSNullASTimeValue:[dic objectForKey:@"refund_time"] withStyle:@"1"];
        self.refund_succ_time = [NSString trimNSNullASTimeValue:[dic objectForKey:@"refund_succ_time"] withStyle:@"1"];
        
    }
    return self;
}

- (BDTranscationStatus )getTransWthStatus:(NSString *)status
{
    BDTranscationStatus mStatus = BDTranscationStatus_Unpay;
    if ([status isEqualToString:@"1"])
    {
        mStatus = BDTranscationStatus_Pay;
    }
    else  if ([status isEqualToString:@"2"])
    {
        mStatus = BDTranscationStatus_Progress;
    }
    else  if ([status isEqualToString:@"3"])
    {
        mStatus = BDTranscationStatus_Finish;
    }
    else
    {
        mStatus = BDTranscationStatus_Unpay;
    }
    return mStatus;
}

- (NSArray *)transTitleArray
{
    if (self.finsh_status == BDTranscationStatus_Pay || self.finsh_status == BDTranscationStatus_Unpay)
    {
        NSArray *statusArray = @[LS(@"Actual_Receivable"),LS(@"Settlement_Amount"),LS(@"Trading_Status"),LS(@"Liquidation_Status"),LS(@"Channels_Payment"),LS(@"Payment_Business")];
        NSArray *messageArray = messageArray = @[LS(@"Transaction_Time"),LS(@"Transaction_Number"),LS(@"Payment_Code")];
        return @[statusArray,messageArray];
    }
    else
    {
        NSArray * statusArray = @[LS(@"Actual_Receivable"),LS(@"Settlement_Amount"),LS(@"Trading_Status"),LS(@"Liquidation_Status"),LS(@"Channels_Payment"),LS(@"Payment_Business"),LS(@"Transaction_Time"),LS(@"Transaction_Number"),LS(@"Payment_Code")];
        NSArray * messageArray = @[LS(@"Refund_Start_Time"),LS(@"Refund_Reason")];
        return @[statusArray,messageArray];
    }
}

- (NSArray *)transMessageArray
{
    NSArray *oneArray = [NSArray new];
    NSArray *twoArray = [NSArray new];
    NSString *settleMoney = [NSString stringWithFormat:@"%@ %@",self.currency_sign,self.settle_amount];
    NSString *refundReason = @"";
    if ([self.refund_reason_type isEqualToString:@"1"])
    {
        refundReason = LS(@"Business_Negotiations");
    }
    else if ([self.refund_reason_type isEqualToString:@"2"])
    {
        refundReason = LS(@"Many_Times_Pay");
    }
    else if ([self.refund_reason_type isEqualToString:@"9"])
    {
        refundReason = self.refund_reason;
    }
    else
    {
        refundReason = @"";
    }
    NSString *status = @"";
    if ([self.settlement_status isEqualToString:@"1"])
    {
        status = LS(@"Has_Been_Cleared");
    }
    else
    {
        status = LS(@"Not_Cleared");
    }
    
    if (self.finsh_status == BDTranscationStatus_Pay || self.finsh_status == BDTranscationStatus_Unpay)
    {
        oneArray = @[self.trans_amount,settleMoney,@"",status,self.payment_channel_name,self.shopName];
        twoArray = @[self.pay_time,self.trans_id,self.out_trans_id];
    }
    else
    {
        oneArray = @[self.trans_amount,settleMoney,@"",status,self.payment_channel_name,self.shopName,self.pay_time,self.trans_id,self.out_trans_id];
        twoArray = [NSArray array];
        if (self.finsh_status == BDTranscationStatus_Finish)
        {
            twoArray = @[self.refund_succ_time,status];
        }
        else
        {
            twoArray = @[self.refund_time,status];
        }
    }
   return  @[oneArray,twoArray];
}

@end
