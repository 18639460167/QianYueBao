//
//  BDBasicMessageModel.h
//  QianYueBao
//
//  Created by Black on 17/5/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBasicMessageModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *commercial_circle; // 商圈
@property (nonatomic, strong) NSArray *comp_platform; // 竞品
@property (nonatomic, strong) NSArray *comp_platform_val; // id数组
@property (nonatomic, copy) NSString *create_time; // 创建时间
@property (nonatomic, copy) NSString *geo_address; // 详细地址
@property (nonatomic, copy) NSString *geo_lat; // 纬度
@property (nonatomic, copy) NSString *geo_lng; // 经度
@property (nonatomic, copy) NSString *loc_city; // 市
@property (nonatomic, copy) NSString *loc_country; //国家
@property (nonatomic, copy) NSString *country_code; // 国家id
@property (nonatomic, copy) NSString *loc_state; // 省
@property (nonatomic, strong) NSArray *support_service; //提供服务
@property (nonatomic, strong) NSArray *support_service_val;// 提供服务ID
@property (nonatomic, copy) NSString *title; // 店名
@property (nonatomic, copy) NSString *update_time; // 更新时间
@property (nonatomic, copy) NSString *mID; // 店铺ID
@property (nonatomic, copy) NSString *oId; // 订单id
@property (nonatomic, copy) NSString *cat_id; // 类目ID
@property (nonatomic, copy) NSString *category; // 类目

@property (nonatomic, copy) NSString *shopLogo;// 店铺logo
@property (nonatomic, strong) NSArray *thumbnails; // 店铺详情缩略图
@property (nonatomic, assign) BOOL isChange; // 图片是否变化

@property (nonatomic, copy) NSString *comp_platform_string; // 竞品信息
@property (nonatomic, copy) NSString *support_service_message; //服务信息


- (instancetype)initWithDic:(NSDictionary *)dic;

/**
 *  model 赋值
 *
 *  @param row   指定cell
 *  @param title 信息
 */
- (void)setMessage:(NSInteger)row title:(NSString *)title;

/**
 *  获取model信息
 *
 *  @param row   指定row
 *  @param title 信息
 */
- (NSString *)getMessage:(NSInteger)row;

@end
