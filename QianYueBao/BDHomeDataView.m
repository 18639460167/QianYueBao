//
//  BDHomeDataView.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/29.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDHomeDataView.h"

@implementation BDChartsButton

+ (instancetype)createButton
{
    BDChartsButton *button = [[BDChartsButton alloc]initWithFrame:CGRectZero];
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.layer.borderWidth = 0.5;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = HScale*35/2;
        self.layer.borderColor = WHITE_COLOR.CGColor;
        self.backgroundColor = [WHITE_COLOR colorWithAlphaComponent:0.2];
        self.layer.allowsEdgeAntialiasing = YES;
        
        UIImageView *chartsImage = [UIImageView createImage:@"charts"];
        [self addSubview:chartsImage];
        [chartsImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(WScale*26, HScale*14));
            make.left.equalTo(self).offset(HScale*10);
        }];
        
        UIImageView *arrorwImage = [UIImageView createImage:@"charts_arrorw"];
        [self addSubview:arrorwImage];
        [arrorwImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(WScale*8, WScale*16));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.equalTo(self).offset(WScale*-10);
        }];
        
        UILabel *titleLbl = [UILabel createNoramlLbl:LS(@"Trade_Charts") font:15 textColor:WHITE_COLOR];
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(chartsImage.mas_right).offset(WScale*5);
            make.right.equalTo(arrorwImage.mas_left).offset(WScale*-5);
        }];
    }
    return self;
}

@end

@implementation BDSearchButton

+ (instancetype)createButton
{
    BDSearchButton *button = [[BDSearchButton alloc]initWithFrame:CGRectZero];
    return button;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIImageView *seachImage = [UIImageView createImage:@"homeSearch"];
        [self addSubview:seachImage];
        [seachImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(HScale*25, HScale*25));
            make.top.equalTo(self);
        }];
        
        UILabel *searchLbl = [UILabel createLbl:LS(@"Search") font:12 textColor:WHITE_COLOR];
        [self addSubview:searchLbl];
        [searchLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(seachImage.mas_bottom);
        }];
    }
    return self;
}

@end

@implementation BDHomeDataView
@synthesize unitLbl;
@synthesize moneyLbl;
@synthesize numberLbl;

+ (instancetype)createView:(UIViewController *)vc
{
    UIImageView *bgImage = [UIImageView createImage:@"home_bg"];
    [vc.view addSubview:bgImage];
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(vc.view);
    }];
    
    BDHomeDataView *view = [[BDHomeDataView alloc]initWithFrame:CGRectZero createView:vc];
    [vc.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(vc.view);
        make.height.mas_equalTo(20+HScale*230);
    }];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame createView:(UIViewController *)vc
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = CLEAR_COLOR;
        CGFloat width = [BDStyle getWidthWithTitle:LS(@"Search") font:12];
        BDSearchButton *searchBtn = [BDSearchButton createButton];
        [[searchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (vc)
            {
                [vc presentSearchView];
            }
        }];
        [self addSubview:searchBtn];
        [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(20+HScale*10);
            make.size.mas_equalTo(CGSizeMake(width+WScale*5, HScale*40));
            make.right.equalTo(self).offset(WScale*-35);
        }];
        
        UIView *dataView = [BDStyle createView:CLEAR_COLOR];
        [self addSubview:dataView];
        [dataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(searchBtn.mas_bottom).offset(HScale*15);
            make.height.mas_equalTo(HScale*70);
        }];
        
        UIView *lineView =[BDStyle createView:WHITE_COLOR];
        [dataView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(dataView.mas_centerX);
            make.width.mas_equalTo(0.6);
            make.top.equalTo(dataView).offset(HScale*17);
            make.bottom.equalTo(dataView).offset(HScale*-22);
        }];
        UILabel *numberTit = [UILabel createLbl:LS(@"Signed_Success_Number") font:15 textColor:WHITE_COLOR];
        numberTit.textAlignment = NSTextAlignmentCenter;
        [dataView addSubview:numberTit];
        [numberTit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dataView);
            make.height.mas_equalTo(HScale*20);
            make.left.equalTo(dataView).offset(WScale*8);
            make.right.equalTo(lineView.mas_left).offset(WScale*-8);
        }];
        
        unitLbl = [UILabel createLbl:LS(@"TransAction_Amount_Week") font:15 textColor:WHITE_COLOR];
        unitLbl.textAlignment = NSTextAlignmentCenter;
        [dataView addSubview:unitLbl];
        [unitLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dataView);
            make.height.mas_equalTo(HScale*20);
            make.left.equalTo(lineView.mas_right).offset(WScale*8);
            make.right.equalTo(dataView).offset(WScale*-8);
        }];
        numberLbl = [UILabel createLbl:@"0" font:25 textColor:WHITE_COLOR];
        [dataView addSubview:numberLbl];
        [numberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(dataView);
            make.height.mas_equalTo(HScale*26);
            make.left.equalTo(dataView).offset(WScale*8);
            make.right.equalTo(lineView.mas_left).offset(WScale*-8);
        }];
        
        moneyLbl = [UILabel createLbl:@"0" font:25 textColor:WHITE_COLOR];
        [dataView addSubview:moneyLbl];
        [moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(dataView);
            make.height.mas_equalTo(HScale*26);
            make.left.equalTo(lineView.mas_right).offset(WScale*8);
            make.right.equalTo(dataView).offset(WScale*-8);
        }];
        
        CGFloat chartsWidth = [BDStyle getWidthWithTitle:LS(@"Trade_Charts") font:15];
        BDChartsButton *chartsButton = [BDChartsButton createButton];
        [[chartsButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (vc)
            {
                [vc pushAction:[BDChartsViewController new]];
            }
        }];
        [self addSubview:chartsButton];
        [chartsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(chartsWidth+WScale*66, HScale*35));
            if (SCREEN_WIDTH == 320)
            {
                make.top.equalTo(dataView.mas_bottom).offset(BDHeight(10));
            }
            else
            {
                 make.top.equalTo(dataView.mas_bottom).offset(HScale*15);
            }
        }];
    }
    return self;
}

- (void)bindData:(NSString *)number weekSale:(NSString *)sale sign:(NSString *)sign
{
    numberLbl.text = number;
    moneyLbl.text = sale;
    if ([sign isEqualToString:@""] || (!sign))
    {
        unitLbl.text = LS(@"TransAction_Amount_Week");
    }
    else
    {
        unitLbl.text = [NSString stringWithFormat:@"%@／%@",LS(@"TransAction_Amount_Week"),sign];
    }
    
}

@end
