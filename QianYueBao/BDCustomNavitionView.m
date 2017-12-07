//
//  BDCustomNavitionView.m
//  QianYueBao
//
//  Created by Black on 17/4/18.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDCustomNavitionView.h"

@implementation BDCustomNavitionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    if (self = [super init])
    {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initView];
    }
    return self;
}
- (void)initView
{
    self.backgroundColor = [UIColor subjectColor];
}
- (void)setIsShowRight:(BOOL)isShowRight
{
    if (isShowRight)
    {
        CGFloat width = [BDStyle getWidthWithTitle:LS(@"BACK") font:16]+WScale*18;
        BDBackButton  *backButton = [BDBackButton button:CGRectZero];
        [backButton addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(WScale*10);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(@44);
            make.width.mas_equalTo(width);
            
        }];
        
        if (_titleView)
        {
            [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mas_centerX);
                make.width.mas_equalTo(SCREEN_WIDTH-((WScale*15+width)*2));
            }];
        }
    }
    _isShowRight = isShowRight;
}

- (void)setTitleView:(UIView *)titleView
{
    [_titleView removeFromSuperview];
    if (titleView)
    {
        [self addSubview:titleView];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(0);
            make.centerX.equalTo(self.mas_centerX);
            make.width.mas_equalTo(SCREEN_WIDTH-160);
            make.height.mas_equalTo(44);
        }];
    }
    _titleView = titleView;
}

- (void)setLeftButton:(UIButton *)leftButton
{
    [_leftButton removeFromSuperview];
    if (leftButton)
    {
        [self addSubview:leftButton];
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(WScale*-10);
            make.centerY.mas_equalTo(_titleView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(leftButton.frame.size.width, leftButton.frame.size.height));
        }];
        
        CGFloat width = [BDStyle getWidthWithTitle:LS(@"BACK") font:16]+20;
        
        if (leftButton.frame.size.width+WScale*10 > width)
        {
            [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.mas_equalTo(self.mas_centerX);
                make.width.mas_equalTo(SCREEN_WIDTH-((leftButton.frame.size.width+WScale*10)*2));
            }];
        }
    }
    _leftButton = leftButton;
}

- (void)btnBackClicked
{
    if (_complete)
    {
        _complete();
    }
    else
    {
        if (self.currentVC)
        {
            [self.currentVC.navigationController popViewControllerAnimated:YES];
        }
    }
}
@end
