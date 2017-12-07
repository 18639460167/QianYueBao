//
//  BDCommonVieModel.m
//  QianYueBao
//
//  Created by Black on 17/5/12.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDCommonVieModel.h"
#import "HYHeardRequest.h"

@implementation BDCommonVieModel

#pragma mark - 上传多张图片
+ (void)updateMorePicture:(NSArray *)imageArray backHandler:(void (^)(NSInteger, NSArray *))complete
{
   __block int failnumber = 0;
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *resultArray = [NSMutableArray new];
    for (int i=0; i<imageArray.count; i++)
    {
        id asset = imageArray[i];
        dispatch_group_enter(group);
        [self updatePicture:[NSArray arrayWithObject:asset] handler:^(NSString *logoUrl, BOOL success) {
            if (success)
            {
                [resultArray addObject:logoUrl];
            }
            else
            {
                failnumber++;
            }
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete)
            {
                complete(failnumber,resultArray);
            }
        });
    });
}

+ (void)updatePicture:(NSArray *)imagePic handler:(void (^)(NSString *, BOOL))complete
{
    if (imagePic.count>1)
    {
        id result = imagePic[0];
        if ([result isKindOfClass:[NSString class]])
        {
            complete(REQUEST_SUCCESS,YES);
            return;
        }
    }
    NSString *indetifier = @"hypicture";
    NSString *url = [NSString stringWithFormat:@"%@/common/image/upload.do",ServiceRoot];
    NSURL *thumUrl = [NSURL URLWithString:url];
    HYHeardRequest *request = [HYHeardRequest shareRequest:thumUrl];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 20.0f;
    NSMutableData *requestData = [NSMutableData data];
    [requestData appendData:[[NSString stringWithFormat:@"--%@\r\n",indetifier] dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (imagePic.count>0)
    {
        for (int i=0; i<imagePic.count; i++)
        {
            UIImage *image = nil;
            id asset = imagePic[i];
            if ([asset isKindOfClass:[HYPhotoAssets class]])
            {
                HYPhotoAssets *pAsset = (HYPhotoAssets *)asset;
                image = pAsset.originImage;
            }
            else if([asset isKindOfClass:[HYCamera class]])
            {
                HYCamera *cAsset = (HYCamera *)asset;
                image = cAsset.photoImage;
                
            }
            else if ([asset isKindOfClass:[UIImage class]])
            {
                image = asset;
            }
            image = [BDStyle imageByScalingToMaxSize:image];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%d.jpg\"\r\n",i];
            [requestData appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
            [requestData appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [requestData appendData:[NSData dataWithData:imageData]];
            if (i==imagePic.count-1)
            {
                [requestData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",indetifier] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            else
            {
                [requestData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",indetifier] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
    }
    request.HTTPBody = requestData;
    NSInteger length = [requestData length];
    [request setValue:[NSString stringWithFormat:@"%ld",(long)length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",indetifier] forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *  data, NSURLResponse *  response, NSError *  error) {
        BACK(^{
            MAIN((^{
                if (error)
                {
                    complete(LS(@"Disconnect_Internet"),NO);
                }
                else
                {
                    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSData *data= [responseString dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *error = nil;
                    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                    if ([jsonObject isKindOfClass:[NSDictionary class]])
                    {
                        if (![[jsonObject objectForKey:@"errcode"] isEqual:[NSNull null]])
                        {
                            int retCode = [[jsonObject objectForKey:@"errcode"] intValue];
                            if (retCode == 0)
                            {
                                NSString *str = [NSString trimNSNullAsNoValue:[jsonObject objectForKey:@"result"]];
                                complete(str,YES);
                                
                            }
                            else if (retCode == 1001)
                            {
                                complete(NEED_LOGIN,NO);
                            }
                            else
                            {
                                complete(LS(@"Disconnect_Internet"),NO);
                            }
                        }
                        else
                        {
                            complete(LS(@"Disconnect_Internet"),NO);
                        }
                    }
                    else
                    {
                        complete(LS(@"Disconnect_Internet"),NO);
                    }
                    
                }
            }));
        });
    }];
    [dataTask resume];

}

#pragma mark - 获取类目
+ (void)getMerchantCategory:(void (^)(NSString *, NSArray *))complete
{
    [HYHttpClient doPost:@"/common/shop/category/list.json" param:nil timeInterVal:REQUEST_TIME callback:^(HYHttpsResponse *response) {
        BACK(^{
            MAIN((^{
                if (response.mStatus == HY_HTTP_UNLOGIN)
                {
                    complete(NEED_LOGIN,nil);
                }
                else if (response.mStatus == HY_HTTP_OK)
                {
                    id jsObject = response.mResult;
                    if ([jsObject isKindOfClass:[NSDictionary class]])
                    {
                        id result = [jsObject objectForKey:RESULT];
                        if ([result isKindOfClass:[NSArray class]])
                        {
                            NSMutableArray *categoryArray = [NSMutableArray new];
                            for (NSDictionary *dic in result)
                            {
                                BDSignCategoryModel *model = [[BDSignCategoryModel alloc]initWithDic:dic];
                                [categoryArray addObject:model];
                            }
                            complete(REQUEST_SUCCESS,categoryArray);
                        }
                        else
                        {
                            complete(LS(@"Disconnect_Internet"),nil);
                        }
                    }
                    else
                    {
                        complete(LS(@"Disconnect_Internet"),nil);
                    }
                }
                else
                {
                    complete(LS(@"Disconnect_Internet"),nil);
                }
            }));
        });
    }];
}

#pragma mark - 获取竞品列表
+ (void)getMerchantCompplatform:(void (^)(NSString *, NSMutableArray *))complete
{
    [HYHttpClient doPost:@"/common/comp_platform/list.json" param:nil timeInterVal:REQUEST_TIME callback:^(HYHttpsResponse *response) {
        BACK(^{
            MAIN((^{
                if (response.mStatus == HY_HTTP_UNLOGIN)
                {
                    complete(NEED_LOGIN,nil);
                }
                else if (response.mStatus == HY_HTTP_OK)
                {
                    id jsObject = response.mResult;
                    if ([jsObject isKindOfClass:[NSDictionary class]])
                    {
                        id result = [jsObject objectForKey:RESULT];
                        if ([result isKindOfClass:[NSArray class]])
                        {
                            NSMutableArray *categoryArray = [NSMutableArray new];
                            for (id dic in result)
                            {
                                BDMoreSelectModel *model = [BDMoreSelectModel createModel:dic];
                                [categoryArray addObject:model];
                            }
                            complete(REQUEST_SUCCESS,categoryArray);
                        }
                        else
                        {
                            complete(LS(@"Disconnect_Internet"),nil);
                        }
                    }
                    else
                    {
                        complete(LS(@"Disconnect_Internet"),nil);
                    }
                }
                else
                {
                    complete(LS(@"Disconnect_Internet"),nil);
                }
            }));
        });
    }];
}

#pragma mark - 商户服务列表
+ (void)getMerchantService:(void (^)(NSString *, NSMutableArray *))complete
{
    [HYHttpClient doPost:@"/common/merchant_service/list.json" param:nil timeInterVal:REQUEST_TIME callback:^(HYHttpsResponse *response) {
        BACK(^{
            MAIN((^{
                if (response.mStatus == HY_HTTP_UNLOGIN)
                {
                    complete(NEED_LOGIN,nil);
                }
                else if (response.mStatus == HY_HTTP_OK)
                {
                    id jsObject = response.mResult;
                    if ([jsObject isKindOfClass:[NSDictionary class]])
                    {
                        id result = [jsObject objectForKey:RESULT];
                        if ([result isKindOfClass:[NSArray class]])
                        {
                            NSMutableArray *categoryArray = [NSMutableArray new];
                            for (id dic in result)
                            {
                                BDMoreSelectModel *model = [BDMoreSelectModel createModel:dic];
                                [categoryArray addObject:model];
                            }
                            complete(REQUEST_SUCCESS,categoryArray);
                        }
                        else
                        {
                            complete(LS(@"Disconnect_Internet"),nil);
                        }
                    }
                    else
                    {
                        complete(LS(@"Disconnect_Internet"),nil);
                    }
                }
                else
                {
                    complete(LS(@"Disconnect_Internet"),nil);
                }
            }));
        });
    }];
}

#pragma mark - 获取支付通道列表
+ (void)getMerchantPaymentCannel:(void (^)(NSString *, NSMutableArray *))complete
{
    [HYHttpClient doPost:@"/common/payment_channel/list.json" param:nil timeInterVal:REQUEST_TIME callback:^(HYHttpsResponse *response) {
        BACK(^{
            MAIN((^{
                if (response.mStatus == HY_HTTP_UNLOGIN)
                {
                    complete(NEED_LOGIN,nil);
                }
                else if (response.mStatus == HY_HTTP_OK)
                {
                    id jsObject = response.mResult;
                    if ([jsObject isKindOfClass:[NSDictionary class]])
                    {
                        id result = [jsObject objectForKey:RESULT];
                        if ([result isKindOfClass:[NSArray class]])
                        {
                            NSMutableArray *categoryArray = [NSMutableArray new];
                            for (id dic in result)
                            {
                                BDMoreSelectModel *model = [BDMoreSelectModel createModel:dic];
                                [categoryArray addObject:model];
                            }
                            complete(REQUEST_SUCCESS,categoryArray);
                        }
                        else
                        {
                            complete(LS(@"Disconnect_Internet"),nil);
                        }
                    }
                    else
                    {
                        complete(LS(@"Disconnect_Internet"),nil);
                    }
                }
                else
                {
                    complete(LS(@"Disconnect_Internet"),nil);
                }
            }));
        });
    }];
}

#pragma mark - 获取国家列表
+ (void)getMerchantCountry:(void (^)(NSString *, NSMutableArray *))complete
{
    [HYHttpClient doPost:@"/common/country/list.json" param:nil timeInterVal:REQUEST_TIME callback:^(HYHttpsResponse *response) {
        BACK(^{
            MAIN((^{
                if (response.mStatus == HY_HTTP_UNLOGIN)
                {
                    complete(NEED_LOGIN,nil);
                }
                else if (response.mStatus == HY_HTTP_OK)
                {
                    id jsObject = response.mResult;
                    if ([jsObject isKindOfClass:[NSDictionary class]])
                    {
                        id result = [jsObject objectForKey:RESULT];
                        if ([result isKindOfClass:[NSArray class]])
                        {
                            NSMutableArray *categoryArray = [NSMutableArray new];
                            for (NSDictionary *dic in result)
                            {
                                BDCountryModel *model = [[BDCountryModel alloc]initWithDic:dic];
                                [categoryArray addObject:model];
                            }
                            complete(REQUEST_SUCCESS,categoryArray);
                        }
                        else
                        {
                            complete(LS(@"Disconnect_Internet"),nil);
                        }
                    }
                    else
                    {
                        complete(LS(@"Disconnect_Internet"),nil);
                    }
                }
                else
                {
                    complete(LS(@"Disconnect_Internet"),nil);
                }
            }));
        });
    }];
}


@end
