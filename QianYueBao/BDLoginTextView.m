//
//  BDLoginTextView.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/28.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDLoginTextView.h"

@implementation BDLoginTextView
@synthesize messageText;

+ (instancetype)createView:(CGRect)frame leftName:(NSString *)leftName
{
    BDLoginTextView *textView = [[BDLoginTextView alloc]initWithFrame:frame leftName:leftName];
    return textView;
}
- (instancetype)initWithFrame:(CGRect)frame leftName:(NSString *)leftName
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [WHITE_COLOR colorWithAlphaComponent:0];
        
        UIView *txtView = [BDStyle createView:WHITE_COLOR];
        txtView.layer.cornerRadius = HScale*20;
        txtView.layer.masksToBounds = YES;
        [self addSubview:txtView];
        [txtView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.left.equalTo(self).offset(WScale*50);
        }];
        
        UIImageView *leftImage = [UIImageView createImage:leftName];
        [txtView addSubview:leftImage];
        [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(txtView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(WScale*16, HScale*15));
            make.left.equalTo(txtView).offset(HScale*20);
        }];
        
        UIView *lineView = [BDStyle createView:[UIColor colorWithHexString:@"#788096"]];
        [txtView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(txtView).offset(HScale*8);
            make.left.equalTo(leftImage.mas_right).offset(WScale*7.5);
            make.width.mas_equalTo(0.5);
            make.centerY.mas_equalTo(txtView.mas_centerY);
        }];

        messageText = [UITextField createText:@"" font:16 textColor:[UIColor colorWithHexString:@"#788096"]];
        [txtView addSubview:messageText];
        [messageText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(txtView);
            make.left.equalTo(lineView.mas_right).offset(WScale*5);
            make.right.equalTo(txtView).offset(WScale*-5);
        }];
    }
    return self;
}

@end
