//
//  HYHeardRequest.m
//  TourGuidShop
//
//  Created by tenpastnine-ios-dev on 16/12/23.
//  Copyright © 2016年 Black. All rights reserved.
//

#import "HYHeardRequest.h"

@implementation HYHeardRequest

+ (HYHeardRequest *)shareRequest:(NSURL *)url
{
    HYHeardRequest *shareModel;
    shareModel = [self requestWithURL:url];
    if (![READ_SHOP_SIGN(AccessToken) isEqualToString:@""])
    {
        NSLog(@"==%@",READ_SHOP_SIGN(AccessToken));
        [shareModel addValue:READ_SHOP_SIGN(AccessToken) forHTTPHeaderField:@"accessToken"];
    }
    return shareModel;
}

@end
