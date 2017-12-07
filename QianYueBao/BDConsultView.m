//
//  BDConsultView.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/27.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDConsultView.h"

@implementation BDConsultView

+ (instancetype)createView:(UIViewController *)vc title:(NSString *)title
{
    BDConsultView *view = [[BDConsultView alloc]initWithFrame:CGRectZero createView:vc title:title];
    [vc.view addSubview:view];
    return view;
}
- (instancetype)initWithFrame:(CGRect)frame createView:(UIViewController *)vc title:(NSString *)title
{
    if (self = [super initWithFrame:frame])
    {
        
        UIImageView *arrorwImage = [UIImageView createImage:@"dish_arrorw"];
        [self addSubview:arrorwImage];
        [arrorwImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.equalTo(self).offset(WScale*-18);
            make.size.mas_equalTo(CGSizeMake(WScale*12, HScale*22));
        }];
        
        UILabel *titleLbl = [UILabel createNoramlLbl:title font:15 textColor:[UIColor threeTwoColor]];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.right.equalTo(arrorwImage.mas_left).offset(BDWidth(-8));
            make.left.equalTo(self).offset(WScale*18);
        }];
        
        UIView *lineView = [BDStyle createView:[UIColor cEightColor]];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(0.5);
            make.left.equalTo(self).offset(WScale*18);
        }];
        
        UIButton *actionBtn = [UIButton buttonWithType:0];
        actionBtn.backgroundColor = CLEAR_COLOR;
        [actionBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:actionBtn];
        [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(self);
        }];
    }
    return self;
}

- (void)btnAction
{
    
}

@end
