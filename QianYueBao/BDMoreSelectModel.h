//
//  BDMoreSelectModel.h
//  QianYueBao
//
//  Created by Black on 17/5/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDMoreSelectModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *dId;
@property (nonatomic, assign) BOOL isSelect;

+ (instancetype)createModel:(NSDictionary *)dic;

//+ (instancetype)createModel:(NSString *)message;

@end
