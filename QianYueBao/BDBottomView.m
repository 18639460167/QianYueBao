//
//  BDBottomView.m
//  QianYueBao
//
//  Created by Black on 17/5/16.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDBottomView.h"

@implementation BDBottomButton

+ (instancetype)createBottomBtn:(TradeStatus)status handler:(noParameterBlock)complete
{
    BDBottomButton *bottomBtn = [[BDBottomButton alloc]initWithFrame:CGRectZero createBottomBtn:status handler:complete];
    return bottomBtn;
}
- (instancetype)initWithFrame:(CGRect)frame createBottomBtn:(TradeStatus)status handler:(noParameterBlock)complete
{
    if (self = [super initWithFrame:frame])
    {
        switch (status)
        {
            case TradeStatus_Process:
            {
                [self setTitle:LS(@"Under_Review") forState:UIControlStateNormal];
                self.backgroundColor = [UIColor colorWithHexString:@"#b4b4b4"];
                self.enabled = NO;
            }
                break;
            case TradeStatus_Fail:
            {
                [self setTitle:LS(@"Review_Fail_Change") forState:UIControlStateNormal];
                self.backgroundColor = [UIColor colorWithHexString:@"#b4b4b4"];
                self.enabled = YES;
            }
                break;
            case TradeStatus_Wait:
            {
                [self setTitle:LS(@"Determiner_Submit") forState:UIControlStateNormal];
                self.backgroundColor = [UIColor subjectColor];
                self.enabled = YES;
            }
                break;
                
            default:
                break;
        }
        [self setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        self.layer.cornerRadius = HScale*20;
        self.layer.masksToBounds = YES;
        self.titleLabel.font = FONTSIZE(16);
        [[self rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (complete)
            {
                complete();
            }
        }];
    }
    return self;
}

@end

@implementation BDBottomView
@synthesize bottomBtn;

+ (instancetype)createBottomView:(TradeStatus)status fathView:(UIView *)fathView handler:(noParameterBlock)complete
{
    BDBottomView *bottomView = [[BDBottomView alloc]initWithFrame:CGRectZero createBottomView:status handler:complete];
    CGFloat h = HScale*50;
    if (status == TradeStatus_Fail)
    {
        h = HScale*58+ WScale*15;
    }
    bottomView.height = h;
    [fathView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(fathView);
        make.height.mas_equalTo(h);
    }];
    return bottomView;
}
- (instancetype)initWithFrame:(CGRect)frame createBottomView:(TradeStatus)status handler:(noParameterBlock)complete
{
    if (self = [super initWithFrame:frame])
    {
        bottomBtn = [BDBottomButton createBottomBtn:status handler:complete];
        [self addSubview:bottomBtn];
        [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.left.equalTo(self).offset(WScale*15);
            make.height.mas_equalTo(HScale*40);
        }];
        
        if (status == TradeStatus_Fail)
        {
            UILabel *label = [UILabel createLbl:LS(@"Review_Fail_Reason") font:13 textColor:BLACK_COLOR];
            [self addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bottomBtn.mas_bottom).offset(HScale*8);
                make.height.mas_equalTo(WScale*15);
                make.left.equalTo(self).offset(WScale*8);
                make.centerX.mas_equalTo(self.mas_centerX);
            }];
        }
    }
    return self;
}

@end
