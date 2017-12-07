//
//  BDBottomView.h
//  QianYueBao
//
//  Created by Black on 17/5/16.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDSignListModel.h"
@interface BDBottomButton : UIButton

+ (instancetype)createBottomBtn:(TradeStatus)status handler:(noParameterBlock)complete;

@end

@interface BDBottomView : UIView

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong)  BDBottomButton *bottomBtn;

+ (instancetype)createBottomView:(TradeStatus)status fathView:(UIView *)fathView handler:(noParameterBlock)complete;

@end
