//
//  BDTransactionModel.h
//  QianYueBao
//
//  Created by Black on 17/5/18.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,BDTranscationStatus) {
    BDTranscationStatus_Unpay, // 未支付
    BDTranscationStatus_Pay, // 已支付
    BDTranscationStatus_Progress, // 申请退款
    BDTranscationStatus_Finish // 已退款
};

@interface BDTransactionModel : NSObject

@property (nonatomic, copy) NSString *out_trans_id; // 交易ID
@property (nonatomic, copy) NSString *pay_time; // 支付时间
@property (nonatomic, copy) NSString *payment_channel; // 支付通道
@property (nonatomic, copy) NSString *payment_channel_icon; // 支付图标
@property (nonatomic, copy) NSString *payment_channel_name; // 支付名称
@property (nonatomic, copy) NSString *settle_amount; // 结算金额
@property (nonatomic, copy) NSString *settlement_status; // 结算状态
@property (nonatomic, copy) NSString *trans_amount;
@property (nonatomic, copy) NSString *trans_amount_cny;
@property (nonatomic, copy) NSString *trans_id;
@property (nonatomic, copy) NSString *currency_sign; // 货币单位
@property (nonatomic, copy) NSString *refund_reason; // 退款原因
@property (nonatomic, copy) NSString *refund_reason_type; // 退款类型
@property (nonatomic, copy) NSString *refund_succ_time; // 退款成功时间
@property (nonatomic, copy) NSString *refund_time; // 退款发起时间
@property (nonatomic, copy) NSString *shopName; // 商铺名称
@property (nonatomic, assign) BDTranscationStatus finsh_status; //完成状态

+ (instancetype)createModelWithDic:(NSDictionary *)dic;

- (NSArray *)transTitleArray;
- (NSArray *)transMessageArray;

@end
