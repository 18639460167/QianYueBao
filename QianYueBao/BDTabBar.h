//
//  BDTabBar.h
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/24.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDTabBar : UITabBar

@property (nonatomic, copy) void (^signAction)(void);

@end
