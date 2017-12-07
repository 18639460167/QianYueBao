//
//  BDSliderView.m
//  自定义tabbar
//
//  Created by tenpastnine-ios-dev on 17/3/6.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDSliderView.h"
#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define KTopViewHight 50

@interface BDSliderView()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *vcArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UIScrollView *bottomScrollview;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIScrollView *topScrollview;
@property (nonatomic, strong) UIView *slideView;
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, copy)   sliderBlock block;

@end

@implementation BDSliderView

- (instancetype)initWithFrame:(CGRect)frame WithViewControllers:(NSArray *)viewControllers titleArray:(NSArray *)titleArray complete:(sliderBlock)complete
{
    if (self = [super initWithFrame:frame])
    {
        self.block = complete;
        self.titleArray = titleArray;
        self.vcArray = viewControllers;
    }
    return self;
}

#pragma mark - 加载VC
- (void)setVcArray:(NSArray *)vcArray
{
    _vcArray = vcArray;
    _btnArray = [NSMutableArray array];
    if (self.titleArray)
    {
        [self configTopView];
    }
    [self configButomView];
}

- (void)configTopView
{
    CGFloat btnWidth = SCREEN_WIDTH / _vcArray.count;
    CGFloat btnHeight = KTopViewHight-15;
    
    CGRect topViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.topView = [[UIView alloc]initWithFrame:topViewFrame];
    self.topView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.topView];
    
    self.slideView = [[UIView alloc]initWithFrame:CGRectMake(0, KTopViewHight-1, btnWidth, 1)];
    [self.slideView setBackgroundColor:CLEAR_COLOR];
    [self.topView addSubview:self.slideView];
    
    UIView *bgView = [BDStyle createView:[UIColor navigationColor]];
    [self.slideView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.slideView.mas_centerX);
        make.top.bottom.equalTo(self.slideView);
        make.left.equalTo(self.slideView).offset(WScale*5);
    }];
    
    //  添加按钮
    for (int i=0; i<self.vcArray.count; i++)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(btnWidth*i, 15, btnWidth, btnHeight)];
        [self.topView addSubview:view];
        
        UIButton *button = [UIButton buttonWithType:0];
        button.tag = i;
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = FONTSIZE(15);
        [button setTitleColor:[UIColor nineSixColor] forState:UIControlStateNormal];
        if (i == 0)
        {
            [button setTitleColor:[UIColor navigationColor] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(tabButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(view);
        }];
        
        if (i!=self.vcArray.count-1)
        {
            UIView *lineView = [BDStyle createView: [UIColor colorWithHexString:@"#788096"]];
            [button addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(button);
                make.centerY.mas_equalTo(button.mas_centerY);
                make.height.mas_equalTo(WScale*18);
                make.width.mas_equalTo(0.5);
            }];
        }
        
        [self.btnArray addObject:button];
    }
}

- (void)configButomView
{
    int height = SCREEN_HEIGHT-KTopViewHight-HScale*190;
    int top = self.titleArray ? KTopViewHight : 0;
    CGRect bottomScrollviewFrame = CGRectMake(0, top, SCREEN_WIDTH, height);
    self.bottomScrollview = [[UIScrollView alloc]initWithFrame:bottomScrollviewFrame];
    [self addSubview:_bottomScrollview];
    for (int i=0; i<self.vcArray.count; i++)
    {
        CGRect vcFrame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, bottomScrollviewFrame.size.height);
        UIViewController *vc = self.vcArray[i];
        vc.view.frame = vcFrame;
        [self.bottomScrollview addSubview:vc.view];
    }
    
    self.bottomScrollview.contentSize = CGSizeMake(self.vcArray.count*SCREEN_WIDTH, 0);
    self.bottomScrollview.pagingEnabled = YES;
    self.bottomScrollview.showsHorizontalScrollIndicator = NO;
    self.bottomScrollview.showsVerticalScrollIndicator = NO;
    self.bottomScrollview.directionalLockEnabled = YES;
    self.bottomScrollview.bounces = NO;
    self.bottomScrollview.delegate = self;
    if (self.block)
    {
        self.block(0);
    }
}

- (void)tabButtonAction:(UIButton *)button
{
//    [self.bottomScrollview setContentOffset:CGPointMake(button.tag * SCREEN_WIDTH, 0) animated:YES];
//    if (self.block)
//    {
//        self.block(button.tag);
//    }
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomScrollview.contentOffset=CGPointMake(button.tag * SCREEN_WIDTH, 0);
        [self.bottomScrollview setContentOffset:CGPointMake(button.tag * SCREEN_WIDTH, 0) animated:YES];
    }completion:^(BOOL finished) {
        if (self.block)
        {
            self.block(button.tag);
        }
    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frame = self.slideView.frame;
    frame.origin.x = scrollView.contentOffset.x/self.vcArray.count;
    self.slideView.frame = frame;
    int pageNum = scrollView.contentOffset.x/SCREEN_WIDTH;
    for (UIButton *button in self.btnArray)
    {
        int willSelNum = pageNum;
        if (scrollView.contentOffset.x > (pageNum*SCREEN_WIDTH +SCREEN_WIDTH/2))
        {
            willSelNum = willSelNum + 1;
        }
        if (button.tag == willSelNum)
        {
            [button setTitleColor:[UIColor navigationColor] forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:[UIColor nineSixColor] forState:UIControlStateNormal];
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int pageNum = scrollView.contentOffset.x/SCREEN_WIDTH;
    if (self.block)
    {
        self.block(pageNum);
    }
}

@end
