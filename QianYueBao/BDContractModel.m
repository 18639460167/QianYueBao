//
//  BDContractModel.m
//  QianYueBao
//
//  Created by Black on 17/5/9.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDContractModel.h"

@implementation BDContractModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.bd_id = [NSString trimNSNullASDefault:[dic objectForKey:@"bd_id"] andDefault:@"-1"];
        self.premium_rate = [NSString trimNSNullAsNoValue:[dic objectForKey:@"mdr"]];
        self.settlement_term = [NSString trimNSNullAsNoValue:[dic objectForKey:@"settlement_term"]];
        NSString *status = [NSString trimNSNullASDefault:[dic objectForKey:@"contract_status"] andDefault:@"-2"];
        self.contract_status = [self tradeStatus:status];
        
        self.contract_image = [NSString trimNsNullAsArray:[dic objectForKey:@"contract_image"]];
        self.payment_channel = [NSString trimNsNullAsArray:[dic objectForKey:@"payment_channel"]];
        self.payment_channel_val = [NSString trimNsNullAsArray:[dic objectForKey:@"payment_channel_val"]];
        
        self.payment_channel_string = [NSString getMessageWithArray:self.payment_channel_val];
        self.update_time = [NSString trimNSNullASTimeValue:[dic objectForKey:@"update_time"] withStyle:@"1"];
        self.mid = [NSString trimNSNullAsNoValue:[dic objectForKey:@"mid"]];
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

- (NSString *)statusMessage:(TradeStatus)status
{
    
    NSString *message = @"";
    switch (status)
    {
        case TradeStatus_Fail:
        {
            message = LS(@"Review_Fail");
        }
            break;
        case TradeStatus_Process:
        {
            message = LS(@"Under_Review");
        }
            break;
        case TradeStatus_Finish:
        {
            message = LS(@"Contract_Inforce");
        }
            break;
        default:
        {
            message = LS(@"Contract_Expired");
        }
            break;
    }
    return message;

}

/**
 *  获取变更合同信息
 */
- (NSString *)getChangeContactMessage:(NSInteger)row
{
    NSString *message = @"";
    switch (row)
    {
        case 0:
        {
            message = self.premium_rate;
        }
            break;
        case 2:
        {
            self.payment_channel_string = [NSString getMessageWithArray:self.payment_channel_val];
            message = self.payment_channel_string;
        }
            break;
        case 3:
        {
            message = self.settlement_term;
        }
            break;
            
        default:
            break;
    }
    return message;
}

- (void)setMessage:(NSInteger)row message:(NSString *)message
{
    switch (row)
    {
        case 0:
        {
             self.premium_rate = message;
        }
            break;
        case 2:
        {
            self.payment_channel_string = message;
        }
            break;
        case 3:
        {
            self.settlement_term = message;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 归档解档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i=0; i<count; i++)
    {
        const char*name = ivar_getName(ivars[i]);
        NSString *key= [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    free(ivars);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        unsigned int count = 0;
        // ivar 定义对象的实例变量，包括类型和名字
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i=0; i<count; i++)
        {
            const char *name = ivar_getName(ivars[i]);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}

#pragma mark - 监听全部信息
- (void)racIsAllMessage
{
    RACSignal *preSigal = [RACObserve(self,premium_rate) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    RACSignal *paySigal = [RACObserve(self,payment_channel_string) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    RACSignal *setSigal = [RACObserve(self,settlement_term) map:^id(id value) {
        return @(![value isEqualToString:@""]);
    }];
    RACSignal *imageSigal = [RACObserve(self,contract_image) map:^id(id value) {
        NSArray *array = value;
        return @(array.count!=0);
    }];
    
    [[RACSignal combineLatest:@[preSigal,paySigal,imageSigal,setSigal] reduce:^id(NSNumber *valid1 , NSNumber *valid2,NSNumber *valid3,NSNumber *valid4){
        return @([valid1 boolValue] && [valid2 boolValue] && [valid3 boolValue] && [valid4 boolValue]
        );
    }]
     subscribeNext:^(NSNumber *isOK) {
         self.isAllMessage = [isOK boolValue];
     }];
}

@end
