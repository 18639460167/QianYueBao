//
//  BDSignListModel.h
//  QianYueBao
//
//  Created by Black on 17/5/9.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BDSignDetailModel;

typedef NS_ENUM(NSInteger, TradeStatus)
{
    TradeStatus_Finish, // 已完成
    TradeStatus_Process,// 审核中
    TradeStatus_Wait, // 待提交
    TradeStatus_Fail, // 审核失败
    TradeStatus_UnKnow // 未知
};

@interface BDSignListModel : NSObject


@property (nonatomic, strong) NSMutableArray *comp_platform; // 竞品数组
@property (nonatomic, assign) TradeStatus contract_status; // 合同状态
@property (nonatomic, copy) NSString *create_time; // 创建时间
@property (nonatomic, copy) NSString *sign_mid; // 订单id
@property (nonatomic, copy) NSString *title; // 店名
@property (nonatomic, copy) NSString *upadte_time; // 更新时间

@property (nonatomic, strong) BDSignDetailModel *detailModel; // 详情model
@property (nonatomic, copy) NSString *detailID; // 数据库ID

@property (nonatomic, assign) BOOL isFmdb;// 是否是fmdb

- (NSString *)getTradeStatus:(TradeStatus)status;

- (instancetype)initWithDic:(NSDictionary *)dic;

- (instancetype)initWithDetail:(BDSignDetailModel *)model;

@end
