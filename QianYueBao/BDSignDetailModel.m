//
//  BDSignDetailModel.m
//  QianYueBao
//
//  Created by Black on 17/5/9.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDSignDetailModel.h"
#import <objc/runtime.h>

@implementation BDSignDetailModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        NSDictionary *contrctDic = [NSString trimNsNullAsDic:[dic objectForKey:@"contractInfo"]];
        self.contractModel = [[BDContractModel alloc]initWithDic:contrctDic];
        
        id object = [dic objectForKey:@"ownerInfo"];
        if ([object isKindOfClass:[NSDictionary class]])
        {
            self.haveOwner = YES;
        }
        NSDictionary *ownerDic = [NSString trimNsNullAsDic:[dic objectForKey:@"ownerInfo"]];
        self.ownerModel = [[BDOwnerModel alloc]initWithDic:ownerDic];
        
        NSDictionary *shopInfo  = [NSString trimNsNullAsDic:[dic objectForKey:@"shopInfo"]];
        self.basicModel = [[BDBasicMessageModel alloc]initWithDic:shopInfo];
        self.signID = @"-1";
        self.status = TradeStatus_Wait;
        
       
    }
    return self;
}

- (NSArray *)getTitleArray
{
    if (self.requestSuccess)
    {
        NSArray *oneArray = @[LS(@"Owner_Name_Colon"),LS(@"Account_Name_Colon"),LS(@"Account_C")];
        NSArray *twoArray = @[LS(@"Shop_Logo"),LS(@"Shopper_Name"),@"",LS(@"Country_C"),LS(@"Province_C"),LS(@"City_C"),LS(@"Detail_Address"),LS(@"Belong_Area"),LS(@"Belong_Cate"),LS(@"Coorperation"),LS(@"Product_Service"),LS(@"Publicize_Photo")];
        NSArray *threeArray = @[LS(@"Rate"),LS(@"Contract_Photo"),LS(@"PayChannel"),LS(@"Settle_Cycle")];
        NSArray * titleArray = @[oneArray,twoArray,threeArray];
        return titleArray;
    }
    else
    {
        return [NSArray new];
    }
}

- (NSInteger)getRowCount:(NSInteger)section
{
    if (section == 0)
    {
        if (!self.haveOwner)
        {
            return 1;
        }
    }
    else if (section==1)
    {
        if (self.firstOpen)
        {
            return 0;
        }
    }
    if(section == 2)
    {
        if (self.twoOpen)
        {
            return 0;
        }
    }
    NSArray *titleArray = [self getTitleArray][section];
    return titleArray.count;
}

#pragma mark - 获取row高度
- (CGFloat)getRowHeight:(NSInteger)section indexRow:(NSInteger)row
{
    NSArray *titleArr = [self getTitleArray][section];
    CGFloat width = [BDStyle getWidthWithTitle:titleArr[row] font:15]+WScale*46;
    switch (section)
    {
        case 0:
        {
            if (!self.haveOwner)
            {
                return HScale*100;
            }
            return HScale*50;
        }
            break;
        case 1:
        {
            if (row == 0)
            {
                return HScale*75;
            }
            if (row == 3)
            {
                return [NSString getRowHeight:self.basicModel.loc_country titleWidth:width];
            }
            else if (row == 8)
            {
                return [NSString getRowHeight:self.basicModel.category titleWidth:width];
            }
            else if (row == 9)
            {
                NSString *message = [NSString getMessageWithArray:self.basicModel.comp_platform_val];
                return [NSString getRowHeight:message titleWidth:width];
            }
            else if (row == 10)
            {
                NSString *message = [NSString getMessageWithArray:self.basicModel.support_service_val];
                return [NSString getRowHeight:message titleWidth:width];
            }
            else if (row == 11)
            {
                return ([BDStyle getTagViewHeightArrcount:
                         self.basicModel.thumbnails.count lineTagCount:3]+HScale*50+(0.5));
            }
            else
            {
                return HScale*50;
            }
        }
            break;
        case 2:
        {
            if (row == 1)
            {
                return ([BDStyle getTagViewHeightArrcount:
                         self.contractModel.contract_image.count lineTagCount:3]+HScale*50+0.5);
            }
            else if (row == 2)
            {
                return [NSString getRowHeight:[NSString getMessageWithArray:self.contractModel.payment_channel_val] titleWidth:width];
            }
            else
            {
                return HScale*50;
            }
        }
            break;
            
        default:
            break;
    }
    return HScale*50;
}

#pragma mark - 获取所有属性
+ (NSArray *)getAllProperties
{
    u_int count;
    objc_property_t *properties = class_copyPropertyList(self, &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i=0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}

- (NSDictionary *)properties_asp
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i=0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char *char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        if ([propertyName isEqualToString:@"basicModel"])
        {
            NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self.basicModel];
            if (data)
            {
                [props setObject:data forKey:propertyName];
            }
            
        }
       else if ([propertyName isEqualToString:@"contractModel"])
        {
            NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self.contractModel];
            if (data)
            {
                [props setObject:data forKey:propertyName];
            }
            
        }
       else if ([propertyName isEqualToString:@"ownerModel"])
        {
            NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self.ownerModel];
            if (data)
            {
                [props setObject:data forKey:propertyName];
            }
            
        }
        else
        {
            id propertyValue = [self valueForKey:(NSString *)propertyName];
            if (propertyValue)
            {
                [props setObject:propertyValue forKey:propertyName];
            }
        }
        
    }
    free(properties);
    return props;
}

#pragma mark - 请求字段
- (NSDictionary *)getModelDicWithMid:(NSString *)mid
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[NSString trimNSNullAsNoValue:self.ownerModel.account] forKey:@"oid"];
    [dic setObject:[NSString trimNSNullAsNoValue:self.basicModel.title] forKey:@"title"];
    [dic setObject:[NSString trimNSNullAsNoValue:self.basicModel.cat_id] forKey:@"cat_id"];
    [dic setObject:[NSString trimNSNullAsNoValue:self.basicModel.country_code] forKey:@"country_code"];
    [dic setObject:[NSString trimNSNullAsNoValue:self.basicModel.loc_state] forKey:@"loc_state"];
    [dic setObject:[NSString trimNSNullAsNoValue:self.basicModel.loc_city] forKey:@"loc_city"];
    [dic setObject:[NSString trimNSNullAsNoValue:self.basicModel.shopLogo] forKey:@"logo_url"];
    
    NSString *thum = [NSString getMessageWithArray:self.basicModel.thumbnails];
    [dic setObject:thum forKey:@"thumbnails"];
    
    [dic setObject:[NSString trimNSNullAsNoValue:self.basicModel.geo_lat] forKey:@"geo_lat"];
    [dic setObject:[NSString trimNSNullAsNoValue:self.basicModel.geo_lng ] forKey:@"geo_lng"];
    [dic setObject:[NSString trimNSNullAsNoValue:self.basicModel.geo_address] forKey:@"geo_address"];
    [dic setObject:[NSString trimNSNullAsNoValue:self.basicModel.commercial_circle] forKey:@"commercial_circle"];
    [dic setObject:[NSString getMessageWithArray:self.basicModel.comp_platform] forKey:@"comp_platform"];
    [dic setObject:[NSString getMessageWithArray:self.basicModel.support_service] forKey:@"support_service"];
    if (mid)
    {
        [dic setObject:[NSString trimNSNullAsNoValue:mid] forKey:@"mid"];
    }
    else
    {
        [dic setObject:[NSString trimNSNullAsNoValue:self.contractModel.premium_rate] forKey:@"mdr"];
        [dic setObject:[NSString getMessageWithArray:self.contractModel.payment_channel] forKey:@"payment_channel"];
        [dic setObject:[NSString trimNSNullAsNoValue:self.contractModel.settlement_term] forKey:@"settlement_term"];
        
        NSString *contract = [NSString getMessageWithArray:self.contractModel.contract_image];
        [dic setObject:contract forKey:@"contract_image"];
    }
    return dic;
}

#pragma mark - fmdb解析
- (instancetype)initWithFmdbDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.currentTime = [dic objectForKey:@"currentTime"];
        self.firstOpen = [[dic objectForKey:@"firstOpen"] boolValue];
        self.twoOpen = [[dic objectForKey:@"twoOpen"] boolValue];
        self.haveOwner = [[dic objectForKey:@"haveOwner"] boolValue];
        int value = [[dic objectForKey:@"status"] intValue];
        switch (value)
        {
            case 0:
            {
                self.status = TradeStatus_Finish;
            }
                break;
            case 1:
            {
                self.status = TradeStatus_Process;
            }
                break;
            case 2:
            {
                self.status = TradeStatus_Wait;
            }
                break;
                
            default:
            {
                self.status = TradeStatus_Fail;
            }
                break;
        }
        NSData *basicData = [dic objectForKey:@"basicModel"];
        if (basicData)
        {
            self.basicModel = (BDBasicMessageModel*)[NSKeyedUnarchiver unarchiveObjectWithData:basicData];
        }
        else
        {
            self.basicModel = [[BDBasicMessageModel alloc]initWithDic:[NSDictionary new]];
        }
        
        NSData *ownerData = [dic objectForKey:@"ownerModel"];
        if (ownerData)
        {
            self.ownerModel = (BDOwnerModel *)[NSKeyedUnarchiver unarchiveObjectWithData:ownerData];
        }
        else
        {
            self.ownerModel = [[BDOwnerModel alloc]initWithDic:[NSDictionary new]];
        }
        
        NSData *contractData = [dic objectForKey:@"contractModel"];
        if (contractData)
        {
            self.contractModel = (BDContractModel *)[NSKeyedUnarchiver unarchiveObjectWithData:contractData];
        }
        else
        {
            self.contractModel = [[BDContractModel alloc]initWithDic:[NSDictionary new]];
        }
        self.contractModel.isChange = NO;
        self.basicModel.isChange = NO;
        self.requestSuccess = YES;
        self.signID = [NSString trimNSNullAsIntValue:[dic objectForKey:@"signID"]];
    }
    return self;
}

@end
