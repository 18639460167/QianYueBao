//
//  BDWelcomeView.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/28.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDWelcomeView.h"

@implementation BDWelcomeView

+ (void)showWelcomeView:(void (^)(void))complete
{
    if ([[BDAccountService sharedService] checkVersion])
    {
        BDWelcomeView *view = [[BDWelcomeView alloc]initWithFrame:[UIScreen mainScreen].bounds showWelcomeView:complete];
        [view show];
    }
    else
    {
        if (complete)
        {
            complete();
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame showWelcomeView:(void (^)(void))complete
{
    if (self = [super initWithFrame:frame])
    {
        UIImageView *bgImage = [UIImageView createImage:@"welcome"];
        [self addSubview:bgImage];
        [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        
        UIButton *actionBtn = [UIButton buttonWithType:0];
        [actionBtn setTitle:LS(@"Use_Immediately") forState:0];
        actionBtn.titleLabel.font = FONTSIZE(16);
        actionBtn.layer.borderWidth = 0.5;
        actionBtn.layer.borderColor = [[UIColor colorWithHexString:@"#f6f6f6"] colorWithAlphaComponent:0.69].CGColor;
        actionBtn.backgroundColor = [WHITE_COLOR colorWithAlphaComponent:0];
        actionBtn.layer.cornerRadius = HScale*45/2+(0.5);
        actionBtn.layer.masksToBounds = YES;
        [[actionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [UIView animateWithDuration:0.3 animations:^{
                self.alpha = 0.1;
            } completion:^(BOOL finished) {
                if (complete)
                {
                    complete();
                }
                [self removeFromSuperview];
            }];
        }];
        CGFloat width =[BDStyle getWidthWithTitle:LS(@"Use_Immediately") font:16]+HScale*90;
        if (width>SCREEN_WIDTH-WScale*20)
        {
            width = SCREEN_WIDTH-WScale*20;
        }
        [self addSubview:actionBtn];
        [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.equalTo(self).offset(HScale*-60);
            make.height.mas_equalTo(HScale*45);
            make.width.mas_equalTo(width);
        }];
    }
    return self;
}
- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

@end
