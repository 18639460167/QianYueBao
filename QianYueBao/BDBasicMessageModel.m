//
//  BDBasicMessageModel.m
//  QianYueBao
//
//  Created by Black on 17/5/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDBasicMessageModel.h"

@implementation BDBasicMessageModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.commercial_circle = [NSString trimNSNullAsNoValue:[dic objectForKey:@"commercial_circle"]];
        self.create_time = [NSString trimNSNullASTimeValue:[dic objectForKey:@"create_time"] withStyle:@"0"];
        self.geo_address = [NSString trimNSNullAsNoValue:[dic objectForKey:@"geo_address"]];
        self.geo_lat = [NSString trimNSNullAsNoValue:[dic objectForKey:@"geo_lat"]];
        self.geo_lng = [NSString trimNSNullAsNoValue:[dic objectForKey:@"geo_lng"]];
        self.loc_city = [NSString trimNSNullAsNoValue:[dic objectForKey:@"loc_city"]];
        self.loc_country = [NSString trimNSNullAsNoValue:[dic objectForKey:@"loc_country"]];
        self.country_code = [NSString trimNSNullAsNoValue:[dic objectForKey:@"country_code"]];
        self.loc_state = [NSString trimNSNullAsNoValue:[dic objectForKey:@"loc_state"]];
        self.mID = [NSString trimNSNullASDefault:[dic objectForKey:@"mid"] andDefault:@"-1"];
        self.oId = [NSString trimNSNullASDefault:[dic objectForKey:@"oid"] andDefault:@"-1"];
        self.title = [NSString trimNSNullAsNoValue:[dic objectForKey:@"title"]];
        self.update_time = [NSString trimNSNullASTimeValue:[dic objectForKey:@"update_time"] withStyle:@"0"];
        self.shopLogo = [NSString trimNSNullAsNoValue:[dic objectForKey:@"logo_url"]];
        self.thumbnails = [NSString trimNsNullAsArray:[dic objectForKey:@"thumbnails"]];
        self.cat_id = [NSString trimNSNullAsNoValue:[dic objectForKey:@"cat_id"]];
        self.comp_platform = [NSString trimNsNullAsArray:[dic objectForKey:@"comp_platform"]];
        self.support_service = [NSString trimNsNullAsArray:[dic objectForKey:@"support_service"]];
        
        self.comp_platform_val = [NSString trimNsNullAsArray:[dic objectForKey:@"comp_platform_val"]];
        self.support_service_val = [NSString trimNsNullAsArray:[dic objectForKey:@"support_service_val"]];
        self.comp_platform_string = [NSString getMessageWithArray:self.comp_platform_val];
        self.support_service_message = [NSString getMessageWithArray:self.support_service_val];
        NSString *firstCategory = [NSString trimNSNullAsNoValue:[dic objectForKey:@"first_category"]];
        NSString *secondCategory = [NSString trimNSNullAsNoValue:[dic objectForKey:@"second_category"]];
        if ([secondCategory isEqualToString:@""])
        {
            self.category = firstCategory;
        }
        else
        {
            if ([firstCategory isEqualToString:@""])
            {
                self.category = secondCategory;
            }
            else
            {
                self.category = [NSString stringWithFormat:@"%@>%@",firstCategory,secondCategory];
            }
        }
        
    }
    return self;
}

#pragma mark -model取值赋值
- (void)setMessage:(NSInteger)row title:(NSString *)title
{
    switch (row) {
        case 0:
        {
            self.shopLogo = title;
        }
            break;
        case 1:
        {
            self.title = title;
        }
            break;
        case 3:
        {
            self.loc_country = title;
        }
            break;
        case 4:
        {
            self.loc_state = title;;
        }
            break;
        case 5:
        {
            self.loc_city = title;
        }
            break;
        case 6:
        {
            self.geo_address = title;
        }
            break;
        case 7:
        {
            self.commercial_circle = title;
        }
            break;
        case 8:
        {
            self.category = title;
        }
            break;
        case 9:
        {
            self.comp_platform_string = title;
        }
            break;
        case 10:
        {
            self.support_service_message = title;
        }
            break;
            
        default:
            break;
    }
}

- (NSString *)getMessage:(NSInteger)row
{
    NSString *message = @"";
    switch (row) {
        case 0:
        {
            message = self.shopLogo;
        }
            break;
        case 1:
        {
           message = self.title;
        }
            break;
        case 3:
        {
            message =  self.loc_country;
        }
            break;
        case 4:
        {
            message =  self.loc_state;
        }
            break;
        case 5:
        {
            message =  self.loc_city;
        }
            break;
        case 6:
        {
            message =  self.geo_address;
        }
            break;
        case 7:
        {
           message =  self.commercial_circle;
        }
            break;
        case 8:
        {
           message = self.category;
        }
            break;
        case 9:
        {
            self.comp_platform_string = [NSString getMessageWithArray:self.comp_platform_val];
            message = self.comp_platform_string;
        }
            break;
        case 10:
        {
            self.support_service_message  = [NSString getMessageWithArray:self.support_service_val];
           message = self.support_service_message;
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

@end
