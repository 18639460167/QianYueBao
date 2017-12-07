//
//  BDHomeViewModel.h
//  QianYueBao
//
//  Created by Black on 17/5/8.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "BDSignMessageModel.h"
@class BDSignDetailModel;
@class BDSignListModel;

@interface BDHomeViewModel : NSObject

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger orderTotal;
@property (nonatomic, assign) TradeStatus tradeStatus; // 签约状态
@property (nonatomic, copy) NSString *total_count; //签约数量
@property (nonatomic, copy) NSString *week_sale; // 交易额
@property (nonatomic, copy) NSString *currency_sign; // 货币单位
@property (nonatomic, strong) NSMutableArray *signListArray; // 签约数组

@property (nonatomic, assign) BOOL RequestFail; // 是否请求失败

/**
 *  刷新数据
 *  签约状态,0-审核中,1-审核通过,-1-审核失败
 *  @param complete 返回状态
 */
- (void)loadNewSignList:(BDHandler)complete;

/**
 *  加载更多
 *
 *  @param complete 返回状态
 */
- (void)loadMoreSignList:(BDHandler)complete;


- (void)loadFmdbDataWithArray:(NSMutableArray *)modelArray;


/**
 *  获取商户详细信息
 *
 *  @param mid      店铺id
 *  @param complete 返回结果
 */
+ (void)merchantShopDetail:(NSString *)mid handler:(void(^)(NSString *status,BDSignDetailModel *model))complete;

/**
 *  创建新店铺
 *
 *  @param model    店铺详情
 *  @param complete 返回结果
 */
+ (void)merchantCreateShop:(BDSignDetailModel *)model status:(TradeStatus)status handler:(BDHandler)complete;

/**
 *  修改店铺信息
 *
 *  @param mid      店铺ID
 *  @param model    详情model
 *  @param complete 返回结果
 */
+ (void)updateShopMessage:(NSString *)mid shop:(BDSignDetailModel *)model hadnler:(BDHandler)complete;

/**
 *  重新提交
 *
 *  @param model    店铺详情
 *  @param complete 返回结果
 */
+ (void)resubmitShopMessage:(BDSignDetailModel *)model handler:(BDHandler)complete;

@end
