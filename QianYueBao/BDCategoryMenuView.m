//
//  BDCategoryMenuView.m
//  QianYueBao
//
//  Created by Black on 17/5/9.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDCategoryMenuView.h"

@implementation BDCategoryView

+ (instancetype)createViewFrame:(CGRect)frame title:(NSString *)title
{
    BDCategoryView *view = [[BDCategoryView alloc]initWithFrame:frame title:title];
    return view;
}
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    if (self = [super initWithFrame:frame])
    {
        UIImageView *arrorwImage = [UIImageView createImage:@"dish_arrorw"];
        [self addSubview:arrorwImage];
        [arrorwImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(WScale*7, HScale*12));
        }];
        HYWeakSelf;
        UIButton *actionBtn = [UIButton createBtn:title font:15 textColor:[UIColor subjectColor] complete:^{
            HYStrongSelf;
            if (sSelf.complete)
            {
                sSelf.complete();
            }
        }];
        actionBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:actionBtn];
        [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(arrorwImage.mas_left).offset(WScale*-4);
        }];
    }
    return self;
}

@end

@implementation BDCategoryMenuView
@synthesize scrollview;

+ (instancetype)createView:(UIView *)fatherView
{
    BDCategoryMenuView *menuView = [[BDCategoryMenuView alloc]initWithFrame:CGRectZero];
    [fatherView addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(fatherView);
        make.top.equalTo(fatherView).offset(64);
        make.height.mas_equalTo(HScale*50);
    }];
    return menuView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
        scrollview = [[UIScrollView alloc]initWithFrame:CGRectZero];
        scrollview.bounces = NO;
        scrollview.showsHorizontalScrollIndicator = NO;
        scrollview.showsVerticalScrollIndicator = NO;
        scrollview.scrollEnabled = NO;
        scrollview.backgroundColor = [UIColor clearColor];
        [self addSubview:scrollview];
        [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(self);
        }];
    }
    return self;
}

- (void)reloadData:(NSArray *)titleArray
{
    HYWeakSelf;
    [scrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    scrollview.scrollEnabled = NO;
    if (titleArray.count > 0)
    {
        CGFloat width = 0;
        for (int i=0; i<titleArray.count; i++)
        {
            CGFloat titleWidth = [BDStyle getWidthWithTitle:titleArray[i] font:15];
            width = width+WScale*10;
            if (i==titleArray.count-1)
            {
                UILabel *titleLbl = [UILabel createNoramlLbl:titleArray[i] font:15 textColor:[UIColor nineSixColor]];
                titleLbl.frame = CGRectMake(width, 0, titleWidth, HScale*50);
                [scrollview addSubview:titleLbl];
                width = width+titleWidth;
            }
            else
            {
                CGFloat xWidth = titleWidth+WScale*13;
                BDCategoryView *view = [BDCategoryView createViewFrame:CGRectMake(width, 0, xWidth, HScale*50) title:titleArray[i]];
                view.tag = i+1;
                view.complete = ^(){
                    HYStrongSelf;
                    if (sSelf.backIndexHandler)
                    {
                        sSelf.backIndexHandler(i+1);
                    }
                };
                [scrollview addSubview:view];
                width = width+xWidth;
            }
        }
        if (width>SCREEN_WIDTH)
        {
            scrollview.scrollEnabled = YES;
            scrollview.contentSize=CGSizeMake(width, 0);
        }
    }
}


@end
