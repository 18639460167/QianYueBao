//
//  BDAccountService.h
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/28.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDAccountService : NSObject


+ (instancetype)sharedService;

- (BOOL)checkVersion;

- (void)saveWithDic:(NSDictionary *)dic;

- (void)logout;



@end
