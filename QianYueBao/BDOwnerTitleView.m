//
//  BDOwnerTitleView.m
//  QianYueBao
//
//  Created by Black on 17/5/8.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDOwnerTitleView.h"

@implementation BDOwnerTitleView

+ (instancetype)createView:(UIView *)fatherView
{
    BDOwnerTitleView *view = [[BDOwnerTitleView alloc]initWithFrame:CGRectZero];
    [fatherView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(fatherView);
        make.top.equalTo(fatherView).offset(64);
        make.height.mas_equalTo(HScale*50);
    }];
    return view;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        CGFloat width = (SCREEN_WIDTH-WScale*54-HScale*15)/3;
        UILabel * nameLbl = [UILabel createNoramlLbl:LS(@"Owner_Name") font:15 textColor:[UIColor nineSixColor]];
        [self addSubview:nameLbl];
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(WScale*15);
            make.width.mas_equalTo(width);
        }];
        
        UILabel *accountLbl = [UILabel createRightLbl:LS(@"Account_Number") font:15 textColor:[UIColor nineSixColor]];
        [self addSubview:accountLbl];
        [accountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.right.equalTo(self).offset(WScale*-23+HScale*-15);
            make.width.mas_equalTo(width);
        }];
        
        UILabel *accountNameLbl = [UILabel createLbl:LS(@"Account_Name") font:15 textColor:[UIColor nineSixColor]];
        [self addSubview:accountNameLbl];
        [accountNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(width);
            make.left.equalTo(nameLbl.mas_right).offset(WScale*8);
        }];
        
        UIView *lineView = [BDStyle createView:[UIColor cEightColor]];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.equalTo(self);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(0.5);
        }];

    }
    return self;
}

@end
