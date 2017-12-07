//
//  BDLocationModel.h
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/27.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^locationBlock)(NSString *address,CLLocation * location, BOOL isSuccess);
@interface BDLocationModel : NSObject


+ (void)getCurrentAddress:(locationBlock)complete;

@end
