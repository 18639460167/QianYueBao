//
//  BDCommonVieModel.h
//  QianYueBao
//
//  Created by Black on 17/5/12.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDCommonVieModel : NSObject

/**
 *  上传多张图片
 *
 *  @param imageArray 图片数组
 *  @param complete   返回结果
 */
+ (void)updateMorePicture:(NSArray *)imageArray backHandler:(void(^)(NSInteger failNum,NSArray *pictureArray))complete;

/**
 *  单张图片上传
 */
+ (void)updatePicture:(NSArray *)imagePic handler:(void(^)(NSString *logoUrl,BOOL success))complete;

/**
 *  获取类别列表
 *
 *  @param complete 返回结果
 */
+ (void)getMerchantCategory:(void(^)(NSString *status,NSArray *titleArray))complete;

/**
 *  获取店铺已经入住的竞品列表
 *
 *  @param complete 返回竞品列表
 */
+ (void)getMerchantCompplatform:(void(^)(NSString *status,NSMutableArray *titleArray))complete;

/**
 *  获取商户服务列表
 *
 *  @param complete 返回服务列表
 */
+ (void)getMerchantService:(void(^)(NSString *status,NSMutableArray *titleArray))complete;

/**
 *  获取支付通道
 *
 *  @param complete 返回支付通道列表
 */
+ (void)getMerchantPaymentCannel:(void(^)(NSString *status,NSMutableArray *titleArray))complete;

/**
 *  获取国家列表
 *
 *  @param complete 国家列表
 */
+ (void)getMerchantCountry:(void(^)(NSString *status,NSMutableArray *countaryArray))complete;



@end
