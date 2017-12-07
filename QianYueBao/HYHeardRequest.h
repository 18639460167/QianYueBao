//
//  HYHeardRequest.h
//  TourGuidShop
//
//  Created by tenpastnine-ios-dev on 16/12/23.
//  Copyright © 2016年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYHeardRequest : NSMutableURLRequest

+ (HYHeardRequest *)shareRequest:(NSURL *)url;

@end
