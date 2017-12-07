//
//  BDTranctionViewModel.h
//  QianYueBao
//
//  Created by Black on 17/5/18.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BDTransactionModel;

@interface BDTranctionViewModel : NSObject

@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger total_count;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, strong) NSMutableArray *tramsArray;

@property (nonatomic, assign) BOOL isRequestFial;

- (void)loadNewListWithMid:(NSString *)mid handler:(BDHandler)complete;

- (void)loadMore:(BDHandler)complete;


/**
 *  获取交易详情
 *
 *  @param trans_id 交易ID
 *  @param complete 返回结果
 */
+ (void)getTransDetail:(NSString *)trans_id handle:(void(^)(NSString *status,BDTransactionModel*model))complete;

/**
 *  获取交易排行榜
 *
 *  @param complete 返回排行列表，最多10条
 */
+ (void)getTransRankHandler:(void(^)(NSString *status,NSArray *modelArray))complete;

@end
