//
//  BDSignDetailModel.h
//  QianYueBao
//
//  Created by Black on 17/5/9.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BDBasicMessageModel;
@class BDContractModel;
@class BDOwnerModel;
@class BDSignListModel;
@interface BDSignDetailModel : NSObject

@property (nonatomic, strong) BDBasicMessageModel *basicModel; // 基本信息
@property (nonatomic, strong) BDContractModel *contractModel; // 合同信息
@property (nonatomic, strong) BDOwnerModel *ownerModel; // 店主信息

@property (nonatomic, copy) NSString *currentTime; // 结算时间

@property (nonatomic, assign) TradeStatus status; // 状态

@property (nonatomic, copy) NSString *signID; // 唯一标示;

@property (nonatomic, assign) BOOL firstOpen;

@property (nonatomic, assign) BOOL twoOpen;

@property (nonatomic, assign) BOOL haveOwner; //是否有店主

@property (nonatomic, assign) BOOL requestSuccess; //请求是否成功


- (instancetype)initWithDic:(NSDictionary *)dic;

- (instancetype)initWithFmdbDic:(NSDictionary *)dic; 

/**
 *  获取标题数组
 *
 *  @return <#return value description#>
 */
- (NSArray *)getTitleArray;

/**
 *  根据section返回cell个数
 *
 *  @param section 指定区
 *
 *  @return 返回个数
 */
- (NSInteger)getRowCount:(NSInteger)section;

/**
 *  根据区返回cell高度
 *
 *  @param section 指定区
 *
 *  @return row高度
 */
- (CGFloat)getRowHeight:(NSInteger)section indexRow:(NSInteger)row;


/**
 *  获取所有属性
 *
 *  @return 属性数组
 */
+ (NSArray *)getAllProperties;

/**
 *  model到字典
 */
- (NSDictionary *)properties_asp;

/**
 *  请求所需字段
 *
 *  @return 返回字典
 */
- (NSDictionary *)getModelDicWithMid:(NSString *)mid;

@end
