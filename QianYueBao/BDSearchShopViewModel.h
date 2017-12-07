//
//  BDSearchShopViewModel.h
//  QianYueBao
//
//  Created by Black on 17/5/8.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDSearchShopViewModel : NSObject

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger orderTotal;
@property (nonatomic, copy) NSString *total_count; //签约数量
@property (nonatomic, copy) NSString *week_sale; // 交易额
@property (nonatomic, strong) NSMutableArray *signListArray; // 签约数组
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, assign) BOOL isRequestFail; // 是否请求失败

/**
 *  刷新数据
 *  签约状态,0-审核中,1-审核通过,-1-审核失败
 *  @param complete 返回状态
 */
- (void)loadNewSignList:(NSString *)keyWord handler:(BDHandler)complete;

/**
 *  加载更多
 *
 *  @param complete 返回状态
 */
- (void)loadMoreSignList:(BDHandler)complete;


@end
