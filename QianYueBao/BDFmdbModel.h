//
//  BDFmdbModel.h
//  QianYueBao
//
//  Created by Black on 17/5/11.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BDSignDetailModel;
@class BDSignListModel;

@interface BDFmdbModel : NSObject

+ (instancetype)shareInstance;

/**
 *  数据库中是否存在表
 */
- (BOOL)isExistWithTableName:(NSString *)name;

/**
 *  默认简历主键ID
 创建表(如果存在就不创建)keys数据存放要求@[字段名称1,字段名称2]
 */
- (BOOL)createTableWithTableName:(NSString *)name keys:(NSArray *)keys;

/**
 *  插入 只关心key和value @{key:value,key:value}
 */
- (BOOL)insertIntoTableName:(NSString *)name Dict:(NSDictionary *)dict;

/**
 *  根据条件查询字段，返回的数组是字典(@[@{key:value},@{key:value}]) ,where形式 @[@"key",@"=",@"value",@"key",@">=",@"value"]
 */
- (NSArray *)queryWithTableName:(NSString *)name keys:(NSArray *)keys where:(NSArray *)where;

/**
 *  全部查询 返回的数组是字典( @[@{key:value},@{key:value}] )
 */
- (NSArray *)queryWithTableName:(NSString *)name;

/**
 *  根据key更新value形式@[@"key",@"=",@"value",@"key",@">=",@"value"]
 */
- (BOOL)updateWithTableName:(NSString *)name valueDict:(NSDictionary*)valueDict where:(NSArray*)where;

/**
 *  根据表名和表字段删除表内容 where形式 where形式 @[@"key",@"=",@"value",@"key",@">=",@"value"]
 */
- (BOOL)deleteWithTableName:(NSString *)name where:(NSArray *)where;

/**
 *  根据表名删除表格全部内容
 */
- (BOOL)clearTable:(NSString *)name;

/**
 *  删除表
 */
- (BOOL)dropTable:(NSString *)name;


/**
 *  缓存信息
 *
 *  @param model    详情model
 *  @param complete 返回结果
 */
+ (void)saveDetailModel:(BDSignDetailModel *)model complete:(BDHandler)complete;

///**
// *  更新信息
// *
// *  @param modle    请求model
// *  @param complete 返回结果
// */
//+ (void)updateDetailModel:(BDSignDetailModel *)modle id:(NSString *)valueID complete:(BDHandler)complete;

/**
 *  更新数据
 *
 *  @param modle     更新的model
 *  @param listModel 更新的条件
 *  @param vc        当前vc
 *  @param complete  返回结果
 */
+ (void)updateDetailModel:(BDSignDetailModel *)modle id:(BDSignListModel *)listModel currentVC:(BDSuperViewController *)vc complete:(BDHandler)complete;

@end
