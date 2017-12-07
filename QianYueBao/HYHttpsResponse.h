//
//  HYHttpsResponse.h
//  TourGuidShop
//
//  Created by tenpastnine-ios-dev on 16/12/23.
//  Copyright © 2016年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,HYHttpsStatus) {
    HY_HTTP_OK, // 请求成功
    HY_HTTP_FAILED, // 请求错误
    HY_HTTP_UNLOGIN, // 未登录
    HY_HTTP_UNRIGHTMESSAGE // 错误信息
};

@interface HYHttpsResponse : NSObject

@property (nonatomic, strong) NSDictionary *mResult;
@property (nonatomic, assign) HYHttpsStatus mStatus;

- (HYHttpsResponse*)initWithStatus:(HYHttpsStatus)status andResult:(NSDictionary*)result;

@end
