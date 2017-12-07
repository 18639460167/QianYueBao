//
//  BDOwnerModel.h
//  QianYueBao
//
//  Created by Black on 17/5/3.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDOwnerModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *ownerName;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *IDNumber;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *contact_assress; // 通信地址
@property (nonatomic, copy) NSString *phone; // 电话
@property (nonatomic, copy) NSString *mobil_phone; // 手机
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *remittance_bank;// 汇款银行
@property (nonatomic, copy) NSString *branch; // 分行
@property (nonatomic, copy) NSString *swift_code; // 银行代码
@property (nonatomic, copy) NSString *bank_name; // 银行账户名称
@property (nonatomic, copy) NSString *bank_number; // 银行账号
@property (nonatomic, copy) NSString *account_name; // 账户名称
@property (nonatomic, copy) NSString *countey_code; // 国家code

@property (nonatomic, copy) NSString *account; // 账号

@property (nonatomic, assign) BOOL isOpen; // 是否收起

- (instancetype)initWithDic:(NSDictionary *)dic;

+ (NSArray *)getTitleArray;

- (NSString *)getOwnerMessage:(NSInteger)row;

- (void)saveMessage:(NSInteger)index message:(NSString *)message;

/**
 *  获取详情店主信息
 */
- (NSString *)detailGetMeesgae:(NSInteger)row;

- (NSDictionary *)ownerWithDic;

@end
