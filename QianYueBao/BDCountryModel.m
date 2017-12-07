//
//  BDCountryModel.m
//  QianYueBao
//
//  Created by Black on 17/5/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDCountryModel.h"

@implementation BDCountryModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.code = [NSString trimNSNullAsNoValue:[dic objectForKey:@"country_code"]];
        self.name = [NSString trimNSNullAsNoValue:[dic objectForKey:@"country_name"]];
        self.phone_code = [NSString trimNSNullAsNoValue:[dic objectForKey:@"phone_code"]];
    }
    return self;
}

@end
