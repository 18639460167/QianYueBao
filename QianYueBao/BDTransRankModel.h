//
//  BDTransRankModel.h
//  QianYueBao
//
//  Created by Black on 17/6/6.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDTransRankModel : NSObject

@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *total;

+ (instancetype)createModelWithDic:(NSDictionary *)dic;

@end
