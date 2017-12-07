//
//  BDSettleMentViewModel.h
//  QianYueBao
//
//  Created by Black on 17/5/18.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDSettleMentViewModel : NSObject

@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger total_count;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, strong) NSMutableArray *settlementArray;

@property (nonatomic, assign) BOOL isRequestFial;

- (void)loadNewListWithMid:(NSString *)mid handler:(BDHandler)complete;

- (void)loadMore:(BDHandler)complete;

/**
 *  获取清算详情
 *
 *  @param mid      清算ID
 *  @param complete 返回结果
 */
+ (void)getSettleDeatil:(NSString *)mid handler:(void(^)(NSString *status,NSArray *modelArray))complete;

@end
