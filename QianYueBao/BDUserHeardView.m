//
//  BDUserHeardView.m
//  QianYueBao
//
//  Created by Black on 17/4/19.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDUserHeardView.h"
@implementation BDUserHeardView
@synthesize logoImage;
@synthesize nameLbl;
@synthesize currentVC;

+ (instancetype)crateHeardView:(UIViewController *)vc
{
    BDUserHeardView *heardView = [[BDUserHeardView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HScale*240) currentVC:vc];
    return heardView;
}

- (instancetype)initWithFrame:(CGRect)frame currentVC:(UIViewController *)vc
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = WHITE_COLOR;
        currentVC = vc;
        
        UIImageView *heardImage = [UIImageView createImage:@"set_bg"];
        [self addSubview:heardImage];
        [heardImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        
        logoImage = [UIImageView createImage:@"head"];
        logoImage.layer.cornerRadius = HScale*50;
        logoImage.layer.masksToBounds = YES;
        logoImage.userInteractionEnabled = YES;
        logoImage.contentMode =  UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [logoImage addGestureRecognizer:tap];
        [self addSubview:logoImage];
        [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(HScale*100, HScale*100));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.equalTo(self).offset(HScale*60);
        }];
        
        nameLbl = [UILabel createLbl:@"" font:16 textColor:[UIColor threeTwoColor]];
        [self addSubview:nameLbl];
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(HScale *20);
            make.bottom.equalTo(self).offset(HScale*-8);
            make.left.equalTo(self).offset(WScale*5);
            make.width.mas_equalTo(SCREEN_WIDTH-WScale*10);
        }];
        
//        UIImageView *arrorwImage = [UIImageView createImage:@"user_arrorw"];
//        [self addSubview:arrorwImage];
//        [arrorwImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(logoImage.mas_centerY);
//            make.right.equalTo(self).offset(WScale*-15);
//            make.size.mas_equalTo(CGSizeMake(HScale*20, HScale*35));
//        }];

    }
    return self;
}

- (void)tapAction
{
    if (currentVC)
    {
        [currentVC pushAction:[BDUserViewController new]];
    }
}

@end
