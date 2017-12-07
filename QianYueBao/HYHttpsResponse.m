//
//  HYHttpsResponse.m
//  TourGuidShop
//
//  Created by tenpastnine-ios-dev on 16/12/23.
//  Copyright © 2016年 Black. All rights reserved.
//

#import "HYHttpsResponse.h"


@implementation HYHttpsResponse

- (HYHttpsResponse *)initWithStatus:(HYHttpsStatus)status andResult:(NSDictionary *)result
{
    if (self = [super init])
    {
        self.mStatus = status;
        self.mResult = result;
    }
    return self;
}

@end
