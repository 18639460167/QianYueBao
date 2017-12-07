//
//  BDCustomNavitionView.h
//  QianYueBao
//
//  Created by Black on 17/4/18.
//  Copyright © 2017年 Black. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BDNavitionStyle) {
    BDNavitionStyle_Normal, // 导航显示
    BDNavitionStyle_Clean, // 背景透明
};

@interface BDCustomNavitionView : UIView

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, copy) noParameterBlock complete;
@property (nonatomic, assign) BOOL isShowRight;

@property (nonatomic, strong) UIViewController *currentVC;

@end
