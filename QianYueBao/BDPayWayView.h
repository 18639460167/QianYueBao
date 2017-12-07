//
//  BDPayWayView.h
//  QianYueBao
//
//  Created by Black on 17/4/12.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDPayWayView : UIView

@property (nonatomic, copy) noParameterBlock complete;

@property (nonatomic, strong) UILabel *titleLbl;

+ (instancetype)createView:(UIView *)fatherView;

@end
