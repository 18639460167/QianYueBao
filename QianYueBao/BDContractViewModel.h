//
//  BDContractViewModel.h
//  QianYueBao
//
//  Created by Black on 17/5/22.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BDContractModel;

@interface BDContractViewModel : NSObject

@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger total_count;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, strong) NSMutableArray *contractArray;

@property (nonatomic, assign) BOOL isRequestFial;

- (void)loadNewListWithMid:(NSString *)mid handler:(BDHandler)complete;

- (void)loadMore:(BDHandler)complete;

/**
 *  获取合同列表
 *
 *  @param mid      商户ID
 *  @param complete 返回结果
 */
+ (void)getContractList:(NSString *)mid handler:(void(^)(NSString *status,NSArray *listArray))complete;


/**
 *  合同修改
 *
 *  @param mid      店铺ID
 *  @param complete 返回状态
 */
+ (void)updateContract:(NSString *)mid contractModel:(BDContractModel *)model handler:(BDHandler)complete;

@end
