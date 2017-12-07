//
//  BDSettleMentModel.h
//  QianYueBao
//
//  Created by Black on 17/5/18.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,BDSettleStatus) {
    BDSettleStatus_Success, // 提现成功
    BDSettleStatus_Progress, // 审核中
    BDSettleStatus_Fail, //  提现失败
    BDSettleStatus_Unknow // 未知
};

@interface BDSettleMentModel : NSObject

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *batch_no;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *finish_time;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *oid;
@property (nonatomic, copy) NSString *settlement_id;
@property (nonatomic, copy) NSString *currency_sign;
@property (nonatomic, assign) BDSettleStatus settleStatus;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
