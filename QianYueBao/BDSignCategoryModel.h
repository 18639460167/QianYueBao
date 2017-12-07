//
//  BDSignCategoryModel.h
//  QianYueBao
//
//  Created by Black on 17/4/14.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDSignCategoryModel : NSObject

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, copy) NSString *category_id;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSMutableArray *categoryArray;

- (instancetype)initWithAarray:(NSArray *)array;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
