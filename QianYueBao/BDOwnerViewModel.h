//
//  BDOwnerViewModel.h
//  QianYueBao
//
//  Created by Black on 17/5/12.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BDOwnerModel;

@interface BDOwnerViewModel : NSObject

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger orderTotal;

@property (nonatomic, copy) NSString *keyWord; // 关键字
@property (nonatomic, strong) NSMutableArray *ownerListArray; // 店主列表
@property (nonatomic, assign) BOOL isRequestFail; // 是否请求失败

/**
 *  刷新数据
 *
 *  @param key      关键值
 *  @param complete 返回结果
 */
- (void)loadNewOwnerListKey:(NSString *)key handler:(BDHandler)complete;

/**
 *  加载更多
 *
 *  @param complete 返回结果
 */
- (void)loadMoreOwnerList:(BDHandler)complete;

/**
 *  创建店主
 *
 *  @param model    店主信息
 *  @param complete 返回结果
 */
+ (void)createOwner:(BDOwnerModel *)model handler:(BDHandler)complete;

@end
