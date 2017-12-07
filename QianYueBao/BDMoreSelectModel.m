//
//  BDMoreSelectModel.m
//  QianYueBao
//
//  Created by Black on 17/5/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDMoreSelectModel.h"

@implementation BDMoreSelectModel

//+ (instancetype)createModel:(NSString *)message
//{
//    BDMoreSelectModel *model = [[BDMoreSelectModel alloc]initWithTitle:message];
//    return model;
//}
//- (instancetype)initWithTitle:(NSString *)message
//{
//    if (self = [super init])
//    {
//        self.title = message;
//        self.isSelect = NO;
//    }
//    return self;
//}

+ (instancetype)createModel:(NSDictionary *)dic
{
    BDMoreSelectModel *model = [[BDMoreSelectModel alloc]initWithDic:dic];
    return model;
}
- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.dId = [NSString trimNSNullAsNoValue:[dic objectForKey:@"id"]];
        self.title = [NSString trimNSNullAsNoValue:[dic objectForKey:@"title"]];
        self.isSelect = NO;
    }
    return self;
}

@end
