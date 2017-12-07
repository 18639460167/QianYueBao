//
//  BDSignFinishTopView.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/29.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDSignFinishTopView.h"

@implementation BDSignFinishTopView

+ (instancetype)cretaView:(BDSignFinishViewController *)vc
{
    BDSignFinishTopView *view = [[BDSignFinishTopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HScale*185) cretaView:vc];
    [vc.view addSubview:view];
    [vc.view insertSubview:view belowSubview:vc.navBarView];
    return view;
}
- (instancetype)initWithFrame:(CGRect)frame cretaView:(BDSignFinishViewController *)vc
{
    if (self = [super initWithFrame:frame])
    {
        UIImageView *bgImage = [UIImageView createImage:@"change_color"];
        [self addSubview:bgImage];
        [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        
        NSArray *imageArray = @[@"inforamtion",@"contract_change"];
        NSArray *nameArray = @[LS(@"Basic_Message"),LS(@"Contract_Change")];
        CGFloat width = SCREEN_WIDTH/2.0;
        for (int i=0; i<imageArray.count; i++)
        {
            UIView *actionView = [BDStyle createView:CLEAR_COLOR];
            actionView.frame = CGRectMake(width*i, 64, width, HScale*185-64);
            [self addSubview:actionView];
            
            UILabel *messageLbl = [UILabel createLbl:nameArray[i] font:13 textColor:WHITE_COLOR];
            [actionView addSubview:messageLbl];
            [messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(actionView.mas_centerX);
                make.left.equalTo(actionView).offset(WScale*8);
                make.height.mas_equalTo(WScale*14);
                make.bottom.equalTo(actionView).offset(HScale*-40);
            }];
            
            UIImageView *logoImage = [UIImageView createImage:imageArray[i]];
            [actionView addSubview:logoImage];
            [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(actionView.mas_centerX);
                make.size.mas_equalTo(CGSizeMake(HScale*20, HScale*25));
                make.bottom.equalTo(messageLbl.mas_top).offset(HScale*-7);
            }];
            
            UIButton *actionBtn = [UIButton buttonWithType:0];
            [[actionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                if (i==0)
                {
                    BDBasisMessageViewController *bVc = [BDBasisMessageViewController new];
                    bVc.signModel = vc.signModel;
                    [vc pushAction:bVc];
                }
                else
                {
                    BDChangeContractViewController *bVc = [BDChangeContractViewController new];
                    bVc.signModel = vc.signModel;
                    [vc pushAction:bVc];
                }
            }];
            [actionView addSubview:actionBtn];
            [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(actionView.mas_centerX);
                make.centerY.mas_equalTo(actionView.mas_centerY);
                make.left.equalTo(actionView).offset(WScale*5);
                make.top.equalTo(actionView).offset(WScale*5);
            }];
        }
        
        UIView *lineView  = [BDStyle createView:[WHITE_COLOR colorWithAlphaComponent:0.3]];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(1, HScale*50));
            make.bottom.equalTo(self).offset(HScale*-38);
        }];
    }
    return self;
}

@end
