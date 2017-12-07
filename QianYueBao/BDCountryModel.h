//
//  BDCountryModel.h
//  QianYueBao
//
//  Created by Black on 17/5/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDCountryModel : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone_code;
@property (nonatomic, assign) BOOL isSelect;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
