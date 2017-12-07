//
//  BDSuperViewController.m
//  QianYueBao
//
//  Created by Black on 17/4/18.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDSuperViewController.h"

@interface BDSuperViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BDSuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.distanceTop = 0;
   [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = WHITE_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setInteractivePopGestureState:(BOOL)interactivePopGestureState
{
    _interactivePopGestureState = interactivePopGestureState;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        _interactivePopGestureState = interactivePopGestureState;
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = (_interactivePopGestureState ? self : nil);
        }
    }
}

- (BDCustomNavitionView *)navBarView
{
    if (!_navBarView)
    {
        self.distanceTop = 0;
        _navBarView = [BDCustomNavitionView new];
        [self.view addSubview:_navBarView];
        
        [_navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.mas_equalTo(64);
        }];
    }
    return _navBarView;
}

@end

@implementation BDSuperViewController(NavVarStyle)

- (void)LoadNavigation:(UIButton *)leftBtn
              navStyle:(BDNavitionStyle)style
                 title:(NSString *)title
         didBackAction:(noParameterBlock)handler
{
    UILabel *titleLbl = [UILabel new];
    titleLbl.text = title;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = FONTSIZE(18);
    titleLbl.textColor = [UIColor whiteColor];
    self.navBarView.currentVC = self;
    self.navBarView.titleView = titleLbl;
    self.navBarView.isShowRight = YES;
    self.navBarView.complete = handler;
    self.navBarView.leftButton = leftBtn;
    if (style == BDNavitionStyle_Clean)
    {
        self.navBarView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    }
    
}

- (void)loadHaveLeftBtn:(BOOL)isShowRight navStyle:(BDNavitionStyle)style title:(NSString *)title didBackAction:(noParameterBlock)handler
{
    UILabel *titleLbl = [UILabel new];
    titleLbl.text = title;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = FONTSIZE(18);
    titleLbl.textColor = [UIColor whiteColor];
    self.navBarView.currentVC = self;
    self.navBarView.titleView = titleLbl;
    self.navBarView.isShowRight = isShowRight;
    self.navBarView.complete = handler;
    if (style == BDNavitionStyle_Clean)
    {
        self.navBarView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    }
}

@end
