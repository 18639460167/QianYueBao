//
//  BDMoreChooseViewController.h
//  QianYueBao
//
//  Created by Black on 17/5/10.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDSuperViewController.h"

typedef NS_ENUM(NSInteger, ChooseStatus) {
    ChooseStatus_Platform, // 合作竞品
    ChooseStatus_Service, // 推荐服务
    ChooseStatus_Payment, // 支付通道
    ChooseStatus_UnKnow // 未知
};

@interface BDMoreChooseViewController : BDSuperViewController

@property (nonatomic, assign) ChooseStatus chooseStatus;

@property (nonatomic, strong) NSMutableArray *selectArray;

@property (nonatomic, copy) void(^backSelectHandler)(NSArray *messageArray,NSArray *idArray);

//@property (nonatomic, copy) void(^backSelectHandler)(NSString *message,NSArray *selectArray);

@end
