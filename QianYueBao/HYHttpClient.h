//
//  HYHttpClient.h
//  TourGuidShop
//
//  Created by tenpastnine-ios-dev on 16/12/23.
//  Copyright © 2016年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYHttpsResponse.h"

typedef void (^HYHttpCallback)(HYHttpsResponse *response);
@interface HYHttpClient : NSObject
/**
 *  Get请求
 *
 *  @param action          端口
 *  @param paramDic        参数
 *  @param timeInterValInt 超时时间
 *  @param callbackBlock   返回信息
 */
+(void)doGet:(NSString*)action param:(NSDictionary*)paramDic timeInterVal:(NSTimeInterval)timeInterValInt callback:(HYHttpCallback)callbackBlock;
/**
 *  Post 请求
 */
+(void)doPost:(NSString*)action param:(NSDictionary*)paramDic timeInterVal:(NSTimeInterval)timeInterValInt callback:(HYHttpCallback)callbackBlock;

/**
 *  Post 请求(没请求头)
 */
+(void)noHeadPost:(NSString*)action param:(NSDictionary*)aParam timeInterVal:(NSTimeInterval)aTimeInterVal callback:(HYHttpCallback)callbackBlock;

@end
