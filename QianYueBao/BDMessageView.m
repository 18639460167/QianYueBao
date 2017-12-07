//
//  BDMessageView.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/27.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDMessageView.h"

@implementation BDMessageView
@synthesize messageLbl;

+ (instancetype)createView:(NSString *)title
{
    BDMessageView *view = [[BDMessageView alloc]initWithFrame:CGRectZero title:title];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    if (self = [super initWithFrame:frame])
    {
        CGFloat width = [BDStyle getWidthWithTitle:title font:15];
        UILabel *titleLbl = [UILabel createNoramlLbl:title font:15 textColor:[UIColor nineSixColor]];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(width);
            make.left.equalTo(self).offset(WScale*15);
        }];
        
        messageLbl = [UILabel createRightLbl:@"" font:15 textColor:[UIColor threeTwoColor]];
        [self addSubview:messageLbl];
        [messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.right.equalTo(self).offset(WScale*-15);
            make.left.equalTo(titleLbl.mas_right).offset(WScale*5);
        }];
        
        UIView *lineView = [BDStyle createView:[UIColor cEightColor]];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.left.equalTo(self).offset(WScale*15);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    messageLbl.text = message;
}

@end
