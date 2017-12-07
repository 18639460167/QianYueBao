//
//  BDCodeView.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/29.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDCodeView.h"

@implementation BDCodeView
@synthesize numberLbl;
@synthesize titleLbl;
@synthesize codeImage;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
       
        
        UIView *bgView = [BDStyle createView:WHITE_COLOR];
        bgView.layer.borderWidth = 0.5;
        bgView.layer.borderColor = [UIColor lineColor].CGColor;
        bgView.layer.masksToBounds = YES;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(self);
        }];
        
        titleLbl = [UILabel createLbl:@"ddajsakjdajdksal" font:12 textColor:[UIColor colorWithHexString:@"#323232"]];
        titleLbl.adjustsFontSizeToFitWidth = YES;
        titleLbl.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(bgView);
            make.top.equalTo(bgView).offset(HScale*10);
            make.height.mas_equalTo(WScale*13);
        }];
        
        codeImage = [UIImageView createImage:@""];
        [bgView addSubview:codeImage];
        [codeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView.mas_centerX);
            make.centerY.mas_equalTo(bgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(HScale*140, HScale*140));
        }];
        
        numberLbl = [UILabel createRightLbl:@"" font:12 textColor:[UIColor nineSixColor]];
        [self addSubview:numberLbl];
        [numberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView);
            make.right.equalTo(bgView).offset(WScale*-8);
            make.bottom.equalTo(bgView).offset(HScale*-8);
            make.height.mas_equalTo(WScale*13);
        }];
    }
    return self;
}

@end
