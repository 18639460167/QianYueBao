//
//  BDOwnerModel.m
//  QianYueBao
//
//  Created by Black on 17/5/3.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDOwnerModel.h"

@implementation BDOwnerModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.ownerName = [NSString trimNSNullAsNoValue:[dic objectForKey:@"owner_name"]];
        self.account_name = [NSString trimNSNullAsNoValue:[dic objectForKey:@"nickname"]];
        self.account = [NSString trimNSNullAsNoValue:[dic objectForKey:@"oid"]];
        self.sex = @"";
        self.bank_name = @"";
        self.bank_number = @"";
        self.IDNumber = @"";
        self.countey_code = @"";
        self.city = @"";
        self.contact_assress = @"";
        self.mobil_phone = @"";
        self.email = @"";
        self.swift_code = @"";
        self.branch = @"";
        self.phone = @"";
        self.country = @"";
        self.remittance_bank = @"";
        self.province = @"";
    }
    return self;
}

+ (NSArray *)getTitleArray
{
    NSArray *titleArray = @[LS(@"Owner_Name_Colon"),LS(@"Account_Name_Colon"),LS(@"ID_Card_C"),LS(@"Country_C"),LS(@"Province_C"),LS(@"City_C"),LS(@"Dispatch_Address_C"),LS(@"Telephone_C"),LS(@"Phone_C"),LS(@"Email_C"),LS(@"Remittance_Bank_C"),LS(@"Branch_C"),LS(@"Swift_Code_C"),LS(@"Bank_Account_Name_C"),LS(@"Bank_Account_C")];
    return titleArray;
}

- (NSString *)getOwnerMessage:(NSInteger)row
{
    NSString *message = @"";
    switch (row)
    {
        case 0:
        {
            message = self.ownerName ;
        }
            break;
        case 1:
        {
            message = self.account_name ;
        }
//        case 2:
//        {
//            message = self.sex;
//        }
//            break;
        case 2:
        {
            message = self.IDNumber;
        }
            break;
        case 3:
        {
            message = self.country;
        }
            break;
        case 4:
        {
            message = self.province;
        }
            break;
        case 5:
        {
            message = self.city;
        }
            break;
        case 6:
        {
            message = self.contact_assress;
        }
            break;
        case 7:
        {
            message = self.phone;
        }
            break;
        case 8:
        {
            message =  self.mobil_phone;
        }
            break;
        case 9:
        {
            message = self.email;
        }
            break;
        case 10:
        {
            message = self.remittance_bank;
        }
            break;
        case 11:
        {
            message = self.branch;
        }
            break;
        case 12:
        {
            message = self.swift_code;
        }
            break;
        case 13:
        {
            message = self.bank_name;
        }
            break;
        case 14:
        {
            message = self.bank_number;
        }
            break;
            
        default:
        break;
    }
    return message;
}

- (void)saveMessage:(NSInteger)index message:(NSString *)message
{
    switch (index)
    {
        case 0:
        {
            self.ownerName = message;
        }
            break;
        case 1:
        {
            self.account_name = message;
        }
//        case 2:
//        {
//            self.sex = message;
//        }
//            break;
        case 2:
        {
            self.IDNumber = message;
        }
            break;
        case 3:
        {
            self.country = message;
        }
            break;
        case 4:
        {
            self.province = message;
        }
            break;
        case 5:
        {
            self.city = message;
        }
            break;
        case 6:
        {
            self.contact_assress = message;
        }
            break;
        case 7:
        {
            self.phone = message;
        }
            break;
        case 8:
        {
            self.mobil_phone = message;
        }
            break;
        case 9:
        {
            self.email = message;
        }
            break;
        case 10:
        {
            self.remittance_bank = message;
        }
            break;
        case 11:
        {
            self.branch = message;
        }
            break;
        case 12:
        {
            self.swift_code = message;
        }
            break;
        case 13:
        {
            self.bank_name = message;
        }
            break;
        case 14:
        {
            self.bank_number = message;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 详情信息
- (NSString *)detailGetMeesgae:(NSInteger)row
{
    NSString *message = @"";
    switch (row)
    {
        case 0:
        {
            message = self.ownerName;
        }
            break;
        case 1:
        {
            message = self.account_name;
        }
            break;
        case 2:
        {
            message = self.account;
        }
            break;
        default:
            break;
    }
    return message;
}

#pragma mark - 归档解档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i=0; i<count; i++)
    {
        const char*name = ivar_getName(ivars[i]);
        NSString *key= [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    free(ivars);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        unsigned int count = 0;
        // ivar 定义对象的实例变量，包括类型和名字
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i=0; i<count; i++)
        {
            const char *name = ivar_getName(ivars[i]);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}

- (NSDictionary *)ownerWithDic
{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[NSString trimNSNullAsNoValue:self.ownerName] forKey:@"owner_name"];
    [param setObject:[NSString trimNSNullAsNoValue:self.account_name] forKey:@"nickname"];
//    NSString *str = @"0";
//    if ([self.sex isEqualToString:@"女"])
//    {
//        str = @"1";
//    }
//    [param setObject:str forKey:@"sex"];
    [param setObject:[NSString trimNSNullAsNoValue:self.IDNumber] forKey:@"citizen_id"];
    [param setObject:[NSString trimNSNullAsNoValue:self.countey_code] forKey:@"country_code"];
    [param setObject:[NSString trimNSNullAsNoValue:self.province] forKey:@"loc_state"];
    [param setObject:[NSString trimNSNullAsNoValue:self.city] forKey:@"loc_city"];
    [param setObject:[NSString trimNSNullAsNoValue:self.contact_assress] forKey:@"geo_address"];
    [param setObject:[NSString trimNSNullAsNoValue:self.phone] forKey:@"telephone"];
    [param setObject:[NSString trimNSNullAsNoValue:self.mobil_phone] forKey:@"mobile_phone"];
    [param setObject:[NSString trimNSNullAsNoValue:self.email] forKey:@"email"];
    [param setObject:[NSString trimNSNullAsNoValue:self.remittance_bank] forKey:@"bank_name"];
    [param setObject:[NSString trimNSNullAsNoValue:self.branch] forKey:@"bank_branch"];
    [param setObject:[NSString trimNSNullAsNoValue:self.swift_code] forKey:@"swift_code"];
    [param setObject:[NSString trimNSNullAsNoValue:self.bank_name] forKey:@"bank_account_name"];
    [param setObject:[NSString trimNSNullAsNoValue:self.bank_number] forKey:@"bank_account_number"];
    return param;
}


@end
