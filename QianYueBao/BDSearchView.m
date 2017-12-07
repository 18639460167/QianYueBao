//
//  BDSearchView.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/28.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDSearchView.h"

@implementation BDSearchView
@synthesize messageText;

+ (instancetype)createSearchView:(UIViewController *)vc
{
    BDSearchView *view = [[BDSearchView alloc]initWithFrame:CGRectZero createSearchView:vc];
    [vc.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(vc.view);
        make.height.mas_equalTo(20+HScale*50);
    }];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame createSearchView:(UIViewController *)vc
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor navigationColor];
        
        UIView *bgView = [BDStyle createView:CLEAR_COLOR];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self).offset(20);
        }];
        
        CGFloat width = [BDStyle getWidthWithTitle:LS(@"Cancel") font:15];
        UIButton *canCelBtn = [UIButton createBtn:LS(@"Cancel") font:15 textColor:WHITE_COLOR complete:^{
            if (vc)
            {
                [vc dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        [bgView addSubview:canCelBtn];
        [canCelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(bgView);
            make.width.mas_equalTo(width+WScale*20);
            make.right.equalTo(bgView);
        }];
        
        
        UIView *textView = [BDStyle createView:CLEAR_COLOR];
        textView.layer.borderWidth = 0.5;
        textView.layer.borderColor = WHITE_COLOR.CGColor;
        [bgView addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bgView.mas_centerY);
            make.top.equalTo(bgView).offset(HScale*7.5);
            make.left.equalTo(bgView).offset(WScale*10);
            make.right.equalTo(canCelBtn.mas_left).offset(WScale*-3);
        }];
        
        UIImageView *searchImage = [UIImageView createImage:@"homeSearch"];
        [textView addSubview:searchImage];
        [searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(HScale*20, HScale*20));
            make.centerY.mas_equalTo(textView.mas_centerY);
            make.left.equalTo(textView).offset(WScale*10);
        }];
        
        messageText = [UITextField createText:LS(@"Enter_Merchant_Name") font:15 textColor:WHITE_COLOR];
        messageText.returnKeyType = UIReturnKeySearch;
        messageText.delegate = self;
        [textView addSubview:messageText];
        [messageText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(textView);
            make.left.equalTo(searchImage.mas_right).offset(WScale*5);
            make.right.equalTo(textView).offset(WScale*-5);
        }];
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (self.handler)
    {
        self.handler();
    }
    return YES;
}

@end
