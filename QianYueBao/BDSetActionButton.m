//
//  BDSetActionButton.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/28.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDSetActionButton.h"

@implementation BDSetActionButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)createButton:(NSString *)title imageName:(NSString *)imageName isSame:(BOOL)isSame
{
    BDSetActionButton *actionBtn = [[BDSetActionButton alloc]initWithFrame:CGRectZero createButton:title imageName:imageName isSame:isSame];
    return actionBtn;
}

- (instancetype)initWithFrame:(CGRect)frame createButton:(NSString *)title imageName:(NSString *)imageName isSame:(BOOL)isSame
{
    if (self = [super initWithFrame:frame])
    {
        UIImageView *logoImage = [UIImageView createImage:imageName];
        [self addSubview:logoImage];
        [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(HScale*25);
            make.top.equalTo(self).offset(HScale*18);
            if (isSame)
            {
                make.width.mas_equalTo(HScale*18);
            }
            else
            {
                make.width.mas_equalTo(HScale*25);
            }
        }];
        
        UILabel *titleLbl = [UILabel createLbl:title font:16 textColor:[UIColor threeTwoColor]];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.left.equalTo(self).offset(WScale*2.5);
            make.height.mas_equalTo(HScale *20);
            make.top.equalTo(logoImage.mas_bottom).offset(HScale*13);
        }];
    }
    return self;
}

@end
