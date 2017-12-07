//
//  BDPayWayView.m
//  QianYueBao
//
//  Created by Black on 17/4/12.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDPayWayView.h"

@implementation BDPayWayView

@synthesize titleLbl;

+ (instancetype)createView:(UIView *)fatherView
{
    BDPayWayView *payView = [[BDPayWayView alloc]initWithFrame:CGRectZero];
    [fatherView addSubview:payView];
    return payView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = HScale*15;
        self.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
        
        UIImageView *arrorImage = [UIImageView createImage:@"select_arrorw"];
        [self addSubview:arrorImage];
        [arrorImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(WScale*7, HScale*15));
            make.right.equalTo(self).offset(HScale*-10);
        }];
        
        titleLbl = [UILabel createNoramlLbl:@"" font:15 textColor:[UIColor threeTwoColor]];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(HScale*10);
            make.right.equalTo(arrorImage.mas_left).offset(-WScale*5);
        }];
        
        UIButton *actionBtn = [UIButton buttonWithType:0];
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
    if (self.complete)
    {
        self.complete();
    }
}


@end
