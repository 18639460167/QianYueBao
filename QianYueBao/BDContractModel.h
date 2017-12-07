//
//  BDContractModel.h
//  QianYueBao
//
//  Created by Black on 17/5/9.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BDSignListModel;

@interface BDContractModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *bd_id; //合同id
@property (nonatomic, assign) TradeStatus contract_status; // 合同状态
@property (nonatomic, copy) NSString *premium_rate; // 费率
@property (nonatomic, copy) NSString *settlement_term; // 结算周期
@property (nonatomic, strong) NSArray *contract_image; // 合同照片
@property (nonatomic, strong) NSArray *payment_channel; // 支付接口
@property (nonatomic, strong) NSArray *payment_channel_val; // 支付id
@property (nonatomic, copy) NSString *update_time; // 更新时间
@property (nonatomic, copy) NSString *mid; // 店铺ID

@property (nonatomic, copy) NSString *payment_channel_string; // 支付信息

@property (nonatomic, assign) BOOL isChange; // 是否有新照片

@property (nonatomic, assign) BOOL isAllMessage; // 是否是完整信息

- (instancetype)initWithDic:(NSDictionary *)dic;

- (NSString *)statusMessage:(TradeStatus)status;

/**
 *  获取变更合同信息
 */
- (NSString *)getChangeContactMessage:(NSInteger)row;

- (void)setMessage:(NSInteger)row message:(NSString *)message;

- (void)racIsAllMessage ;

@end
