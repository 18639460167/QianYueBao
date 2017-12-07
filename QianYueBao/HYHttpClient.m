//
//  HYHttpClient.m
//  TourGuidShop
//
//  Created by tenpastnine-ios-dev on 16/12/23.
//  Copyright © 2016年 Black. All rights reserved.
//

#import "HYHttpClient.h"
#import "HYHeardRequest.h"
//NSString* const ServiceRoot = @"https://biz1.huanyouji.com"; // 测试
//NSString* const ServiceRoot = @"https://biz.huanyouji.com"; // 线上

@implementation HYHttpClient

+ (void)doGet:(NSString *)action param:(NSDictionary *)paramDic timeInterVal:(NSTimeInterval)timeInterValInt callback:(HYHttpCallback)callbackBlock
{
    [self doService:action param:paramDic timeInterVal:timeInterValInt method:@"GET" callBack:callbackBlock];
}

+ (void)doPost:(NSString *)action param:(NSDictionary *)paramDic timeInterVal:(NSTimeInterval)timeInterValInt callback:(HYHttpCallback)callbackBlock
{
    [self doService:action param:paramDic timeInterVal:timeInterValInt method:@"POST" callBack:callbackBlock];
}
+ (void)noHeadPost:(NSString *)action param:(NSDictionary *)aParam timeInterVal:(NSTimeInterval)aTimeInterVal callback:(HYHttpCallback)callbackBlock
{
    [self doNoHeadService:action param:aParam timeInterVal:aTimeInterVal method:@"POST" callback:callbackBlock];
}


#pragma mark - 请求处理
+ (void)doService:(NSString *)action param:(NSDictionary *)paramDic timeInterVal:(NSTimeInterval)timeInterValInt method:(NSString *)httpMethod callBack:(HYHttpCallback)callBackBlock
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServiceRoot,action]];
    NSString *postStr = @"";
    if (paramDic != nil)
    {
        for (NSString *key in paramDic.allKeys)
        {
             postStr = [NSString stringWithFormat:@"%@%@=%@&",postStr,key,[[paramDic objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    NSData *postData = [postStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    HYHeardRequest *request = [HYHeardRequest shareRequest:url];
    [request setHTTPMethod:httpMethod];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:timeInterValInt];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        HYHttpsResponse *hyResponse = [[HYHttpsResponse alloc]init];
        if (error)
        {
            hyResponse.mStatus = HY_HTTP_FAILED;
            callBackBlock(hyResponse);
        }
        else
        {
            NSString *responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            id jsonResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if ([jsonResult isKindOfClass:[NSDictionary class]])
            {
                if (![[jsonResult objectForKey:@"errcode"] isEqual:[NSNull null]])
                {
                    int retCode = [[jsonResult objectForKey:@"errcode"]intValue];
                    hyResponse.mResult = jsonResult;
                    if (retCode == 0)
                    {
                        hyResponse.mStatus = HY_HTTP_OK;
                    }
                    else if (retCode == 1001)
                    {
                        hyResponse.mStatus = HY_HTTP_UNLOGIN;
                    }
                    else
                    {
                        hyResponse.mStatus = HY_HTTP_UNRIGHTMESSAGE;
                    }
                    callBackBlock(hyResponse);
                }
                else
                {
                    hyResponse.mStatus = HY_HTTP_FAILED;
                    callBackBlock(hyResponse);
                }
            }
            else
            {
                hyResponse.mStatus = HY_HTTP_FAILED;
                callBackBlock(hyResponse);
            }
            
        }
    }];
    [dataTask resume];
    
}

+ (void)doNoHeadService:(NSString*)action param:(NSDictionary*)aParam timeInterVal:(NSTimeInterval)aTimeInterVal method:(NSString*)httpMethod callback:(HYHttpCallback)callbackBlock
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServiceRoot,action]];
    NSString *postStr = @"";
    if(aParam!=nil)
    {
        for(NSString*key in aParam.allKeys)
        {
            postStr = [NSString stringWithFormat:@"%@%@=%@&",postStr,key,[[aParam objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    NSData *postData = [postStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:httpMethod];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:aTimeInterVal];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *  data, NSURLResponse *  response, NSError *  error) {
        HYHttpsResponse *hyResponse= [[HYHttpsResponse alloc]init];
        if (error)
        {
            hyResponse.mStatus = HY_HTTP_FAILED;
            callbackBlock(hyResponse);
        }
        else
        {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSData *data= [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            
            id jsonResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if ([jsonResult isKindOfClass:[NSDictionary class]])
            {
                if (![[jsonResult objectForKey:@"errcode"] isEqual:[NSNull null]])
                {
                    int retCode = [[jsonResult objectForKey:@"errcode"]intValue];
                    hyResponse.mResult = jsonResult;
                    if(retCode==0)
                    {
                        hyResponse.mStatus = HY_HTTP_OK;
                    }
                    else if(retCode==1001)
                    {
                        hyResponse.mStatus = HY_HTTP_UNLOGIN;
                    }
                    else
                    {
                        hyResponse.mStatus = HY_HTTP_UNRIGHTMESSAGE;
                    }
                    callbackBlock(hyResponse);
                }
            }
            else
            {
                hyResponse.mStatus = HY_HTTP_FAILED;
                callbackBlock(hyResponse);
            }
        }
    }];
    [dataTask resume];
}

@end
